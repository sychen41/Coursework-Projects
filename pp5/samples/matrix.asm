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
	
__Matrix.Init:
	# BeginFunc 0
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Matrix.Set:
	# BeginFunc 0
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Matrix.Get:
	# BeginFunc 0
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Matrix.PrintMatrix:
	# BeginFunc 68
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 68	# decrement sp to make space for locals/temps
	# _tmp0 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp0
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp0 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L0:
	# _tmp1 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp2 = i < _tmp1
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp2 Goto _L1
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp1 from $t0 to $fp-20
	sw $t2, -24($fp)	# spill _tmp2 from $t2 to $fp-24
	beqz $t2, _L1	# branch if _tmp2 is zero 
	# _tmp3 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp3
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp3 from $t0 to $fp-28
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L2:
	# _tmp4 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp5 = j < _tmp4
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp5 Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp4 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp5 from $t2 to $fp-36
	beqz $t2, _L3	# branch if _tmp5 is zero 
	# _tmp6 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp7 = *(_tmp6)
	lw $t2, 0($t1) 	# load with offset
	# PushParam j
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load i from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp8 = ACall _tmp7
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp6 from $t1 to $fp-40
	sw $t2, -44($fp)	# spill _tmp7 from $t2 to $fp-44
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# PushParam _tmp8
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp8 from $t0 to $fp-48
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp9 = "\t"
	.data			# create string constant marked with label
	_string1: .asciiz "\t"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp9
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp9 from $t0 to $fp-52
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp10 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp11 = j + _tmp10
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp11
	move $t1, $t2		# copy value
	# Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp10 from $t0 to $fp-60
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -56($fp)	# spill _tmp11 from $t2 to $fp-56
	b _L2		# unconditional branch
_L3:
	# _tmp12 = "\n"
	.data			# create string constant marked with label
	_string2: .asciiz "\n"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp12
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp12 from $t0 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp13 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp14 = i + _tmp13
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp14
	move $t1, $t2		# copy value
	# Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp13 from $t0 to $fp-72
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -68($fp)	# spill _tmp14 from $t2 to $fp-68
	b _L0		# unconditional branch
_L1:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Matrix.SeedMatrix:
	# BeginFunc 180
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 180	# decrement sp to make space for locals/temps
	# _tmp15 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp15
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp15 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L4:
	# _tmp16 = 5
	li $t0, 5		# load constant value 5 into $t0
	# _tmp17 = i < _tmp16
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp17 Goto _L5
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp16 from $t0 to $fp-20
	sw $t2, -24($fp)	# spill _tmp17 from $t2 to $fp-24
	beqz $t2, _L5	# branch if _tmp17 is zero 
	# _tmp18 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp18
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp18 from $t0 to $fp-28
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L6:
	# _tmp19 = 5
	li $t0, 5		# load constant value 5 into $t0
	# _tmp20 = j < _tmp19
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp20 Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp19 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp20 from $t2 to $fp-36
	beqz $t2, _L7	# branch if _tmp20 is zero 
	# _tmp21 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp22 = *(_tmp21 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp23 = i + j
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	lw $t4, -12($fp)	# load j from $fp-12 into $t4
	add $t5, $t3, $t4	
	# PushParam _tmp23
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam j
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp22
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp21 from $t1 to $fp-40
	sw $t2, -44($fp)	# spill _tmp22 from $t2 to $fp-44
	sw $t5, -48($fp)	# spill _tmp23 from $t5 to $fp-48
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp24 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp25 = j + _tmp24
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp25
	move $t1, $t2		# copy value
	# Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp24 from $t0 to $fp-56
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -52($fp)	# spill _tmp25 from $t2 to $fp-52
	b _L6		# unconditional branch
_L7:
	# _tmp26 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp27 = i + _tmp26
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp27
	move $t1, $t2		# copy value
	# Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp26 from $t0 to $fp-64
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -60($fp)	# spill _tmp27 from $t2 to $fp-60
	b _L4		# unconditional branch
