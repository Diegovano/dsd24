module fx_to_ft
  (
    input logic [23:0] x,
    output logic [31:0] y
  );

  logic [22:0] no_sign;
  logic [22:0] mantissa;
  logic [7:0] exponent;

  int unsigned leading_zeros;

  always_comb begin
    no_sign = 23'(x[23] ? ~x[22:0] + 1 : x[22:0]);
    leading_zeros = 0;

    if (no_sign != 23'b0) begin
      for (int i = 0; i < 22; i++) begin
        if (no_sign[22 - i] == 1'b1) begin
          break;
        end
        else begin
          leading_zeros++;
        end
      end
    end

    mantissa = no_sign << (leading_zeros + 1); // exclude MSB

    exponent = 8'(127 - leading_zeros);

    y = {x[23], exponent, mantissa};
  end
endmodule