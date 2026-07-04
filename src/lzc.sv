/*
Leading Zero Count (LZC) module
This module counts the number of leading zeros in a binary input vector.
Supports arbitrary widths (not just powers of 2).
Is used on the divider/multiplier to determine the number of bits to shift for normalization.

*/


module lzc #(
  parameter int WIDTH = 32
) (
  input  logic [WIDTH-1:0] src,
  output logic [$clog2(WIDTH):0] lzc_count,
  output logic all_zero
);
  generate 
    if (WIDTH == 1) begin : g_base
        assign lzc_count = ~src[0];
        assign all_zero = ~src[0];
    end else if (WIDTH == 2) begin : g_base2
        // Caso base para 2 bits - evita problemas con divisiones
        assign all_zero = (src == 2'b00);
        always_comb begin
          case (src)
            2'b00:   lzc_count = 2'd2;
            2'b01:   lzc_count = 2'd1;
            default: lzc_count = 2'd0;  // 1x
          endcase
        end
    end else begin : g_rec
        // División asimétrica para soportar anchos arbitrarios
        localparam int HALF_LO = WIDTH / 2;
        localparam int HALF_HI = WIDTH - HALF_LO;  // >= HALF_LO
        
        logic [$clog2(HALF_HI):0] cnt_hi;
        logic [$clog2(HALF_LO):0] cnt_lo;
        logic az_hi, az_lo;

        // Instancias para la mitad alta y baja
        lzc #(.WIDTH(HALF_HI)) u_hi (.src(src[WIDTH-1:HALF_LO]), .lzc_count(cnt_hi), .all_zero(az_hi));
        lzc #(.WIDTH(HALF_LO)) u_lo (.src(src[HALF_LO-1:0]),     .lzc_count(cnt_lo), .all_zero(az_lo));

        assign all_zero = az_hi & az_lo;

        // Si la mitad alta tiene un 1 -> el conteo lo da ella (cnt_hi).
        // Si la mitad alta es todo ceros -> HALF_HI + conteo de la mitad baja.
        always_comb
          lzc_count = az_hi ? (HALF_HI + cnt_lo) : cnt_hi;
    end
  endgenerate

endmodule