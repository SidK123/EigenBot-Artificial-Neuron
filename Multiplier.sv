`default_nettype none
module Adder
#(
    parameter WIDTH = 32
)(
    input  logic [WIDTH - 1 : 0] a, b,
    output logic [WIDTH - 1 : 0] sum,
    output logic                 overflow
);

assign {overflow, sum} = a + b;

endmodule : Adder

module Multiplier(
input logic signed [31 : 0] a, b,
input logic clock, reset,
output logic signed [31 : 0] out,
output logic ready,
output logic [8:0] count
);

logic [63:0] sum, sum_new;
logic [63:0] input_to_adder;
logic overflow;
logic signed [63 : 0] intermediate_a, intermediate_b;
logic sign;
always_ff @(posedge clock, posedge reset)
begin
    if(reset)
    begin
    count <= 0;
    sum <= 0;
    end 
    else if(count != 9'd63)
    begin
    count <= count + 1;
    sum <= sum_new;
    end
    else
    begin
    if(sign)
    begin
        out <= ~sum_new[31:0] + 1'b1;
        ready <= 1'b1; 
    end
    else
    begin
        out <= sum_new[31:0];
        ready <= 1'b1; 
    end
    end
end

always_comb begin
    if(a[31] == 1'b1)
    begin
    intermediate_a = {32'b0, ~a + 1'b1};
    end
    else
    intermediate_a = {32'b0, a};
end

always_comb begin
    if(b[31] == 1'b1)
    begin
    intermediate_b = {32'b0, ~b + 1'b1};
    end
    else
    intermediate_b = {32'b0, b};
end 

always_comb begin
    if(a[31] ^ b[31] == 0)
      sign <= 1'b0;
    else
      sign <= 1'b1;
    
end

assign input_to_adder = (intermediate_a[count] ? intermediate_b : 64'b0) << count;
Adder  #(64) adder_module(.a(sum), .b(input_to_adder), .sum(sum_new), .overflow(overflow));


endmodule : Multiplier

module top();

logic signed [31:0] a,b,out;
logic [8:0] count;
logic clock, reset, ready;

Multiplier multiplication_module(.a(a), .b(b), .out(out), .clock(clock), .reset(reset), .ready(ready), .count(count));
initial begin
    $monitor($time, "a:%b, b: %b, out:%b, count:%d, ready:%d", a, b, out, count, ready);
    clock = 1'b0;
    reset = 1'b1;
    forever #5 clock = ~clock;
end

initial begin
    @(posedge clock)
    a <= 32'sh0000_0008;
    b <= 32'sh0000_0002;
    @(posedge clock)
    reset = 1'b0;
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)  
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)  
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)  
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    #2 $finish;
end 
endmodule: top