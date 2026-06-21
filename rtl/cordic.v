`timescale 1ns/1ps

module cordic(
    input  signed [31:0] z0,
    output reg signed [31:0] xn,
    output reg signed [31:0] yn,
    output reg signed [31:0] zn
);

parameter signed [31:0] x0 = 32'h00009B75;
parameter signed [31:0] y0 = 32'h00000000;

parameter N = 20;

reg signed [31:0] x [0:N];
reg signed [31:0] y [0:N];
reg signed [31:0] z [0:N];

reg signed [31:0] arctan [0:N-1];

integer i;

initial begin
    arctan[0]  = 32'h002D0000;
    arctan[1]  = 32'h001A90A3;
    arctan[2]  = 32'h000E0945;
    arctan[3]  = 32'h00072000;
    arctan[4]  = 32'h0003938B;
    arctan[5]  = 32'h0001CA38;
    arctan[6]  = 32'h0000E52A;
    arctan[7]  = 32'h00007297;
    arctan[8]  = 32'h0000394B;
    arctan[9]  = 32'h00001CA5;
    arctan[10] = 32'h00000E52;
    arctan[11] = 32'h00000729;
    arctan[12] = 32'h00000394;
    arctan[13] = 32'h000001CA;
    arctan[14] = 32'h000000E5;
    arctan[15] = 32'h00000072;
    arctan[16] = 32'h00000039;
    arctan[17] = 32'h0000001C;
    arctan[18] = 32'h0000000E;
    arctan[19] = 32'h00000007;
end

always @(*) begin

    x[0] = x0;
    y[0] = y0;
    z[0] = z0;

    for(i=0;i<N;i=i+1) begin

        if(z[i] >= 0) begin
            x[i+1] = x[i] - (y[i] >>> i);
            y[i+1] = y[i] + (x[i] >>> i);
            z[i+1] = z[i] - arctan[i];
        end
        else begin
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
