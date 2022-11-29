// File: assign3.asm
// Author: Anh Nguyen
// UCID: 30105311
// Section: CPSC 355 L01 - Tutorial 04
// Date: October 19th, 2022
// Source: Assignment 3
//
// Description: an ARMv8 assembly language that implements
// a c program that sorts an array of integer

SIZE = 40                                       // defines SIZE 40
i_size = 4                                      // i takes 4 bytes in the stack
j_size = 4                                      // j takes 4 bytes in the stack
v_size = SIZE * 4                               // v takes SIZE*4 bytes in the stack
alloc = - (16 + i_size + j_size + v_size) & -16 // caculates stack storage for sp, fp, i,j and v
v_s = 16                                        // v offset relative to fp
i_s = 16 + v_size                               // i offset relative to fp
j_s = 16 + v_size + 4                           // j offset relative to fp

str:    .string "v[%d]: %d\n"                   // creates the format string for printing array
str1:   .string "\nSorted array:\n"             // creates the format string for print_head

        .global main                            // ensures instructions are properly aligned
        .balign 4                               // makes main visible to linker

main:   stp     fp, lr, [sp, alloc]!            // allocates alloc bytes in stack memory to store x29, x30, v, i, and j
        mov     fp, sp                          // stores the contents of x29, x30 to the stack

        define(base_r,x19)                      // defines register for array base address
        define(index_r,w20)                     // defines register for index

        mov     index_r,0      	                // i = 0
        str     index_r,[fp,i_s]                // stores the value 0 to i in stack

        add	base_r,fp,v_s                   // calculates array base address

        bl      loop_test1                      // starts loop 1

loop_body1:
        bl      rand                            // calles rand function
        and     w0,w0,0xFF                      // w0 = rand() & 0xFF

        ldr     index_r,[fp,i_s]                // loads i in stack to index
        str     w0,[base_r,index_r,SXTW 2]      // v[i] = rand() & 0xFF

print_original:
        adrp    x0,str                          // puts format string to x0
        add     x0,x0, :lo12:str                // sets 1st argument to printf
        ldr     index_r,[fp,i_s]                // loads i from stack
        mov     w1,index_r                      // sets argument 2 to i

        ldr     w21,[base_r,index_r,SXTW 2]     // loads v[i] from the stack
        mov     w2,w21                          // sets argument 3 to v[i]
        bl      printf                          // calls printf

        add     index_r,index_r,1               // i = i + 1
        str     index_r,[fp,i_s]                // stores i to the stack

loop_test1:
        ldr     index_r,[fp,i_s]                // loads i from the stack
        cmp     index_r,SIZE                    // compares i with SIZE
        b.lt    loop_body1                      // if i < SIZE, stays in the loop
debug1:
        mov     w21,SIZE                        // initializes w21 = SIZE
        add     index_r,w21,-1                  // i = SIZE - 1
        str     index_r,[fp,i_s]                // stores i in stack memory

        add     sp,sp,-4&-16                    // allocates memory for temporary var temp

        bl      loop_test2a                     // branches to loop_test2a

loop_body2a:
        mov     index_r,1                       // j = 1
        str     index_r,[fp,j_s]                // stores j in stack memory
        bl      loop_test2b                     // starts loop2b

loop_body2b:
        ldr     index_r,[fp,j_s]                // index = j
        ldr     w22,[base_r,index_r,SXTW 2]     // loads v[j]
        add     index_r,index_r,-1              // index = j - 1
        ldr     w21,[base_r,index_r,SXTW 2]     // loads v[j-1]
if:
        cmp     w21,w22                         // compares v[j-1] and v[j]
        b.le    pre_test2b                      // if v[j-1] <= v[j] branches to pre_test2b

        ldr     index_r,[fp,j_s]                // index = j
        add     index_r,index_r,-1              // index = j - 1
        ldr     w21,[base_r,index_r,SXTW 2]     // loads v[j-1]
        str     w21,[fp,-4]                     // stores temp = v[j-1] in memory

        ldr     index_r,[fp,j_s]                // index = j
        ldr     w22,[base_r,index_r,SXTW 2]     // loads v[j]
        add     index_r,index_r,-1              // index = j - 1
        str     w22,[base_r,index_r,SXTW 2]     // stores v[j] in v[j-1]

        ldr     index_r,[fp,j_s]                // index = j
        ldr     w21,[fp,-4]                     // load temp
        str     w21,[base_r,index_r,SXTW 2]     // stores temp in v[j]

pre_test2b:
        ldr     index_r,[fp,j_s]                // loads j
        add     index_r,index_r,1               // j = j + 1
        str     index_r,[fp,j_s]                // stores in stack

loop_test2b:
        ldr     w21,[fp,i_s]                    // loads i from stack
        ldr     index_r,[fp,j_s]                // loads j from stack
        cmp     index_r,w21                     // compares j and i
        b.le    loop_body2b                     // if j >= i, stays in loop

pre_test2a:
        ldr     index_r,[fp,i_s]                // loads i from stack
        add     index_r,index_r,-1              // i = i - 1
        str     index_r,[fp,i_s]                // stores i in stack

loop_test2a:
        ldr     index_r,[fp,i_s]                // loads i from the stack
        cmp     index_r,0                       // compares i with 0
        b.ge    loop_body2a                     // if i >= 0, stays in loop

        add     sp,sp,-(-4&-16)                 // deallocates memory for temp

debug2:
	adrp    x0,str1                         // puts format string to x0
        add     x0,x0, :lo12:str1               // sets 1st argument to printf
        bl      printf                          // calls printf

setup_print_loop:
        mov     index_r,0                       // i = 0
        str     index_r,[fp,i_s]                // stores i to stack

        bl      print_loop_test                 // starts print loop test

print_loop_body:
        adrp    x0,str                          // puts format string to x0
        add     x0,x0, :lo12:str                // sets 1st argument to printf
        ldr     index_r,[fp,i_s]                // loads i from stack
        mov     w1,index_r                      // sets argument 2 to i
        ldr     w21,[base_r,index_r,SXTW 2]     // loads v[i]
        mov     w2,w21                          // sets argument 3 to v[i]
        bl      printf                          // calls printf

        add     index_r,index_r,1               // i = i + 1
        str     index_r,[fp,i_s]                // stores i in stack

print_loop_test:
        ldr     index_r,[fp,i_s]                // loads i from stack
        cmp     index_r,SIZE                    // compares i with SIZE
        b.lt    print_loop_body                 // if i < SIZE, stays in loop

return:
        mov     x0,0                            // returns 0
        ldp     fp,lr,[sp],-alloc               // restores the stack
        ret                                     // returns to OS
