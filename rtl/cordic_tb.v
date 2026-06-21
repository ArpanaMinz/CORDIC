`timescale 1ns/100ps

module cordic_tb;

  reg signed [31:0] x0;
  reg signed [31:0] y0;
  reg signed [31:0] z0;

  wire signed [31:0] xn;
  wire signed [31:0] yn;
  wire signed [31:0] zn;

    cordic dut (
      .z0(z0),
      .xn(xn),
      .yn(yn),
      .zn(zn)
    );

    initial begin
        $dumpfile("cordic.vcd");
        $dumpvars(0, cordic_tb);


        // Test 1: 0 degrees
        z0 = 32'h00000000;
        #10;
        $display("Angle = 0 deg");
        $display("xn/cos = %f, yn/sin = %f, zn = %f",
                 xn / 65536.0,
                 yn / 65536.0,
                 zn / 65536.0);

        // Test 2: 45 degrees
        z0 = 32'h002D0000;
        #10;
        $display("Angle = 45 deg");
        $display("xn/cos = %f, yn/sin = %f, zn = %f",
                 xn / 65536.0,
                 yn / 65536.0,
                 zn / 65536.0);

        // Test 3: 90 degrees
        z0 = 32'h005A0000;
        #10;
        $display("Angle = 90 deg");
        $display("xn/cos = %f, yn/sin = %f, zn = %f",
                 xn / 65536.0,
                 yn / 65536.0,
                 zn / 65536.0);

        #10;
        $finish;
    end

endmodule