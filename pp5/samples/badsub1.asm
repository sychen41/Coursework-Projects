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
	# BeginFunc 120
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 120	# decrement sp to make space for locals/temps
	# _tmp0 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp1 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp2 = _tmp0 < _tmp1
	slt $t2, $t0, $t1	
	# _tmp3 = _tmp0 == _tmp1
	seq $t3, $t0, $t1	
	# _tmp4 = _tmp2 || _tmp3
	or $t4, $t2, $t3	
	# IfZ _tmp4 Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp0 from $t0 to $fp-16
	sw $t1, -20($fp)	# spill _tmp1 from $t1 to $fp-20
	sw $t2, -24($fp)	# spill _tmp2 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp3 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp4 from $t4 to $fp-32
	beqz $t4, _L0	# branch if _tmp4 is zero 
	# _tmp5 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string1: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp5
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp5 from $t0 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L0:
	# _tmp6 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp7 = _tmp0 * _tmp6
	lw $t1, -16($fp)	# load _tmp0 from $fp-16 into $t1
	mul $t2, $t1, $t0	
	# _tmp8 = _tmp7 + _tmp6
	add $t3, $t2, $t0	
	# PushParam _tmp8
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp9 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp6 from $t0 to $fp-40
	sw $t2, -44($fp)	# spill _tmp7 from $t2 to $fp-44
	sw $t3, -48($fp)	# spill _tmp8 from $t3 to $fp-48
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp9) = _tmp0
	lw $t1, -16($fp)	# load _tmp0 from $fp-16 into $t1
	sw $t1, 0($t0) 	# store with offset
	# arr = _tmp9
	move $t2, $t0		# copy value
	# _tmp10 = 0
	li $t3, 0		# load constant value 0 into $t3
	# i = _tmp10
	move $t4, $t3		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp9 from $t0 to $fp-52
	sw $t2, -8($fp)	# spill arr from $t2 to $fp-8
	sw $t3, -56($fp)	# spill _tmp10 from $t3 to $fp-56
	sw $t4, -12($fp)	# spill i from $t4 to $fp-12
_L1:
	# _tmp11 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp12 = i < _tmp11
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# _tmp13 = i == _tmp11
	seq $t3, $t1, $t0	
	# _tmp14 = _tmp12 || _tmp13
	or $t4, $t2, $t3	
	# IfZ _tmp14 Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp11 from $t0 to $fp-60
	sw $t2, -64($fp)	# spill _tmp12 from $t2 to $fp-64
	sw $t3, -68($fp)	# spill _tmp13 from $t3 to $fp-68
	sw $t4, -72($fp)	# spill _tmp14 from $t4 to $fp-72
	beqz $t4, _L2	# branch if _tmp14 is zero 
	# _tmp15 = *(arr)
	lw $t0, -8($fp)	# load arr from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp16 = i < _tmp15
	lw $t2, -12($fp)	# load i from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# _tmp17 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp18 = _tmp17 < i
	slt $t5, $t4, $t2	
	# _tmp19 = _tmp18 && _tmp16
	and $t6, $t5, $t3	
	# IfZ _tmp19 Goto _L3
	# (save modified registers before flow of control change)
	sw $t1, -76($fp)	# spill _tmp15 from $t1 to $fp-76
	sw $t3, -80($fp)	# spill _tmp16 from $t3 to $fp-80
	sw $t4, -84($fp)	# spill _tmp17 from $t4 to $fp-84
	sw $t5, -88($fp)	# spill _tmp18 from $t5 to $fp-88
	sw $t6, -92($fp)	# spill _tmp19 from $t6 to $fp-92
	beqz $t6, _L3	# branch if _tmp19 is zero 
	# _tmp20 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp21 = i * _tmp20
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp22 = _tmp21 + _tmp20
	add $t3, $t2, $t0	
	# _tmp23 = arr + _tmp22
	lw $t4, -8($fp)	# load arr from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp20 from $t0 to $fp-96
	sw $t2, -100($fp)	# spill _tmp21 from $t2 to $fp-100
	sw $t3, -104($fp)	# spill _tmp22 from $t3 to $fp-104
	sw $t5, -104($fp)	# spill _tmp23 from $t5 to $fp-104
	b _L4		# unconditional branch
_L3:
	# _tmp24 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string2: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp24
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp24 from $t0 to $fp-108
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L4:
	# *(_tmp23) = i
	lw $t0, -12($fp)	# load i from $fp-12 into $t0
	lw $t1, -104($fp)	# load _tmp23 from $fp-104 into $t1
	sw $t0, 0($t1) 	# store with offset
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp25 = "\n"
	.data			# create string constant marked with label
	_string3: .asciiz "\n"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp25
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp25 from $t0 to $fp-112
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp26 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp27 = i + _tmp26
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	add $t2, $t1, $t0	
	# i = _tmp27
	move $t1, $t2		# copy value
	# Goto _L1
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp26 from $t0 to $fp-120
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
	sw $t2, -116($fp)	# spill _tmp27 from $t2 to $fp-116
	b _L1		# unconditional branch
_L2:
	# _tmp28 = "Done\n"
	.data			# create string constant marked with label
	_string4: .asciiz "Done\n"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp28
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp28 from $t0 to $fp-124
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
