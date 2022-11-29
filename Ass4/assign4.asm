FALSE = 0                                               // #define FALSE 0
TRUE = 1                                                // #define TRUE 0
point_size = 8                                          // point size in bytes
dimension_size = 8                                      // dimension size in bytes
cuboid_size = point_size + dimension_size + 8           // cuboid size in bytes
first_s = 16                                            // first offset
second_s = 16 + cuboid_size                             // second offset
origin_s = 0                                            // origin offset
base_s = point_size                                     // base offset
height_s = point_size + dimension_size                  // height offset
volume_s = point_size + dimension_size + 4              // volume offset
x_s = 0                                                 // x offset
y_s = 4                                                 // y offset
width_s = 0                                             // width offset
length_s = 4                                            // length offset

str_main:
        .string "Initial cuboid values:\n"              // creates the format string for print in main
str1_main:
        .string "\nChanged cuboid values:\n"            // creates the format string for print in main
str_first:
        .string "first"                                 // creates the format string for "first"
str_second:
        .string "second"                                // creates the format string for "second"
str_pC:
        .string "Cuboid %s origin = (%d, %d)\n"         // creates the format string for printCuboid str_pC
str_pC1:
        .string "\tBase width = %d Base length = %d\n"  // creates the format string for printCuboid str_pC1
str_pC2:
        .string "\tHeight = %d\n"                       // creates the format string for printCuboid str_pC2
str_pC3:
        .string "\tVolume = %d\n\n"                     // creates the format string for printCuboid str_pC2

        .balign 4                                       // ensures instructions are properly aligned
        .global main                                    // makes main visible to linker

//=================================================================

//                           newCuboid

//================================================================
alloc = -(16 + cuboid_size) & -16                       // alloc for newCuboid

newCuboid:
        stp     fp,lr,[sp,alloc]!                       // allocates allocNew bytes in stack memory
        mov     fp,sp                                   // stores the contents of x29, x30 to the stack

        define(c_r,x9)                                  // defines x9 regiter for cuboid address
        add     c_r,x29,16                              // calculates cuboid address

        str     xzr,[c_r,origin_s+x_s]                  // c.origin.x = 0
        str     xzr,[c_r,origin_s+y_s]                  // c->origin.y = 0
        mov     w10,2                                   // w10 = 2
        str     w10,[c_r,base_s+width_s]                // c.base.width = 2
        str     w10,[c_r,base_s+length_s]               // c.base.length = 2
        mov     w10,3                                   // w10 = 3
        str     w10,[c_r,height_s]                      // c.height = 3

        ldr     w10,[c_r,base_s+width_s]                // w10 = c->base.width
        ldr     w11,[c_r,base_s+length_s]               // w11 = c->base.length
        ldr     w12,[c_r,height_s]                      // w12 = c->height
        mul     w10,w10,w11                             // w10 = w10 * w11 = c->base.width * c->base.length
        mul     w10,w10,w12                             // w10 = w10 * w12 = c.base.width * c.base.length * c.height
        str     w10,[c_r,volume_s]                      // c.volume = c.base.width * c.base.length * c.height

        ldr     w10,[c_r,origin_s+x_s]                  // loads c.origin.x to w10
        str     w10,[x8,origin_s+x_s]                   // stores c.origin.x in main

        ldr     w10,[c_r,origin_s+y_s]                  // loads c.origin.y to w10
        str     w10,[x8,origin_s+y_s]                   // stores c.origin.y in main

        ldr     w10,[c_r,base_s+width_s]                // loads c.base.width to w10
        str     w10,[x8,base_s+width_s]                 // stores c.base.width in main

        ldr     w10,[c_r,base_s+length_s]               // loads c.base.length to w10
        str     w10,[x8,base_s+length_s]                // stores c.base.length in main

        ldr     w10,[c_r,height_s]                      // loads c.height to w10
        str     w10,[x8,height_s]                       // stores c.height in main

        ldr     w10,[c_r,volume_s]                      // loads c.volume to w10
        str     w10,[x8,volume_s]                       // stores c.volume in main

        ldp     fp,lr,[sp],-alloc                       // deallocates allocated memory in stack
        ret                                             // returns

//=================================================================

//                           move

