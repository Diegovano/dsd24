module accelerator_top #(
	parameter FOLD_FACT = 4,
	parameter CORD_ITER = 16
)
(
	input logic clk,
	input logic clk_en,
	input logic reset,
	input logic start,
	input logic[31:0] x,
	output logic done,
	output logic[31:0] y
);

typedef enum logic [2:0] {
	IDLE_STATE,
	MULTIPLY_STATE_1, // includes cordic
	MULTIPLY_STATE_2, // x^2 * cos
	ACCUMULATE_STATE,
	OUTPUT_AVAIL_STATE
} state_t;

logic start_cordic;
logic done_cordic;

logic [31:0] x_squared, next_x_squared;
logic [31:0] x_half, next_x_half;
logic [31:0] x_cos, next_x_cos;
logic [31:0] x_squared_cos, next_x_squared_cos;
logic [31:0] acc_res, next_acc_res;

logic [31:0] x_cos_out;

logic [31:0] mul_dataa_1;
logic [31:0] mul_datab_1;
logic [31:0] mul_res_1;

logic [31:0] mul_dataa_2;
logic [31:0] mul_datab_2;
logic [31:0] mul_res_2;

logic [31:0] add_dataa_1;
logic [31:0] add_datab_1;
logic [31:0] add_res_1;

state_t state, next_state;

fp_mult mult_1 (
	.clk(clk),
	.areset(reset),
	.a(mul_dataa_1),
	.b(mul_datab_1),
	.q(mul_res_1)
);

fp_mult mult_2 (
	.clk(clk),
	.areset(reset),
	.a(mul_dataa_2),
	.b(mul_datab_2),
	.q(mul_res_2)
);

fp_add add_1 (
	.clk(clk),
	.areset(reset),
	.a(add_dataa_1),
	.b(add_datab_1),
	.q(add_res_1)
);

cordic_top #(.FOLD_FACT(FOLD_FACT), .CORD_ITER(CORD_ITER)) my_cordic (
	.clk(clk),
	.clk_en(clk_en),
	.reset(reset),
	.start(start_cordic),
	.done(done_cordic),
	.x_ft(x),
	.y_ft(x_cos_out)
);

int count;

always_ff @ (posedge clk) begin
	if (clk_en) begin
		if (reset) state <= IDLE_STATE;
		else begin
			state <= next_state;
			x_squared <= next_x_squared;
			x_half <= next_x_half;
			x_cos <= next_x_cos;
			x_squared_cos <= next_x_squared_cos;
			acc_res <= next_acc_res;

			count = next_state != state ? 0 : count + 1;
		end
	end
end

always_comb begin
	start_cordic = 0;
	done = 0;

	mul_dataa_1 = 0;
	mul_datab_1 = 0;

	mul_dataa_2 = 0;
	mul_datab_2 = 0;

	add_dataa_1 = 0;
	add_datab_1 = 0;

	next_x_squared = 0;
	next_x_half = 0;
	next_x_cos = 0;
	next_x_squared_cos = 0;
	next_acc_res = 0;

	y = 0;

	next_state = IDLE_STATE;		
		// state = next_state;
	case (state)
		default: begin // covers idle state
		// IDLE_STATE: begin
			if (start) begin
				next_state = MULTIPLY_STATE_1;

				start_cordic = 1;
			end
			else begin
				next_state = IDLE_STATE;

				start_cordic = 0;
			end
		end

		MULTIPLY_STATE_1: begin
			start_cordic = 0;

			mul_dataa_1 = 31'h3F000000;
			mul_datab_1 = x;

			mul_dataa_2 = x;
			mul_datab_2 = x;

			next_x_half = mul_res_1;
			next_x_squared = mul_res_2;
			next_x_cos = x_cos_out;

			if (done_cordic && count >= 2) begin
				next_state = MULTIPLY_STATE_2; // if mults finished and cordic finished
			end
			else next_state = MULTIPLY_STATE_1;
		end

		MULTIPLY_STATE_2: begin
			mul_dataa_1 = x_squared;
			mul_datab_1 = x_cos;

			next_x_squared_cos = mul_res_1;
			next_x_half = x_half;

			if (count >= 2) begin
				next_state = ACCUMULATE_STATE;
			end
			else next_state = MULTIPLY_STATE_2;
		end

		ACCUMULATE_STATE: begin
			add_dataa_1 = x_squared_cos;
			add_datab_1 = x_half;

			next_acc_res = add_res_1;

			if (count >= 2) begin
				next_state = OUTPUT_AVAIL_STATE;
			end
			else next_state = ACCUMULATE_STATE;
		end

		OUTPUT_AVAIL_STATE: begin
			next_state = IDLE_STATE;
			done = 1;

			y = acc_res;

		end
	endcase
end

endmodule