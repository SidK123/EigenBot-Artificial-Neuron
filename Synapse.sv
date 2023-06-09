`default_nettype none

module Synapse{
  input logic reset;
  input logic clock;
  input logic s1, s2, s3;
  input signed logic [17:0] w1, w2, w3;
  output signed logic [17:0] out;
}

  logic [17:0] v;
  always @(posedge clock)
    if(reset){ //If we reset, then our current goes back to 0. 
      v <= 18'b0;
    }
    else{
      v <= vnew; //Otherwise, the current at the synapse is equal to the new current at our synapse.
    }
  //The current at the synapse exponentially decreases, but the neurons that input to this synapse also contribute current based on if they spike or not. If they spike, we add some amount of current to our synapse, which are the different weights.
  vnew = v + ((-1 * v) >>> 4) + (s1 ? w1 : 17'b0) + (s2 ? w2 : 17'b0) + (s3 ? w3 : 17'b0); 
  assign out = v; //Our output current is equaL to v, which is the variable we use for current.
endmodule Synapse
