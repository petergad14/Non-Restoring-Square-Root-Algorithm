# Non-Restoring Square Root Algorithm implementation using VHDL
This project is used to design a Square root algorithm using VHDL to be implemented on an FPGA. The project consists of 5 different architectures:

## Architecture 1
Architecture 1 is based on the Newton-Raphson method which is an iterative method to functions using their derivatives. The following iterative equation is used to design the Square root:

Let $x = a^2$

$f(x) = x^2 - a$

&there4; $f'(x) = 2x$

&there4; $x_{n+1} = x_{n/2} + a/x_{n}$

Of course, this method would require too much hardware as there are multiplication and division  processes as shown in the final iterative equation.

I used fixed numbers for the output and calculations for the VHDL code to get accurate results. However, this would make the hardware even more complex.

## Architecture 2
For this architecture, we used another algorithm introduced in the ICCD’96 by Yamin Li and Wanming Chu [1]. It is also an iterative algorithm that computes the bits of the result sequentially. It starts with the MSB, based on a modified non-restoring integer square root computing algorithm [1].

## Architecture 3
For this architecture, we used the same algorithm in the paper [1] but with a different design 
to be able to make it a combinatorial circuit. The circuit is very simple as shown in the figure below. It
needs only shifters, registers, adders, and subtractors. For the left side of the adder/subtractor, it 
simply consists of the remainder, and the most 2 significant bits in the input. For the right side, it 
consists of the output, MSB of the remainder, and ‘1’. The input should be shifted to the left by 2 
bits each iteration. The remainder will be formed by adding or subtracting the left and right 
sides based on the MSB of the remainder of the previous iteration. Finally, the output is formed 
by shifting the previous output to the left and concatenating the MSB of the remainder with it.

<p>
   <img src="https://github.com/petergad14/Non-Restoring-Square-Root-Algorithm/assets/139645814/860cab6d-e318-4c84-9c8e-a407d92f7c45">

  <em align="center">Figure 1: combinatorial architecture</em>
</p>

## Architecture 4
This architecture is based on the figure shown below which is taken from [1]. It is a pipelined architecture where  each signal or 
variable is made as arrays to be able to hold the values when we enter different inputs in each 
clock cycle. For this architecture, we need around 32 adder/subtractors, one for each stage. We 
need also an array of registers for the output and reminders.

<p>
   <img src="https://github.com/petergad14/Non-Restoring-Square-Root-Algorithm/assets/139645814/f6c5568b-65d0-4a4c-96c8-984c9c366fb3">
  
  <em align="center">Figure 2: Pipelined architecture</em>
</p>

## Architecture 5
For the last architecture, a structural approach was used to better control the architecture of the 
circuit. For this architecture, the design shown in the Fig. 1 was used. It only uses 2 shifters (1 
for input shifting and another one for the output) and an 18-bit adder/subtractor. A design was 
made for the 2 shifters and the adder/subtractor and a FSM was used as a control unit to control 
the flow of the data throughout the whole process as shown in Fig. 3.

<p>
   <img src="https://github.com/petergad14/Non-Restoring-Square-Root-Algorithm/assets/139645814/41a0ba0f-dc68-465c-b4c6-b697687ca246" width="500" height="300">
  
  <em align="center">Figure 3: FSM</em>
</p>

## References
_[1] “A New Non-Restoring Square Root Algorithm and Its VLSI Implementations”, Yamin Li 
and Wanming Chu, ICCD’96, International Conference on Computer Design._
