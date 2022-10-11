`timescale 1ns / 1ps

module CD #(parameter n=50000000) (input clk, reset, output reg clk_out);
reg [31:0] count;

always@ (posedge clk, posedge reset)
begin
    if (reset) count <= 0;
    else if (count == n-1) count <= 0;
    else count <= count +1;  
end

always @(posedge clk)
begin

    if (count == n-1) clk_out <= ~clk_out;
    else clk_out <= clk_out;    

end
endmodule



module SQUARES(input clk, rst, output reg [6:0] bcd, reg [3:0] sel);

wire clk_div;

CD m (clk, rst, clk_div);

reg [2:0] count;

always@ (posedge clk_div, posedge rst)
begin
    if (rst) begin ;  sel = 4'b1110;  bcd <= 7'b0011100;    
    count <= 0; end
    else begin
    count <= count+1;
    if (count == 0 ) begin sel = 4'b1110;     bcd <= 7'b0011100;    end
    if (count == 1 ) begin sel = 4'b1101;    bcd <= 7'b0011100;    end
    if (count == 2 ) begin sel = 4'b1011;     bcd <= 7'b0011100;    end
    if (count == 3 ) begin sel = 4'b0111;    bcd <= 7'b0011100;    end
    if (count == 4 ) begin sel = 4'b0111;     bcd = 7'b1100010;   end
    if (count == 5 ) begin sel = 4'b1011;       bcd = 7'b1100010;   end
    if (count == 6 ) begin sel = 4'b1101;     bcd = 7'b1100010;   end
    if (count == 7 ) begin sel = 4'b1110;     bcd = 7'b1100010;   end
    end   
end
endmodule