_L5:
	# _tmp28 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp29 = *(_tmp28 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp30 = 4
	li $t3, 4		# load constant value 4 into $t3
	# PushParam _tmp30
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp31 = 3
	li $t4, 3		# load constant value 3 into $t4
	# PushParam _tmp31
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp32 = 2
	li $t5, 2		# load constant value 2 into $t5
	# PushParam _tmp32
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp29
	# (save modified registers before flow of control change)
	sw $t1, -68($fp)	# spill _tmp28 from $t1 to $fp-68
	sw $t2, -72($fp)	# spill _tmp29 from $t2 to $fp-72
	sw $t3, -76($fp)	# spill _tmp30 from $t3 to $fp-76
	sw $t4, -80($fp)	# spill _tmp31 from $t4 to $fp-80
	sw $t5, -84($fp)	# spill _tmp32 from $t5 to $fp-84
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp33 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp34 = *(_tmp33 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp35 = 2
	li $t3, 2		# load constant value 2 into $t3
	# PushParam _tmp35
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp36 = 6
	li $t4, 6		# load constant value 6 into $t4
	# PushParam _tmp36
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp37 = 4
	li $t5, 4		# load constant value 4 into $t5
	# PushParam _tmp37
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp34
	# (save modified registers before flow of control change)
	sw $t1, -88($fp)	# spill _tmp33 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp34 from $t2 to $fp-92
	sw $t3, -96($fp)	# spill _tmp35 from $t3 to $fp-96
	sw $t4, -100($fp)	# spill _tmp36 from $t4 to $fp-100
	sw $t5, -104($fp)	# spill _tmp37 from $t5 to $fp-104
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp38 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp39 = *(_tmp38 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp40 = 5
	li $t3, 5		# load constant value 5 into $t3
	# PushParam _tmp40
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp41 = 3
	li $t4, 3		# load constant value 3 into $t4
	# PushParam _tmp41
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp42 = 2
	li $t5, 2		# load constant value 2 into $t5
	# PushParam _tmp42
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp39
	# (save modified registers before flow of control change)
	sw $t1, -108($fp)	# spill _tmp38 from $t1 to $fp-108
	sw $t2, -112($fp)	# spill _tmp39 from $t2 to $fp-112
	sw $t3, -116($fp)	# spill _tmp40 from $t3 to $fp-116
	sw $t4, -120($fp)	# spill _tmp41 from $t4 to $fp-120
	sw $t5, -124($fp)	# spill _tmp42 from $t5 to $fp-124
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp43 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp44 = *(_tmp43 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp45 = 1
	li $t3, 1		# load constant value 1 into $t3
	# PushParam _tmp45
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp46 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp46
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp47 = 0
	li $t5, 0		# load constant value 0 into $t5
	# PushParam _tmp47
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp44
	# (save modified registers before flow of control change)
	sw $t1, -128($fp)	# spill _tmp43 from $t1 to $fp-128
	sw $t2, -132($fp)	# spill _tmp44 from $t2 to $fp-132
	sw $t3, -136($fp)	# spill _tmp45 from $t3 to $fp-136
	sw $t4, -140($fp)	# spill _tmp46 from $t4 to $fp-140
	sw $t5, -144($fp)	# spill _tmp47 from $t5 to $fp-144
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp48 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp49 = *(_tmp48 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp50 = 3
	li $t3, 3		# load constant value 3 into $t3
	# PushParam _tmp50
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp51 = 6
	li $t4, 6		# load constant value 6 into $t4
	# PushParam _tmp51
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp52 = 1
	li $t5, 1		# load constant value 1 into $t5
	# PushParam _tmp52
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp49
	# (save modified registers before flow of control change)
	sw $t1, -148($fp)	# spill _tmp48 from $t1 to $fp-148
	sw $t2, -152($fp)	# spill _tmp49 from $t2 to $fp-152
	sw $t3, -156($fp)	# spill _tmp50 from $t3 to $fp-156
	sw $t4, -160($fp)	# spill _tmp51 from $t4 to $fp-160
	sw $t5, -164($fp)	# spill _tmp52 from $t5 to $fp-164
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp53 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp54 = *(_tmp53 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp55 = 7
	li $t3, 7		# load constant value 7 into $t3
	# PushParam _tmp55
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp56 = 7
	li $t4, 7		# load constant value 7 into $t4
	# PushParam _tmp56
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp57 = 7
	li $t5, 7		# load constant value 7 into $t5
	# PushParam _tmp57
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp54
	# (save modified registers before flow of control change)
	sw $t1, -168($fp)	# spill _tmp53 from $t1 to $fp-168
	sw $t2, -172($fp)	# spill _tmp54 from $t2 to $fp-172
	sw $t3, -176($fp)	# spill _tmp55 from $t3 to $fp-176
	sw $t4, -180($fp)	# spill _tmp56 from $t4 to $fp-180
	sw $t5, -184($fp)	# spill _tmp57 from $t5 to $fp-184
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Matrix
	.data
	.align 2
	Matrix:		# label for class Matrix vtable
	.word __Matrix.Get
	.word __Matrix.Init
	.word __Matrix.PrintMatrix
	.word __Matrix.SeedMatrix
	.word __Matrix.Set
	.text
__DenseMatrix.Init:
	# BeginFunc 280
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 280	# decrement sp to make space for locals/temps
	# _tmp58 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp59 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp60 = _tmp58 < _tmp59
	slt $t2, $t0, $t1	
	# _tmp61 = _tmp58 == _tmp59
	seq $t3, $t0, $t1	
	# _tmp62 = _tmp60 || _tmp61
	or $t4, $t2, $t3	
	# IfZ _tmp62 Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp58 from $t0 to $fp-16
	sw $t1, -20($fp)	# spill _tmp59 from $t1 to $fp-20
	sw $t2, -24($fp)	# spill _tmp60 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp61 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp62 from $t4 to $fp-32
	beqz $t4, _L8	# branch if _tmp62 is zero 
	# _tmp63 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string3: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp63
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp63 from $t0 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L8:
	# _tmp64 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp65 = _tmp58 * _tmp64
	lw $t1, -16($fp)	# load _tmp58 from $fp-16 into $t1
	mul $t2, $t1, $t0	
	# _tmp66 = _tmp65 + _tmp64
	add $t3, $t2, $t0	
	# PushParam _tmp66
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp67 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp64 from $t0 to $fp-40
	sw $t2, -44($fp)	# spill _tmp65 from $t2 to $fp-44
	sw $t3, -48($fp)	# spill _tmp66 from $t3 to $fp-48
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp67) = _tmp58
	lw $t1, -16($fp)	# load _tmp58 from $fp-16 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp68 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp69 = this + _tmp68
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp69) = _tmp67
	sw $t0, 0($t4) 	# store with offset
	# _tmp70 = 0
	li $t5, 0		# load constant value 0 into $t5
	# i = _tmp70
	move $t6, $t5		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp67 from $t0 to $fp-52
	sw $t2, -56($fp)	# spill _tmp68 from $t2 to $fp-56
	sw $t4, -60($fp)	# spill _tmp69 from $t4 to $fp-60
	sw $t5, -64($fp)	# spill _tmp70 from $t5 to $fp-64
	sw $t6, -8($fp)	# spill i from $t6 to $fp-8
_L9:
	# _tmp71 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp72 = i < _tmp71
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp72 Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp71 from $t0 to $fp-68
	sw $t2, -72($fp)	# spill _tmp72 from $t2 to $fp-72
	beqz $t2, _L10	# branch if _tmp72 is zero 
	# _tmp73 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp74 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp75 = _tmp73 < _tmp74
	slt $t2, $t0, $t1	
	# _tmp76 = _tmp73 == _tmp74
	seq $t3, $t0, $t1	
	# _tmp77 = _tmp75 || _tmp76
	or $t4, $t2, $t3	
	# IfZ _tmp77 Goto _L11
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp73 from $t0 to $fp-76
	sw $t1, -80($fp)	# spill _tmp74 from $t1 to $fp-80
	sw $t2, -84($fp)	# spill _tmp75 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp76 from $t3 to $fp-88
	sw $t4, -92($fp)	# spill _tmp77 from $t4 to $fp-92
	beqz $t4, _L11	# branch if _tmp77 is zero 
	# _tmp78 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string4: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp78
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp78 from $t0 to $fp-96
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L11:
	# _tmp79 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp80 = _tmp73 * _tmp79
	lw $t1, -76($fp)	# load _tmp73 from $fp-76 into $t1
	mul $t2, $t1, $t0	
	# _tmp81 = _tmp80 + _tmp79
	add $t3, $t2, $t0	
	# PushParam _tmp81
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp82 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp79 from $t0 to $fp-100
	sw $t2, -104($fp)	# spill _tmp80 from $t2 to $fp-104
	sw $t3, -108($fp)	# spill _tmp81 from $t3 to $fp-108
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp82) = _tmp73
	lw $t1, -76($fp)	# load _tmp73 from $fp-76 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp83 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp84 = *(_tmp83)
	lw $t4, 0($t3) 	# load with offset
	# _tmp85 = i < _tmp84
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp86 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp87 = _tmp86 < i
	slt $s0, $t7, $t5	
	# _tmp88 = _tmp87 && _tmp85
	and $s1, $s0, $t6	
	# IfZ _tmp88 Goto _L12
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp82 from $t0 to $fp-112
	sw $t3, -116($fp)	# spill _tmp83 from $t3 to $fp-116
	sw $t4, -120($fp)	# spill _tmp84 from $t4 to $fp-120
	sw $t6, -124($fp)	# spill _tmp85 from $t6 to $fp-124
	sw $t7, -128($fp)	# spill _tmp86 from $t7 to $fp-128
	sw $s0, -132($fp)	# spill _tmp87 from $s0 to $fp-132
	sw $s1, -136($fp)	# spill _tmp88 from $s1 to $fp-136
	beqz $s1, _L12	# branch if _tmp88 is zero 
	# _tmp89 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp90 = i * _tmp89
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp91 = _tmp90 + _tmp89
	add $t3, $t2, $t0	
	# _tmp92 = _tmp83 + _tmp91
	lw $t4, -116($fp)	# load _tmp83 from $fp-116 into $t4
	add $t5, $t4, $t3	
	# Goto _L13
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp89 from $t0 to $fp-140
	sw $t2, -144($fp)	# spill _tmp90 from $t2 to $fp-144
	sw $t3, -148($fp)	# spill _tmp91 from $t3 to $fp-148
	sw $t5, -148($fp)	# spill _tmp92 from $t5 to $fp-148
	b _L13		# unconditional branch
_L12:
	# _tmp93 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string5: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp93
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp93 from $t0 to $fp-152
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L13:
	# *(_tmp92) = _tmp82
	lw $t0, -112($fp)	# load _tmp82 from $fp-112 into $t0
	lw $t1, -148($fp)	# load _tmp92 from $fp-148 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp94 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp95 = i + _tmp94
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	add $t4, $t3, $t2	
	# i = _tmp95
	move $t3, $t4		# copy value
	# Goto _L9
	# (save modified registers before flow of control change)
	sw $t2, -160($fp)	# spill _tmp94 from $t2 to $fp-160
	sw $t3, -8($fp)	# spill i from $t3 to $fp-8
	sw $t4, -156($fp)	# spill _tmp95 from $t4 to $fp-156
	b _L9		# unconditional branch
_L10:
	# _tmp96 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp96
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -164($fp)	# spill _tmp96 from $t0 to $fp-164
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L14:
	# _tmp97 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp98 = i < _tmp97
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp98 Goto _L15
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp97 from $t0 to $fp-168
	sw $t2, -172($fp)	# spill _tmp98 from $t2 to $fp-172
	beqz $t2, _L15	# branch if _tmp98 is zero 
	# _tmp99 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp99
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp99 from $t0 to $fp-176
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L16:
	# _tmp100 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp101 = j < _tmp100
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp101 Goto _L17
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp100 from $t0 to $fp-180
	sw $t2, -184($fp)	# spill _tmp101 from $t2 to $fp-184
	beqz $t2, _L17	# branch if _tmp101 is zero 
	# _tmp102 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp103 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp104 = *(_tmp103)
	lw $t3, 0($t2) 	# load with offset
	# _tmp105 = i < _tmp104
	lw $t4, -8($fp)	# load i from $fp-8 into $t4
	slt $t5, $t4, $t3	
	# _tmp106 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp107 = _tmp106 < i
	slt $t7, $t6, $t4	
	# _tmp108 = _tmp107 && _tmp105
	and $s0, $t7, $t5	
	# IfZ _tmp108 Goto _L18
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp102 from $t0 to $fp-188
	sw $t2, -192($fp)	# spill _tmp103 from $t2 to $fp-192
	sw $t3, -196($fp)	# spill _tmp104 from $t3 to $fp-196
	sw $t5, -200($fp)	# spill _tmp105 from $t5 to $fp-200
	sw $t6, -204($fp)	# spill _tmp106 from $t6 to $fp-204
	sw $t7, -208($fp)	# spill _tmp107 from $t7 to $fp-208
	sw $s0, -212($fp)	# spill _tmp108 from $s0 to $fp-212
	beqz $s0, _L18	# branch if _tmp108 is zero 
	# _tmp109 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp110 = i * _tmp109
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp111 = _tmp110 + _tmp109
	add $t3, $t2, $t0	
	# _tmp112 = _tmp103 + _tmp111
	lw $t4, -192($fp)	# load _tmp103 from $fp-192 into $t4
	add $t5, $t4, $t3	
	# Goto _L19
	# (save modified registers before flow of control change)
	sw $t0, -216($fp)	# spill _tmp109 from $t0 to $fp-216
	sw $t2, -220($fp)	# spill _tmp110 from $t2 to $fp-220
	sw $t3, -224($fp)	# spill _tmp111 from $t3 to $fp-224
	sw $t5, -224($fp)	# spill _tmp112 from $t5 to $fp-224
	b _L19		# unconditional branch
_L18:
	# _tmp113 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp113
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -228($fp)	# spill _tmp113 from $t0 to $fp-228
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L19:
	# _tmp114 = *(_tmp112)
	lw $t0, -224($fp)	# load _tmp112 from $fp-224 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp115 = *(_tmp114)
	lw $t2, 0($t1) 	# load with offset
	# _tmp116 = j < _tmp115
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp117 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp118 = _tmp117 < j
	slt $t6, $t5, $t3	
	# _tmp119 = _tmp118 && _tmp116
	and $t7, $t6, $t4	
	# IfZ _tmp119 Goto _L20
	# (save modified registers before flow of control change)
	sw $t1, -232($fp)	# spill _tmp114 from $t1 to $fp-232
	sw $t2, -236($fp)	# spill _tmp115 from $t2 to $fp-236
	sw $t4, -240($fp)	# spill _tmp116 from $t4 to $fp-240
	sw $t5, -244($fp)	# spill _tmp117 from $t5 to $fp-244
	sw $t6, -248($fp)	# spill _tmp118 from $t6 to $fp-248
	sw $t7, -252($fp)	# spill _tmp119 from $t7 to $fp-252
	beqz $t7, _L20	# branch if _tmp119 is zero 
	# _tmp120 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp121 = j * _tmp120
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp122 = _tmp121 + _tmp120
	add $t3, $t2, $t0	
	# _tmp123 = _tmp114 + _tmp122
	lw $t4, -232($fp)	# load _tmp114 from $fp-232 into $t4
	add $t5, $t4, $t3	
	# Goto _L21
	# (save modified registers before flow of control change)
	sw $t0, -256($fp)	# spill _tmp120 from $t0 to $fp-256
	sw $t2, -260($fp)	# spill _tmp121 from $t2 to $fp-260
	sw $t3, -264($fp)	# spill _tmp122 from $t3 to $fp-264
	sw $t5, -264($fp)	# spill _tmp123 from $t5 to $fp-264
	b _L21		# unconditional branch
_L20:
	# _tmp124 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string7: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp124
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -268($fp)	# spill _tmp124 from $t0 to $fp-268
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L21:
	# *(_tmp123) = _tmp102
	lw $t0, -188($fp)	# load _tmp102 from $fp-188 into $t0
	lw $t1, -264($fp)	# load _tmp123 from $fp-264 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp125 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp126 = j + _tmp125
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	add $t4, $t3, $t2	
	# j = _tmp126
	move $t3, $t4		# copy value
	# Goto _L16
	# (save modified registers before flow of control change)
	sw $t2, -276($fp)	# spill _tmp125 from $t2 to $fp-276
	sw $t3, -12($fp)	# spill j from $t3 to $fp-12
	sw $t4, -272($fp)	# spill _tmp126 from $t4 to $fp-272
	b _L16		# unconditional branch
_L17:
	# _tmp127 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp128 = i + _tmp127
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp128
	move $t1, $t2		# copy value
	# Goto _L14
	# (save modified registers before flow of control change)
	sw $t0, -284($fp)	# spill _tmp127 from $t0 to $fp-284
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -280($fp)	# spill _tmp128 from $t2 to $fp-280
	b _L14		# unconditional branch
_L15:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__DenseMatrix.Set:
	# BeginFunc 80
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 80	# decrement sp to make space for locals/temps
	# _tmp129 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp130 = *(_tmp129)
	lw $t2, 0($t1) 	# load with offset
	# _tmp131 = x < _tmp130
	lw $t3, 8($fp)	# load x from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp132 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp133 = _tmp132 < x
	slt $t6, $t5, $t3	
	# _tmp134 = _tmp133 && _tmp131
	and $t7, $t6, $t4	
	# IfZ _tmp134 Goto _L22
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp129 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp130 from $t2 to $fp-12
	sw $t4, -16($fp)	# spill _tmp131 from $t4 to $fp-16
	sw $t5, -20($fp)	# spill _tmp132 from $t5 to $fp-20
	sw $t6, -24($fp)	# spill _tmp133 from $t6 to $fp-24
	sw $t7, -28($fp)	# spill _tmp134 from $t7 to $fp-28
	beqz $t7, _L22	# branch if _tmp134 is zero 
	# _tmp135 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp136 = x * _tmp135
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp137 = _tmp136 + _tmp135
	add $t3, $t2, $t0	
	# _tmp138 = _tmp129 + _tmp137
	lw $t4, -8($fp)	# load _tmp129 from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L23
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp135 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp136 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp137 from $t3 to $fp-40
	sw $t5, -40($fp)	# spill _tmp138 from $t5 to $fp-40
	b _L23		# unconditional branch
_L22:
	# _tmp139 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string8: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp139
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp139 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L23:
	# _tmp140 = *(_tmp138)
	lw $t0, -40($fp)	# load _tmp138 from $fp-40 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp141 = *(_tmp140)
	lw $t2, 0($t1) 	# load with offset
	# _tmp142 = y < _tmp141
	lw $t3, 12($fp)	# load y from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp143 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp144 = _tmp143 < y
	slt $t6, $t5, $t3	
	# _tmp145 = _tmp144 && _tmp142
	and $t7, $t6, $t4	
	# IfZ _tmp145 Goto _L24
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp140 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp141 from $t2 to $fp-52
	sw $t4, -56($fp)	# spill _tmp142 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp143 from $t5 to $fp-60
	sw $t6, -64($fp)	# spill _tmp144 from $t6 to $fp-64
	sw $t7, -68($fp)	# spill _tmp145 from $t7 to $fp-68
	beqz $t7, _L24	# branch if _tmp145 is zero 
	# _tmp146 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp147 = y * _tmp146
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp148 = _tmp147 + _tmp146
	add $t3, $t2, $t0	
	# _tmp149 = _tmp140 + _tmp148
	lw $t4, -48($fp)	# load _tmp140 from $fp-48 into $t4
	add $t5, $t4, $t3	
	# Goto _L25
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp146 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp147 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp148 from $t3 to $fp-80
	sw $t5, -80($fp)	# spill _tmp149 from $t5 to $fp-80
	b _L25		# unconditional branch
_L24:
	# _tmp150 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string9: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp150
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp150 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L25:
	# *(_tmp149) = value
	lw $t0, 16($fp)	# load value from $fp+16 into $t0
	lw $t1, -80($fp)	# load _tmp149 from $fp-80 into $t1
	sw $t0, 0($t1) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__DenseMatrix.Get:
	# BeginFunc 84
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 84	# decrement sp to make space for locals/temps
	# _tmp151 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp152 = *(_tmp151)
	lw $t2, 0($t1) 	# load with offset
	# _tmp153 = x < _tmp152
	lw $t3, 8($fp)	# load x from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp154 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp155 = _tmp154 < x
	slt $t6, $t5, $t3	
	# _tmp156 = _tmp155 && _tmp153
	and $t7, $t6, $t4	
	# IfZ _tmp156 Goto _L26
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp151 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp152 from $t2 to $fp-12
	sw $t4, -16($fp)	# spill _tmp153 from $t4 to $fp-16
	sw $t5, -20($fp)	# spill _tmp154 from $t5 to $fp-20
	sw $t6, -24($fp)	# spill _tmp155 from $t6 to $fp-24
	sw $t7, -28($fp)	# spill _tmp156 from $t7 to $fp-28
	beqz $t7, _L26	# branch if _tmp156 is zero 
	# _tmp157 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp158 = x * _tmp157
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp159 = _tmp158 + _tmp157
	add $t3, $t2, $t0	
	# _tmp160 = _tmp151 + _tmp159
	lw $t4, -8($fp)	# load _tmp151 from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L27
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp157 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp158 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp159 from $t3 to $fp-40
	sw $t5, -40($fp)	# spill _tmp160 from $t5 to $fp-40
	b _L27		# unconditional branch
_L26:
	# _tmp161 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp161
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp161 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L27:
	# _tmp162 = *(_tmp160)
	lw $t0, -40($fp)	# load _tmp160 from $fp-40 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp163 = *(_tmp162)
	lw $t2, 0($t1) 	# load with offset
	# _tmp164 = y < _tmp163
	lw $t3, 12($fp)	# load y from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp165 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp166 = _tmp165 < y
	slt $t6, $t5, $t3	
	# _tmp167 = _tmp166 && _tmp164
	and $t7, $t6, $t4	
	# IfZ _tmp167 Goto _L28
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp162 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp163 from $t2 to $fp-52
	sw $t4, -56($fp)	# spill _tmp164 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp165 from $t5 to $fp-60
	sw $t6, -64($fp)	# spill _tmp166 from $t6 to $fp-64
	sw $t7, -68($fp)	# spill _tmp167 from $t7 to $fp-68
	beqz $t7, _L28	# branch if _tmp167 is zero 
	# _tmp168 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp169 = y * _tmp168
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp170 = _tmp169 + _tmp168
	add $t3, $t2, $t0	
	# _tmp171 = _tmp162 + _tmp170
	lw $t4, -48($fp)	# load _tmp162 from $fp-48 into $t4
	add $t5, $t4, $t3	
	# Goto _L29
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp168 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp169 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp170 from $t3 to $fp-80
	sw $t5, -80($fp)	# spill _tmp171 from $t5 to $fp-80
	b _L29		# unconditional branch
_L28:
	# _tmp172 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string11: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string11	# load label
	# PushParam _tmp172
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp172 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L29:
	# _tmp173 = *(_tmp171)
	lw $t0, -80($fp)	# load _tmp171 from $fp-80 into $t0
	lw $t1, 0($t0) 	# load with offset
	# Return _tmp173
	move $v0, $t1		# assign return value into $v0
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
	# VTable for class DenseMatrix
	.data
	.align 2
	DenseMatrix:		# label for class DenseMatrix vtable
	.word __DenseMatrix.Get
	.word __DenseMatrix.Init
	.word __Matrix.PrintMatrix
	.word __Matrix.SeedMatrix
	.word __DenseMatrix.Set
	.text
__SparseItem.Init:
	# BeginFunc 24
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 24	# decrement sp to make space for locals/temps
	# _tmp174 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp175 = this + _tmp174
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp175) = d
	lw $t3, 8($fp)	# load d from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# _tmp176 = 12
	li $t4, 12		# load constant value 12 into $t4
	# _tmp177 = this + _tmp176
	add $t5, $t1, $t4	
	# *(_tmp177) = y
	lw $t6, 12($fp)	# load y from $fp+12 into $t6
	sw $t6, 0($t5) 	# store with offset
	# _tmp178 = 8
	li $t7, 8		# load constant value 8 into $t7
	# _tmp179 = this + _tmp178
	add $s0, $t1, $t7	
	# *(_tmp179) = next
	lw $s1, 16($fp)	# load next from $fp+16 into $s1
	sw $s1, 0($s0) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__SparseItem.GetNext:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp180 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# Return _tmp180
	move $v0, $t1		# assign return value into $v0
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
__SparseItem.GetY:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp181 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# Return _tmp181
	move $v0, $t1		# assign return value into $v0
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
__SparseItem.GetData:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp182 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# Return _tmp182
	move $v0, $t1		# assign return value into $v0
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
__SparseItem.SetData:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp183 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp184 = this + _tmp183
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp184) = val
	lw $t3, 8($fp)	# load val from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class SparseItem
	.data
	.align 2
	SparseItem:		# label for class SparseItem vtable
	.word __SparseItem.GetData
	.word __SparseItem.GetNext
	.word __SparseItem.GetY
	.word __SparseItem.Init
	.word __SparseItem.SetData
	.text
