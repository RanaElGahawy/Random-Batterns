`timescale 1ns / 1ps


module BB (input [2:0] num, output reg [6:0] out);


always @(num)
begin
    case(num)
    0: out = 7'b0011111;
    1: out = 7'b0111101;
    2: out = 7'b1110011;
    3: out = 7'b1100111;
    4: out = 7'b1111111;
    endcase
end
endmodule


module Battern(input clk, rst, output reg [3:0] sel, reg [6:0] bcd);
wire clk_div, clk_div2;
CD #(50000) (clk, rst, clk_div);
CD #(10000000) (clk, rst, clk_div2);
wire [6:0] num1, num2, num3, num4;
reg [2:0] r1,r2,r3,r4;

parameter A=3'b000, B=3'b001 ,C= 3'b010 ,D=3'b011,E=3'b100,F=3'b101;
reg [2:0] state, nextState;

always@(state)
begin
    case (state)
    A: begin
    nextState <= B;
    r1 <= 0;
    r2 <= 1;
    r3 <= 4;
    r4 <= 4;
    end
    B: begin
    nextState <= C;
    r1 <= 4;
    r2 <= 0;
    r3 <= 1;
    r4 <= 4;    
    end
    C: begin
    nextState <= D;
    r1 <= 4;
    r2 <= 4;
    r3 <= 0;
    r4 <= 1;    
    end
    D: begin
    nextState <= E;
    r1 <= 4;
    r2 <= 4;
    r3 <= 3;
    r4 <= 2;    
    end
    E: begin
    nextState <= F;
    r1 <= 4;
    r2 <= 3;
    r3 <= 2;
    r4 <= 4;    
    end  
    F: begin
    nextState <= A;
    r1 <= 3;
    r2 <= 2;
    r3 <= 4;
    r4 <= 4;    
    end      
    endcase
end
always @ (posedge clk_div2 or posedge rst)
begin
    if (rst) state <= A;
    else state <= nextState;
end

BB L1 (r1, num1);
BB L2 (r2, num2);
BB L3 (r3, num3);
BB L4 (r4, num4);

reg [1:0] count;
always @(posedge clk_div, posedge rst)
begin
    if (rst) begin bcd <= 7'b0000001; sel <= 4'b0000; end
    else
    begin
    count <= count + 1;
    if (count == 0) begin bcd <= num1; sel <= 4'b1110; end
    else if (count == 1) begin bcd <= num2; sel <= 4'b1101; end
    else if (count == 2) begin bcd <= num3; sel <= 4'b1011; end
    else if (count == 3) begin bcd <= num4; sel <= 4'b0111; end  
    end
end
endmodule
