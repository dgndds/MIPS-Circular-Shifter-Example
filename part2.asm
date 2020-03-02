	.text
main:
	lw $s0, size
	
	jal initializeArray
	
	### Pass array address and size ###
	add $a0, $zero, $v0
	move $a1, $v1
	
	jal bubbleSort
	
	jal processArray
	
	### End of the program ###
	li $v0, 10
	syscall

initializeArray:
	### Make space in stack and save registers ###
	addi $sp,$sp,-16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
readSize:
	### Ask for size of the array ###
	li $v0, 4
	la $a0, askMsg
	syscall
	
	### Read the value ###
	li $v0,5
	syscall
	
	### Save value to the register ###
	add $s1, $zero, $v0
	
	### Branch according to input
	bgt $v0,$s0,readSize
	blt $v0,$s0,generateNumbers
	
generateNumbers:
	li $a1, 100000  #max bound.
	li $a0, 1       #min bound.
   	li $v0, 42      #generates the random number.
    	syscall
    	
    	### Save it to the array ###
	sw $a0, array($s2)
	addi $s2,$s2,4
	
	### Increment counter ###
	addi $s3,$s3,1
	
	### Generate until size ###
	blt $s3,$s1,generateNumbers
    	
    	### Return adress and size of the array ###
	la $v0, array
	move $v1, $s1
	
	### Deallocate the stack space ###
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp,$sp,16
	
	### Return ###
	jr $ra

bubbleSort: 
	### Allocate memory in stack ###
	addi $sp,$sp,-40
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $a0, 32($sp)
	sw $a1, 36($sp)
	
sort:	
	### Initialize values ###
	add $s0, $zero, $a0  # Address of the array 
	add $s1, $zero, $a1  # Size of the array
	addi $s2, $s2, 0    # counter of outer
	addi $s6, $s6, 1     # counter of inner
	add $s5, $zero, $zero  # temp register
	add $s7, $zero, $zero  # temp register
	
  	add $s2, $zero, $zero        # Initialize beginning  
start_loop_1:  
  	beq $s2, $s1, end_loop_1  

  	li $s6, 0        # Initialize beginning
  	sub $s7, $s1, $s2  
  	subi $s7, $s7, 1  
start_loop_2:  
  	beq $s6, $s7, end_loop_2  
  	addi $s6, $s6, 1    # Increment counter 
  	 
  	### Get data from index ###
	lw $s3, 0($s0) #First data
	lw $s4, 4($s0) #second data
	
	### Swap if greater ###
	bge  $s3,$s4,swap  	
	
swap_return:
	### Increment adress ###
	addi $s0, $s0, 4
  	b start_loop_2  
	end_loop_2:  
	
	### Reset ###
	move $s0,$a0
  	addi $s2, $s2, 1    # Increment counter  
  	
  	b start_loop_1  
  	
end_loop_1:
	
	### Deallocate stack ###
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $a0, 32($sp)
	lw $a1, 36($sp)
 	addi $sp,$sp,40
 	
 	### return ###
	jr $ra
	
swap:
	### Swap ###
	move $s5,$s3
	move $s3,$s4
	move $s4,$s5
	
	### First address ###
	### Second address ###
	sw $s3, 0($s0)
	sw $s4, 4($s0)
	
	### return back ###
	j swap_return
	
processArray:
	### Allocate memory in stack ###
	addi $sp,$sp,-40
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $a0, 32($sp)
	sw $a1, 36($sp)

	move $s0, $a0 # adress of the array
	move $s1, $a1 # size of the array
	
	addi $s2, $zero, 0 # index
	addi $s3, $zero, 0 # value 
	
	addi $s4, $zero, 0 # index
	addi $s5, $zero, 0 # temp
	addi $s6, $zero, 0 # temp 
	addi $s7, $zero, 0 # temp  

print:
	### Get value ###
	lw $s3, 0($s0)
	
	### Print index ###	
	li $v0,1
	move $a0,$s2
	syscall

	### Print dash ###	
	li $v0,4
	la $a0,dash
	syscall
	
	### Print value ###
	li $v0,1
	move $a0,$s3
	syscall
	
	### Reset temp counter ###
	add $s6, $zero, $zero
	j sumDigit
	
sumDigit_return:
	
	### Print dash ###
	li $v0,4
	la $a0,dash
	syscall
	
	### Print sum of the digits ###
	li $v0,1
	move $a0,$s6
	syscall
	
	j checkPrime

checkPrime_return:
	
	### Print next line ###
	li $v0,4
	la $a0,newLine
	syscall
	
	### Increment counter and memory address ###
	addi $s2, $s2, 1 
	addi $s0, $s0, 4 
	
	### Loop ###
	blt $s2,$s1,print
	
	### Deallocate stack ###
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $a0, 32($sp)
	lw $a1, 36($sp)
 	addi $sp,$sp,40
	
	### return ###
	jr $ra
	
sumDigit:
	### Store value in temp register ###
	move $s5, $s3
if_not_zero:
	
	### Divide value with 10 ###
	div  $s5,$s5,10
	mfhi $s4 #remainder
	mflo $s5 # result
	
	### Add reminder to sum ###
	add $s6,$s6,$s4
	
	### Loop until quotient is zero ###
	bne $s5,$zero,if_not_zero 
	
	### Return ###
	j sumDigit_return 

checkPrime:
	### Store value in temp register ###
	### Init temp register with value 2 ###
	move $s5,$s3
	add  $s4,$zero,2
	
check_loop:
	
	### Divide number with value and store reminder ###
	div $s5,$s4
	mfhi $s7
	
	### check reminder if zero ###
	beq $s7,$zero, notPrime
	
	### Increment value and loop ###
	add $s4,$s4,1
	bne $s4,$s5,check_loop
	
	### return ###
	j isPrime	
	
isPrime:

	### Print dash ###
	li $v0,4
	la $a0,dash
	syscall
	
	### Print result ###
	li $v0,4
	la $a0,yesMsg
	syscall
	
	### Return ###
	j checkPrime_return

notPrime:
	
	### Print dash ###
	li $v0,4
	la $a0,dash
	syscall
	
	### Print result ###
	li $v0,4
	la $a0,notMsg
	syscall
	
	### Return ###
	j checkPrime_return
	
	.data
array:  .space 80
size:   .word 20
askMsg: .asciiz "Size of array: "
newLine: .asciiz "\n"
dash: .asciiz " ------ "
yesMsg: .asciiz	 "Prime"
notMsg: .asciiz	 "Not Prime"