__SparseMatrix.Init:
	# BeginFunc 116
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 116	# decrement sp to make space for locals/temps
	# _tmp185 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp186 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp187 = _tmp185 < _tmp186
	slt $t2, $t0, $t1	
	# _tmp188 = _tmp185 == _tmp186
	seq $t3, $t0, $t1	
	# _tmp189 = _tmp187 || _tmp188
	or $t4, $t2, $t3	
	# IfZ _tmp189 Goto _L30
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp185 from $t0 to $fp-12
	sw $t1, -16($fp)	# spill _tmp186 from $t1 to $fp-16
	sw $t2, -20($fp)	# spill _tmp187 from $t2 to $fp-20
	sw $t3, -24($fp)	# spill _tmp188 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp189 from $t4 to $fp-28
	beqz $t4, _L30	# branch if _tmp189 is zero 
	# _tmp190 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string12: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string12	# load label
	# PushParam _tmp190
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp190 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L30:
	# _tmp191 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp192 = _tmp185 * _tmp191
	lw $t1, -12($fp)	# load _tmp185 from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp193 = _tmp192 + _tmp191
	add $t3, $t2, $t0	
	# PushParam _tmp193
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp194 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp191 from $t0 to $fp-36
	sw $t2, -40($fp)	# spill _tmp192 from $t2 to $fp-40
	sw $t3, -44($fp)	# spill _tmp193 from $t3 to $fp-44
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp194) = _tmp185
	lw $t1, -12($fp)	# load _tmp185 from $fp-12 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp195 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp196 = this + _tmp195
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp196) = _tmp194
	sw $t0, 0($t4) 	# store with offset
	# _tmp197 = 0
	li $t5, 0		# load constant value 0 into $t5
	# i = _tmp197
	move $t6, $t5		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp194 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp195 from $t2 to $fp-52
	sw $t4, -56($fp)	# spill _tmp196 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp197 from $t5 to $fp-60
	sw $t6, -8($fp)	# spill i from $t6 to $fp-8
