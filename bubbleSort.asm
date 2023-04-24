#bubble sort test test



.data
# 1 or 2 arrays to test with

.text
main:

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