module accelerator_top #(
	parameter FOLD_FACT = 4,
	parameter CORD_ITER = 16
)
(
	input logic clk,
	input logic clk_en,
	input logic reset,
	input logic start,
	input logic[23:0] x_fx,
	input logic[31:0] x_ft,
	output logic done,
	output logic[23:0] y_fx,
	output logic[31:0] y_ft
);

logic [23:0] cos_in;
logic [23:0] cos_res;
logic [31:0] cur_flt;

logic [23:0] x;
logic [23:0] y;
logic [23:0] z;

logic [23:0] out_x;
logic [23:0] out_y;
logic [23:0] out_z;

logic [23:0] fixed;
// logic [23:0] out_y1;
// logic [23:0] out_z1;

int count;

ft_to_fx to_fixed(
	.x(x_ft),
	.y(fixed)
);

cordic_daisychain #(.NUMBER_CHAINED(FOLD_FACT), .CORD_ITER(CORD_ITER)) c0(
	.shift(count),
	.z0(z),
	.x0(x),
	.y0(y),
	.zf(out_z),
	.xf(out_x),
	.yf(out_y)
);

// cordic_single s0(
// 	.i(count),
// 	.z(z),
// 	.x(x),
// 	.y(y),
// 	.out_z(out_z0),
// 	.out_x(out_x0),
// 	.out_y(out_y0)
// );

// cordic_single s1(
// 	.i(count+1),
// 	.z(out_z0),
// 	.x(out_x0),
// 	.y(out_y0),
// 	.out_z(out_z1),
// 	.out_x(out_x1),
// 	.out_y(out_y1)
// );

// cordic_ip cosine_accel(
// 	.clk(clk),
// 	.clk_en(clk_en),
// 	.reset(reset),
// 	.z(cos_in),
// 	.cos(cos_res)
// );

fx_to_ft to_float(
	.x(x),
	.y(cur_flt)
);

always_comb begin

	// else y_ft = 0;
	// if (count >= CORD_ITER) y_fx = x;
end

always_ff @ (posedge clk) begin
	if (clk_en) begin
		y_ft <= cur_flt;
		done <= count >= CORD_ITER ? 1 : 0;


		if (start) begin
			count = 0;
			// z <= x_fx ? x_fx : cos_in;
			z <= cos_in;
			x <= 24'h26DD3B;
			y <= 0;
		end

		else if (count < CORD_ITER) begin
			z <= out_z;
			x <= out_x;
			y <= out_y;
			count <= count + FOLD_FACT;

		end
	end
end

endmodule