_L31:
	# _tmp198 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp199 = i < _tmp198
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp199 Goto _L32
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp198 from $t0 to $fp-64
	sw $t2, -68($fp)	# spill _tmp199 from $t2 to $fp-68
	beqz $t2, _L32	# branch if _tmp199 is zero 
	# _tmp200 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp201 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp202 = *(_tmp201)
	lw $t3, 0($t2) 	# load with offset
	# _tmp203 = i < _tmp202
	lw $t4, -8($fp)	# load i from $fp-8 into $t4
	slt $t5, $t4, $t3	
	# _tmp204 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp205 = _tmp204 < i
	slt $t7, $t6, $t4	
	# _tmp206 = _tmp205 && _tmp203
	and $s0, $t7, $t5	
	# IfZ _tmp206 Goto _L33
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp200 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp201 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp202 from $t3 to $fp-80
	sw $t5, -84($fp)	# spill _tmp203 from $t5 to $fp-84
	sw $t6, -88($fp)	# spill _tmp204 from $t6 to $fp-88
	sw $t7, -92($fp)	# spill _tmp205 from $t7 to $fp-92
	sw $s0, -96($fp)	# spill _tmp206 from $s0 to $fp-96
	beqz $s0, _L33	# branch if _tmp206 is zero 
	# _tmp207 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp208 = i * _tmp207
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp209 = _tmp208 + _tmp207
	add $t3, $t2, $t0	
	# _tmp210 = _tmp201 + _tmp209
	lw $t4, -76($fp)	# load _tmp201 from $fp-76 into $t4
	add $t5, $t4, $t3	
	# Goto _L34
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp207 from $t0 to $fp-100
	sw $t2, -104($fp)	# spill _tmp208 from $t2 to $fp-104
	sw $t3, -108($fp)	# spill _tmp209 from $t3 to $fp-108
	sw $t5, -108($fp)	# spill _tmp210 from $t5 to $fp-108
	b _L34		# unconditional branch
