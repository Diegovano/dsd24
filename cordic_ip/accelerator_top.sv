module accelerator_top
(
	input logic[23:0] x_fx,
	input logic[31:0] x_ft,
	output logic[23:0] y_fx,
	output logic[31:0] y_ft
);

parameter logic[23:0] fx = {1'b0, 1'b0, 1'b1, 21'b0};

logic[23:0] cos_res;

logic[31:0] fp;

ft_to_fx to_fixed(
	.x(x_ft),
	.y(y_fx)
);

fx_to_ft to_float(
	// .x(cos_res),
	.x(x_fx),
	.y(y_ft)
);

cordic_ip cosine_accel(
	// .z(fx / real'(1 << 22)),
	.z(x_fx),
	.cos(cos_res)
);

// always_comb begin
	// assign y_fx = cos_res;
// 	y = 0;
// end

endmodule