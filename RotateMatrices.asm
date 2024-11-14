######### Jason Wu ##########
######### JASONWU1 ##########
######### 114474379 ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:
	#file name is stored in $a0
	#buffer stored in $a1
	addi $sp, $sp, -44
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)	
	
	move $t3, $a0
	lb $s0, 0($a1)  	#check if buffer is empty or not
	bne $s0, $0, Part2
	
	li $s0, 0 		#counter for array
	addi $t9, $a1, 8	#start of array
	addi $t8, $a1, 0	#rows value
	addi $t7, $a1, 4  	#columns value
	li $t6, 0x10012000  	#random space for reading values
	
	
	
	Part1: 			#goal of part 1 is to read file and create a matrix
	li $v0, 13		#$a0 is still the file name
	li $a1, 0
	li $a2, 0
	syscall
	
	
	li $t0, -1
	beq $t0, $v0, quitInitializeFail
	
	move $s7, $v0		#$s7 = file descriptor
				
	loopGetRows:
		li $v0, 14
		move $a0, $s7		#$s7 cannot be used
		move $a1, $t6		#loop gives 1 character
		li $a2, 1
		syscall
		li $t0, -1
		beq $t0, $v0, quitInitializeFail 
		
		
		lw $s1, 0($t6)
		li $t0, 13		
		beq $t0, $s1, loopGetRows
		li $t0, 10
		beq $t0, $s1, loopGetColumns
		j addtoRows		
	
		addtoRows:
			li $t0, 48
			blt $s1, $t0, quitInitializeFail
			li $t0, 57
			bgt $s1, $t0, quitInitializeFail
			addi $s1, $s1, -48
			lw $t0, 0($t8)
			beqz $t0, addNumberRow
			j addTwoNumbersRow
			
			addNumberRow:
				sw $s1, 0($t8)
				j loopGetRows
			
			addTwoNumbersRow:
				li $t1, 10
				mult $t1, $t0
				mflo $t1
				add $t1, $t1, $s1
				sw $t1, 0($t8)
				j loopGetRows
		
			
	loopGetColumns:
		li $v0, 14
		move $a0, $s7		#$s7 cannot be used
		move $a1, $t6		#loop gives 1 character
		li $a2, 1
		syscall
		li $t0, -1
		beq $t0, $v0, quitInitializeFail 
		
		lw $s1, 0($t6)
		li $t0, 13		
		beq $t0, $s1, loopGetColumns
		li $t0, 10
		beq $t0, $s1, GetArray
		j addtoColumns
	
		addtoColumns:
			li $t0, 48
			blt $s1, $t0, quitInitializeFail
			li $t0, 57
			bgt $s1, $t0, quitInitializeFail
			addi $s1, $s1, -48
			lw $t0, 0($t7)
			beqz $t0, addNumberColumn
			j addTwoNumbersColumn
	
			addNumberColumn:
				sw $s1, 0($t7)
				j loopGetColumns
	
			addTwoNumbersColumn:
				li $t1, 10
				mult $t1, $t0
				mflo $t1
				add $t1, $t1, $s1
				sw $t1, 0($t7)
				j loopGetColumns
				
	GetArray:
		li $t5, 0		#amount of columns
		li $t4, 0			#amount of rows
		
	loopGetArray:
		li $v0, 14
		move $a0, $s7		#$s7 cannot be used
		move $a1, $t6		#loop gives 1 character
		li $a2, 1
		syscall
		li $t0, -1
		beq $t0, $v0, quitInitializeFail
		beqz $v0, checkMatrix
			
		lw $s1, 0($t6)
		
		li $t0, 13		
		beq $t0, $s1, loopGetArrayNextRow
		li $t0, 10
		beq $t0, $s1, loopGetArray
		li $t0, 32
		beq $t0, $s1, loopGetArrayCounter
		j addtoArray	

		loopGetArrayNextRow:
			addi $s0, $s0, 1  #total amount
			addi $t9, $t9, 4  #increment address
			
			addi $t4, $t4, 1  #increment num of rows
			addi $t5, $t5, 1
			lw $t0, 0($t7)
			bgt $t5, $t0, quitInitializeFail
			li $t5, 0
			lw $t0, 0($t8)
			bgt $t4, $t0, quitInitializeFail
			j loopGetArray
				
		loopGetArrayCounter:
			addi $s0, $s0, 1  #total amount
			addi $t9, $t9, 4  #increment address
			addi $t5, $t5, 1  #increment num of columns
			j loopGetArray
		
		addtoArray:
			li $t0, 48
			blt $s1, $t0, quitInitializeFail
			li $t0, 57
			bgt $s1, $t0, quitInitializeFail
			addi $s1, $s1, -48
			lw $t0, 0($t9)
			beqz $t0, addNumberArray
			j addTwoNumbersArray	
	
			addNumberArray:
				sw $s1, 0($t9)
				j loopGetArray
	
			addTwoNumbersArray:
				li $t1, 10
				mult $t1, $t0
				mflo $t1
				add $t1, $t1, $s1
				sw $t1, 0($t9)
				j loopGetArray
	
			
	checkMatrix:
	#CHECK TO SEE THAT ROWS AND COLUMNS ARE 1-10
	#AMOUNT OF INPUTS = ROWS * COLUMNS
		lw $t0, 0($t7)
		li $t1, 0
		ble $t0, $t1, quitInitializeFail	#check rows 1-10
		li $t1, 10
		bgt $t0, $t1, quitInitializeFail
		
		lw $t1, 0($t8)
		li $t2, 0
		ble $t1, $t2, quitInitializeFail	#check columns 1-10
		li $t2, 10
		bgt $t1, $t2, quitInitializeFail
		
		mult $t0, $t1
		mflo $t0
		bne $t0, $s0, quitInitializeFail
		j quitInitializeSucceed
	
	quitInitializeFail:
		#reset buffer
		li $s1,0
		sw $s1, 0($t8)
		sw $s1, 0($t7)
		addi $t5, $t8, 0
		addi $t5, $t5, 8
		quitLoop:
			beqz $s0, continueInitializeFail
			sw $s1, 0($t5)
			addi $s0, $s0, -1
			addi $t5, $t5, 4
			j quitLoop
		
	continueInitializeFail:
		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		li $v0, -1
		addi $sp, $sp, 44
 		jr $ra
 		
 	quitInitializeSucceed:
		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		move $a0, $t3
		move $a1, $t8
		li $v0, 1
		addi $sp, $sp, 44
 		jr $ra
 		
 #THIS IS THE LINE BETWEEN PART 1 AND PART 2. JUST A BUNCH OF WORDS TO FORM A LINE SO THAT THERE IS LESS CONFUSION
 	
 	
 	Part2:			#goal is to write the information in the buffer into a file
 		move $s0, $a0		#file name
 		move $s1, $a1		#buffer address
 		lw $s2, 0($a1)		#amount of rows
 		lw $s3, 4($a1) 		#amount of columns
 		li $s4, 0		#counter for amount of characters 
 		li $s5, 10		#dividend for power
 		li $s6, 0 		#counter for power
 		li $t9, 0x10014000 	#storage for chars
 		
 		startPart2:
 			li $v0, 13
 			move $a0, $s0
 			li $a1, 1
 			li $a2, 0
 			syscall
 			
 			move $s7, $v0 	#file descriptor 
 		
 			writeRow:
 				li $t0, 10
 				beq $s2, $t0, writeRowTen
 				addi $t0, $s2, 48
 				sb $t0, 0($t9)
 				li $t0, 13
 				sb $t0, 1($t9)
 				li $t0, 10
 				sb $t0, 2($t9)
 				Part2Row:
 					li $v0, 15
 					move $a0, $s7
 					move $a1, $t9
 					li $a2, 3
 					syscall
 				
 					li $t0, -1
 					beq $t0, $v0, quitPart2Fail
 			
 					add $s4, $s4, $v0
 					addi $s1, $s1, 4
 					#add a make a next line thingie
 					j writeColumn
 			
 			writeRowTen:
 				li $t0, 49
 				sb $t0, 0($t9)
 				li $t0, 48
 				sb $t0, 1($t9)
 				li $t0, 13
 				sb $t0, 2($t9)
 				li $t0, 10
 				sb $t0, 3($t9)
 				
 				li $v0, 15
 				move $a0, $s7
 				move $a1, $t9
 				li $a2, 4
 				syscall
 				
 				li $t0, -1
 				beq $t0, $v0, quitPart2Fail
 				
 				add $s4, $s4, $v0
 				addi $s1, $s1, 4
				j writeColumn

 			writeColumn:
 				li $t0, 10
 				beq $s3, $t0, writeColumnTen
 				addi $t0, $s3, 48
 				sb $t0, 0($t9)
 				li $t0, 13
 				sb $t0, 1($t9)
 				li $t0, 10
 				sb $t0, 2($t9)
 				Part2Column:
 					li $v0, 15
 					move $a0, $s7
 					move $a1, $t9
 					li $a2, 3
 					syscall
 				
 					li $t0, -1
 					beq $t0, $v0, quitPart2Fail
 			
 					add $s4, $s4, $v0
 					addi $s1, $s1, 4
 					#add a make a next line thingie
 					j writeArray
 	
 			writeColumnTen:
 				li $t0, 49
 				sb $t0, 0($t9)
 				li $t0, 48
 				sb $t0, 1($t9)
 				li $t0, 13
 				sb $t0, 2($t9)
 				li $t0, 10
 				sb $t0, 3($t9)
 				
 				li $v0, 15
 				move $a0, $s7
 				move $a1, $t9
 				li $a2, 4
 				syscall
 				
 				li $t0, -1
 				beq $t0, $v0, quitPart2Fail
 				
 				add $s4, $s4, $v0
 				addi $s1, $s1, 4
				j writeArray
 	
 	
 		writeArray:
 		li $t8, 1		#counter for columns
 		li $t7, 0		#counter for rows
 		li $t6, 0		#how many char to write
 			loopWriteArray:	
 				li $t5, 0
 				beq $t7, $s2, quitPart2Succeed
 				lw $t1, 0($s1)
 				div $t1, $s5
 				mflo $t2
 				beqz $t2, singleInputWriteArray
 				addi $t5, $t5, 1
 				j power
 				powerBack:
 					li $t0, 1
 					beq $t5, $t0, writeDoubleDigit
 					li $t0, 2
 					beq $t5, $t0, writeTripleDigit
 					li $t0, 3
 					beq $t5, $t0, writeQuadDigit
 					returnWritingDigit:
 					j loopWriteArray
 	
 					power:
 						div $t2, $s5
 						mflo $t2
 						beqz $t2, powerBack
 						addi $t5, $t5, 1
 						j power
	
					writeDoubleDigit:
						div $t1, $s5
						mfhi $t4		#remainder
						mflo $t3		#quotient
						addi $t3, $t3, 48
						sb $t3, 0($t9)
						addi $t4, $t4, 48
						sb $t4, 1($t9)
 						j spaceOrNewLineDouble
 						determinedDouble:
 						li $v0, 15
 						move $a0, $s7
 						move $a1, $t9
 						move $a2, $t6
 						syscall
 						li $t0, -1
 						beq $t0, $v0, quitPart2Fail
 						add $s4, $s4, $v0
 						addi $s1, $s1, 4
 						j loopWriteArray
 	
 							spaceOrNewLineDouble:
 								beq $t8, $s3, newLineWriteDouble	
 								li $t0, 32
 								sb $t0, 2($t9)
 								li $t6, 3
 								addi $t8, $t8, 1
 								j determinedDouble
 		
 								newLineWriteDouble:
 									li $t0, 13
 									sb $t0, 2($t9)
 									li $t0, 10
 									sb $t0, 3($t9)
 									li $t6, 4
 									li $t8, 1
 									addi $t7, $t7, 1
 									j determinedDouble
 					writeTripleDigit:
						div $t1, $s5
						mfhi $t4		#remainder
						mflo $t3		#quotient
						addi $t4, $t4, 48
						sb $t4, 2($t9)
						div $t3, $s5
						mfhi $t4
						mflo $t3
						addi $t4, $t4, 48
						sb $t4, 1($t9)
						addi $t3, $t3, 48
						sb $t3, 0($t9)
 						j spaceOrNewLineTriple
 						determinedTriple:
 						li $v0, 15
 						move $a0, $s7
 						move $a1, $t9
 						move $a2, $t6
 						syscall
 						li $t0, -1
 						beq $t0, $v0, quitPart2Fail
 						add $s4, $s4, $v0
 						addi $s1, $s1, 4
 						j loopWriteArray
 	
 							spaceOrNewLineTriple:
 								beq $t8, $s3, newLineWriteTriple	
 								li $t0, 32
 								sb $t0, 3($t9)
 								li $t6, 4
 								addi $t8, $t8, 1
 								j determinedTriple
 		
 								newLineWriteTriple:
 									li $t0, 13
 									sb $t0, 3($t9)
 									li $t0, 10
 									sb $t0, 4($t9)
 									li $t6, 5
 									li $t8, 1
 									addi $t7, $t7, 1
 									j determinedTriple
 					writeQuadDigit:
						div $t1, $s5
						mfhi $t4		#remainder
						mflo $t3		#quotient
						addi $t4, $t4, 48
						sb $t4, 3($t9)
						div $t3, $s5
						mfhi $t4
						mflo $t3
						addi $t4, $t4, 48
						sb $t4, 2($t9)
						div $t3, $s5
						mfhi $t4
						mflo $t3
						addi $t4, $t4, 48
						sb $t4, 1($t9)
						addi $t3, $t3, 48
						sb $t3, 0($t9)
 						j spaceOrNewLineQuad
 						determinedQuad:
 						li $v0, 15
 						move $a0, $s7
 						move $a1, $t9
 						move $a2, $t6
 						syscall
 						li $t0, -1
 						beq $t0, $v0, quitPart2Fail
 						add $s4, $s4, $v0
 						addi $s1, $s1, 4
 						j loopWriteArray
 	
 							spaceOrNewLineQuad:
 								beq $t8, $s3, newLineWriteQuad	
 								li $t0, 32
 								sb $t0, 4($t9)
 								li $t6, 5
 								addi $t8, $t8, 1
 								j determinedQuad
 		
 								newLineWriteQuad:
 									li $t0, 13
 									sb $t0, 4($t9)
 									li $t0, 10
 									sb $t0, 5($t9)
 									li $t6, 6
 									li $t8, 1
 									addi $t7, $t7, 1
 									j determinedQuad
 			
 				singleInputWriteArray:
 					addi $t1, $t1, 48
 					sb $t1, 0($t9)
 					j spaceOrNewLine
 					determined:
 						li $v0, 15
 						move $a0, $s7
 						move $a1, $t9
 						move $a2, $t6
 						syscall
 						li $t0, -1
 						beq $t0, $v0, quitPart2Fail
 						add $s4, $s4, $v0
 						addi $s1, $s1, 4
 						j loopWriteArray
 	
 	
 	
 
 	spaceOrNewLine:
 		beq $t8, $s3, newLineWrite	
 		li $t0, 32
 		sb $t0, 1($t9)
 		li $t6, 2
 		addi $t8, $t8, 1
 		j determined
 		
 		newLineWrite:
 			li $t0, 13
 			sb $t0, 1($t9)
 			li $t0, 10
 			sb $t0, 2($t9)
 			li $t6, 3
 			li $t8, 1
 			addi $t7, $t7, 1
 			j determined
 	
 	quitPart2Fail:
 		li $v0, 16
 		move $a0, $s7
 		syscall
		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		li $v0, -1
		addi $sp, $sp, 44
 		jr $ra									


 	quitPart2Succeed:
 		li $v0, 16
 		move $a0, $s7
 		syscall
 		move $v0, $s4
		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		addi $sp, $sp, 44
 		jr $ra		

