`default_nettype none

module Izhikevich_module(
  input logic CLOCK_50,
  input logic reset,
  output logic signed [31:0] vcurr, ucurr,
  output logic spike, // boolean for whether or not this neuron spiked
  output logic [1:0] count,
  output logic signed [31 : 0] vnew_extra, unew_extra,
  output logic signed [31:0] dv
);
  logic signed [31:0] a, b, c, d, p, I;
  logic signed [31:0] bv;
  logic signed [31:0] vnew, unew; //current v and c parameters
  logic signed [31:0] vsquare, vtimesb, du; //for multiplication of two different signed values
  logic signed [31:0] c14; //constant for the implementation of the Izhikevich neuron model
  logic signed [31:0] c_point04; //constant for first coefficient of polynomial
  logic signed [31:0] first_term; //first term of polynomial
  logic signed [31:0] c140; //constant for 140

  always @(posedge CLOCK_50, posedge reset)
  begin
    count <= count+2'd1; //one more clock cycle
    if(reset)
      begin
        count <= 2'b0;
        vcurr <= 32'shffff_4ccd; //rest membrane potential, -.65
        ucurr <= 32'shffff_cccd; //nominal u value, -.2
        a <= 32'sh0000_052d; //time scale of recovery variable u, .02
        b <= 32'sh0000_3333; //sensitivity of subthreshold fluctuations of v
        c <= 32'shffff_8000; //after-spike reset of v, .5
        d <= 32'sh0000_052d; //after-spike reset of u, .02
        p <= 32'sh0000_4ccc; //peak potential of the spike, .3
        c14 <= 32'sh0001_6666; //1.4 constant
        c140 <= 32'sh008C_0000; //140 constant
        c_point04 <= a << 1; //.04 constant
        I <= 32'sh0000_2666*25 ; //current being supplied to the neuron
      end
    else if (count == 2'd0)
      begin
      if(vcurr > p) //if our current membrane potential is larger than the peak potential
        begin
            vcurr <= c; //reset conditions, we bring our membrane potential to the after-spike potential
            ucurr <= ucurr + d; //we want to reset the value of u
            spike <= 1'b1;
        end
      else
        begin
          vcurr <= vnew;
          ucurr <= unew;
        end
      end
    else
      begin
        vcurr <= vnew; //if our membrane potential has not been reached yet, we should still keep increasing it
        ucurr <= unew; //if our membrane potential has not been reached yet, we follow the equations provided by Izhikevich
        spike <= 1'b0; 
      end
  end

  signed_mult squarev1(.out(vsquare), .a(vcurr), .b(vcurr)); //generate the squared v
  signed_mult squaretimesconst(.out(first_term), .a(vsquare), .b(c_point04));
  assign dv = ((vsquare + ((vcurr + vcurr << 2) >>> 2) + (c14 >>> 2) - (ucurr >>> 2) + (I >>> 2)) >>> 8); 
  assign vnew = vcurr + dv; //we divided by 16 overall to account for the multiplication by dt, otherwise it's the equation provided by Izhikevich
  assign vnew_extra = vnew;

  signed_mult bv_mult(.out(bv), .a(vcurr), .b(b)); //multiplying b and v for the equation for u
  signed_mult output_u(.out(du), .a(bv-ucurr), .b(a)); //calculate the change in u with the given equation
  assign unew = ucurr + du>>>10; //add the value of the current u to the change in u multiplied by the time step for discretization
  assign unew_extra = unew;
endmodule: Izhikevich_module

module signed_mult(
  input logic signed [31:0] a, b,
  output logic signed [31:0] out
  //output logic signed [31:0] int_point, float_point
);
  wire signed [63:0] intermediate;  

  assign intermediate = a*b; //multiply our two values
  assign out[31] = intermediate[63];
  assign out[30:0] = intermediate[46:16];
  //assign int_point = out[63:32];
  //assign float_point = out[31:0];

endmodule: signed_mult


module top_two();
  logic signed [31:0] vcurr, ucurr, vnew, unew;
  logic clock, reset, spike;
  logic [1:0] count;
  logic [31:0] dv; 

  Izhikevich_module test_neuron(.dv(dv), .vnew_extra(vnew), .unew_extra(unew), .CLOCK_50(clock), .reset(reset), .vcurr(vcurr), .ucurr(ucurr), .count(count), .spike(spike));

  initial begin
    $monitor($time, "dv:%b, vnew: %b, unew:%b, vcurr: %b, ucurr: %b, count:%d, spike:%b", dv, vnew, unew, vcurr, ucurr, count, spike);
    clock = 1'b0;
    reset = 1'b1;
    forever #5 clock = ~clock;
  end

  initial begin
    @(posedge clock)
    reset = 1'b0;
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)
    @(posedge clock)  

    #2 $finish;
  end

endmodule: top_two

/*module top();
  logic signed [31:0] vnew, unew;
  logic clock, reset, spike;
  logic signed [31:0] a, b, int_point, float_point;
  logic signed [63:0] out;

  signed_mult test_multiply(.a(a), .b(b), .out(out), .int_point(int_point), .float_point(float_point));

  initial begin
    $monitor($time, "a:%b, b:%b, out:%b, int_point:%b, float_point: %b",
                    a, b, out, int_point, float_point);
  end

  initial begin
    #2 a = 32'sh8000_3333;
    #2 b = 32'sh8002_1000;
    #2 a = 32'sh8000_a666;
    #2 b = 32'sh8000_a666;
  end

endmodule: top*/

