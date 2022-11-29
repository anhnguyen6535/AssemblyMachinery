// File: a5b.asm
// Author: Anh Nguyen
// UCID: 30105311
// Section: CPSC 355 L01 - Tutorial 04
// Date: November 22nd, 2022
// Source: Assignment 5
//
// Description: reate an ARMv8 assembly language program to accept 
// as command line arguments two strings representing a date in the 
// format mm dd. This program will print the name of month, the day 
// (with the appropriate suffix), and the season for this date.

string_size = 28				// month + day + th + season = 8 + 4 + 8 + 8
alloc = -(16 + string_size) & -16
month_s = 16
day_s = 16 + 8
suffix_s = 16 + 8 + 4
season_s = 16 + 8 + 4 + 8
	.text
ouput:	.string	"%s %d%s is %s\n"		// output string
jan:	.string	"January"			// January string
feb:	.string	"February"			// February string
mar:	.string "March"				// March string
apr:	.string "April"				// April string
may:	.string	"May"				// May string
jun:	.string "June"				// June string
jul:	.string	"July"				// July string
aug:	.string	"August"			// August string
sep:	.string	"September"			// September string
oct:	.string	"October"			// October string
nov:	.string	"November"			// November string
dec:	.string "December"			// December string
	
spr_m:	.string	"Spring"			// Spring string
sum_m:	.string	"Summer"			// Summer string
fal_m:	.string	"Fall"				// Fall string
win_m:	.string	"Winter"					// Winter string
str:	.string "test: %s %d\n"

th:	.string "th"
st:	.string	"st"
nd:	.string	"nd"
rd:	.string	"rd"

	.data
seasons:.dword	win_m,spr_m,sum_m,fal_m				// Array of season strings
months: .dword	jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec	//Array of month strings	

	.text
	.balign	4
	
a_fc:
	stp     x29,x30,[sp,16]!
        mov     x29,sp
	mov	w9,0
	
	ldp	x29,x30,[sp],-16
	ret

	.global main
main:
	stp	x29,x30,[sp,alloc]!
	mov	x29,sp

	define(argc_r,w19)					// define register for argument count
	define(argv_r,x20)					// define register for arguments array
	define(month_r,w21)
	define(day_r,w22)

	mov	argc_r,w0					// copy argument count
	mov	argv_r,x1					// copy arguments array

	bl	a_fc
	mov	w23,1						// index 1
	ldr	x0,[argv_r,w23,sxtw 3]				// argv[1] = month
	bl	atoi						// convert string to number
	mov     month_r,w0					// load month number to month_r

	mov	w23,2						// index 2
	ldr     x0,[argv_r,w23,sxtw 3]                          // argv[2] = day
        bl      atoi						// convert string to number
	mov	day_r,w0					// load day nember to day_r
	str	day_r,[x29,day_s]				// store day to stack

find_month:
        adrp    x23,months
        add     x23,x23,:lo12:months

	add	w24,month_r,-1
        ldr     x0,[x23,w24,sxtw 3]     			//size is 64 => multply by 8 = 2^3
	str	x0,[x29,month_s]				// store string of month to stack

find_suffix:
	cmp	day_r,1
	b.eq	st_case
	cmp	day_r,2
	b.eq	nd_case
	cmp	day_r,3
	b.eq	rd_case
	cmp	day_r,21
	b.eq	st_case
	cmp	day_r,22
	b.eq	nd_case
	cmp	day_r,23
	b.eq	rd_case
	cmp	day_r,31
	b.eq	st_case
	
	adrp    x0,th
        add     x0,x0,:lo12:th
	b	final
st_case:
	adrp	x0,st
	add	x0,x0,:lo12:st
	b 	final
nd_case:
	adrp    x0,nd
        add     x0,x0,:lo12:nd
	b	final
rd_case:
	adrp    x0,rd
        add     x0,x0,:lo12:rd
final:	str	x0,[x29,suffix_s]		

find_season:
	adrp    x23,seasons
        add     x23,x23,:lo12:seasons

	cmp	month_r,2
	b.le	winter

winter:
        mov     w24,0
        ldr     x0,[x23,w24,sxtw 3]                             //size is 64 => multply by 8 = 2^3
        str     x0,[x29,month_s]                                // store string of month to stack

test:	adrp    x0,str
        add     x0,x0,:lo12:str
	ldr	x1,[x29,suffix_s]
//	ldr	w2,[x29,day_s]
	mov	w2,day_r
	bl 	printf

return:
	mov     x0,0                            // returns 0
        ldp     fp,lr,[sp],-alloc                // restores the stack
        ret                                     // returns to OS
		