.globl rotate_clkws_90

rotate_clkws_90:
	addi $sp, $sp, -44
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)	
	lw $s0, 0($a0)
	#beqz $s0, initialize90

	okayContinue90:
	move $s5, $a1 
	move $s0, $a0			#address of buffer we increment
	move $s1, $a0			
	addi $s1, $s1, 8		#address of array we dont touch
	li $s2, 0x10013000		#storing all the values
	li $s3, 0x10013000		#dont touch this value
	
	
	lw $t9, 0($s0)			#row value original
	lw $t0, 4($s0)
	sw $t0, 0($s0)
	addi $s0, $s0, 4
	
	lw $t8, 0($s0)			#column value original
	sw $t9, 0($s0)			#columns and rows are swapped
	addi $s0, $s0, 4		#$s0 is at the beginning of the array
	loopMatrixRotate90:
		li $t7, 0		#counter for row
		li $t0, 4
		mult $t8, $t0		#increment for address during heap loop
		mflo $t6		#increment for address during heap loop
		li $t5, 0 		#which column we on increment for heap loop
		li $s4, 0 		#counter for column
		loopStartStoreToHeap90:
			beq $s4, $t8, finishThe90
			move $t4, $s1
			add $t4, $t4, $t5
			loopStoreToHeap90:
				beq $t7, $t9, moveHeapToRandomAddress90
				lw $t0, 0($t4)
				sw $t0, 0($sp)
				addi $sp, $sp, -4
				add $t4, $t4, $t6
				addi $t7, $t7, 1
				j loopStoreToHeap90
 	
 			moveHeapToRandomAddress90:
 				addi $t5, $t5, 4
 				addi $s4, $s4, 1
 				loopMoveHeap90:
 				beqz $t7, loopStartStoreToHeap90
 				addi $sp, $sp, 4
 				lw $t0, 0($sp)
 				sw $t0, 0($s2)
 				addi $s2, $s2, 4
 				addi $t7, $t7, -1
 				j loopMoveHeap90
 	
 				finishThe90:
 					mult $t9, $t8
 					mflo $t1
 					addi $s1, $s1, -8
 					move $t2, $s1
 					addi $s1, $s1, 8
 					loopFinish90:
 						beqz $t1, printOut90
 						lw $t0, 0($s3)
 						sw $t0, 0($s1)
 						addi $s1, $s1, 4
 						addi $s3, $s3, 4
 						addi $t1, $t1, -1
 						j loopFinish90
 					
 					printOut90:
 						move $a0, $s5
 						move $a1, $t2
 						jal initialize
 						j quitRotate90
 	
 	#initialize90:
	#	jal initialize
	#	j okayContinue90
 	
 	quitRotate90:
 		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		addi $sp, $sp, 44
 		jr $ra

