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



endmodule