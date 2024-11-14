############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:

.globl create_network
create_network:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)	
	# int i is stored in $a0, max number of nodes
	# int j is stored in $a1, max number of edges
	
	check_nonnegative:
		move $s0, $a0		#max nodes
		move $s1, $a1		#max edges
		li $t0, 0
		blt $s0, $t0, quit_create_fail
		blt $s1, $t0, quit_create_fail
		
		li $a0, 4
		li $v0, 9
		syscall
		sw $s0, 0($v0)
		move $s0, $v0		#address of the nodes
	
		li $a0, 4
		li $v0, 9
		syscall
		sw $s1, 0($v0)
		move $s1, $v0		#address of the edges
	
		li $t0, 0 		#zero for initialization
		
		li $a0, 4
		li $v0, 9
		syscall
		sw $t0, 0($v0)
		move $s2, $v0		#address for X
		
		li $a0, 4
		li $v0, 9
		syscall
		sw $t0, 0($v0)
		move $s3, $v0		#address for Y
		
		create_node_array:
			lw $t0, 0($s0)	#amount of nodes
			li $t1, 0	#counter for nodes
			li $t2, 0 	#zero
			
			loop_create_node_array:
				beq $t0, $t1, create_edge_array
				li $a0, 4
				li $v0, 9
				syscall
				sw $t2, 0($v0)
				
				addi $t1, $t1, 1
				j loop_create_node_array
	
		create_edge_array:
			lw $t0, 0($s1)	#amount of edges
			li $t1, 0	#counter for edges
			li $t2, 0	#zero
			
			loop_create_edge_array:
				beq $t0, $t1, quit_create_network
				li $a0, 4
				li $v0, 9
				syscall
				sw $t2, 0($v0)
				
				addi $t1, $t1, 1
				j loop_create_edge_array
	
	
	quit_create_fail:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)	
		addi $sp, $sp, 36
		li $v0, -1
  		jr $ra
	
	quit_create_network:
		move $v0, $s0
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)	
		addi $sp, $sp, 36
  		jr $ra

.globl add_person
add_person:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	#network address stored in $a0
	#String name stored in $a1
	
	move $s0, $a0		#address of network
	move $s1, $a1		#address of string
	check_capacity:
		lw $t0, 0($s0)
		lw $t1, 8($s0)
		beq $t0, $t1, quit_add_person_fail
		li $t9, 0	#amount of chars in string
		move $t8, $s1
		count_chars:
			lb $s2, 0($t8)
			beqz $s2, check_empty_string
			addi $t9, $t9, 1
			addi $t8, $t8, 1
			j count_chars
		
		check_empty_string:
			beqz $t9, quit_add_person_fail
			j check_person_exists
			
			check_person_exists:
				lw $t0, 8($s0)	#num of existing nodes in array
				li $t1, 0
				beq $t0, $t1, add_the_node
				li $t2, 0 	#counter for existing nodes
				move $t3, $s0	#address of network
				addi $t3, $t3, 16	#address of the node array
				loop_check_person:
					beq $t0, $t2, add_the_node
					j loop_in_loop_check
					goback:
					addi $t3, $t3, 4
					addi $t2, $t2, 1
					j loop_check_person
					
				loop_in_loop_check:
					lw $t4, 0($t3)	#address of node in $t4
					lw $t7, 0($t4)	#char count of node	
					bne $t7, $t9, goback	#char counts of the 2 string dont match up
					li $t5, 0	#counter
					addi $t4, $t4, 4	#start of char in array
					move $t6, $s1		#start of char we tryna add
					j loop_char_for_char
		
					loop_char_for_char:
						beq $t5, $t9, quit_add_person_fail
						lb $t7, 0($t4)
						lb $t1, 0($t6)
						bne $t7, $t1, goback
						addi $t4, $t4, 1
						addi $t6, $t6, 1
						addi $t5, $t5, 1
						j loop_char_for_char
			
			add_the_node:
				li $t0, 0x10012000
				move $t1, $s0 		#address of network
				lw $t2, 8($t1)		#amount of nodes in array atm
				li $t3, 0		#counter
				li $t4, 0		#total space needed
				li $t5, 4
				mult $t2, $t5
				mflo $t5		#space from ints in node
				addi $t1, $t1, 16
				j loop_get_address_mult
				finishAdd:
				add $t4, $t4, $t5
				add $t0, $t0, $t4	#address of node
				
				move $t1, $s0		#address of network
				lw $t2, 8($t1)		#existing # nodes
				addi $t1, $t1, 16	#node array
				li $t3, 4		
				mult $t2, $t3		
				mflo $t2
				add $t1, $t1, $t2	#empty spot for node 
				sw $t0, 0($t1)		#store node address to empty node array spot
				
				sw $t9, 0($t0)		#store char count at node address
				addi $t0, $t0, 4	#increment by 4
				move $t1, $s1		#string address
				j add_string_loop	#call a loop that adds the string to the node address
				
				add_string_loop:
					lb $t7, 0($t1)
					beqz $t7, quit_add_person
					sb $t7, 0($t0)
					addi $t1, $t1, 1
					addi $t0, $t0, 1
					j add_string_loop
				
				loop_get_address_mult:
					beq $t2, $t3, finishAdd
					lw $t6, 0($t1)
					lw $t6, 0($t6)
					add $t4, $t4, $t6
					addi $t1, $t1, 4
					addi $t3, $t3, 1
					j loop_get_address_mult
				
				
	
	
	quit_add_person:		#return the address of the network, memory and heap is unchanged
		move $v0, $s0
		lw $t0, 8($v0)
		addi $t0, $t0, 1
		sw $t0, 8($v0)
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
		li $v1, 1
 		jr $ra
	
	quit_add_person_fail:		#return -1 in $v0
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
		li $v0, -1
		li $v1, -1
 		jr $ra
		
