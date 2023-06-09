`default_nettype none

module Izhikevich_module{
  input signed [17:0] a, b, c, d; //different parameters of the Izhikevich model
  input logic CLOCK_50;
  input signed [17:0] p; //peak voltage for the neuron spike
  input signed [17:0] I; //input current from a synapse or external input
  output signed [17:0] vcurr, ccurr;
  output logic spike; // boolean for whether or not this neuron spiked
}
  logic [11:0] count; //clock divider to get only 4096 clock cycles out of the clock before restarting\
  signed [17:0] vnew, unew, bv;
  signed [17:0] vcurr, ccurr; //current v and c parameters
  signed [17:0] vnew, cnew; //new c or v parameter
  signed [17:0] vsquare, vtimesb, du; //for multiplication of two different signed values
  signed [17:0] c14; //constant for the implementation of the Izhikevich neuron model

  always @(posedge CLOCK_50)
  begin
    count <= count+1; //one more clock cycle
    if(reset)
    begin
      vcurr <= -0.65; //rest membrane potential
      ucurr <= 0.2; //nominal u value
      a <= 0.02; //time scale of recovery variable u
      b <= 0.2; //sensitivity of subthreshold fluctuations of v
      c <= -0.5; //after-spike reset of v
      d <= 0.02; //after-spike reset of u
      p <= 0.30; //peak potential of the spike
      c14 <= 1.4; //1.4 constant
      I <= 0.15; //current being supplied to the neuron
    end
    else if (count == 0)
      if(vcurr > p) //if our current membrane potential is larger than the peak potential
        begin
            vcurr <= c; //reset conditions, we bring our membrane potential to the after-spike potential
            ucurr <= ucurr + d; //we want to reset the value of u
        end
      else
        begin
            vcurr <= vnew; //if our membrane potential has not been reached yet, we should still keep increasing it
            ucurr <= unew; //if our membrane potential has not been reached yet, we follow the equations provided by Izhikevich
        end
  end

  signed_mult squarev1(.out(vsquare), .a(vcurr), .b(vcurr)); //generate the squared v
  assign vnew = vcurr + ((vsquare + vcurr + vcurr >>> 2 + c14 >>> 2 - ucurr >>> 2 + I >>> 2) >>> 2); //we divided by 16 overall to account for the multiplication by dt, otherwise it's the equation provided by Izhikevich

  signed_mult bv(.out(bv), .a(vcurr), .b(b)); //multiplying b and v for the equation for u
  signed_mult final(.out(du), .a(bv-ucurr), .b(a)); //calculate the change in u with the given equation
  assign unew = ucurr + du>>>4; //add the value of the current u to the change in u multiplied by the time step for discretization
endmodule Izhikevich_module

module signed_mult{
  input signed [17:0] a, b;
  output       [17:0] out;    
}
  wire signed [17:0] intermediate;
  wire signed [35:0] mult_intermediate;
  
  assign mult_intermediate = a*b; //multiply our two values
  assign out = {mult_intermediate[35], mult_intermediate[32:16]}; //we want the signed bit and the other most significant bits

endmodule signed_mult