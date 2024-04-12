// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen
// by writing 'black' in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen by writing
// 'white' in every pixel;
// the screen should remain fully clear as long as no key is pressed.

//// Replace this comment with your code.

// nwords = 8192 (8K words) representing each 16 pixels
@8192
D=A
@nwords
M=D

// Wait for keyboard measurement
(KBLOOP)
// i = 0
@i
M=0
@KBD
D=M
// if keypress goto BLACK
@BLACK
D;JNE
// otherwise goto WHITE
@WHITE
0;JMP

(BLACK)
// if i = nwords goto KBLOOP
@i
D=M
@nwords
D = D - M
@KBLOOP
D;JEQ
// turn black RAM[SCREEN+i] pixel
// A = SCREEN + i 
@i
D=M
@SCREEN
A = A + D
// pixel goes black
M = -1 
// i = i + 1
@i
M=M+1
// if keypress goto BLACK otherwise goto WHITE
@KBD
D=M
// if keypress goto BLACK
@BLACK
D;JNE
// otherwise goto KBLOOP
@KBLOOP
0;JMP

(WHITE)
// if i = nwords goto KBLOOP
@i
D=M
@nwords
D = D - M
@KBLOOP
D;JEQ
// turn white RAM[SCREEN+i] pixel
// A = SCREEN + i 
@i
D=M
@SCREEN
A = A + D
// pixel goes black
M = 0 
// i = i + 1
@i
M=M+1
// if keypress goto KBLOOP otherwise goto WHITE
@KBD
D=M
// if keypress goto KBLOOP
@KBLOOP
D;JNE
// otherwise goto WHITE
@WHITE
0;JMP

(END)
@END
0;JMP

