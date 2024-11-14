################# Jason Wu #################
################# JASONWU1 #################
################# 114474379 #################
################# ZhenShiDaoMei #################

################# DO NOT CHANGE THE DATA SECTION #################

.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "Invalid Arguments\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
invalid_hand_msg: .asciiz "Loot Hand Invalid\n"
newline: .asciiz "\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:
    #part 1.1
    li $s0, 2
    bne $a0,$s0, LessThanTwoArgs
    #check for exactly 2 arguments, if not terminate
    
    #part 1.2
    lbu $t1, 0($a1)
    beqz $t1, LessThanTwoArgs #if first character is 00, then invalid
    la $s4, arg1_addr
    li $s1, 0 #num of char
    li $s2, 0 #num of blank
    li $s3, 2 #limit of 2 char
  while:
    beq $s3, $s1, InvalidArg
    lb $s5, 0($a1) #t1 has first character stored
    bne $s2, $0, exitLoop
    bne $s5, $0, addToChar
    beq $s5, $0, addToBlank   
    
   addToBlank:
    addi $s2, $s2, 1
    j loop    
    
   addToChar:
    addi $s1, $s1, 1
    j loop    
     
   loop: 
    addi $a1, $a1, 1
    j while
  
  exitLoop:
    #part 1.3
  # $t2 = Letter we comparing arg1 to, $t1 = first arg letter
    sub $a1, $a1, $s1
    sub $a1, $a1, $s2
    lbu $s1, 0($a1)
    
  CaseD:
    li $s2, 68
    bne $s1, $s2, CaseO
    j doneCase
    
  CaseO:
    li $s2, 79
    bne $s1, $s2, CaseS
    j Beginning3
    
  CaseS:
    li $s2, 83
    bne $s1, $s2, CaseT
    j Beginning3 #"D", "O", "S", "T", "E", "H", "U", "F", or "L"
    
  CaseT:
    li $s2, 84
    bne $s1, $s2, CaseE
    j Beginning3
    
  CaseE:
    li $s2, 69
    bne $s1, $s2, CaseH
    j Beginning3
    
  CaseH:
    li $s2, 72
    bne $s1, $s2, CaseU
    j Beginning3
    
  CaseU:
    li $s2, 85
    bne $s1, $s2, CaseF
    j Beginning3
    
  CaseF:
    li $s2, 70
    bne $s1, $s2, CaseL
    j hexiPart4
    
  CaseL:
    li $s2, 76
    bne $s1, $s2, InvalidArg
    j doneCase
   
  doneCase:
  #part 2.1
    li $s0, 0x10010002
    lb $s1, 0($s0)
    beqz $s1, InvalidArg
    li $s2, 49 #1
    li $s3, 48 #0
    li $s4, 0 #counter that has to be under 32
    li $s5, 32 #max counter
   
   while2:
    lb $s1, 0($s0)
    beqz $s1, doneWhile2
    slt $s6, $s4, $s5
    beq $s6, $0, InvalidArg
    beq $s1, $s2, loopWhile2
    beq $s1, $s3, loopWhile2
    j InvalidArg
   loopWhile2:
    addi $s4, $s4, 1
    addi $s0, $s0, 1
    j while2

  doneWhile2:
  
    li $s0, 0 #amount of 1s
    li $s1, 1 #power amount
    li $s2, 0x10010002 #start of binary number
    add $s2, $s2, $s4
    sub $s2, $s2, $s1
    li $s3, 0 #total
    li $s5, 0 # counter
    addi $s6, $s4, 0 #number of characters
    li $s7, 32
    beq $s6, $s7, Negation
    
  #part 2.2  
   while3:
    li $t1, 1
    beq $s4, $t1, checkNegation
   continue3:
    beq $s4, $0, returnDecimal
    lb $t1, 0($s2)
    li $t2, 49
    beq $t1, $t2, addToTotal
    j loopWhile3
   
   addToTotal:
    addi, $s0, $s0, 1
    add, $s3, $s3, $s1
    j loopWhile3 
     
   checkNegation:
    bne $s4, $s7, continue3
    lb $t1, 0($s2)
    li $t2, 49
    bne $t1, $t2, continue3
    addi, $s0, $s0, 1
    beq $s0, $s6, returnDecimal
    addi $t6, $s3, 0
    sub $s3, $s3, $t6
    sub $s3, $s3, $t6
    j returnDecimal
                       
                       
   loopWhile3:
    li $t0, 1
    sub $s2, $s2, $t0
    li $t0, 1
    sub $s4, $s4, $t0
    li $t7, 1
    li $t1, 30
    beq $s5, $t1, skip
    addi $s5, $s5, 1
    add, $s1, $s1, $s1
   skip:
    j while3
    
   Negation:
    li $s7, 1 #if s7 is 1, then negate the total
    j while3
    
  returnDecimal:
    li $t1, 32
    beq $s0, $t1, return1
    li $v0, 1
    move $a0, $s3
    syscall
    j doneWhile3
        
  return1:
    li $t0, -1 
    li $v0, 1
    move $a0, $t0
    syscall 
    j doneWhile3
  
  doneWhile3:
    
  #part 3.1 
  Beginning3:
    li $s0, 0 #length counter
    lw $s1, arg2_addr
	findLengthPart3:
		lbu $t0, 0($s1)
		beqz $t0, verifyPart3
		addi $s1, $s1, 1  
		
		j findLengthPart3
	
	verifyPart3:
		lw $t0, arg2_addr
		sub $s2, $s1, $t0 #$s2 is the length
		li $t2, 8
		li $t1, 1
		slt $s3, $s2, $t1
		beq $s3, $t1, InvalidArg
		slt $s3, $t2, $s2
		beq $s3, $t1, InvalidArg
		lw $s1, arg2_addr #values for validhexstrings
		li $t2, -1        #values for validhexstrings
		j validHex
		
	validHex:
		lbu $t3, 0($s1)
		addi $s1, $s1, 1 #next character
		addi $t2, $t2, 1 #increment
		li $t7, 'A'
		li $t6, 'F'
		li $t5, '0'
		li $t4, '9'
		beq $t2, $s2, constructString 
		bgt $t3, $t6, InvalidArg
		blt $t3, $t5, InvalidArg
		bgt $t3, $t4, nestedValidHex
		j validHex
		nestedValidHex:
			blt $t3, $t7, InvalidArg
			j validHex
	
	constructString:
		li $t0, 8 #amount of hexidecimal 
		li $t7, 0 #where im adding hexidecimal binary reps
		li $t2, 48
		lw $t8, arg2_addr
		li $t6, 0 #counter
		constructLoop:
		        beq $t6, $s2, exitConstruct #if length is equal to the counter then stop
			lbu $t3, 0($t8)
			li $t4, 57
			ble $t3, $t4, constructChar
			addi $t3, $t3, -55
			sll $t7, $t7, 4
			or $t7, $t7, $t3
			addi $t8, $t8, 1
			addi $t6, $t6, 1
			j constructLoop
		
		constructChar:
			addi $t3, $t3, -48
			sll $t7, $t7, 4
			or $t7, $t7, $t3
			addi $t8, $t8, 1
			addi $t6, $t6, 1
			j constructLoop
		
		exitConstruct:
			li $s3, 0x10010000
			lbu $s1, 0($s3)
			li $s2, 79
    		 	beq $s1, $s2, OpCode
    		 	li $s2, 83
   			beq $s1, $s2, rsRegister
   			li $s2, 84
   			beq $s1, $s2, rtRegister
   			li $s2, 69
   			beq $s1, $s2, rdRegister
   			li $s2, 72
   			beq $s1, $s2, shamt
   			li $s2, 85
   			beq $s1, $s2, funct
   			
	#part 3.2
		#$t7 contains the 32 bit binary rep of the hexidecimal
		OpCode:
			li $t0, 26
			srl $t7, $t7, 26
			li $v0, 1
			move $a0, $t7
			syscall
			j Exit
		rsRegister:
			li $t0, 6
			li $t1, 27			
			sll $t7, $t7, 6
			srl $t7, $t7, 27
			li $v0, 1
			move $a0, $t7
			syscall
			j Exit
		rtRegister: 
			sll $t7, $t7, 11
			srl $t7, $t7, 27
			li $v0, 1
			move $a0, $t7
			syscall
			j Exit		
		rdRegister:
			sll $t7, $t7, 16
			srl $t7, $t7, 27
			li $v0, 1
			move $a0, $t7
			syscall
			j Exit
		shamt:
			sll $t7, $t7, 21
			sra $t7, $t7, 27
			li $v0, 1
			move $a0, $t7
			syscall
			j Exit  
		funct:
			sll $t7, $t7, 26
			srl $t7, $t7, 26
			li $v0, 1
			move $a0, $t7
			syscall
			j Exit
  
  
  
  
  
  
  #part 4.1
  hexiPart4:
    lw $t9, arg2_addr
    li $t7, 0
    li $t6, 8
    li $t3, -1
    li $s2, 0x0000
	findLengthPart4:
		lbu $t8, 0($t9)
		beq $t8, $zero, endFindLengthPart4
		addi $t9, $t9, 1
		j findLengthPart4
	
	endFindLengthPart4:
		lw $t8, arg2_addr
		sub $s1, $t9, $t8 #s1 holds the length of the string
		lw $t9, arg2_addr
		beq $s1, $t6, valid_hex_digits #if length is 8, move on. else throw an error.
		j InvalidArg
	
	valid_hex_digits:
		lbu $t8, 0($t9)
		addi $t9, $t9, 1 #next character
		addi $t3, $t3, 1 #increment
		li $t7, 'A'
		li $t6, 'F'
		li $t5, '0'
		li $t4, '9'
		beq $t3, $s1, construct_string
		bgt $t8, $t6, InvalidArg
		blt $t8, $t5, InvalidArg
		bgt $t8, $t4, nested_valid_hex_digits
		j valid_hex_digits
		nested_valid_hex_digits:
			blt $t8, $t7, InvalidArg
			j valid_hex_digits
		
	construct_string:
		lw $t9, arg2_addr
		li $t7, -1 #count
		construct_loop:
			li $t6, 'F'
			li $t5, 'A'
			li $t4, '9'
			li $t3, '0'
			lbu $t8, 0($t9) #stores each byte into t8
			addi $t9, $t9, 1 #iterates next character
			addi $t7, $t7, 1 #counter
			beq $t7, $s1, check_equality
			bge $t8, $t5, nested_letter_loop #greater than or equal to A. Doesn't encompass any number values
			ble $t8, $t4, nested_number_loop #less than or equal to 9
			
			nested_letter_loop:
				ble $t8, $t6, part4_subtract55 #less than or equal to F
				j InvalidArg
			nested_number_loop:
				bge $t8, $t3, part4_subtract48 #greater than or equal to 0
				j InvalidArg
				
			part4_subtract55:
				addi $t8, $t8, -55
				j append_hexa_string
				
			part4_subtract48:
				addi $t8, $t8, -48
				j append_hexa_string
			
			append_hexa_string:
				rol $s2, $s2, 4
				add $s2, $s2, $t8
				j construct_loop
				
			check_equality:
				li $t9, 0x00000000
				li $t8, 0x80000000
				li $t7, 0xFF800000
				li $t6, 0x7F800000
				li $t5, 0x7F800001
				li $t4, 0x7FFFFFFF
				li $t3, 0xFF800001
				li $t2, 0xFFFFFFFF
				
				beq $s2, $t9, print_zero
				beq $s2, $t8, print_zero
				beq $s2, $t7, print_neg_infinity
				beq $s2, $t6, print_pos_infinity
				bge $s2, $t5, nested_print_NaN
				bge $s2, $t3, nested_print_NaN_1
				
				j IEEE_754
				
				nested_print_NaN:
					ble $s2, $t4, print_NaN
					j IEEE_754
					
				nested_print_NaN_1:
					ble $s2, $t2, print_NaN
					j IEEE_754
				
				print_zero:
					li $v0, 4
					la $a0, zero
					syscall
					
					j Exit
				
				print_neg_infinity:
					li $v0, 4
					la $a0, inf_neg
					syscall
					
					j Exit
					
				print_pos_infinity:
					li $v0, 4
					la $a0, inf_pos
					syscall
					
					j Exit
					
				print_NaN:
					li $v0, 4
					la $a0, nan
					syscall
					
					j Exit
		IEEE_754:
			li $t7, 0 #counter
			li $t6, 1
			lui $t3, 0x8000
			ori $t2, $t3, 0x0000
			li $t2, 8
			li $s3, 0
			li $s4, 0
			la $t8, mantissa #load mantissa string
			calculate_signed_bit:
				and $t9, $s2, $t3 #gets the sign bit
				beq $t9, $t3, signed_bit
				beqz $t9, signed_bit
				j InvalidArg
				
			signed_bit:
				move $s3, $t9 #s3 now holds signed bit
				srl $s3, $s3, 31 #makes it only 1
				beqz $s3, positive_signed_bit
				beq $s3, $t6, negative_signed_bit
				j calculate_exponent
				
			negative_signed_bit:
				li $t6, 0x2E #.
				li $t5, 0x2D #-
				li $t4, '1' #1
				sb $t5, 0($t8)
				addi $t8, $t8, 1
				sb $t4, 0($t8)
				addi $t8, $t8, 1
				sb $t6, 0($t8)
				addi $t8, $t8, 1
				j calculate_exponent
				
			positive_signed_bit:
				li $t6, 0x2E #.
				li $t5, '1' #1
				sb $t5, 0($t8)
				addi $t8, $t8, 1
				sb $t6, 0($t8)
				addi $t8, $t8, 1
				j calculate_exponent
				
			calculate_exponent:
				move $t9, $s2
				srl $t3, $t3, 1 #shifts the mask string right one bit.
				and $t9, $t3, $t9 #gets the next bit after masking.
				add $s4, $s4, $t9 #adds the new bit to pre-existing one.
				addi $t7, $t7, 1 #increment $t7 until 8.
				bne $t7, $t2, calculate_exponent
				j exponent
			
			exponent:
				srl $s4, $s4, 23
				li $t7, 0
				li $t2, 22
				addi $s4, $s4 -127 #get exponent via based exponent 127
				move $a0, $s4
				j calculate_mantissa
				
			calculate_mantissa:
				move $t9, $s2
				srl $t3, $t3, 1
				and $t9, $t9, $t3
				#add $s5, $s5, $t9
				j mantissa_string
			
			mantissa_string:
				srlv $t7, $t9, $t2
				addi $t7, $t7, 48
				sb $t7, 0($t8)
				addi $t8, $t8, 1
				addi $t2, $t2, -1
				bgez $t2, calculate_mantissa
				j load_mantissa
				
			load_mantissa:
				la $t0, mantissa
				move $a1, $t0 #loads mantissa into $a1
				
				j Exit
				
					
#below the line is all functions (conditional, not always going to activate) we can jump to ------------------------------------------------------------------------------- 	
 Exit:
    li $v0, 10
    syscall
    
 InvalidArg:
    #print invalid msg
    li $v0, 4
    la $a0, invalid_arg_msg
    syscall
    
    #terminate
    j Exit
    
 LessThanTwoArgs:
    #prints string
    li $v0, 4
    la $a0, args_err_msg
    syscall
    
    #terminate
    j Exit
