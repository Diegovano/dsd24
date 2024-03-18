`timescale 1 us / 100 ps
module tb ();

	//Inputs to DUT are reg type
	// logic [31:0] in_ft;
	logic [31:0] in_ft;
	logic [23:0] in_fx;

	logic clk;
	logic clk_en;
	logic reset;
	logic start;

	//Output from DUT is wire type
	logic [31:0] res_ft;
	logic [23:0] res_fx;

	accelerator_top #(.FOLD_FACT(16), .CORD_ITER(16)) the_accel(
		.clk(clk),
		.clk_en(clk_en),
		.reset(reset),
		.start(start),
		// .x_fx(in_fx),
		.x(in_ft),
		// .y_fx(res_fx),
		.y(res_ft)
	);

	// ---- If a clock is required, see below ----
	// //Create a 50MHz clock
	always
	 	#5 clk = ~clk;
	// -----------------------

	//Initial Block
	initial
	begin
		$display($time, " << Starting Simulation >> ");
		
		// intialise/set input
		clk = 1'b0;
		reset = 1'b1;
		clk_en = 1'b1;
		// If using a clock
		// @(posedge clk); 
		
		// Wait 10 cycles (corresponds to timescale at the top) 
		#10
		reset = 0;
		// TEST FT_TO_FX
		// in_ft = $shortrealtobits(0.25);

		// reset = 1'b0;
		in_ft = $shortrealtobits(224.0);
		// in_fx = {1'b0, 1'b0, 2'b11, 20'b0}; // 0.75

		#10

		start = 1'b1;

		#10

		start = 1'b0;

		#10

		$display("res y(%f) = ", $bitstoshortreal(in_ft));
		$display($bitstoshortreal(res_ft));

		// in_ft = $shortrealtobits(-0.25);
		// END FT_TO_FX

		// TEST FX_TO_FT
		// in_fx = {1'b0, 1'b0, 2'b11, 20'b0}; // 0.75

		// #10

		// in_fx = {1'b1, 1'b1, 2'b01, 20'b0}; // -0.75

		// #10

		// in_fx = 24'h66666; // 0.1

		// #10

		// in_fx = 24'hF9999A; // -0.1 ?
		// END FX_TO_FT

		// $display("Input ang: %s%f", in_fx[23] ? "-" : "", in_fx[22:0] / shortreal'(1 << 22));

		#10

		// $display("fx output: %s%f", res_fx[23] ? "-" : "", res_fx[22:0] / shortreal'(1 << 22));
		// $display("got bytes %b, \nfloat: %f", res_ft, $bitstoshortreal(res_ft));

		
		// #10

		// in_fx = {1'b0, 1'b0, 2'b11, 20'b0};

		// #10
		// in_fx = {4'b1111, 20'b0}; // -1.0
		// in_fx = 24'h4017C4;
		// $display("starting conversion, expecting: %s%f", in_fx[23] ? "-" : "", in_fx[22:0] / shortreal'(1 << 22));
    // #10
		// $display("got bytes %b, \nfloat: %f", res_ft, $bitstoshortreal(res_ft));


		// $display($bitstoreal(res_fx) / (1 << 22));
		// $display("%b", res_fx);

		// #10

		// in_fx = 24'h1DAC67;
		// $display($bitstoreal(res_fx) / (1 << 22));

		// #10

		// in_fx = 24'h0FADBA;
		// $display($bitstoreal(res_fx) / (1 << 22));
		
		// // in_ang = {10'b0, 2'b11, 20'b0};
		
		// #10
//		in_ang <= 32'd332;
//		
//		#100
//		
//		in_ang <= 32'd2;
//		
		#1000
		// $display("cos(%f): %f", $bitstoreal(in_ang) / (1 << 22), $bitstoreal(result) / (1 << 22));
		$display($time, "<< Simulation Complete >>");
		$stop;
	end

endmodule