.globl get_person
get_person:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)		#initialize
	
	move $s0, $a0		#address of the network
	move $s1, $a1		#string
	move $t8, $s1 		#modifiable address of string
	li $t9, 0		#number of chars in given string
		count_chars_get:
			lb $s2, 0($t8)
			beqz $s2, check_get_person_exists
			addi $t9, $t9, 1
			addi $t8, $t8, 1
			j count_chars_get
	
			check_get_person_exists:
				beqz $t9, quit_get_person_fail
				lw $t0, 8($s0)	#num of existing nodes in array
				li $t1, 0	#counter
				beq $t0, $t1, quit_get_person_fail
				move $t3, $s0	#address of network
				addi $t3, $t3, 16	#address of the node array
				
				loop_check_get_person:
					beq $t1, $t0, quit_get_person_fail
					j loop_char_get_person
					return_get_check:
					addi $t1, $t1, 1
					addi $t3, $t3, 4
					j loop_check_get_person
					
					loop_char_get_person:
						lw $t7, 0($t3)	#address of the node
						lw $t4, 0($t7)	#num of char
						li $t5, 0		#counter
						addi $t6, $t7, 4	#address of char string
						move $s6, $s1
						beq $t4, $t9, check_char_get_person
						j return_get_check
						
					check_char_get_person:
						beq $t4, $t5, quit_get_person_found
						lb $s4, 0($t6)
						lb $s5, 0($s6)
						addi $t6, $t6, 1
						addi $s6, $s6, 1
						addi $t5, $t5, 1
						beq $s4, $s5, check_char_get_person
						j return_get_check
	quit_get_person_fail:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
		li $v0, -1
		li $v1, -1
 		jr $ra
 		
 	quit_get_person_found:
 		move $v0, $t7		#returns address of the node
 		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
		li $v1, 1
 		jr $ra

