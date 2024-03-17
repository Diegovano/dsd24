module cordic_daisychain #(
  parameter NUMBER_CHAINED = 16,
  parameter CORD_ITER = 16
)
(
  input int shift,
  input logic [23:0] z0, x0, y0,
  output logic [23:0] zf, xf, yf
);

logic [23:0] z[NUMBER_CHAINED:0];
logic [23:0] x[NUMBER_CHAINED:0];
logic [23:0] y[NUMBER_CHAINED:0];

always_comb begin
  z[0] = z0;
  x[0] = x0;
  y[0] = y0;
  zf = z[NUMBER_CHAINED];
  xf = x[NUMBER_CHAINED];
  yf = y[NUMBER_CHAINED];
end

genvar i;
generate
  for (i = 0; i < NUMBER_CHAINED; i++) begin : the_chain
    cordic_single #(.CORD_ITER(CORD_ITER)) inst(i + shift, z[i], x[i], y[i], z[i+1], x[i+1], y[i+1]);
  end
endgenerate

endmodule