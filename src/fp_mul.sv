/*
Multiplicador de punto flotante de 16 bits (half precision) con redondeo y flags.
-1 bit de signo
-5 bits de exponente
-10 bits de mantisa 
Cuenta con flags de excepcion (NV, DZ, OF, UF, NX) y modos de redondeo (RNE, RTZ, RDN, RUP, RMM).
*/

module fp_mul(
  input  logic [15:0] srca,
  input  logic [15:0] srcb,
  input  logic [2:0]       rm,      // modo de redondeo   RNE=0, RTZ=1, RDN=2, RUP=3, RMM=4

  output logic [15:0] result,
  output logic [4:0]       fflags   // {NV, DZ, OF, UF, NX}
);

//Signos, exponentes y mantisas de los operandos y del resultado
logic sign_a, sign_b, sign_res;
logic [4:0] exp_a, exp_b, exp_res;
logic [10:0] mant_a, mant_b, mant_res; // 11 bits para incluir el bit implicito

logic [4:0] bias = 5'd15; // Bias para f16

//signo
assign sign_a = srca[15];
assign sign_b = srcb[15];

//exponentes
assign exp_a = srca[14:10];
assign exp_b = srcb[14:10];

//mantisa 
assign mant_a = {1'b1, srca[9:0]}; // bit implicito
assign mant_b = {1'b1, srcb[9:0]}; // bit implicito


assign sign_res = sign_a ^ sign_b; // signo del resultado


endmodule