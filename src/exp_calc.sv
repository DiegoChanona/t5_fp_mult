module exp_calc(
  input  logic [4:0] exp_a,
  input  logic [4:0] exp_b,
  input  logic       round,     // señal de redondeo para ajustar el exponente final

  output logic [4:0] exp_res,
  output logic       ov_f,
  output logic       uf_f
);

logic [$clog2(10):0] lzc_count_a, lzc_count_b;

//cuenta de ceros a la izquierda para normalizar el resultado de la multiplicacion
lzc #(.WIDTH(10)) lzc_a (.src(mant_a[9:0]), .lzc_count(lzc_count_a), .all_zero());
lzc #(.WIDTH(10)) lzc_b (.src(mant_b[9:0]), .lzc_count(lzc_count_b), .all_zero());


// Suma de exp a y exp b 
logic [4:0] exp_sum;
parallel_prefix_adder #(.WIDTH(5)) exp_adder (
  .srca(exp_a),
  .srcb(exp_b),
  .cin(), 
  .is_signed(1'b1),
  .result(exp_sum),
  .cout(),
  .zero_f(),
  .ov_f()
);


//suma de lzc_count_a y lzc_count_b para normalizar el resultado de la multiplicacion
logic [$clog2(10):0] lzc_sum;
parallel_prefix_adder #(.WIDTH($clog2(10)+1)) lzc_adder (
  .srca(lzc_count_a),
  .srcb(lzc_count_b),
  .cin(), 
  .is_signed(1'b0),
  .result(lzc_sum),
  .cout(),
  .zero_f(),
  .ov_f()
);

//Resta de lzc para ajustar el exponente final
logic [4:0] exp_adj;

parallel_prefix_adder #(.WIDTH(5)) bias_sub (
  .srca(exp_sum),
  .srcb(~lzc_sum + 1'b1), // complemento a 2 de lzc sum
  .cin(1'b0), 
  .is_signed(1'b1),
  .result(exp_adj),
  .cout(),
  .zero_f(),
  .ov_f()
);


//resta de bias para obtener el exponente final

parallel_prefix_adder #(.WIDTH(5)) bias_sub_final (
  .srca(exp_adj),
  .srcb(~bias + 1'b1), // complemento a 2 de bias
  .cin(1'b0), 
  .is_signed(1'b1),
  .result(exp_res),
  .cout(),
  .zero_f(),
  .ov_f()
);

//suma de redondeo para ajustar el exponente final

logic [4:0] exp_rounded;
parallel_prefix_adder #(.WIDTH(5)) round_adder (
  .srca(exp_res),
  .srcb({4'b0000, round}), // suma de la señal de redondeo
  .cin(1'b0),
  .is_signed(1'b1),
  .result(exp_rounded),
  .cout(),
  .zero_f(),
  .ov_f()
);

assign exp_res = round ? exp_rounded : exp_res;

endmodule