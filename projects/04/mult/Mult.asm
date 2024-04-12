// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/4/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// The algorithm is based on repetitive addition.

// prod = 0 
@prod
M=0
// cnt = R1
@R1
D=M
@cnt
M=D
(LOOP)
// if cnt == 0 goto STOP
@cnt
D=M
@STOP
D;JEQ
// prod = prod + R0 
@prod
D=M
@R0
D = D + M
@prod
M = D 
// cnt = cnt - 1
@cnt
M = M - 1
@LOOP
0;JMP
(STOP)
// R2 = prod
@prod
D = M
@R2
M = D
(END)
@END
0;JMP
	
