module cordic_ip
(
	// input logic clk,
	// input logic clk_en,
	// input logic rst,
	input logic[23:0] z,
	output logic[31:0] cos
);

parameter int CORDIC_STAGES = 16;

// parameter real ANGLES_FLOAT[CORDIC_STAGES] = '{0.7853981633974483, 0.4636476090008061, 0.24497866312686414, 0.12435499454676144,
// 																							0.06241880999595735, 0.031239833430268277, 0.015623728620476831, 0.007812341060101111,
// 																							0.0039062301319669718, 0.0019531225164788188, 0.0009765621895593195, 0.0004882812111948983,
// 																							0.00024414062014936177, 0.00012207031189367021, 6.103515617420877e-05, 3.0517578115526096e-05,
// 																						 };

parameter logic[23:0] ANGLES_FIXED[CORDIC_STAGES] = '{ // fixed 1 bit sign, 1 bit int, 22 bits frac
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

// parameter real K_FLOAT = 0.6072529351031394;
parameter logic[23:0] K_FIXED = 24'h26DD3B;

logic[23:0] x[CORDIC_STAGES];
logic[23:0] y[CORDIC_STAGES];
logic[31:0] in_z[CORDIC_STAGES];

always_comb begin
	in_z[0] = z;
	x[0] = K_FIXED;
	y[0] = 0;

	for (int i = 0; i < CORDIC_STAGES - 1; i++) begin
		// $display("%f", in_z[i][23] ? -(-in_z[i] / real'(1 << 22)) : in_z[i] / real'(1 << 22));
		if (in_z[i][23] == 0) begin // check sign bit
			in_z[i+1] = in_z[i] - ANGLES_FIXED[i];
			x[i+1] = x[i] - (y[i] >> i);
			y[i+1] = y[i] + (x[i] >> i);
		end
		else begin
			in_z[i+1] = in_z[i] + ANGLES_FIXED[i];
			x[i+1] = x[i] + (y[i] >> i);
			y[i+1] = y[i] - (x[i] >> i);
		end
	end

	cos = x[CORDIC_STAGES - 1]; // get last element
end

endmodule