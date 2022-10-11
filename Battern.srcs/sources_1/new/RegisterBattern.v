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

module RegisterBattern(input clk, rst, output reg [6:0] bcd, reg [3:0] sel);

wire clk_div, clk_div2;
CC #(50000) L (clk, rst, clk_div);
CC #(1000000) LL (clk, rst, clk_div2);


reg [3:0] Q1, Q2, Q3, Q4,Q5,Q6, Q7,Q8, s, d;
reg up;

initial up = 1;
initial Q1 <= 0;
initial Q2 <= 1;
initial Q3 <= 4;
initial Q4 <= 4;
initial up = 0;
initial Q5 <= 2;
initial Q6 <= 3;
initial Q7 <= 4;
initial Q8 <= 4;

always @(posedge clk_div or posedge rst)
begin



if (rst)
begin
 up = 1;
 Q1 <= 0;
 Q2 <= 1;
 Q3 <= 4;
 Q4 <= 4;
 up = 0;
 Q5 <= 2;
 Q6 <= 3;
 Q7 <= 4;
 Q8 <= 4;
end

else begin
up = 1;
Q1 <= Q4;
Q2 <= Q1;
Q3 <= Q2;
Q4 <= Q3;
up = 0;
Q5 <= Q8;
Q6 <= Q5;
Q7 <= Q6;
Q8 <= Q7;
end
end

reg [1:0] count;
wire [6:0] QM1, QM2, QM3, QM4, QM5, QM6, QM7, QM8;
BB SS1 (Q1, QM1);
BB SS2 (Q2, QM2);
BB SS3 (Q3, QM3);
BB SS4 (Q4, QM4);
BB SS5 (Q5, QM5);
BB SS6 (Q6, QM6);
BB SS7 (Q7, QM7);
BB SS8 (Q8, QM8);

always @(posedge clk_div or posedge rst)
begin
    if (rst) begin sel <= 4'b0000; bcd <= 7'b1111110; end
    else 
    begin
    count <= count + 1;
    if (up) begin
        if (count == 0) begin bcd <= QM1; sel <= 4'b1110; end
        else if (count == 1) begin bcd <= QM2; sel <= 4'b1101; end
        else if (count == 2) begin bcd <= QM3; sel <= 4'b1011; end
        else if (count == 3) begin bcd <= QM4; sel <= 4'b0111; end   
        end 
    else begin  
    if (count == 0) begin bcd <= QM5; sel <= 4'b0111; end
    else if (count == 1) begin bcd <= QM6; sel <= 4'b1011; end
    else if (count == 2) begin bcd <= QM7; sel <= 4'b1101; end
    else if (count == 3) begin bcd <= QM8; sel <= 4'b1110; end  
    end
          
    end   
 end


endmodule