.globl rotate_clkws_180
rotate_clkws_180:
	addi $sp, $sp, -44
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)	
	lw $s0, 0($a0)
	
	okayContinue180:
	move $s5, $a1
	move $s0, $a0			#address of buffer we increment
	move $s1, $a0			
	addi $s1, $s1, 8		#address of array we dont touch
	li $s2, 0x10013000		#storing all the values
	li $s3, 0x10013000		#dont touch this value
	
	
	lw $t9, 0($s0)			#row value original
	addi $s0, $s0, 4
	lw $t8, 0($s0)			#column value original
	addi $s0, $s0, 4		#$s0 is at the beginning of the array
	loopMatrixRotate180:
		li $t7, 0		#counter for row
		li $t0, 4
		li $t6, 4		#increment for address during heap loop
			
		li $t1, 4			
		mult $t1, $t8
		mflo $t0
		addi $t1, $t9, -1
		mult $t0, $t1
		mflo $t0
		addi $t5, $t0, 0
		li $s4, 0 		#counter for column
		loopStartStoreToHeap180:
			beq $t7, $t9, finishThe180
			move $t4, $s1
			add $t4, $t4, $t5
			loopStoreToHeap180:
				beq $s4, $t8, moveHeapToRandomAddress180
				lw $t0, 0($t4)
				sw $t0, 0($sp)
				addi $sp, $sp, -4
				add $t4, $t4, $t6
				addi $s4, $s4, 1
				j loopStoreToHeap180
 	
 			moveHeapToRandomAddress180:
 				li $t0, 4
 				mult $t0, $t8
 				mflo $t0
 				sub $t5, $t5, $t0
 				addi $t7, $t7, 1
 				loopMoveHeap180:
 				beqz $s4, loopStartStoreToHeap180
 				addi $sp, $sp, 4
 				lw $t0, 0($sp)
 				sw $t0, 0($s2)
 				addi $s2, $s2, 4
 				addi $s4, $s4, -1
 				j loopMoveHeap180
 	
 				finishThe180:
 					mult $t9, $t8
 					mflo $t1
 					addi $s1, $s1, -8
 					move $t2, $s1
 					addi $s1, $s1, 8
 					loopFinish180:
 						beqz $t1, printOut180
 						lw $t0, 0($s3)
 						sw $t0, 0($s1)
 						addi $s1, $s1, 4
 						addi $s3, $s3, 4
 						addi $t1, $t1, -1
 						j loopFinish180
 					
 					printOut180:
 						move $a0, $s5
 						move $a1, $t2
 						jal initialize
 						j quitRotate180

 	quitRotate180:
 		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		addi $sp, $sp, 44
 		jr $ra

