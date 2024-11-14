########### Jason Wu ############
########### JASONWU1 ################
########### 114474379 ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl hash
#part1
hash:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	add $s0, $s0, $a0 #address of string
	li $s1, 0 #total decimal amount
	
	loopHash:
		lb $t0, 0($s0)
		beqz $t0, quitHash #when the string ends, return the total
		add $s1, $s1, $t0
		addi $s0, $s0, 1 #increment
		j loopHash #loop again
	
		quitHash:#might have to use stack to store $ra so we can jump back
			move $v0, $s1
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
  			jr $ra

.globl isPrime
#part2
#a prime number is a number that is no divisible by anything besides 1 and the number itself
#any number less than 2, then it is not prime, ex: 0, 1
isPrime:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	add $s0, $s0, $a0 #since $a0 is a integer, $s0 should now hold the value
	li $s1, 2 #our divider, it will be incremented
	div $s0, $s1
	mflo $s2
	li $t0, 1
	li $t1, 2
	ble $s0, $t0, notPrime #if the integer is less than or equal to 1, it is not prime
	beq $s0, $t1, Prime
	loopPrimeCheck:
		div $s0, $s1
		mfhi $t0
		beq $t0, $0, notPrime
		bge $s1, $s2, Prime
		addi $s1, $s1, 1
		j loopPrimeCheck
	
		Prime:
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
			li $v0, 1
			jr $ra
		
		notPrime:
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
			li $v0, 0
			jr $ra
		
.globl lcm
#part3
lcm:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s3, 8($sp)
	sw $s4, 12($sp)
	sw $ra, 16($sp)
	
	add $s0, $s0, $a0 #num1
	add $s1, $s1, $a1 #num2
	bgt $s0, $s1, checkDivisone
	bgt $s1, $s0, checkDivistwo
	checkDivisone:
		div $s0, $s1
		mflo $s3
		mfhi $s4
		li $t1, 0
		li $t0, 0
		add $t0, $t0, $s0
		beq $s4, $t1, returnLCM
	checkDivistwo:
		div $s1, $s0
		mflo $s3
		mfhi $s4
		li $t1, 0
		li $t0, 0
		add $t0, $t0, $s1
		beq $s4, $t1, returnLCM
	li $s3, 1 #num1 multiplier
	li $s4, 1 #num2 multiplier
	beq $s0, $s1, returnEasyLCM
	
	loopLCM:
		mult $s0, $s3
		mfhi $t0
		mflo $t0 #product of num1 and multiplier
		mult $s1, $s4
		mfhi $t1
		mflo $t1 #product of num2 and multiplier
		beq $t0, $t1, returnLCM
		bgt $t0, $t1, increaseNumTwo
		bgt $t1, $t0, increaseNumOne	
		
		increaseNumTwo:
			addi $s4, $s4, 1
			j loopLCM
		
		increaseNumOne: 
			addi $s3, $s3, 1
			j loopLCM
		
		returnEasyLCM:
			add $v0, $s0, $0
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s3, 8($sp)
			lw $s4, 12($sp)
			lw $ra, 16($sp)	
			addi $sp, $sp, 20
			jr $ra
		returnLCM:
			add $v0, $t0, $0
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s3, 8($sp)
			lw $s4, 12($sp)
			lw $ra, 16($sp)	
			addi $sp, $sp, 20
			jr $ra
		
.globl gcd
#part4
gcd:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	add $s0, $s0, $a0 #num1
	add $s1, $s1, $a1 #num2
	beq $s1, $s0, returnGCD
	loopGCD:
		beq $s1, $s0, returnGCD
		bgt $s0, $s1, subFromNumOne
		bgt $s1, $s0, subFromNumTwo
		
		subFromNumOne:
			sub $s0, $s0, $s1
			j loopGCD
		
		subFromNumTwo:
			sub $s1, $s1, $s0
			j loopGCD
		
		returnGCD:
			add $v0, $s0, $0
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			jr $ra

.globl pubkExp
# part5 Define a function pubkExp that takes an integer z as argument in register $a0 and returns 
# a random number r such that 1 < r < z. Further, z and r are co-prime, that is, the gcd(z,r) = 1.
# To generate a random number in MIPS, use the syscall 42. See MARS Help for usage information.
pubkExp:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s3, 12($sp)
	add $s3, $s0, $a0 #integer z
	randomNumber:
		li $v0, 42
		addi $a1, $s3, 0
		syscall
		beq $a0, $a1, randomNumber
		jal PubkExpGCD
		j returnPubkExp
		
	PubkExpGCD:
		add $s0, $s0, $a0 #num1
		add $s1, $s1, $a1 #num2
		beq $s1, $s0, returnPubkExpGCD
		loopPubkExpGCD:
			beq $s1, $s0, returnPubkExpGCD
			bgt $s0, $s1, subFromPubkExpOne #2 24 2 22 2 20 2 18 2 16 2 14 2 12 2 10 2 8 2 6 2 4 2 2
			bgt $s1, $s0, subFromPubkExpTwo
		
			subFromPubkExpOne:
				sub $s0, $s0, $s1
				j loopPubkExpGCD
		
			subFromPubkExpTwo:
				sub $s1, $s1, $s0
				j loopPubkExpGCD
		
			returnPubkExpGCD:
				li $t1, 1
				bne $s0, $t1, randomNumber
				bne $s1, $t1, randomNumber
				add $v0, $a0, $0
				j returnPubkExp
	returnPubkExp:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		jr $ra