_L33:
	# _tmp211 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string13: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string13	# load label
	# PushParam _tmp211
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp211 from $t0 to $fp-112
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L34:
	# *(_tmp210) = _tmp200
	lw $t0, -72($fp)	# load _tmp200 from $fp-72 into $t0
	lw $t1, -108($fp)	# load _tmp210 from $fp-108 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp212 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp213 = i + _tmp212
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	add $t4, $t3, $t2	
	# i = _tmp213
	move $t3, $t4		# copy value
	# Goto _L31
	# (save modified registers before flow of control change)
	sw $t2, -120($fp)	# spill _tmp212 from $t2 to $fp-120
	sw $t3, -8($fp)	# spill i from $t3 to $fp-8
	sw $t4, -116($fp)	# spill _tmp213 from $t4 to $fp-116
	b _L31		# unconditional branch
_L32:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__SparseMatrix.Find:
	# BeginFunc 96
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 96	# decrement sp to make space for locals/temps
	# _tmp214 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp215 = *(_tmp214)
	lw $t2, 0($t1) 	# load with offset
	# _tmp216 = x < _tmp215
	lw $t3, 8($fp)	# load x from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp217 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp218 = _tmp217 < x
	slt $t6, $t5, $t3	
	# _tmp219 = _tmp218 && _tmp216
	and $t7, $t6, $t4	
	# IfZ _tmp219 Goto _L35
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp214 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp215 from $t2 to $fp-16
	sw $t4, -20($fp)	# spill _tmp216 from $t4 to $fp-20
	sw $t5, -24($fp)	# spill _tmp217 from $t5 to $fp-24
	sw $t6, -28($fp)	# spill _tmp218 from $t6 to $fp-28
	sw $t7, -32($fp)	# spill _tmp219 from $t7 to $fp-32
	beqz $t7, _L35	# branch if _tmp219 is zero 
	# _tmp220 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp221 = x * _tmp220
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp222 = _tmp221 + _tmp220
	add $t3, $t2, $t0	
	# _tmp223 = _tmp214 + _tmp222
	lw $t4, -12($fp)	# load _tmp214 from $fp-12 into $t4
	add $t5, $t4, $t3	
	# Goto _L36
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp220 from $t0 to $fp-36
	sw $t2, -40($fp)	# spill _tmp221 from $t2 to $fp-40
	sw $t3, -44($fp)	# spill _tmp222 from $t3 to $fp-44
	sw $t5, -44($fp)	# spill _tmp223 from $t5 to $fp-44
	b _L36		# unconditional branch
