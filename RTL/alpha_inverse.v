`timescale 1ns / 1ps

module alpha_inv(
    input [31:0] alpha_inv_in,
    output [31:0] alpha_inv_out
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
    
    function [31 : 0] MULalpha(input [7 : 0] c);
    begin
        MULalpha[31:24] = (MULxPOW(8'd23,c,8'ha9) << 24);
        MULalpha[23:16] = (MULxPOW(8'd245,c,8'ha9) << 16);
        MULalpha[15:8] = (MULxPOW(8'd48,c,8'ha9) << 8);
        MULalpha[7:0] = MULxPOW(8'd239,c,8'ha9);            
    end
    endfunction    
    
    assign alpha_inv_out = ((alpha_inv_in << 8) & 32'hffffff00) ^ (MULalpha(alpha_inv_in) & 8'hff);
    
endmodule