.globl add_relation
add_relation:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)	
	
	move $s0, $a0		#reference to network (address)
	move $s1, $a1		#name 1	(char string)
	move $s2, $a2		#name 2 (char string)
	move $s3, $a3		#integer
	
	check_relation_int:							#check int 6
		li $t0, 0
		blt $s3, $t0, quit_add_relation_fail
		li $t0, 3
		bgt $s3, $t0, quit_add_relation_fail
		
		check_edge_capacity:						#check capacity 3
			lw $t0, 4($s0)
			lw $t1, 12($s0)
			beq $t0, $t1, quit_add_relation_fail
			
			check_relation_names_exist:				#check names 1 2 
				move $a0, $s0
				move $a1, $s1
				jal get_person
				move $t0, $v0
				move $t1, $v1
				li $t2, -1
				beq $t2, $t1, quit_add_relation_fail
				move $s4, $t0		#address of node 1
				
				move $a0, $s0
				move $a1, $s2
				jal get_person
				move $t0, $v0
				move $t1, $v1
				li $t2, -1
				beq $t2, $t1, quit_add_relation_fail
				move $s5, $t0		#address of node 2
				
				check_same_name:				#check same name 5
					beq $s4, $s5, quit_add_relation_fail
					
					check_relationship_already_exists:	#check relationship already exists 4
						lw $t0, 12($s0)			#amount of edges atm
						move $t1, $s0			#address of network
						addi $t1, $t1, 16		#in array of nodes
						lw $t2, 0($s0)			#num of nodes
						li $t3, 4
						mult $t2, $t3
						mflo $t2			#space taken by node array
						add $t1, $t1, $t2		#start of edge array
						li $t3, 0
						loop_check_relationship_add:
							beq $t0, $t3, add_relationship_good_to_go
							lw $t4, 0($t1)		#address of edge 
							lw $t5, 0($t4)		#node1 of edge
							beq $t5, $s4, check_node2
							beq $t5, $s5, check_node1 	#check if node1 is = edge node2							
							return_check_node:
							addi $t3, $t3, 1
							addi $t1, $t1, 4
							j loop_check_relationship_add
	
							check_node2:
								lw $t5, 4($t4)
								beq $t5, $s5, quit_add_relation_fail
								j return_check_node
								
							check_node1:
								lw $t5, 4($t4)
								beq $t5, $s4, quit_add_relation_fail
								j return_check_node
								
	############################################ABOVE ARE CONDITIONALS############################################
								
			add_relationship_good_to_go:
				li $t0, 0x10012500
				move $t1, $s0 		#address of network
				lw $t2, 0($t1)		#max amount of nodes
				li $t3, 0		#counter
				li $t4, 12
				mult $t4, $t2
				mflo $t4		#space added due to nodes
				add $t0, $t0, $t4	#address without accounting other edge
				j loop_get_relation_mult
				finishRelation:
				add $t0, $t5, $t0	#address of new edge
				
				move $t1, $s0		#address of network
				lw $t2, 12($t1)		#existing # edges
				addi $t1, $t1, 16	#node array
				li $t3, 4		
				mult $t2, $t3		#space from edges in network
				mflo $t2
				add $t1, $t1, $t2	#empty spot for edge 
				lw $t2, 0($s0)
				mult $t2, $t3
				mflo $t3
				add $t1, $t1, $t3
				sw $t0, 0($t1)		#store edge address to empty edge array spot
				
				sw $s4, 0($t0)		#node1 in edge
				sw $s5, 4($t0)		#node2 in edge
				sw $s3, 8($t0)		#relationship int in edge
				j quit_add_relation_success
				
				loop_get_relation_mult:
					li $t5, 12		#how much space each edge takes up
					lw $t4, 12($s0)		#amount of edges currently
					mult $t4, $t5
					mflo $t5		#add to address
					j finishRelation
	
	quit_add_relation_fail:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
		li $v0, -1
		li $v1, -1
 		jr $ra
 		
 	quit_add_relation_success:
 		move $v0, $s0
		lw $t0, 12($v0)
		addi $t0, $t0, 1
		sw $t0, 12($v0)
 		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
		li $v1, 1
 		jr $ra

