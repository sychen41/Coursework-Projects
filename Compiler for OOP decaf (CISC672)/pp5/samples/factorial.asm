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
	
__factorial:
	# BeginFunc 36
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 36	# decrement sp to make space for locals/temps
	# _tmp0 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1 = n < _tmp0
	lw $t1, 4($fp)	# load n from $fp+4 into $t1
	slt $t2, $t1, $t0	
	# _tmp2 = n == _tmp0
	seq $t3, $t1, $t0	
	# _tmp3 = _tmp1 || _tmp2
	or $t4, $t2, $t3	
	# IfZ _tmp3 Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp0 from $t0 to $fp-8
	sw $t2, -12($fp)	# spill _tmp1 from $t2 to $fp-12
	sw $t3, -16($fp)	# spill _tmp2 from $t3 to $fp-16
	sw $t4, -20($fp)	# spill _tmp3 from $t4 to $fp-20
	beqz $t4, _L0	# branch if _tmp3 is zero 
	# _tmp4 = 1
	li $t0, 1		# load constant value 1 into $t0
	# Return _tmp4
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L1
	b _L1		# unconditional branch
_L0:
_L1:
	# _tmp5 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp6 = n - _tmp5
	lw $t1, 4($fp)	# load n from $fp+4 into $t1
	sub $t2, $t1, $t0	
	# PushParam _tmp6
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp7 = LCall __factorial
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp5 from $t0 to $fp-36
	sw $t2, -32($fp)	# spill _tmp6 from $t2 to $fp-32
	jal __factorial    	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp8 = n * _tmp7
	lw $t1, 4($fp)	# load n from $fp+4 into $t1
	mul $t2, $t1, $t0	
	# Return _tmp8
	move $v0, $t2		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
main:
	# BeginFunc 48
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp9 = 1
	li $t0, 1		# load constant value 1 into $t0
	# n = _tmp9
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp9 from $t0 to $fp-12
	sw $t1, -8($fp)	# spill n from $t1 to $fp-8
_L2:
	# _tmp10 = 15
	li $t0, 15		# load constant value 15 into $t0
	# _tmp11 = n < _tmp10
	lw $t1, -8($fp)	# load n from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# _tmp12 = n == _tmp10
	seq $t3, $t1, $t0	
	# _tmp13 = _tmp11 || _tmp12
	or $t4, $t2, $t3	
	# IfZ _tmp13 Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp10 from $t0 to $fp-16
	sw $t2, -20($fp)	# spill _tmp11 from $t2 to $fp-20
	sw $t3, -24($fp)	# spill _tmp12 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp13 from $t4 to $fp-28
	beqz $t4, _L3	# branch if _tmp13 is zero 
	# _tmp14 = "Factorial("
	.data			# create string constant marked with label
	_string1: .asciiz "Factorial("
	.text
	la $t0, _string1	# load label
	# PushParam _tmp14
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp14 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam n
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load n from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp15 = ") = "
	.data			# create string constant marked with label
	_string2: .asciiz ") = "
	.text
	la $t0, _string2	# load label
	# PushParam _tmp15
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp15 from $t0 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam n
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load n from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp16 = LCall __factorial
	jal __factorial    	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp16
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp16 from $t0 to $fp-40
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp17 = "\n"
	.data			# create string constant marked with label
	_string3: .asciiz "\n"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp17
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp17 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp18 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp19 = n + _tmp18
	lw $t1, -8($fp)	# load n from $fp-8 into $t1
	add $t2, $t1, $t0	
	# n = _tmp19
	move $t1, $t2		# copy value
	# Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp18 from $t0 to $fp-52
	sw $t1, -8($fp)	# spill n from $t1 to $fp-8
	sw $t2, -48($fp)	# spill _tmp19 from $t2 to $fp-48
	b _L2		# unconditional branch
_L3:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