_L35:
	# _tmp224 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string14: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string14	# load label
	# PushParam _tmp224
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp224 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L36:
	# _tmp225 = *(_tmp223)
	lw $t0, -44($fp)	# load _tmp223 from $fp-44 into $t0
	lw $t1, 0($t0) 	# load with offset
	# elem = _tmp225
	move $t2, $t1		# copy value
	# (save modified registers before flow of control change)
	sw $t1, -52($fp)	# spill _tmp225 from $t1 to $fp-52
	sw $t2, -8($fp)	# spill elem from $t2 to $fp-8
_L37:
	# _tmp226 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp227 = elem < _tmp226
	lw $t1, -8($fp)	# load elem from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# _tmp228 = _tmp226 < elem
	slt $t3, $t0, $t1	
	# _tmp229 = _tmp227 || _tmp228
	or $t4, $t2, $t3	
	# IfZ _tmp229 Goto _L38
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp226 from $t0 to $fp-56
	sw $t2, -60($fp)	# spill _tmp227 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp228 from $t3 to $fp-64
	sw $t4, -68($fp)	# spill _tmp229 from $t4 to $fp-68
	beqz $t4, _L38	# branch if _tmp229 is zero 
	# _tmp230 = *(elem)
	lw $t0, -8($fp)	# load elem from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp231 = *(_tmp230 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam elem
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp232 = ACall _tmp231
	# (save modified registers before flow of control change)
	sw $t1, -72($fp)	# spill _tmp230 from $t1 to $fp-72
	sw $t2, -76($fp)	# spill _tmp231 from $t2 to $fp-76
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp233 = _tmp232 == y
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	seq $t2, $t0, $t1	
	# IfZ _tmp233 Goto _L39
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp232 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp233 from $t2 to $fp-84
	beqz $t2, _L39	# branch if _tmp233 is zero 
	# Return elem
	lw $t0, -8($fp)	# load elem from $fp-8 into $t0
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L40
	b _L40		# unconditional branch
_L39:
_L40:
	# _tmp234 = *(elem)
	lw $t0, -8($fp)	# load elem from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp235 = *(_tmp234 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam elem
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp236 = ACall _tmp235
	# (save modified registers before flow of control change)
	sw $t1, -88($fp)	# spill _tmp234 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp235 from $t2 to $fp-92
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# elem = _tmp236
	move $t1, $t0		# copy value
	# Goto _L37
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp236 from $t0 to $fp-96
	sw $t1, -8($fp)	# spill elem from $t1 to $fp-8
	b _L37		# unconditional branch