.globl rotate_clkws_270
rotate_clkws_270:
addi $sp, $sp, -44
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)	
	lw $s0, 0($a0)


	okayContinue270:
	move $s5, $a1 
	move $s0, $a0			#address of buffer we increment
	move $s1, $a0			
	addi $s1, $s1, 8		#address of array we dont touch
	li $s2, 0x10013000		#storing all the values
	li $s3, 0x10013000		#dont touch this value
	
	
	lw $t9, 0($s0)			#row value original
	lw $t0, 4($s0)
	sw $t0, 0($s0)
	addi $s0, $s0, 4
	
	lw $t8, 0($s0)			#column value original
	sw $t9, 0($s0)			#columns and rows are swapped
	addi $s0, $s0, 4		#$s0 is at the beginning of the array
	loopMatrixRotate270:
		li $t7, 0		#counter for row
		li $t0, 4
		mult $t8, $t9		#increment for address during heap loop
		mflo $t6		#increment for address during heap loop
		li $t0, 4
		mult $t6, $t0
		mflo $t6
		addi $t5, $t6, -4 	#which column we on increment for heap loop
		mult $t8, $t0		#increment for address during heap loop
		mflo $t6
		
		li $s4, 0 		#counter for column
		loopStartStoreToHeap270:
			beq $s4, $t8, finishThe270
			move $t4, $s1
			add $t4, $t4, $t5
			loopStoreToHeap270:
				beq $t7, $t9, moveHeapToRandomAddress270
				lw $t0, 0($t4)
				sw $t0, 0($sp)
				addi $sp, $sp, -4
				sub $t4, $t4, $t6
				addi $t7, $t7, 1
				j loopStoreToHeap270
 	
 			moveHeapToRandomAddress270:
 				addi $t5, $t5, -4
 				addi $s4, $s4, 1
 				loopMoveHeap270:
 				beqz $t7, loopStartStoreToHeap270
 				addi $sp, $sp, 4
 				lw $t0, 0($sp)
 				sw $t0, 0($s2)
 				addi $s2, $s2, 4
 				addi $t7, $t7, -1
 				j loopMoveHeap270
 	
 				finishThe270:
 					mult $t9, $t8
 					mflo $t1
 					addi $s1, $s1, -8
 					move $t2, $s1
 					addi $s1, $s1, 8
 					loopFinish270:
 						beqz $t1, printOut270
 						lw $t0, 0($s3)
 						sw $t0, 0($s1)
 						addi $s1, $s1, 4
 						addi $s3, $s3, 4
 						addi $t1, $t1, -1
 						j loopFinish270
 					
 					printOut270:
 						move $a0, $s5
 						move $a1, $t2
 						jal initialize
 						j quitRotate270
 	

 	quitRotate270:
 		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		addi $sp, $sp, 44
 		jr $ra

