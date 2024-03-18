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

logic [31:0] x_squared;
logic [31:0] x_half;
logic [31:0] x_cos_out;
logic [31:0] x_cos;
logic [31:0] x_squared_cos;

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
	.a(mul_dataa_1),
	.b(mul_datab_1),
	.q(mul_res_1)
);

fp_mult mult_2 (
	.clk(clk),
	.a(mul_dataa_2),
	.b(mul_datab_2),
	.q(mul_res_2)
);

fp_add add_1 (
	.clk(clk),
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
		state = next_state;
		if (reset) state = IDLE_STATE;
	end
end

always_comb begin
	if (clk_en) begin
		if (reset) begin
			start_cordic <= 0;
			done <= 0;
			count <= 0;
		end
		else begin
			// state = next_state;
			case (state)
				default: begin // covers idle state
				// IDLE_STATE: begin
					count <= 0;
					done <= 0;
					$display(state);
					if (start) begin
						$display("start");
						next_state <= MULTIPLY_STATE_1;

						start_cordic <= 1;
					end
					else begin
						$display("nostart");
						next_state <= IDLE_STATE;

						start_cordic <= 0;
					end
				end

				MULTIPLY_STATE_1: begin
					count++;
					start_cordic <= 0;

					mul_dataa_1 <= 31'h3F000000;
					mul_datab_1 <= x;

					mul_dataa_2 <= x;
					mul_datab_2 <= x;

					x_half <= mul_res_1;
					x_squared <= mul_res_2;
					x_cos <= x_cos_out;

					if (done_cordic && count >= 2) begin
						next_state = MULTIPLY_STATE_2; // if mults finished and cordic finished
						count <= 0;
					end
					else next_state = MULTIPLY_STATE_1;
				end

				MULTIPLY_STATE_2: begin
					count++;

					mul_dataa_1 <= x_squared;
					mul_datab_1 <= x_cos;

					x_squared_cos <= mul_res_1;

					if (count >= 2) begin
						next_state <= ACCUMULATE_STATE;
						count <= 0;
					end
					else next_state <= MULTIPLY_STATE_2;
				end

				ACCUMULATE_STATE: begin
					count++;

					add_dataa_1 <= x_squared_cos;
					add_datab_1 <= x_half;

					y <= add_res_1;

					if (count >= 2) begin
						next_state <= OUTPUT_AVAIL_STATE;
						count <= 0;
					end
					else next_state <= ACCUMULATE_STATE;
				end

				OUTPUT_AVAIL_STATE: begin
					next_state <= IDLE_STATE;
					done <= 1;
				end
			endcase
		end
	end
end

endmodule