.globl prikExp
# part6 Define a function prikExp that takes two integers, x and y, as input arguments in registers $a0 and $a1. 
# Assume x < y. The function returns an integer z in register $v0, where z is the multiplicative modulo inverse of x mod y.
# In other words, dividing x*z by y will yield a remainder of 1.
prikExp:
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	jal gcd
	li $s0, 1
	bne $v0, $s0, not_prime6	

	move $s0, $a0
	move $s1, $a1 
	li $s2, 0
	li $s3, 1
	
	div $s1, $s0
	mflo $s5	
	mfhi $s4
	
	move $s1, $s0
	move $s0, $s4
	
	div $s1, $s0 	
	mflo $s6	
	mfhi $s4
	
	move $s1, $s0
	move $s0, $s4
	
	div $s1, $s0 	
	mflo $s7	
	mfhi $s4
	
	prikey_loop:
		mult $s3, $s5
		mflo $s5
		sub $s2, $s2, $s5
		move $t9, $a1
		
		div $s2, $t9
		mfhi $t8
		add $s2, $t8, $t9
		div $s2, $t9
		mfhi $t8
	
		move $s2, $s3
		move $s3, $t8
	
		move $s5, $s6
		move $s6, $s7
	
		move $s1, $s0		
		move $s0, $s4
	
		div $s1, $s0 	
		mflo $s7	
		mfhi $s4
	
		beqz $s4, loop_done
		j prikey_loop
	
	loop_done: 
	
		mult $s3, $s5
		mflo $s5
		sub $s2, $s2, $s5
		div $s2, $t9
		mfhi $t8
		add $s2, $t8, $t9
		div $s2, $t9
		mfhi $t8
		move $s2, $s3
		move $s3, $t8
		move $s5, $s6
		move $s6, $s7
		move $s1, $s0		
		move $s0, $s4
		div $s1, $s0 	
		mflo $s7	
		mfhi $s4
		mult $s3, $s5
		mflo $s5
		sub $s2, $s2, $s5
		div $s2, $t9
		mfhi $t8
		add $s2, $t8, $t9
		div $s2, $t9
		mfhi $t8
	
		move $v0, $t8
	j done6
	
	not_prime6:
		li $s0, -1
		move $v0, $s0
	j done6
	
	done6:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36
 	 	jr $ra

.globl encrypt
encrypt:
		
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0
	move $s1, $a1 
	move $s2, $a2
	
	mult $s1, $s2
	mflo $s3		
	
	addi $s1, $s1, -1
	addi $s2, $s2, -1
	
	move $a0, $s1
	move $a1, $s2
	jal lcm
	move $s4, $v0	
	
	move $a0, $s4
	jal pubkExp
	
	move $s5, $v0		
	
	move $s7, $s5		
	addi $s7, $s7, -1 
	move $s6, $s0
	
	encryptloop:
		div $s0, $s3
		mfhi $s1
		mult $s1, $s6
		mflo $s2
		div $s2, $s3
		mfhi $s1
		addi $s7, $s7, -1  
		beqz $s7, encryptdone
		move $s0, $s1
		j encryptloop
		
	encryptdone:
		move $v0, $s1
		move $v1, $s5
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36
 		jr $ra

.globl decrypt
decrypt:
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	move $s0, $a0		
	move $s1, $a1 		
	move $s2, $a2		 
	move $s3, $a3		
	mult $s2, $s3
	mflo $s4		
	addi $s2, $s2, -1	
	addi $s3, $s3, -1	
	move $a0, $s2
	move $a1, $s3
	jal lcm
	move $s5, $v0		
	move $a0, $s1		
	move $a1, $s5		
	jal prikExp
	move $s6, $v0		 
	move $s7, $s6		
	addi $s7, $s7, -1 
	move $t9, $s0
	
	loopDecrypt:
		div $s0, $s4
		mfhi $s2
		mult $s2, $t9
		mflo $s3
		div $s3, $s4
		mfhi $s2
		addi $s7, $s7, -1  
		beqz $s7, decryptDone
		move $s0, $s2
		j loopDecrypt
		
	decryptDone:
		move $v0, $s2
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36
  		jr $ra
