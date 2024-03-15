module accelerator_top
(
	// input logic[23:0] x_fx,
	input logic clk,
	input logic clk_en,
	input logic reset,
	input logic start,
	// input logic start,
	input logic[31:0] x_ft,
	// output logic done,
	output logic[23:0] y_fx,
	output logic[31:0] y_ft
);

logic [23:0] cos_in;
logic [23:0] cos_res;

int count;

ft_to_fx to_fixed(
	.x(x_ft),
	.y(cos_in)
);

cordic_ip cosine_accel(
	.clk(clk),
	.clk_en(clk_en),
	.reset(reset),
	.z(cos_in),
	.cos(cos_res)
);

fx_to_ft to_float(
	.x(cos_res),
	.y(y_ft)
);

always_comb begin
	if (start) count = 0;
	if (count == 16) y_fx = cos_res;
end

always_ff @ (posedge clk) count++;

endmodule