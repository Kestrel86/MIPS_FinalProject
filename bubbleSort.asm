# Teamsters: Ruben Barbero, Youssef Mikhail, Jeffery Rodas, Andrew John Valdez 
# CS 2640.02
# Final Project: Bubble Sort
# This program will:
# Use the bubble sort algorithm to sort two hard-coded arrays
# Print both arrays before nad after sorting.


# Applies the bubble sort algorithm to the given array with the given array size.
.macro bubbleSort(%arrayLabel, %arraySize)
	#storing user input to decide which sort to do
	add $t5, $t5, $t0
	
	#load arrays in the address
	la $s7, %arrayLabel
	
	#initalize loop counters ($s0 for outer iteration loop, $s1 for inner "swap" loop) 
	li $s0, 0
	li $s1, 0

	#initialize "limit" for loops at $s6.  This limit will be adjusted accordingly, but it should start as arraySize.
	li $s6, %arraySize
	j whichLoop
# Jeffrey R.
whichLoop:
	#deciding which sort to do 
	beq $t5, 1, loop 
	beq $t5, 2, loop2

# Andrew V	
loop: #low to high
	sll $t7, $s1, 2		#multiply $s1 by 2 and put it in t7
	add $t7, $s7, $t7 	#add the address of numbers to t7

	lw $t0, 0($t7)  		#load numbers[j]	
	lw $t1, 4($t7) 		#load numbers[j+1]

	slt $t2, $t0, $t1	#if t0 < t1
	beq $t1, $t0, increment  #if the numbers are the same then it will go to increment
	bne $t2, $zero, increment

	#swap
	sw $t1, 0($t7) 		
	sw $t0, 4($t7)
	
	j loop

# Jeffrey R.	
loop2: #high to low
	sll $t7, $s1, 2		#multiply $s1 by 2 and put it in t7
	add $t7, $s7, $t7 	#add the address of numbers to t7

	lw $t0, 0($t7)  		#load numbers[j]	
	lw $t1, 4($t7) 		#load numbers[j+1]

	sgt $t2, $t0, $t1	#if t0 > t1
	beq $t1, $t0, increment  #if the numbers are the same then it will go to increment
	bne $t2, $zero, increment

	#swap
	sw $t1, 0($t7) 		
	sw $t0, 4($t7)

increment:	

	addi $s1, $s1, 1		#increment s1
	sub $s5, $s6, $s0 	#subtract s0 from s6 ( $s5 = # of elements - # of total passes)

	bne  $s1, $s5, whichLoop		# if s1 (counter for second loop) does not equal # of elements - # of total passes - 1, loop
					# This case simply moves the pointer again over 1.  
					# In other words, goes to the next iteration of the inner "swap" loop
							
	# This below case is for when we reach the limit of the "swap" loop,
	# and now must go to the next iteration of the outer loop.
	addi $s0, $s0, 1 		#otherwise add 1 to s0
	li $s1, 0 			#reset s1 to 0

	bne  $s0, $s6, whichLoop		# go back through loop with s0 = s0 + 1
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
	add $t4, $t5, $t4 	#used to avoid address if sort from high to low
	# Print an open bracket
	printString(arrayOpenBracket)

printArrayLoop:

	# Print current element.
	li $v0, 1
	lw $a0, 0($t4)
	syscall
	
	# Increment loop counter
	addi $t3, $t3, 1

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

.macro menu
	#print a menu
	printString(option1)
.end_macro

.data
arr: .space 40
unsortedMessage: .asciiz "Unsorted Array: "
sortedMessage: .asciiz "\nSorted Array: "
arrayOpenBracket: .asciiz "["
arrayClosedBracket: .asciiz "]"
arrayCommaSpace: .asciiz ", "
enter: .asciiz "Enter 10 integers individually:\n"
option1: .asciiz "\nPlease enter 1 of 3 choices:\n1) Sort Array (low to high)\n2) Sort Array (high to low)\n3) Exit program\nInput: "
errorMessage: .asciiz "Please input a number from the given options"

.text
main:
	j Menu

# Youssef
Menu:
	menu
	#getting user input for prompt
	li $v0,5
    syscall
    move $t0, $v0
    #comparing user input
    beq $t0,3,exit
    bgt $t0, 3, error
    blt $t0, 0, error
    #print message and getting array
    printString(enter)
    j input
  	
input: 	
	#getting user input (10 integers)
	beq $s3,40,oneOrTwo
	li $v0,5
    syscall
    sw $v0,arr($s3)
    add $s3,$s3,4
	j input

# Jeffrey R.	
oneOrTwo: 
	#finding which sort it should do
	beq $t0, 1, lowToHigh
    beq $t0, 2, highToLow
	
lowToHigh:
	# Print the first array (unsorted)
	printString(unsortedMessage)
	printArray(arr, 10)
	
	#array
	bubbleSort(arr, 10)
	
	# Print the sorted message
	printString(sortedMessage)
	
	# Initialize loop counter + starting address
	li $t5, 0 #initializing $t5 for the print array
	printArray(arr, 10)
	
	#reset register s3
	li $s3,0
	
	j Menu
	
highToLow:
	#print the first message
	printString(unsortedMessage)
	printArray(arr, 10)
	
	#array
	bubbleSort(arr, 10)
	
	# Print the sorted message
	printString(sortedMessage)
	
	# Initialize loop counter + starting address
	li $t5, 4 #avoiding the address of the array
	printArray(arr, 10)
	
	#reset register s3
	li $s3,0
	
	j Menu
	
error: 
	printString(errorMessage)
	j Menu
exit:
	li $v0, 10
	syscall
