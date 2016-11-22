	# standard Decaf preamble 
	.data
TRUE:
	.asciiz "true"
FALSE:
	.asciiz "false"
	
	.text
	.align 2
	.globl main
	.globl _PrintInt
	.globl _PrintString
	.globl _PrintBool
	.globl _Alloc
	.globl _StringEqual
	.globl _Halt
	.globl _ReadInteger
	.globl _ReadLine
	
_PrintInt:
	subu $sp, $sp, 8	# decrement so to make space to save ra, fp
	sw $fp, 8($sp)  	# save fp
	sw $ra, 4($sp)  	# save ra
	addiu $fp, $sp, 8	# set up new fp
	li $v0, 1       	# system call code for print_int
	lw $a0, 4($fp)
	syscall
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_PrintBool:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	lw $t1, 4($fp)
	blez $t1, fbr
	li $v0, 4       	# system call for print_str
	la $a0, TRUE
	syscall
	b end
fbr:
	li $v0, 4       	# system call for print_str
	la $a0, FALSE
	syscall
end:
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_PrintString:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	li $v0, 4       	# system call for print_str
	lw $a0, 4($fp)
	syscall
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_Alloc:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	li $v0, 9       	# system call for sbrk
	lw $a0, 4($fp)
	syscall
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_StringEqual:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	subu $sp, $sp, 4	# decrement sp to make space for return value
	li $v0, 0
	#Determine length string 1
	lw $t0, 4($fp)
	li $t3, 0
bloop1:
	lb $t5, ($t0)
	beqz $t5, eloop1
	addi $t0, 1
	addi $t3, 1
	b bloop1
eloop1:
	#Determine length string 2
	lw $t1, 8($fp)
	li $t4, 0
bloop2:
	lb $t5, ($t1)
	beqz $t5, eloop2
	addi $t1, 1
	addi $t4, 1
	b bloop2
eloop2:
	bne $t3, $t4, end1	# check if string lengths are the same
	lw $t0, 4($fp)
	lw $t1, 8($fp)
	li $t3, 0
bloop3:
	lb $t5, ($t0)
	lb $t6, ($t1)
	bne $t5, $t6, end1
	addi $t3, 1
	addi $t0, 1
	addi $t1, 1
	bne $t3, $t4, bloop3
eloop3:
	li $v0, 1
end1:
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_Halt:
	li $v0, 10
	syscall
	
_ReadInteger:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	subu $sp, $sp, 4
	li $v0, 5
	syscall
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_ReadLine:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	li $t0, 40
	subu $sp, $sp, 4
	sw $t0, 4($sp)
	jal _Alloc
	move $t0, $v0
	li $a1, 40
	move $a0, $t0
	li $v0, 8
	syscall
	move $t1, $t0
bloop4:
	lb $t5, ($t1)
	beqz $t5, eloop4
	addi $t1, 1
	b bloop4
eloop4:
	addi $t1, -1
	li $t6, 0
	sb $t6, ($t1)
	move $v0, $t0
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
main:
	# BeginFunc 56
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 56	# decrement sp to make space for locals/temps
	# _tmp0 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp1 = 5
	li $t1, 5		# load constant value 5 into $t1
	# _tmp2 = _tmp0 - _tmp1
	sub $t2, $t0, $t1	
	# _tmp3 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp4 = _tmp2 < _tmp3
	slt $t4, $t2, $t3	
	# _tmp5 = _tmp2 == _tmp3
	seq $t5, $t2, $t3	
	# _tmp6 = _tmp4 || _tmp5
	or $t6, $t4, $t5	
	# IfZ _tmp6 Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp0 from $t0 to $fp-12
	sw $t1, -20($fp)	# spill _tmp1 from $t1 to $fp-20
	sw $t2, -16($fp)	# spill _tmp2 from $t2 to $fp-16
	sw $t3, -24($fp)	# spill _tmp3 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp4 from $t4 to $fp-28
	sw $t5, -32($fp)	# spill _tmp5 from $t5 to $fp-32
	sw $t6, -36($fp)	# spill _tmp6 from $t6 to $fp-36
	beqz $t6, _L0	# branch if _tmp6 is zero 
	# _tmp7 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string1: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp7
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp7 from $t0 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L0:
	# _tmp8 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp9 = _tmp2 * _tmp8
	lw $t1, -16($fp)	# load _tmp2 from $fp-16 into $t1
	mul $t2, $t1, $t0	
	# _tmp10 = _tmp9 + _tmp8
	add $t3, $t2, $t0	
	# PushParam _tmp10
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp11 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp8 from $t0 to $fp-44
	sw $t2, -48($fp)	# spill _tmp9 from $t2 to $fp-48
	sw $t3, -52($fp)	# spill _tmp10 from $t3 to $fp-52
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp11) = _tmp2
	lw $t1, -16($fp)	# load _tmp2 from $fp-16 into $t1
	sw $t1, 0($t0) 	# store with offset
	# arr = _tmp11
	move $t2, $t0		# copy value
	# _tmp12 = "How did I get here?\n"
	.data			# create string constant marked with label
	_string2: .asciiz "How did I get here?\n"
	.text
	la $t3, _string2	# load label
	# PushParam _tmp12
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp11 from $t0 to $fp-56
	sw $t2, -8($fp)	# spill arr from $t2 to $fp-8
	sw $t3, -60($fp)	# spill _tmp12 from $t3 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