//================================================================
move:
        stp     fp,lr,[sp,-16]!                         // allocates 16 bytes in stack memory
        mov     fp,sp                                   // stores the contents of x29, x30 to the stack

        ldr     w9,[x0,origin_s+x_s]                    // loads w9 = c.origin.x
        add     w9,w9,w1                                // w9 += deltaX
        str     w9,[x0,origin_s+x_s]                    // stores w9 in c.origin.x

        ldr     w9,[x0,origin_s+y_s]                    // loads w9 = c.origin.y
        add     w9,w9,w2                                // w9 += deltaY
        str     w9,[x0,origin_s+y_s]                    // stores w9 in c.origin.y

        ldp     fp,lr,[sp],16                           // deallocates allocated memory in stack
        ret                                             // returns

//=================================================================

//                           scale

//================================================================
scale:
        stp     fp,lr,[sp,-16]!                         // allocates 16 bytes in stack memory
        mov     fp,sp                                   // stores the contents of x29, x30 to the stack

        ldr     w9,[x0,base_s+width_s]                  // loads w9 = c.base.width
        mul     w9,w9,w1                                // w9 *= factor
        str     w9,[x0,base_s+width_s]                  // stores w9 in c.base.width

        ldr     w9,[x0,base_s+length_s]                 // loads w9 = c.base.length
        mul     w9,w9,w1                                // w9 *= factor
        str     w9,[x0,base_s+length_s]                 // stores w9 in c.base.length

        ldr     w9,[x0,height_s]                        // loads w9 = c.height
        mul     w9,w9,w1                                // w9 *= factor
        str     w9,[x0,height_s]                        // stores w9 in c.height

        ldr     w9,[x0,base_s+width_s]                  // w9 = c.base.width
        ldr     w10,[x0,base_s+length_s]                // w10 = c.base.length
        ldr     w11,[x0,height_s]                       // w11 = c.height
        mul     w9,w9,w10                               // w9 = w9 * w10 = c.base.width * c.base.length
        mul     w9,w9,w11                               // w9 = c.base.width * c.base.length * c.height
        str     w9,[x0,volume_s]                        // c.volume = c.base.width * c.base.length * c.height

        ldp     fp,lr,[sp],16                           // deallocates allocated memory in stack
        ret                                             // returns

//=================================================================

//                           printCuboid

//================================================================
printCuboid:
alloc = -(16+8) & -16                                   // memory spaces for printCuboid function
x19_s = 16						// x19 offset
        stp     fp,lr,[sp,alloc]!                       // allocates alloc_pr bytes in stack memory
        mov     fp,sp                                   // stores the contents of x29, x30 to the stack

	str	x19,[fp,x19_s]				// saves x19 on stack
	mov	x19,x1					// x19 = $cuboid

print0:
        mov     x1,x0                                   // sets 2nd argument to char* name
        adrp    x0,str_pC                               // puts format string to x0
        add     x0,x0,:lo12:str_pC                      // sets 1st argument to printf
        ldr     w2,[x19,origin_s+x_s]                   // loads c.origin.x to 3rd argument
        ldr     w3,[x19,origin_s+y_s]                   // loads c.origin.y to 4th argument
        bl      printf                                  // calls prinf

print1:
        adrp    x0,str_pC1                              // puts format string to x0
        add     x0,x0,:lo12:str_pC1                     // sets 1st argument to printf
        ldr     w1,[x19,base_s+width_s]                 // loads c.base.width to 2nd argument
        ldr     w2,[x19,base_s+length_s]                // sets 3rd argument to c.base.length
        bl      printf                                  // calls prinf

print2:
        adrp    x0,str_pC2                              // puts format string to x0
        add     x0,x0,:lo12:str_pC2                     // sets 1st argument to printf
        ldr     w1,[x19,height_s]                       // sets 2nd argument to c.height
        bl      printf                                  // calls prinf

print3:
        adrp    x0,str_pC3                              // puts format string to x0
        add     x0,x0,:lo12:str_pC3                     // sets 1st argument to printf
        ldr     w1,[x19,volume_s]                       // sets 2nd argument to c.volume
        bl      printf                                  // calls prinf
	
	ldr	x19,[fp,x19_s]				// restores x19
        ldp     fp,lr,[sp],-alloc	                // deallocates allocated memory in stack
        ret                                             // returns

//=================================================================

//                           equalSize

//================================================================
alloc = -(16 + 4) & -16                        		// alloc for equalSize

