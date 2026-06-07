`timescale 1ns/100ps

module cordic
(
  input  signed [31:0] x0,
  input  signed [31:0] y0,
  input  signed [31:0] z0,
  output reg signed [31:0] xn,
  output reg signed [31:0] yn,
  output reg signed [31:0] zn
);

  parameter N = 20;

  reg signed [31:0] x [0:N];
  reg signed [31:0] y [0:N];
  reg signed [31:0] z [0:N];

  reg signed [31:0] arctan [0:N-1];

  integer i;

  
    // arctan(2^-i) in degrees, Q16 format
    assign arctan[0]  = 32'h002D0000; // 45.000000
    assign arctan[1]  = 32'h001A90A3; // 26.565051
    assign arctan[2]  = 32'h000E0945; // 14.036243
    assign arctan[3]  = 32'h00072000; // 7.125016 approx
    assign arctan[4]  = 32'h0003938B; // 3.576334
    assign arctan[5]  = 32'h0001CA38; // 1.789911
    assign arctan[6]  = 32'h0000E52A; // 0.895174
    assign arctan[7]  = 32'h00007297; // 0.447614
    assign arctan[8]  = 32'h0000394B; // 0.223811
    assign arctan[9]  = 32'h00001CA5; // 0.111906
    assign arctan[10] = 32'h00000E52; // 0.055953
    assign arctan[11] = 32'h00000729; // 0.027976
    assign arctan[12] = 32'h00000394; // 0.013988
    assign arctan[13] = 32'h000001CA; // 0.006994
    assign arctan[14] = 32'h000000E5; // 0.003497
    assign arctan[15] = 32'h00000072; // 0.001749
    assign arctan[16] = 32'h00000039; // 0.000874
    assign arctan[17] = 32'h0000001C; // 0.000437
    assign arctan[18] = 32'h0000000E; // 0.000219
    assign arctan[19] = 32'h00000007; // 0.000109
  

  always @(*) begin
    x[0] = x0;
    y[0] = y0;
    z[0] = z0;

    for (i = 0; i < N; i = i + 1) begin

      if (z[i] >= 0) begin
        x[i+1] = x[i] - (y[i] >>> i);
        y[i+1] = y[i] + (x[i] >>> i);
        z[i+1] = z[i] - arctan[i];
      end else begin
        x[i+1] = x[i] + (y[i] >>> i);
        y[i+1] = y[i] - (x[i] >>> i);
        z[i+1] = z[i] + arctan[i];
      end

    end

    xn = x[N];
    yn = y[N];
    zn = z[N];
  end

endmodule