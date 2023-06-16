`default_nettype none

module TopModule(
  input signed logic [17:0] a1, a2, a3,
  input signed logic [17:0] b1, b2, b3,
  input signed logic [17:0] c1, c2, c3,
  input signed logic [17:0] d1, d2, d3,
  input signed logic [5:0] axondelay1, axondelay2;
  input signed logic [17:0] peak_voltage,
  input signed logic [17:0] I2, I3,
  input logic clock,
  input logic reset,
  output signed logic out,
);
  logic [17:0] I1;
  signed logic [17:0] vcurr1, vcurr2, vcurr3;
  signed logic [17:0] ccurr1, ccurr2, ccurr3;
  logic spike1, spike2, spike3;
  logic spike1out, spike2out, spike3out;

  Izhikevich_module module1(.I(I1), .a(a1), .b(b1), .c(c1), .p(peak_voltage), .ccurr(ccurr1), .vcurr(vcurr1), .spike(spike1));
  Izhikevich_module module2(.I(I2), .a(a2), .b(b2), .c(c2), .p(peak_voltage), .ccurr(ccurr2), .vcurr(vcurr2), .spike(spike2));
  Izhikevich_module module3(.I(I3), .a(a3), .b(b3), .c(c3), .p(peak_voltage), .ccurr(ccurr3), .vcurr(vcurr3), .spike(spike3));

  Axon_Delay delay2to1(.spike_in(spike2), .spike_out(spike2_out), .delay(axondelay1), .clock(clock));
  Axon_Delay delay3to1(.spike_in(spike3), .spike_out(spike3_out), .delay(axondelay2), .clock(clock));

  Synapse synapse2and3to1(.clock(clock), .reset(reset), .s1(spike2_out), .s2(spike3_out), .s3(1'b0), .w1(), .w2(), .w3(17'b0), .out(I1));
endmodule: TopModule