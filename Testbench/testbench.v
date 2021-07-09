`timescale 1ns / 1ps

module testbench;
    reg [127:0] s_key;
    reg [127:0] IV;
    reg clk = 0;
    wire [31:0] keystream;
    
    SNOW_3G tb(.s_key(s_key), .IV(IV), .clk(clk), .keystream(keystream));
    
    initial
    begin
        s_key = 128'h121afb43474b84c6b557e59d1e0c359b;
        IV = 128'hb08d861d6ba87f00e04aaa5844c347c5;
        clk=0;
        forever #10 clk = ~clk;
    end

endmodule
