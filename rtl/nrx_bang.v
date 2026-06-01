/**************************************************************
	FPGA New Rally-X (BANG sound generator)

	Fixed-point approximation of the Rally-X discrete explosion
	circuit modeled in MAME PR 15424.
***************************************************************/
module NRX_BANG
(
	input				CLK24M,
	input				RESET,
	input				BANG,
	output reg [5:0]	OUT = 6'd32
);

localparam [13:0] DIV_2K = 14'd12287;
localparam [11:0] BURST_LEN = 12'd3584;	// 0x2a00 samples at the old 6 kHz rate is ~1.8 s.

reg [13:0] div = 14'd0;
wire ce_2k = (div == DIV_2K);

always @(posedge CLK24M) begin
	if (RESET) div <= 14'd0;
	else div <= ce_2k ? 14'd0 : div + 14'd1;
end

reg [17:0] lfsr = 18'h3FFFF;
reg [11:0] burst = 12'd0;
reg [11:0] env = 12'd0;
reg signed [13:0] noise = 14'sd0;
reg signed [16:0] hp = 17'sd0;
reg bang_d = 1'b0;

function [5:0] clip6;
	input signed [16:0] value;
	begin
		if (value < 17'sd0) clip6 = 6'd0;
		else if (value > 17'sd63) clip6 = 6'd63;
		else clip6 = value[5:0];
	end
endfunction

wire feedback = lfsr[17] ^ lfsr[10];
wire bang_rise = BANG & ~bang_d;
wire active = BANG | (burst != 12'd0) | (env != 12'd0);
wire signed [13:0] env_signed = {2'b00, env};
wire signed [13:0] next_noise = active ? (lfsr[0] ? env_signed : -env_signed) : 14'sd0;
wire signed [16:0] next_noise_w = {{3{next_noise[13]}}, next_noise};
wire signed [16:0] noise_w = {{3{noise[13]}}, noise};
wire signed [16:0] next_hp = (next_noise_w - noise_w) + hp - (hp >>> 4);
wire [2:0] env_step = 3'd1 + {1'b0, env[11:10]};
wire [11:0] env_decay = (env > {9'd0, env_step}) ? (env - {9'd0, env_step}) : 12'd0;

always @(posedge CLK24M) begin
	if (RESET) begin
		lfsr    <= 18'h3FFFF;
		burst   <= 12'd0;
		env     <= 12'd0;
		bang_d  <= 1'b0;
		noise   <= 14'sd0;
		hp      <= 17'sd0;
		OUT     <= 6'd32;
	end
	else if (ce_2k) begin
		bang_d  <= BANG;
		lfsr    <= (lfsr == 18'd0) ? 18'd1 : {lfsr[16:0], feedback};
		burst   <= (BANG | bang_rise) ? BURST_LEN : (burst != 12'd0) ? (burst - 12'd1) : 12'd0;
		env     <= (BANG | bang_rise) ? 12'hFFF : (env != 12'd0) ? env_decay : 12'd0;
		noise   <= next_noise;
		hp      <= next_hp;
		OUT     <= clip6(17'sd32 + (next_hp >>> 9));
	end
end

endmodule
