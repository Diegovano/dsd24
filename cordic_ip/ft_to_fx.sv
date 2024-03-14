module ft_to_fx
(
  input logic [31:0] x,
  output logic [23:0] y
);

  logic [22:0] no_sign;
  logic [23:0] number; // mantissa with extra 1 as MSB
  logic [7:0] exponent;


  always_comb begin
    number = {1'b1, x[22:0]}; // add 1 as MSB of mantissa
    no_sign = number >> (1 + 127 - x[30:23]);
    y = {x[31], !x[31] ? no_sign : ~no_sign + 1};
  end
endmodule