module cordic_single #(
  parameter CORD_ITER = 15
)
(
  input int i,
	input logic [23:0] z,
  input logic [23:0] x,
  input logic [23:0] y,
  output logic [23:0] out_z,
	output logic [23:0] out_x,
  output logic [23:0] out_y
);

  parameter logic[23:0] ANGLES_FIXED[16] = '{ // fixed 1 bit sign, 1 bit int, 22 bits frac
    24'h3243F6,
    24'h1DAC67,
    24'h0FADBA,
    24'h07F56E,
    24'h03FEAB,
    24'h01FFD5,
    24'h00FFFA,
    24'h007FFF,
    24'h003FFF,
    24'h001FFF,
    24'h000FFF,
    24'h0007FF,
    24'h0003FF,
    24'h0001FF,
    24'h0000FF,
    24'h00007F
  };

  always_comb begin
    if (i > CORD_ITER || i > 15) begin
      out_z = z;
      out_x = x;
      out_y = y;
    end
    else if (z[23] == 0) begin // check sign bit
      out_z = z - ANGLES_FIXED[i];
      out_x = x - (y >> i);
      out_y = y + (x >> i);
    end
    else begin
      out_z = z + ANGLES_FIXED[i];
      out_x = x + (y >> i);
      out_y = y - (x >> i);
    end
  end
endmodule