`default_nettype none

module Axon_Delay{
  input logic spike_in, clock;
  input logic [5:0] delay;
  output logic spike_out;
}
  logic start;
  logic [5:0] count;
  always @(posedge clock){
    if(spike_in == 1'b1){
      start <= 1'b1;
    }
    if(start == 1'b1){
      count <= count + 1;
    }
    if(count == delay){
    begin
      start <= 1'b0;
      spike_out <= 1'b1;
      count <= 1'b0;
    end
    }
    else{
      spike_out <= 1'b0;
    }
  }
endmodule Axon_Delay