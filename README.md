# Implementation of Rotation Mode CORDIC Architecture on Basys3 FPGA board

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

```text
atan(2^-0), atan(2^-1), atan(2^-2), atan(2^-3), ...
```

These angles are chosen because multiplication by `2^-i` can be implemented using a simple right-shift operation.

The basic rotation equations used are:

| Updated Value | Equation                              |
| ------------- | ------------------------------------- |
| `x[i+1]`      | `x[i+1] = x[i] - d[i] * (y[i] >>> i)` |
| `y[i+1]`      | `y[i+1] = y[i] + d[i] * (x[i] >>> i)` |
| `z[i+1]`      | `z[i+1] = z[i] - d[i] * atan(2^-i)`   |

Here, `d[i]` decides the direction of rotation depending on the sign of the remaining angle `z[i]`.

| Condition   | Rotation Direction               | Angle Update                      |
| ----------- | -------------------------------- | --------------------------------- |
| `z[i] >= 0` | Rotate in the positive direction | Subtract `atan(2^-i)` from `z[i]` |
| `z[i] < 0`  | Rotate in the negative direction | Add `atan(2^-i)` to `z[i]`        |

After several iterations, the remaining angle becomes close to zero. The final `x` and `y` values represent the cosine and sine values respectively.

| Final Output | Meaning                                   |
| ------------ | ----------------------------------------- |
| `xn`         | Approximate value of `cos(z0)`            |
| `yn`         | Approximate value of `sin(z0)`            |
| `zn`         | Remaining angle error, approximately zero |

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

CORDIC introduces an internal gain of approximately:

```text
1.64676
```

To compensate for this gain, the initial x-value is chosen as:

```text
1 / 1.64676 = 0.607252
```

In Q16 fixed-point format:

```verilog
x0 = 32'h00009B75;   // 0.607252
```

For sine and cosine calculation, the initial inputs are:

| Signal | Value          | Meaning                                                  |
| ------ | -------------- | -------------------------------------------------------- |
| `x0`   | `32'h00009B75` | CORDIC scale compensation factor, approximately 0.607252 |
| `y0`   | `32'h00000000` | Initial y-coordinate, equal to 0                         |
| `z0`   | Input angle    | Angle for which sine and cosine are calculated           |

After the CORDIC iterations:

| Output | Meaning                                |
| ------ | -------------------------------------- |
| `xn`   | `cos(z0)`                              |
| `yn`   | `sin(z0)`                              |
| `zn`   | Remaining angle error, approximately 0 |

## Simulation

This design was simulated using EDA Playground.

## Test Cases

The testbench verifies the CORDIC output for different input angles.

| Input Angle | `xn / cos` | `yn / sin` |      `zn` |
| ----------: | ---------: | ---------: | --------: |
|          0° |   1.000000 |   0.000046 |  0.000092 |
|         45° |   0.707108 |   0.707123 | -0.000061 |
|         90° |   0.000046 |   1.000000 | -0.000092 |



