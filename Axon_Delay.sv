//This module is used to generate the biological delay that occurs between the action potential and the
//this action potential propagating through the axon and hitting the axon terminals. We do this by setting
//a counter and then setting the output spike equal to the input spike when we hit the delay value.

`default_nettype none

module Axon_Delay(
  input logic spike_in, clock,
  input logic [5:0] delay,
  output logic spike_out
);
  logic start;
  logic [5:0] count;
  always @(posedge clock)
    begin
    if(spike_in == 1'b1)  //When a spike is generated, we start the counter.
      start <= 1'b1;
    if(start == 1'b1) //If we have started the counter, then we keep adding to the counter until we've hit the delay value.
      count <= count + 1;
    if(count == delay) //If we've hit the delay value, we restart our counter, and we set our output spike equal to the 1, as the delay has passed.
    begin
      start <= 1'b0;
      spike_out <= 1'b1;
      count <= 1'b0;
    end
    else
      spike_out <= 1'b0; //If the delay hasn't passed, then our output spike has not spiked yet, so it is equal to 0.
    end
endmodule: Axon_Delay