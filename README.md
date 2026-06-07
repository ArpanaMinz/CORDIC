# CORDIC Architecture in Verilog

This repository contains a Verilog implementation of the **CORDIC (COordinate Rotation DIgital Computer)** algorithm. The design is written for simulation and understanding of the CORDIC rotation-mode architecture.

CORDIC is commonly used in digital systems to calculate trigonometric functions such as sine and cosine using only shift, addition, and subtraction operations. This makes it suitable for FPGA and hardware-based implementations.

## Project Overview

The implemented CORDIC design works in **rotation mode**. For a given input angle, the architecture rotates an initial vector step by step and produces the corresponding sine and cosine values.

For sine and cosine generation:

* z0 is the input angle.
* x0 is initialized with the CORDIC scale compensation factor.
* y0 is initialized to zero.
* xn gives the cosine output.
* yn gives the sine output.
* zn gives the remaining angle error after all iterations.

## CORDIC Theory

CORDIC rotates a vector using a set of predefined angles:

atan(2^-0), atan(2^-1), atan(2^-2), atan(2^-3), ...

These angles are chosen because multiplication by 2^-i can be implemented using a simple right shift operation.

The basic rotation equations used are:

x[i+1] = x[i] - d[i] * (y[i] >>> i)
y[i+1] = y[i] + d[i] * (x[i] >>> i)
z[i+1] = z[i] - d[i] * atan(2^-i)

where d[i] decides the direction of rotation depending on the sign of the remaining angle z[i].

If z[i] is positive, the vector is rotated in one direction.
If z[i] is negative, the vector is rotated in the opposite direction.

After several iterations, the remaining angle becomes close to zero, and the final x and y values represent cosine and sine respectively.

## Fixed-Point Representation

This design uses signed 32-bit fixed-point representation with 16 fractional bits.

The real value is interpreted as:

real value = stored integer / 65536
Examples:

| Real Value | Fixed-Point Hex |
| ---------: | --------------: |
|        1.0 |  32'h00010000 |
|        0.5 |  32'h00008000 |
|       45.0 |  32'h002D0000 |
|       90.0 |  32'h005A0000 |

The input angle values are represented in degrees using the same fixed-point format.

## CORDIC Scaling Factor

CORDIC introduces an internal gain of approximately:1.64676
To compensate for this gain, the initial x-value is chosen as: 1 / 1.64676 = 0.607252

In Q16 fixed-point format: x0 = 32'h00009B75;

For sine and cosine calculation:
x0 = 32'h00009B75;   // 0.607252
y0 = 32'h00000000;   // 0
z0 = input angle

After the CORDIC iterations:
xn ≈ cos(z0)
yn ≈ sin(z0)
zn ≈ 0

## Simulation

This design was simulated using EDA Playground.

## Test Cases

The testbench verifies the CORDIC output for angles such as:
Angle = 0 deg
xn/cos = 1.000000, yn/sin = 0.000046, zn = 0.000092
Angle = 45 deg
xn/cos = 0.707108, yn/sin = 0.707123, zn = -0.000061
Angle = 90 deg
xn/cos = 0.000046, yn/sin = 1.000000, zn = -0.000092


