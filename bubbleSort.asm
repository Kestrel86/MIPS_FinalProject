# Ruben Barbero, Youssef Mikhail, Jeffery Rodas, Andrew John Valdez
# CS 2640.02
# Final Project: Bubble Sort
# This program will:
# Use the bubble sort algorithm to sort two hard-coded arrays
# Print both arrays before nad after sorting.


# Applies the bubble sort algorithm to the given array with the given array size.
.macro bubbleSort(%arrayLabel, %arraySize)
#load arrays in the address
la $s7, %arrayLabel
	
#initalize loop counters ($s0 for outer iteration loop, $s1 for inner "swap" loop) 
li $s0, 0
li $s1, 0

#initialize "limit" for loops at $s6.  This limit will be adjusted accordingly, but it should start as arraySize.
li $s6, %arraySize
	
loop:
	sll $t7, $s1, 2					#multiply $s1 by 2 and put it in t7
	add $t7, $s7, $t7 				#add the address of numbers to t7

	lw $t0, 0($t7)  				#load numbers[j]	
	lw $t1, 4($t7) 					#load numbers[j+1]

	slt $t2, $t0, $t1				#if t0 < t1
	bne $t2, $zero, increment

	sw $t1, 0($t7) 					#swap
	sw $t0, 4($t7)

increment:	

	addi $s1, $s1, 1				#increment s1
	sub $s5, $s6, $s0 				#subtract s0 from s6 ( $s5 = # of elements - # of total passes)

	bne  $s1, $s5, loop				# if s1 (counter for second loop) does not equal # of elements - # of total passes - 1, loop
							# This case simply moves the pointer again over 1.  
							# In other words, goes to the next iteration of the inner "swap" loop
							
	# This below case is for when we reach the limit of the "swap" loop,
	# and now must go to the next iteration of the outer loop.
	addi $s0, $s0, 1 				#otherwise add 1 to s0
	li $s1, 0 					#reset s1 to 0

	bne  $s0, $s6, loop				# go back through loop with s0 = s0 + 1
.end_macro


# Prints a string at the given label
.macro printString(%stringLabel)
li $v0, 4
la $a0, %stringLabel
syscall
.end_macro


# Loops using $t3 as a loop counter, and $t4 as address
.macro printArray(%arrayLabel, %arraySize)
# Initialize loop counter + starting address
move $t3, $zero
la $t4, %arrayLabel

# Print an open bracket
printString(arrayOpenBracket)

printArrayLoop:
	# Increment loop counter
	addi $t3, $t3, 1

	# Print current element.
	li $v0, 1
	lw $a0, ($t4)
	syscall

	# Move address to point to the next element in the array
	addi $t4, $t4, 4
	
	# If loop counter is at arraySize, leave loop
	beq $t3, %arraySize, outPrintArrayLoop
	
	# Print space if there is more elements to pring
	printString(arrayCommaSpace)

	# Otherwise, loop again
	j printArrayLoop
	
# After exiting loop,
outPrintArrayLoop:
	# Print an end bracket
	printString(arrayClosedBracket)
.end_macro





.data
array1: .word 8, 7, 2, 3, 5, 10, 1, 4, 6, 9
array2: .word 7, 35, 56, 25, 87, 15, 9
unsortedMessage: .asciiz "Unsorted Arrays: "
sortedMessage: .asciiz "\nSorted Arrays: "
arrayOneMessage: .asciiz "\nArray 1: "
arrayTwoMessage: .asciiz "\nArray 2: "
arrayOpenBracket: .asciiz "["
arrayClosedBracket: .asciiz "]"
arrayCommaSpace: .asciiz ", "

.text
main:
	#print the first message
	printString(unsortedMessage)
	# Print the first array (unsorted)
	printString(arrayOneMessage)
	printArray(array1, 10)
	
	# Print the second array (unsorted)
	printString(arrayTwoMessage)
	printArray(array2, 7)
	
	# Sort both arrays
	bubbleSort(array1, 10)
	bubbleSort(array2, 7)
	
	# Print the sorted message
	printString(sortedMessage)
	
	# Print the first array (sorted)
	printString(arrayOneMessage)
	printArray(array1, 10)
	
	# Print the second array (sorted)
	printString(arrayTwoMessage)
	printArray(array2, 7)
	
exit:
	li $v0, 10
	syscall
