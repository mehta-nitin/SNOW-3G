`timescale 1ns / 1ps

module LFSR(
    input [127:0] s_key,
    input [127:0] IV,
    input clk,
    output wire [31:0] keystream
    );

    reg [31:0] s0;
    reg [31:0] s1;
    reg [31:0] s2;
    reg [31:0] s3;
    reg [31:0] s4;
    reg [31:0] s5;
    reg [31:0] s6;
    reg [31:0] s7;
    reg [31:0] s8;
    reg [31:0] s9;
    reg [31:0] s10;
    reg [31:0] s11;
    reg [31:0] s12;
    reg [31:0] s13;
    reg [31:0] s14;
    reg [31:0] s15;
    
    wire [31:0] FSM_out;
    wire [31:0] alpha_out;
    wire [31:0] alpha_inv_out;
    
    always@(posedge clk) 
	begin
	    s0 = (s_key[127:96] ^ IV[31:0]);
        s1 = s_key[95:64];
        s2 = s_key[63:32];
        s3 = (s_key[31:0] ^ IV[63:32]);
        s4 = (s_key[127:96] ^ 32'h11111111);
        s5 = (s_key[95:64] ^ 32'h11111111 ^ IV[95:64]);
        s6 = (s_key[63:32] ^ 32'h11111111 ^ IV[127:96]);
        s7 = (s_key[31:0] ^ 32'h11111111);
        s8 = s_key[127:96];
        s9 = s_key[95:64];
        s10 = s_key[63:32];
        s11 = s_key[31:0];
        s12 = (s_key[127:96] ^ 32'h11111111);
        s13 = (s_key[95:64] ^ 32'h11111111);
        s14 = (s_key[63:32] ^ 32'h11111111);
        s15 = (s_key[31:0] ^ 32'h11111111);
        #640;
	    s0 <= (alpha_inv_out ^ (s13 ^ (alpha_out ^ FSM_out)));
		s1 <= s0;
		s2 <= s1;
		s3 <= s2;
		s4 <= s3;
		s5 <= s4;
		s6 <= s5;
		s7 <= s6;
		s8 <= s7;
		s9 <= s8;
		s10 <= s9;
		s11 <= s10;
		s12 <= s11;
		s13 <= s12;
		s14 <= s13;
		s15 <= s14;        
	end

    assign keystream = (s15 ^ FSM_out);
    
    FSM f1(.in1(s0), .in2(s10), .clk(clk), .FSM_out(FSM_out));
    alpha_inv a1(.alpha_inv_in(s4), .alpha_inv_out(alpha_inv_out));
    alpha a2(.alpha_in(s15), .alpha_out(alpha_out));
    
endmodule