_L38:
	# _tmp237 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp237
	move $v0, $t0		# assign return value into $v0
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
__SparseMatrix.Set:
	# BeginFunc 144
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 144	# decrement sp to make space for locals/temps
	# _tmp238 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp239 = *(_tmp238)
	lw $t2, 0($t1) 	# load with offset
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 12($fp)	# load y from $fp+12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load x from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp240 = ACall _tmp239
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp238 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp239 from $t2 to $fp-16
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# elem = _tmp240
	move $t1, $t0		# copy value
	# _tmp241 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp242 = elem < _tmp241
	slt $t3, $t1, $t2	
	# _tmp243 = _tmp241 < elem
	slt $t4, $t2, $t1	
	# _tmp244 = _tmp242 || _tmp243
	or $t5, $t3, $t4	
	# IfZ _tmp244 Goto _L41
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp240 from $t0 to $fp-20
	sw $t1, -8($fp)	# spill elem from $t1 to $fp-8
	sw $t2, -24($fp)	# spill _tmp241 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp242 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp243 from $t4 to $fp-32
	sw $t5, -36($fp)	# spill _tmp244 from $t5 to $fp-36
	beqz $t5, _L41	# branch if _tmp244 is zero 
	# _tmp245 = *(elem)
	lw $t0, -8($fp)	# load elem from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp246 = *(_tmp245 + 16)
	lw $t2, 16($t1) 	# load with offset
	# PushParam value
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 16($fp)	# load value from $fp+16 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam elem
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp246
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp245 from $t1 to $fp-40
	sw $t2, -44($fp)	# spill _tmp246 from $t2 to $fp-44
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L42
	b _L42		# unconditional branch
_L41:
	# _tmp247 = 16
	li $t0, 16		# load constant value 16 into $t0
	# PushParam _tmp247
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp248 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp247 from $t0 to $fp-48
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp249 = SparseItem
	la $t1, SparseItem	# load label
	# *(_tmp248) = _tmp249
	sw $t1, 0($t0) 	# store with offset
	# elem = _tmp248
	move $t2, $t0		# copy value
	# _tmp250 = *(elem)
	lw $t3, 0($t2) 	# load with offset
	# _tmp251 = *(_tmp250 + 12)
	lw $t4, 12($t3) 	# load with offset
	# _tmp252 = *(this + 4)
	lw $t5, 4($fp)	# load this from $fp+4 into $t5
	lw $t6, 4($t5) 	# load with offset
	# _tmp253 = *(_tmp252)
	lw $t7, 0($t6) 	# load with offset
	# _tmp254 = x < _tmp253
	lw $s0, 8($fp)	# load x from $fp+8 into $s0
	slt $s1, $s0, $t7	
	# _tmp255 = -1
	li $s2, -1		# load constant value -1 into $s2
	# _tmp256 = _tmp255 < x
	slt $s3, $s2, $s0	
	# _tmp257 = _tmp256 && _tmp254
	and $s4, $s3, $s1	
	# IfZ _tmp257 Goto _L43
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp248 from $t0 to $fp-52
	sw $t1, -56($fp)	# spill _tmp249 from $t1 to $fp-56
	sw $t2, -8($fp)	# spill elem from $t2 to $fp-8
	sw $t3, -60($fp)	# spill _tmp250 from $t3 to $fp-60
	sw $t4, -64($fp)	# spill _tmp251 from $t4 to $fp-64
	sw $t6, -68($fp)	# spill _tmp252 from $t6 to $fp-68
	sw $t7, -72($fp)	# spill _tmp253 from $t7 to $fp-72
	sw $s1, -76($fp)	# spill _tmp254 from $s1 to $fp-76
	sw $s2, -80($fp)	# spill _tmp255 from $s2 to $fp-80
	sw $s3, -84($fp)	# spill _tmp256 from $s3 to $fp-84
	sw $s4, -88($fp)	# spill _tmp257 from $s4 to $fp-88
	beqz $s4, _L43	# branch if _tmp257 is zero 
	# _tmp258 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp259 = x * _tmp258
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp260 = _tmp259 + _tmp258
	add $t3, $t2, $t0	
	# _tmp261 = _tmp252 + _tmp260
	lw $t4, -68($fp)	# load _tmp252 from $fp-68 into $t4
	add $t5, $t4, $t3	
	# Goto _L44
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp258 from $t0 to $fp-92
	sw $t2, -96($fp)	# spill _tmp259 from $t2 to $fp-96
	sw $t3, -100($fp)	# spill _tmp260 from $t3 to $fp-100
	sw $t5, -100($fp)	# spill _tmp261 from $t5 to $fp-100
	b _L44		# unconditional branch
_L43:
	# _tmp262 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string15: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string15	# load label
	# PushParam _tmp262
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp262 from $t0 to $fp-104
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L44:
	# _tmp263 = *(_tmp261)
	lw $t0, -100($fp)	# load _tmp261 from $fp-100 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam _tmp263
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, 12($fp)	# load y from $fp+12 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam value
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 16($fp)	# load value from $fp+16 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam elem
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load elem from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# ACall _tmp251
	lw $t5, -64($fp)	# load _tmp251 from $fp-64 into $t5
	# (save modified registers before flow of control change)
	sw $t1, -108($fp)	# spill _tmp263 from $t1 to $fp-108
	jalr $t5            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp264 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp265 = *(_tmp264)
	lw $t2, 0($t1) 	# load with offset
	# _tmp266 = x < _tmp265
	lw $t3, 8($fp)	# load x from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp267 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp268 = _tmp267 < x
	slt $t6, $t5, $t3	
	# _tmp269 = _tmp268 && _tmp266
	and $t7, $t6, $t4	
	# IfZ _tmp269 Goto _L45
	# (save modified registers before flow of control change)
	sw $t1, -112($fp)	# spill _tmp264 from $t1 to $fp-112
	sw $t2, -116($fp)	# spill _tmp265 from $t2 to $fp-116
	sw $t4, -120($fp)	# spill _tmp266 from $t4 to $fp-120
	sw $t5, -124($fp)	# spill _tmp267 from $t5 to $fp-124
	sw $t6, -128($fp)	# spill _tmp268 from $t6 to $fp-128
	sw $t7, -132($fp)	# spill _tmp269 from $t7 to $fp-132
	beqz $t7, _L45	# branch if _tmp269 is zero 
	# _tmp270 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp271 = x * _tmp270
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp272 = _tmp271 + _tmp270
	add $t3, $t2, $t0	
	# _tmp273 = _tmp264 + _tmp272
	lw $t4, -112($fp)	# load _tmp264 from $fp-112 into $t4
	add $t5, $t4, $t3	
	# Goto _L46
	# (save modified registers before flow of control change)
	sw $t0, -136($fp)	# spill _tmp270 from $t0 to $fp-136
	sw $t2, -140($fp)	# spill _tmp271 from $t2 to $fp-140
	sw $t3, -144($fp)	# spill _tmp272 from $t3 to $fp-144
	sw $t5, -144($fp)	# spill _tmp273 from $t5 to $fp-144
	b _L46		# unconditional branch