equalSize:
        stp     fp,lr,[sp,alloc]!         		// allocates allocEqualiSize bytes in stack memory
        mov     fp,sp                                   // stores the contents of x29, x30 to the stack

        mov     w9,FALSE                                // w9 = FALSE = 0
        str     w9,[sp,16]                              // result = FALSE

        ldr     w9,[x0,base_s+width_s]                  // w9 = c1->base.width
        ldr     w10,[x1,base_s+width_s]                 // w10 = c2->base.width
        cmp     w9,w10                                  // compares c1->base.width and c2->base.width
        b.ne    else                                    // if != branches to else

        ldr     w9,[x0,base_s+length_s]                 // w9 = c1->base.length
        ldr     w10,[x1,base_s+length_s]                // w10 = c2->base.length
        cmp     w9,w10                                  // compares c1->base.length and c2->base.length
        b.ne    else                                    // if != branches to else

        ldr     w9,[x0,height_s]                        // w9 = c1->height
        ldr     w10,[x1,height_s]                       // w10 = c2->height
        cmp     w9,w10                                  // compares c1->height and c2->height
        b.ne    else                                    // if != branches to else

       mov     w9,TRUE                                  // w9 = TRUE = 1
        str     w9,[sp,16]                              // result = 1

else:   ldr     w0,[sp,16]                              // returns result

        ldp     fp,lr,[sp],-alloc		        // deallocates allocated memory in stack
        ret                                             // returns

//=================================================================

//                            main

//================================================================
alloc = -(16 + cuboid_size*2) & -16


main:   stp     fp,lr,[sp, alloc]!                      // allocates alloc bytes in stack memory
        mov     fp,sp                                   // stores the contents of x29, x30 to the stack

        define(first_base,x19)                          // defines x19 register for first address
        define(second_base,x20)                         // defines x19 register for second address

        add     first_base,fp,first_s                   // caculates first address
        add     second_base,fp,second_s                 // caculates second address

        mov     x8,first_base                           // x8 = first address
        bl      newCuboid                               // first = newCuboid()
gdb1:
        mov     x8,second_base                          // x8 = second address
        bl      newCuboid                               // second = newCuboid()
gdb2:
        adrp    x0,str_main                             // puts format string to x0
        add     x0,x0,:lo12:str_main                    // sets 1st argument to printf
        bl      printf                                  // calls printf

printC1_before:
        ldr     x0,=str_first                           // sets 1st parameter to "first"
        mov     x1,first_base                           // sets 2nd parameter to &first
        bl      printCuboid                             // calls printCuboid("first",&first)

printC2_before:
        ldr     x0,=str_second                          // sets 1st parameter to "second"
        mov     x1,second_base                          // sets 2nd parameter to &second
        bl      printCuboid                             // calls printCuboid("second",&second)

if:
        mov     x0,first_base                           // sets 1st parameter to first address
        mov     x1,second_base                          // sets 1st parameter to second address
        bl      equalSize                               // calls equalSize(&first,&second)

        cmp     w0,1                                    // compares result outputed by equalSize(&first,&second)
        b.ne    gdb4	                                // if = 0 (FALSE), branches to print2_main

        mov     x0,first_base                           // sets 1st parameter to first address
        mov     w1,3                                    // sets 2nd parameter to 3
        mov     w2,-6                                   // sets 3rd parameter to -6
        bl      move                                    // calls move(&first, 3, -6)
gdb3:
        mov     x0,second_base                          // sets 1st parameter to second address
        mov     w1,4                                    // sets 2nd parameter to 4
        bl      scale                                   // calls scale(&second,4)
gdb4:
        adrp    x0,str1_main                            // puts format string to x0
        add     x0,x0,:lo12:str1_main                   // sets 1st argument to printf
        bl      printf                                  // calls printf
printC1:
        ldr     x0,=str_first                           // sets 1st parameter to "first"
        mov     x1,first_base                           // sets 2nd parameter to &first
        bl      printCuboid                             // calls printCuboid("first",&first)

printC2:
        ldr     x0,=str_second                          // sets 1st parameter to "second"
        mov     x1,second_base                          // sets 2nd parameter to &second
        bl      printCuboid                             // calls printCuboid("second",&second)

return:
        mov     x0,0                                    // returns 0
        ldp     fp,lr,[sp],-alloc                       // restores stack
        ret                                             // returns to OS

