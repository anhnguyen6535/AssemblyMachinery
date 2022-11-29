// File: assign2a.asm
// Author: Anh Nguyen
// UCID: 30105311
// Section: CPSC 355 L01 - Tutorial 04
// Date: October 6th, 2022
// Source: Assignment 2
//
// Description: an ARMv8 assembly language that implements 
// the program "Bit reversal using shift and bitwise logical operation" 
// with x = 0x07FC07FC

str:	.string "original: 0x%08X	reversed: 0x%08X\n"	// creates the format string
	.balign 4						// ensures instructions are properly aligned
	.global main						// makes main visible to linker				

main:	
	stp	x29,x30,[sp,-16]!				// allocates 16 bytes in stack memory to store x29, x30
	mov	x29,sp						// stores the contents of x29, x30 to the stack

initialize:
	define(x_r,w19)						// defines register for x
	define(y_r,w20)						// defines register for y
	define(t1_r,w21)					// defines register for t1
	define(t2_r,w22)					// defines register for t2
	define(t3_r,w23)					// defines register for t3
	define(t4_r,w24)					// defines register for t4

	mov	x_r,0x07FC					// initializes x with 0x07FC
	lsl	x_r,x_r,16					// shifts 4 numbers in hex 
	add	x_r,x_r,0x07FC					// adds 07FC to the end of x

step1:
	and	t1_r,x_r,0x55555555				// t1 = x & 0x55555555
	lsl	t1_r,t1_r,1					// t1 = t1 << 1 = (x & 0x55555555) << 1 
	lsr	t2_r,x_r,1					// t2 = x >> 1
	and	t2_r,t2_r,0x55555555				// t2 = t2 & 0x55555555 = (x >> 1) & 0x55555555
	orr	y_r,t1_r,t2_r					// y = t1 | t2

step2:
        and     t1_r,y_r,0x33333333				// t1 = y & 0x33333333
        lsl     t1_r,t1_r,2					// t1 = t1 << 2 = (y & 0x33333333) << 2
        lsr     t2_r,y_r,2					// t2 = y >> 2
        and     t2_r,t2_r,0x33333333				// t2 = t2 & 0x33333333 = (y >> 2) & 0x33333333
        orr     y_r,t1_r,t2_r					// y = t1 | t2

step3:
        and     t1_r,y_r,0x0F0F0F0F				// t1 = y & 0x0F0F0F0F
        lsl     t1_r,t1_r,4					// t1 = t1 << 4 = (y & 0x0F0F0F0F) << 4
        lsr     t2_r,y_r,4					// t2 = y >> 4
        and     t2_r,t2_r,0x0F0F0F0F				// t2 = t2 & 0x0F0F0F0F = (y >> 4) & 0x0F0F0F0F
        orr     y_r,t1_r,t2_r					// y = t1 | t2

step4:
	lsl	t1_r,y_r,24					// t1 = y << 24
	and	t2_r,y_r,0xFF00					// t2 = y & 0xFF00
	lsl	t2_r,t2_r,8					// t2 = t2 << 8 = (y & 0xFF00) << 8
	lsr	t3_r,y_r,8					// t3 = y >> 8
	and	t3_r,t3_r,0xFF00				// t3 = t3 & 0xFF0 = (y >> 8) & 0xFF00
	lsr	t4_r,y_r,24					// t4 = y >> 24

result:
	orr	y_r,t1_r,t2_r					// y = t1 | t2
	orr	y_r,y_r,t3_r					// y = y | t3 = t1 | t2 | t3
	orr	y_r,y_r,t4_r					// y = y | t4 = t1 | t2 | t3 | t4

print:
	adrp	x0,str						// puts format string to x0 
	add	x0,x0, :lo12:str				// sets 1st argument to printf
	mov	w1,x_r						// sets argument 2 to x
	mov	w2,y_r						// sets argument 3 to y

display:
	bl	printf						// calls printf

done:
	mov	x0,0						// returns 0
	ldp	x29,x30,[sp],16					// restores the stack
	ret							// returns to OS
	
	