_L45:
	# _tmp274 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string16: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string16	# load label
	# PushParam _tmp274
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -148($fp)	# spill _tmp274 from $t0 to $fp-148
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L46:
	# *(_tmp273) = elem
	lw $t0, -8($fp)	# load elem from $fp-8 into $t0
	lw $t1, -144($fp)	# load _tmp273 from $fp-144 into $t1
	sw $t0, 0($t1) 	# store with offset
_L42:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__SparseMatrix.Get:
	# BeginFunc 48
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp275 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp276 = *(_tmp275)
	lw $t2, 0($t1) 	# load with offset
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 12($fp)	# load y from $fp+12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load x from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp277 = ACall _tmp276
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp275 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp276 from $t2 to $fp-16
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# elem = _tmp277
	move $t1, $t0		# copy value
	# _tmp278 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp279 = elem < _tmp278
	slt $t3, $t1, $t2	
	# _tmp280 = _tmp278 < elem
	slt $t4, $t2, $t1	
	# _tmp281 = _tmp279 || _tmp280
	or $t5, $t3, $t4	
	# IfZ _tmp281 Goto _L47
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp277 from $t0 to $fp-20
	sw $t1, -8($fp)	# spill elem from $t1 to $fp-8
	sw $t2, -24($fp)	# spill _tmp278 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp279 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp280 from $t4 to $fp-32
	sw $t5, -36($fp)	# spill _tmp281 from $t5 to $fp-36
	beqz $t5, _L47	# branch if _tmp281 is zero 
	# _tmp282 = *(elem)
	lw $t0, -8($fp)	# load elem from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp283 = *(_tmp282)
	lw $t2, 0($t1) 	# load with offset
	# PushParam elem
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp284 = ACall _tmp283
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp282 from $t1 to $fp-40
	sw $t2, -44($fp)	# spill _tmp283 from $t2 to $fp-44
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Return _tmp284
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L48
	b _L48		# unconditional branch
_L47:
	# _tmp285 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp285
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
_L48:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class SparseMatrix
	.data
	.align 2
	SparseMatrix:		# label for class SparseMatrix vtable
	.word __SparseMatrix.Find
	.word __SparseMatrix.Get
	.word __SparseMatrix.Init
	.word __Matrix.PrintMatrix
	.word __Matrix.SeedMatrix
	.word __SparseMatrix.Set
	.text
main:
	# BeginFunc 84
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 84	# decrement sp to make space for locals/temps
	# _tmp286 = "Dense Rep \n"
	.data			# create string constant marked with label
	_string17: .asciiz "Dense Rep \n"
	.text
	la $t0, _string17	# load label
	# PushParam _tmp286
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp286 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp287 = 8
	li $t0, 8		# load constant value 8 into $t0
	# PushParam _tmp287
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp288 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp287 from $t0 to $fp-16
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp289 = DenseMatrix
	la $t1, DenseMatrix	# load label
	# *(_tmp288) = _tmp289
	sw $t1, 0($t0) 	# store with offset
	# m = _tmp288
	move $t2, $t0		# copy value
	# _tmp290 = *(m)
	lw $t3, 0($t2) 	# load with offset
	# _tmp291 = *(_tmp290 + 4)
	lw $t4, 4($t3) 	# load with offset
	# PushParam m
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp291
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp288 from $t0 to $fp-20
	sw $t1, -24($fp)	# spill _tmp289 from $t1 to $fp-24
	sw $t2, -8($fp)	# spill m from $t2 to $fp-8
	sw $t3, -28($fp)	# spill _tmp290 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp291 from $t4 to $fp-32
	jalr $t4            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp292 = *(m)
	lw $t0, -8($fp)	# load m from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp293 = *(_tmp292 + 12)
	lw $t2, 12($t1) 	# load with offset
	# PushParam m
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp293
	# (save modified registers before flow of control change)
	sw $t1, -36($fp)	# spill _tmp292 from $t1 to $fp-36
	sw $t2, -40($fp)	# spill _tmp293 from $t2 to $fp-40
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp294 = *(m)
	lw $t0, -8($fp)	# load m from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp295 = *(_tmp294 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam m
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp295
	# (save modified registers before flow of control change)
	sw $t1, -44($fp)	# spill _tmp294 from $t1 to $fp-44
	sw $t2, -48($fp)	# spill _tmp295 from $t2 to $fp-48
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp296 = "Sparse Rep \n"
	.data			# create string constant marked with label
	_string18: .asciiz "Sparse Rep \n"
	.text
	la $t0, _string18	# load label
	# PushParam _tmp296
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp296 from $t0 to $fp-52
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp297 = 8
	li $t0, 8		# load constant value 8 into $t0
	# PushParam _tmp297
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp298 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp297 from $t0 to $fp-56
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp299 = SparseMatrix
	la $t1, SparseMatrix	# load label
	# *(_tmp298) = _tmp299
	sw $t1, 0($t0) 	# store with offset
	# m = _tmp298
	move $t2, $t0		# copy value
	# _tmp300 = *(m)
	lw $t3, 0($t2) 	# load with offset
	# _tmp301 = *(_tmp300 + 4)
	lw $t4, 4($t3) 	# load with offset
	# PushParam m
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp301
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp298 from $t0 to $fp-60
	sw $t1, -64($fp)	# spill _tmp299 from $t1 to $fp-64
	sw $t2, -8($fp)	# spill m from $t2 to $fp-8
	sw $t3, -68($fp)	# spill _tmp300 from $t3 to $fp-68
	sw $t4, -72($fp)	# spill _tmp301 from $t4 to $fp-72
	jalr $t4            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp302 = *(m)
	lw $t0, -8($fp)	# load m from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp303 = *(_tmp302 + 12)
	lw $t2, 12($t1) 	# load with offset
	# PushParam m
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp303
	# (save modified registers before flow of control change)
	sw $t1, -76($fp)	# spill _tmp302 from $t1 to $fp-76
	sw $t2, -80($fp)	# spill _tmp303 from $t2 to $fp-80
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp304 = *(m)
	lw $t0, -8($fp)	# load m from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp305 = *(_tmp304 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam m
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp305
	# (save modified registers before flow of control change)
	sw $t1, -84($fp)	# spill _tmp304 from $t1 to $fp-84
	sw $t2, -88($fp)	# spill _tmp305 from $t2 to $fp-88
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
