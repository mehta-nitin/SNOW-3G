`timescale 1ns / 1ps

module alpha(
    input [31:0] alpha_in,
    output [31:0] alpha_out
    );
    
    function [7 : 0] MULx(input [7 : 0] V, input [7 : 0] c);
    begin
        if(V & 8'h80)
            MULx = (V << 1) ^ c;
        else
            MULx = V << 1;        
    end
    endfunction
    
    function [7 : 0] MULxPOW(input [7 : 0] V, input [7 : 0] c, input [7:0] i);
    begin
        if(i == 8'd0)
            MULxPOW = V;
        else
            MULxPOW = MULx(MULxPOW(V,c,(i-1)),c);        
    end
    endfunction
    
    function [31 : 0] DIValpha(input [7 : 0] c);
    begin
        DIValpha[31:24] = (MULxPOW(8'd16,c,8'ha9) << 24);
        DIValpha[23:16] = (MULxPOW(8'd39,c,8'ha9) << 16);
        DIValpha[15:8] = (MULxPOW(8'd6,c,8'ha9) << 8);
        DIValpha[7:0] = MULxPOW(8'd64,c,8'ha9);            
    end
    endfunction    
    
    assign alpha_out = ((alpha_in >> 8) & 32'h00ffffff) ^ (DIValpha(alpha_in) & 8'hff);
    
endmodule