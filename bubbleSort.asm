#bubble sort test test
.data
array1: .word 8, 7, 2, 3, 5, 10, 1, 4, 6, 9
array2: .word 100, 35, 56, 25, 87, 15, 9
message: .asciiz "Unsorted Array:\n1-(8, 7, 2, 3, 5, 10, 1, 4, 6, 9)\n2- (100, 35, 56, 25, 87, 15, 9)"
sort: .asciiz "Sorted Array: "
.text
main:
	#print the first message
	li $v0, 4
	la $a0, message
	syscall
	
	#load arrays in the address
	la $s0, array1
	la $s1, array2
	
	#initalize loop counter $t0 array1
	move $t0, $zero
	#initalize loop counter $t0 array2
	move $t1, $zero
	
	#print the first message
	li $v0, 4
	la $a0, sort
	syscall
	
loop:
#bubble sort is made to iterate through an array,
#swapping values next to each other if they are smaller or large
#can take a ton of time looping until all values have been swapped to 
#a correct organized array

#Loop constantly, checking if the next value is bigger
#or smaller than the one before, if smaller, 
#then swap with the value to the left
#continuing until the end (1 pass)

#loop until all is sorted

exit:
	li $v0, 10
	syscall