.globl mirror

mirror:
	addi $sp, $sp, -44
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)	
	lw $s0, 0($a0)
	
	okayContinueMirror:
	move $s5, $a1
	move $s0, $a0			#address of buffer we increment
	move $s1, $a0			
	addi $s1, $s1, 8		#address of array we dont touch
	li $s2, 0x10013000		#storing all the values
	li $s3, 0x10013000		#dont touch this value
	
	
	lw $t9, 0($s0)			#row value original
	addi $s0, $s0, 4
	lw $t8, 0($s0)			#column value original
	addi $s0, $s0, 4		#$s0 is at the beginning of the array
	loopMatrixRotateMirror:
		li $t7, 0		#counter for row
		li $t0, 4
		li $t6, 4		#increment for address during heap loop
			
		li $t5, 0
		li $s4, 0 		#counter for column
		loopStartStoreToHeapMirror:
			beq $t7, $t9, finishTheMirror
			move $t4, $s1
			add $t4, $t4, $t5
			loopStoreToHeapMirror:
				beq $s4, $t8, moveHeapToRandomAddressMirror
				lw $t0, 0($t4)
				sw $t0, 0($sp)
				addi $sp, $sp, -4
				add $t4, $t4, $t6
				addi $s4, $s4, 1
				j loopStoreToHeapMirror
 	
 			moveHeapToRandomAddressMirror:
 				li $t0, 4
 				mult $t0, $t8
 				mflo $t0
 				add $t5, $t5, $t0
 				addi $t7, $t7, 1
 				loopMoveHeapMirror:
 				beqz $s4, loopStartStoreToHeapMirror
 				addi $sp, $sp, 4
 				lw $t0, 0($sp)
 				sw $t0, 0($s2)
 				addi $s2, $s2, 4
 				addi $s4, $s4, -1
 				j loopMoveHeapMirror
 	
 				finishTheMirror:
 					mult $t9, $t8
 					mflo $t1
 					addi $s1, $s1, -8
 					move $t2, $s1
 					addi $s1, $s1, 8
 					loopFinishMirror:
 						beqz $t1, printOutMirror
 						lw $t0, 0($s3)
 						sw $t0, 0($s1)
 						addi $s1, $s1, 4
 						addi $s3, $s3, 4
 						addi $t1, $t1, -1
 						j loopFinishMirror
 					
 					printOutMirror:
 						move $a0, $s5
 						move $a1, $t2
 						jal initialize
 						j quitRotateMirror

 	quitRotateMirror:
 		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		addi $sp, $sp, 44
 		jr $ra

