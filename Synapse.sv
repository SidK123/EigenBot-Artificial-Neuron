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
    if(reset){
      v <= 18'b0;
    }
    else{
      v <= vnew;
    }
  
  vnew = v + ((-1 * v) >>> 4) + (s1 ? w1 : 17'b0) + (s2 ? w2 : 17'b0) + (s3 ? w3 : 17'b0);
  assign out = v;
endmodule Synapse
