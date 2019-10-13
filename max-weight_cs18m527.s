/******************************************************************************
* file: max-weight_cs18M527.s
* author: Badrinath
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  This is the starter code for assignment 2
  */

  @ BSS section
      .bss

  @ DATA SECTION
.data
data_start: .word 0x205A15E3  
            .word 0x256C8700 
data_end:   .word 0x295468F2 


// This location will store the maximum weight followed
// by the word which had maximum weight
Output:  .word 0xdeadbeef
         .word 0x0

@ TEXT section
      .text

.globl _main




_main:

        // Initialize all the registers
	// r0 -> base register for input word
	// r1 -> end of the input word area in the data section
	// r2,r3,r4, r5 and r6 scratch for per word operation
	// r2 will hold hte current word and will be operated
	// r6 -> backup store for the current workd
	// r7 -> current max wt 
	// r8 -> word having the current max wt
	// Both will be updated in the Output area
	
	mov r0, #0x0
	mov r1, #0x0
	mov r2, #0x0
	mov r3, #0x0
	mov r4, #0x0
	mov r5, #0x0
	mov r6, #0x0 
	mov r7, #0x0   // Current maxmimum weight
        mov r8, #0x0   // word that has current maximum weight

	/* Load the base register in R0 (Data start)
	 * Loop till the base address is <= data_end.
	 * in each loop iteration, count the number of bits sets
	 * If the curr_wt > prev_larget_wt, 
         */
	 

	ldr r0, =data_start
	ldr r1, =data_end

data_loop:

        #check the end address
        #This means we have completed the analysis
        cmp r0, r1
	bgt data_loop_end
        ldr r2, [r0], #4  // load the data into r2 from r0 and increment the address
	mov r6, r2 // store the current word as backup

	// shift and check the bit set, keep counting
 	// if the current wt is > largest_wt, then save the curr_wt as largest_wt
        // and data

        // shift left by one bit to get the carry bit set
        // If carry bit is set, then increment the count
        // Repeat the loop until all the bits are shifted out
        //  this means we will have all zeroes in the register.
        //  This is good even if we dont have additional bits to check
        //  ie, only remaining zeros in the rest of the 32bit word, so 
        //  we can avoid shifting	

	
bit_loop:
	//  shift right by one position
        // Note: if the result after shifting is zero, Z-flag will be set
        //  we will use it break out of the loop for this particular word
	movs r2,r2,LSR#1
	// If the bit in the position was set, we would have it shifted out to 
        //  carry bit is added with r4 < r4 + carry bit + 0
        adc r4,r4,#0  

        // check if we have completed the shifting out all the bits
        //  this can be done by checking with zero, so that if remaining
        // bits are zeros we dont have to shift, ie, we ave taken 
        //  care of all the set bits
        bne bit_loop


	// when we are here, we should compare our bit count with existing bit count
        //  if we are greater than that, then we need to update the current max weight 
        //  with the new value just computed. We should also update the word that has 
        //  maximum weight 
         
	cmp r7, r4
	movlt r7,r4  // if current_max less than r4 (weight) we have just computed, have that in r7
	movlt r8,r6  // r8 contains the value that contains word that has current max_val. updated it too 

	mov r4,#0 
 
	b data_loop
data_loop_end:
	// store the data to output location
	// load the location of the register
	ldr r3, =Output

	// Store the max-wt and autoincrement
        //  so that value can be stored.	
	str r7, [r3], #4 
	str r8, [r3]

	// Branch to self for insepction
	b .  
.end
