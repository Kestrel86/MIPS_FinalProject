#bubble sort test test
.data
array1: .word 8, 7, 2, 3, 5, 10, 1, 4, 6, 9
array2: .word 7, 35, 56, 25, 87, 15, 9
message: .asciiz "Unsorted Array:\n1- (8, 7, 2, 3, 5, 10, 1, 4, 6, 9)\n2- (100, 35, 56, 25, 87, 15, 9)"
sort: .asciiz "\nSorted Array: "
.text
main:
	#print the first message
	li $v0, 4
	la $a0, message
	syscall
	
	#load arrays in the address
	la $s7, array1
	#la $s1, array2
	
	#initalize loop counter $t0 array1
	li $s0, 0
	li $s6, 9
	
	li $s1, 0
	
	li $t3, 0
	li $t4, 10
	#initalize loop counter $t1 array2
	#move $s1, $zero
	
	#print the first message
	li $v0, 4
	la $a0, sort
	syscall
	
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

	addi $s1, $s1, 1				#increment t1
	sub $s5, $s6, $s0 				#subtract s0 from s6

	bne  $s1, $s5, loop				#if s1 (counter for second loop) does not equal 9, loop
	addi $s0, $s0, 1 				#otherwise add 1 to s0
	li $s1, 0 					#reset s1 to 0

	bne  $s0, $s6, loop				# go back through loop with s1 = s1 + 1
	
print:
	beq $t3, $t4, exit				#if t3 = t4 go to final
	
	lw $t5, 0($s7)					#load from numbers
	
	li $v0, 1					#print the number
	move $a0, $t5
	syscall

	li $a0, 32					#print space
	li $v0, 11
	syscall
	
	addi $s7, $s7, 4				#increment through the numbers
	addi $t3, $t3, 1				#increment counter

	j print
	

exit:
	li $v0, 10
	syscall
