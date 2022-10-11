`timescale 1ns / 1ps

module RE (input clk, rst, in, output out);

parameter A= 2'b00, Edge =2'b01 , One =2'b10;
reg [1:0] state, nextState;

always@ (state or in)
begin
    case (state)
        A: begin
        if (in) nextState = Edge;
        else nextState = A;
        end
        Edge: begin
        if (in) nextState = One;
        else nextState = A;
        end
        One: begin
        if (in) nextState <= One;
        else nextState <= A;
        end
    endcase
end

always@ (posedge clk, posedge rst)
begin
    if (rst) state <= A;
    else state <= nextState;
end
    assign out = (state == Edge);

endmodule


module ClkD #(parameter n = 50000000) (input clk, rst, output reg clk_out);

reg [31:0] count;

always@ (posedge clk, posedge rst)
begin
    if (rst) count <= 0;
    else if (count == n-1) count <=0;
    else count <= count +1; 
end

always @(posedge clk)
begin
    if (count == n-1) clk_out <= ~clk_out;
    else clk_out = clk_out;
end

endmodule

module BCD (input [1:0] num, output reg [6:0] bcd);

always@(num)
    begin
    case (num)
    0: bcd = 7'b1111110;
    1: bcd = 7'b1001000;
    2: bcd = 7'b1111001;
    3: bcd = 7'b1111110;
    endcase
end

endmodule


module HI_BATTERN(input clk, rst, output reg [6:0] bcd, reg [3:0] sel );

wire clk_div, clk_div2;
wire E_rst;

ClkD #(1000) dd (clk, rst, clk_div);
ClkD #(100000000) ll (clk, rst, clk_div2);
reg [1:0] count;
reg [1:0]  a, b, c, d;

initial a <= 3;
initial b <= 2;
initial c <= 1;
initial d <= 0;

always@(posedge clk_div2, posedge rst)
begin
    if (rst) 
    begin
    a <= 3;
    b <= 2;
    c <= 1;
    d <= 0;
    end 
    else begin
    a <= a+1;
    b <= b+1;
    c <= c+1;
    d <= d+1;
    end
end

wire [6:0] num1, num2, num3, num4;

BCD M1 (a, num1);
BCD M2 (b, num2);
BCD M3 (c, num3);
BCD M4 (d, num4);


always @(posedge clk_div, posedge rst)
begin
    if (rst) begin bcd <= 7'b1111110; sel <= 4'b0000; end
    else begin
        count <= count+1;
        if ( count == 0 ) begin sel <= 4'b1110; bcd <= num1; end
        if ( count == 1 ) begin sel <= 4'b1101; bcd <= num2; end
        if ( count == 2 ) begin sel <= 4'b1011; bcd <= num3; end
        if ( count == 3 ) begin sel <= 4'b0111; bcd <= num4; end   
    end
end
endmodule