.globl duplicate
duplicate:
	addi $sp, $sp, -44
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)	
	lw $s0, 0($a0)
	
	okayContinueDup:
		move $s0, $a0			#address of buffer we increment
		move $s1, $a0			
		addi $s1, $s1, 8		#address of array we dont touch
			
		lw $t9, 0($s0)			#row value original
		addi $s0, $s0, 4
		lw $t8, 0($s0)			#column value original
		addi $s0, $s0, 4		#$t9, $t8, t7, t6, t5, t4		$s0, $s1,  
		
		li $t7, 0			#row counter
		li $t6, 0			#column counter that checked
		li $t5, 0			#comparing row counter
		li $t4, 4			#increment for checking
		loopCompareRowsDup:
			addi $t7, $t7, 1
			addi $t5, $t7, 1
			beq $t7, $t9, quitRotateDuplicateFail
			compareCurrentRowDup:
				addi $t0, $t9, 1
				beq $t5, $t0, loopCompareRowsDup
				
				move $s2, $s1
				addi $t3, $t7, -1
				mult $t3, $t8
				mflo $t3
				mfhi $t0
				mult $t3, $t4
				mflo $t3
				add $s2, $s2, $t3
				
				move $s3, $s1
				addi $t3, $t5, -1
				mult $t3, $t8
				mflo $t3
				mfhi $t0
				mult $t3, $t4
				mflo $t3
				add $s3, $s3, $t3
				
				loopCompareCurrentDup:
					beq $t6, $t8, quitRotateDuplicateSuccess
					lw $t0, 0($s2)
					lw $t1, 0($s3)
					bne $t0, $t1, loopLoopCompareDup
					addi $s2, $s2, 4
					addi $s3, $s3, 4
					addi $t6, $t6, 1
					j loopCompareCurrentDup
					
					loopLoopCompareDup:
						addi $t5, $t5, 1
						li $t6, 0
						j compareCurrentRowDup
	
	
	
	quitRotateDuplicateFail:
 		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		li $v0, -1
		li $v1, 0
		addi $sp, $sp, 44
 		jr $ra
 		
	quitRotateDuplicateSuccess:
 		lw $ra, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		lw $s2, 20($sp)
		lw $s3, 24($sp)
		lw $s4, 28($sp)
		lw $s5, 32($sp)
		lw $s6, 36($sp)
		lw $s7, 40($sp)
		li $v0, 1
		move $v1, $t5
		addi $sp, $sp, 44
 		jr $ra
