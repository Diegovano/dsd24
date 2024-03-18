module ft_to_fx
(
  input logic [31:0] x,
  output logic [23:0] y // output is converted to fixed (x/128) - 1
);

  logic [22:0] no_sign;
  logic [23:0] number; // mantissa with extra 1 as MSB

  // no need for denorm as such a small number cannot be represented by our fxp
  always_comb begin
    number = {1'b1, x[22:0]}; // add 1 as MSB of mantissa
    no_sign = 23'(number >> (1 + 127 - x[30:23] + 7)); // also divide by 128
    y = {x[31], 23'(!x[31] ? no_sign : ~no_sign + 1)} - (1 << 22); // subtract by 1
  end
endmodule