.globl get_distant_friends
get_distant_friends:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)	
	
	move $s0, $a0			#address of the network
	move $s1, $a1			#name/string
	li $t9, 0x10011000		#address for list of good nodes
	move $s7, $t9		#iterate t9
	li $t8, 0x10011300		#address for list of bad nodes
	move $s6, $t8		#iterate t8
	li $t7, 0x10011600		#list of edges
	move $s5, $t7		#iterate t7
	
	check_distance_name_exist:	#find out if name exists as a node
		jal get_person
		move $t6, $v0		#address of node we are trying to find friends for t6
		move $t1, $v1
		li $t2, -1
		beq $t2, $t1, quit_distant_noName
		
		check_for_friends_relations:	#find edges that contain the node
			move $t0, $s0		#address
			addi $t0, $t0, 16
			lw $t1, 0($s0)
			li $t2, 4
			mult $t1, $t2
			mflo $t2
			add $t0, $t0, $t2	#start of edge array t0
			lw $t1, 12($s0)		#amount of edge atm
			li $t2, 0		#counter
			li $t5, 0		#edgelist counter
			loop_check_for_friends_relations:		#give a list of edges that contain said node
				beq $t1, $t2, valid_list_distant
				lw $t3, 0($t0)	#address of edge
				lw $t4, 0($t3) 	#address of node1
				beq $t4, $t6, add_to_edge_list
				lw $t4, 4($t3)	#address of node2
				beq $t4, $t6, add_to_edge_list
				continueloopcheck:
				addi $t0, $t0, 4
				addi $t2, $t2, 1
				j loop_check_for_friends_relations
				
				add_to_edge_list:
					sw $t3, 0($s5)
					addi $s5, $s5, 4
					addi $t5, $t5, 1
					j continueloopcheck
	
				valid_list_distant:		#check if the relationship is 3
					lw $t0, 0($t7)
					beqz $t0, quit_distant_no_friends
					li $s4, 0		#another counter
					move $s5, $t7
					loop_valid_list_distant:
						beq $s4, $t5, last_bad_list
						lw $t0, 0($s5)	#edge address
						lw $t0, 8($t0)	#int relation
						li $t1, 3
						bne $t0, $t1, add_to_good_list
						j add_to_bad_list
						continueaddtolist:
						addi $s4, $s4, 1
						addi $s5, $s5, 4
						j loop_valid_list_distant
						
						add_to_good_list:
							lw $t0, 0($s5) 		#address of edge
							lw $t1, 0($t0)		#node1
							lw $t0, 0($t0)		#node2
							beq $t1, $t6, add_node2_togoodlist
							beq $t0, $t6, add_node1_togoodlist
							j continueaddtolist
						
							add_node2_togoodlist:	#adds to good list
								sw $t0, 0($s7)
								sw $t0, 0($s6)
								addi $s6, $s6, 4
								addi $s7, $s7, 4
								j continueaddtolist
							
							add_node1_togoodlist:	#adds to good list
								sw $t1, 0($s7)
								sw $t1, 0($s6)
								addi $s6, $s6, 4
								addi $s7, $s7, 4
								j continueaddtolist
							
						add_to_bad_list:
							lw $t0, 0($s5) 		#address of edge
							lw $t1, 0($t0)		#node1
							lw $t0, 0($t0)		#node2
							beq $t1, $t6, add_node2_tobadlist
							beq $t0, $t6, add_node1_tobadlist
							j continueaddtolist	
	
							add_node2_tobadlist:	#adds to bad list
								sw $t0, 0($s6)
								addi $s6, $s6, 4
								j continueaddtolist
							
							add_node1_tobadlist:	#adds to bad list
								sw $t1, 0($s6)
								addi $s6, $s6, 4
								j continueaddtolist
	
					last_bad_list:
						sw $t6, 0($s6)	#bad list contains starting node, all friend nodes, and direct friend nodes
						move $t0, $s0		#address
						addi $t0, $t0, 16
						lw $t1, 0($s0)
						li $t2, 4
						mult $t1, $t2
						mflo $t2
						add $t0, $t0, $t2	#start of edge array t0
						lw $t1, 12($s0)		#amount of edge atm
						li $t2, 0		#counter
						li $t7, 0x10011800	#linkedlistaddress
						move $s3, $t7
						loop_find_distant_finally:
							beq $t2, $t1, make_linked_list
							lw $t3, 0($t0)	#edge address
							lw $t4, 0($t3)	#node 1
							lw $t5, 4($t3)	#node 2
							j check_good_or_bad
							returnlinkedlist:
							addi $t2, $t2, 1
							addi $t0, $t0, 4
							j loop_find_distant_finally
	
							check_good_or_bad:
								move $s7, $t9	#good
								move $s6, $t8	#bad
								loop_check_firstgoodnode:
									lw $s1, 0($s7)
									beqz $s1, loop_check_secondgoodnode
									beq $t4, $s1, check_good_or_badfirst
									addi $s7, $s7, 4
									j loop_check_firstgoodnode
								
									check_good_or_badfirst:
										lw $s1, 0($s6)
										beqz $s1, add_to_linked_first
										beq $s1, $t5, returnlinkedlist
										addi $s6, $s6, 4
										j check_good_or_badfirst
								
								loop_check_secondgoodnode:
									move $s7, $t9	#good
									move $s6, $t8	#bad
									loop_check_firstgoodsecondnode:
										lw $s1, 0($s7)
										beqz $s1, returnlinkedlist
										beq $t5, $s1, check_good_or_badsecond
										addi $s7, $s7, 4
										j loop_check_firstgoodsecondnode
								
										check_good_or_badsecond:
											lw $s1, 0($s6)
											beqz $s1, add_to_linked_second
											beq $s1, $t4, returnlinkedlist
											addi $s6, $s6, 4
											j check_good_or_badsecond
								
							
									add_to_linked_first:
										sw $t5, 0($s3)
										addi $s3, $s3, 4
										j returnlinkedlist
										
									add_to_linked_second:
										sw $t4, 0($s3)
										addi $s3, $s3, 4
										j returnlinkedlist
										
						
						make_linked_list:
							lw $t0, 0($t7)		#list of nodes
							beqz $t0, quit_distant_no_friends
							li $t9, 0x10013000
							move $s1, $t9
							li $t8, 0
							loop_make_linked_list:
								lw $t0, 0($t7)	#address of node
								beqz $t0, quit_distant_linkedlist
								j store_char_linkedlist
								store_char_linkedlist_return:
								j store_friendnode #make sure to loop	
								
								store_char_linkedlist:
									lw $t3, 0($t0)	#num char of node
									li $t4, 0
									addi $t5, $t0, 4
									
									loop_store_char_linkedlist:
										beq $t3, $t4, store_char_linkedlist_return
										lb $t6, 0($t5)	#char
										sb $t6, 0($s1)	#address t9
										addi $t5, $t5, 1
										addi $s1, $s1, 1
										addi $t4, $t4, 1
										j loop_store_char_linkedlist
								
								store_friendnode:
									sw $t0, 0($s1)
									addi $s1, $s1, 4						
									
									li $a0, 4
									li $v0, 9
									syscall
									sw $t9, 0($v0)
									
									add $t9, $t4, $t9
									addi $t9, $t9, 4
									addi $t7, $t7, 4
									j loop_make_linked_list
	quit_distant_linkedlist:
		addi $t0, $s0, 16
		lw $t1, 0($s0)
		lw $t2, 4($s0)
		add $t1, $t1, $t2
		li $t3, 4
		mult $t1, $t3
		mflo $t1
		add $t0, $t1, $t0
		move $v0, $t0		#$s0 is the address of the linkedlist
 		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
 		jr $ra
	
	quit_distant_no_friends:
		li $v0, -1		
 		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
 		jr $ra

	quit_distant_noName:
		li $v0, -2	
 		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
 		jr $ra
