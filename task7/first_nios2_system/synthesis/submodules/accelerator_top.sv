module accelerator_top
(
	input logic clk,
	input logic clk_en,
	input logic rst,
	// input logic[23:0] x_fx,
	input logic[31:0] x_ft,
	output logic[23:0] y_fx,
	output logic[31:0] y_ft
);

logic [23:0] cos_in;
logic [23:0] cos_res;

ft_to_fx to_fixed(
	.x(x_ft),
	.y(cos_in)
);

cordic_ip cosine_accel(
	.z(cos_in),
	.cos(cos_res)
);

fx_to_ft to_float(
	.x(cos_res),
	.y(y_ft)
);

assign y_fx = cos_res;

endmodule