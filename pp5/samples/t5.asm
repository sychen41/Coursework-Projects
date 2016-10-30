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
	
__Wild:
	# BeginFunc 76
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 76	# decrement sp to make space for locals/temps
	# _tmp0 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp0
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp0 from $t0 to $fp-12
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L0:
	# _tmp1 = *(names)
	lw $t0, 4($fp)	# load names from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2 = i < _tmp1
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp2 Goto _L1
	# (save modified registers before flow of control change)
	sw $t1, -16($fp)	# spill _tmp1 from $t1 to $fp-16
	sw $t3, -20($fp)	# spill _tmp2 from $t3 to $fp-20
	beqz $t3, _L1	# branch if _tmp2 is zero 
	# _tmp3 = *(names)
	lw $t0, 4($fp)	# load names from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp4 = i < _tmp3
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# _tmp5 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp6 = _tmp5 < i
	slt $t5, $t4, $t2	
	# _tmp7 = _tmp6 && _tmp4
	and $t6, $t5, $t3	
	# IfZ _tmp7 Goto _L4
	# (save modified registers before flow of control change)
	sw $t1, -28($fp)	# spill _tmp3 from $t1 to $fp-28
	sw $t3, -32($fp)	# spill _tmp4 from $t3 to $fp-32
	sw $t4, -36($fp)	# spill _tmp5 from $t4 to $fp-36
	sw $t5, -40($fp)	# spill _tmp6 from $t5 to $fp-40
	sw $t6, -44($fp)	# spill _tmp7 from $t6 to $fp-44
	beqz $t6, _L4	# branch if _tmp7 is zero 
	# _tmp8 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp9 = i * _tmp8
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp10 = _tmp9 + _tmp8
	add $t3, $t2, $t0	
	# _tmp11 = names + _tmp10
	lw $t4, 4($fp)	# load names from $fp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L5
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp8 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp9 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp10 from $t3 to $fp-56
	sw $t5, -56($fp)	# spill _tmp11 from $t5 to $fp-56
	b _L5		# unconditional branch
_L4:
	# _tmp12 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string1: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp12
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp12 from $t0 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L5:
	# _tmp13 = *(_tmp11)
	lw $t0, -56($fp)	# load _tmp11 from $fp-56 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam answer
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, 8($fp)	# load answer from $fp+8 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam _tmp13
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp14 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t1, -64($fp)	# spill _tmp13 from $t1 to $fp-64
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp14 Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp14 from $t0 to $fp-24
	beqz $t0, _L2	# branch if _tmp14 is zero 
	# _tmp15 = 1
	li $t0, 1		# load constant value 1 into $t0
	# Return _tmp15
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L3
	b _L3		# unconditional branch
_L2:
_L3:
	# _tmp16 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp17 = i + _tmp16
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp17
	move $t1, $t2		# copy value
	# Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp16 from $t0 to $fp-76
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -72($fp)	# spill _tmp17 from $t2 to $fp-72
	b _L0		# unconditional branch
_L1:
	# _tmp18 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp18
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
main:
	# BeginFunc 244
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 244	# decrement sp to make space for locals/temps
	# _tmp19 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp20 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp21 = _tmp19 < _tmp20
	slt $t2, $t0, $t1	
	# _tmp22 = _tmp19 == _tmp20
	seq $t3, $t0, $t1	
	# _tmp23 = _tmp21 || _tmp22
	or $t4, $t2, $t3	
	# IfZ _tmp23 Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp19 from $t0 to $fp-12
	sw $t1, -16($fp)	# spill _tmp20 from $t1 to $fp-16
	sw $t2, -20($fp)	# spill _tmp21 from $t2 to $fp-20
	sw $t3, -24($fp)	# spill _tmp22 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp23 from $t4 to $fp-28
	beqz $t4, _L6	# branch if _tmp23 is zero 
	# _tmp24 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string2: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp24
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp24 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L6:
	# _tmp25 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp26 = _tmp19 * _tmp25
	lw $t1, -12($fp)	# load _tmp19 from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp27 = _tmp26 + _tmp25
	add $t3, $t2, $t0	
	# PushParam _tmp27
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp28 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp25 from $t0 to $fp-36
	sw $t2, -40($fp)	# spill _tmp26 from $t2 to $fp-40
	sw $t3, -44($fp)	# spill _tmp27 from $t3 to $fp-44
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp28) = _tmp19
	lw $t1, -12($fp)	# load _tmp19 from $fp-12 into $t1
	sw $t1, 0($t0) 	# store with offset
	# names = _tmp28
	move $t2, $t0		# copy value
	# _tmp29 = "Brian"
	.data			# create string constant marked with label
	_string3: .asciiz "Brian"
	.text
	la $t3, _string3	# load label
	# _tmp30 = *(names)
	lw $t4, 0($t2) 	# load with offset
	# _tmp31 = 0
	li $t5, 0		# load constant value 0 into $t5
	# _tmp32 = _tmp31 < _tmp30
	slt $t6, $t5, $t4	
	# _tmp33 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp34 = _tmp33 < _tmp31
	slt $s0, $t7, $t5	
	# _tmp35 = _tmp34 && _tmp32
	and $s1, $s0, $t6	
	# IfZ _tmp35 Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp28 from $t0 to $fp-48
	sw $t2, -8($fp)	# spill names from $t2 to $fp-8
	sw $t3, -52($fp)	# spill _tmp29 from $t3 to $fp-52
	sw $t4, -56($fp)	# spill _tmp30 from $t4 to $fp-56
	sw $t5, -64($fp)	# spill _tmp31 from $t5 to $fp-64
	sw $t6, -60($fp)	# spill _tmp32 from $t6 to $fp-60
	sw $t7, -68($fp)	# spill _tmp33 from $t7 to $fp-68
	sw $s0, -72($fp)	# spill _tmp34 from $s0 to $fp-72
	sw $s1, -76($fp)	# spill _tmp35 from $s1 to $fp-76
	beqz $s1, _L7	# branch if _tmp35 is zero 
	# _tmp36 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp37 = _tmp31 * _tmp36
	lw $t1, -64($fp)	# load _tmp31 from $fp-64 into $t1
	mul $t2, $t1, $t0	
	# _tmp38 = _tmp37 + _tmp36
	add $t3, $t2, $t0	
	# _tmp39 = names + _tmp38
	lw $t4, -8($fp)	# load names from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp36 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp37 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp38 from $t3 to $fp-88
	sw $t5, -88($fp)	# spill _tmp39 from $t5 to $fp-88
	b _L8		# unconditional branch
_L7:
	# _tmp40 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string4: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp40
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp40 from $t0 to $fp-92
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L8:
	# *(_tmp39) = _tmp29
	lw $t0, -52($fp)	# load _tmp29 from $fp-52 into $t0
	lw $t1, -88($fp)	# load _tmp39 from $fp-88 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp41 = "Cam"
	.data			# create string constant marked with label
	_string5: .asciiz "Cam"
	.text
	la $t2, _string5	# load label
	# _tmp42 = *(names)
	lw $t3, -8($fp)	# load names from $fp-8 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp43 = 1
	li $t5, 1		# load constant value 1 into $t5
	# _tmp44 = _tmp43 < _tmp42
	slt $t6, $t5, $t4	
	# _tmp45 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp46 = _tmp45 < _tmp43
	slt $s0, $t7, $t5	
	# _tmp47 = _tmp46 && _tmp44
	and $s1, $s0, $t6	
	# IfZ _tmp47 Goto _L9
	# (save modified registers before flow of control change)
	sw $t2, -96($fp)	# spill _tmp41 from $t2 to $fp-96
	sw $t4, -100($fp)	# spill _tmp42 from $t4 to $fp-100
	sw $t5, -108($fp)	# spill _tmp43 from $t5 to $fp-108
	sw $t6, -104($fp)	# spill _tmp44 from $t6 to $fp-104
	sw $t7, -112($fp)	# spill _tmp45 from $t7 to $fp-112
	sw $s0, -116($fp)	# spill _tmp46 from $s0 to $fp-116
	sw $s1, -120($fp)	# spill _tmp47 from $s1 to $fp-120
	beqz $s1, _L9	# branch if _tmp47 is zero 
	# _tmp48 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp49 = _tmp43 * _tmp48
	lw $t1, -108($fp)	# load _tmp43 from $fp-108 into $t1
	mul $t2, $t1, $t0	
	# _tmp50 = _tmp49 + _tmp48
	add $t3, $t2, $t0	
	# _tmp51 = names + _tmp50
	lw $t4, -8($fp)	# load names from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp48 from $t0 to $fp-124
	sw $t2, -128($fp)	# spill _tmp49 from $t2 to $fp-128
	sw $t3, -132($fp)	# spill _tmp50 from $t3 to $fp-132
	sw $t5, -132($fp)	# spill _tmp51 from $t5 to $fp-132
	b _L10		# unconditional branch
_L9:
	# _tmp52 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp52
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -136($fp)	# spill _tmp52 from $t0 to $fp-136
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L10:
	# *(_tmp51) = _tmp41
	lw $t0, -96($fp)	# load _tmp41 from $fp-96 into $t0
	lw $t1, -132($fp)	# load _tmp51 from $fp-132 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp53 = "Gavan"
	.data			# create string constant marked with label
	_string7: .asciiz "Gavan"
	.text
	la $t2, _string7	# load label
	# _tmp54 = *(names)
	lw $t3, -8($fp)	# load names from $fp-8 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp55 = 2
	li $t5, 2		# load constant value 2 into $t5
	# _tmp56 = _tmp55 < _tmp54
	slt $t6, $t5, $t4	
	# _tmp57 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp58 = _tmp57 < _tmp55
	slt $s0, $t7, $t5	
	# _tmp59 = _tmp58 && _tmp56
	and $s1, $s0, $t6	
	# IfZ _tmp59 Goto _L11
	# (save modified registers before flow of control change)
	sw $t2, -140($fp)	# spill _tmp53 from $t2 to $fp-140
	sw $t4, -144($fp)	# spill _tmp54 from $t4 to $fp-144
	sw $t5, -152($fp)	# spill _tmp55 from $t5 to $fp-152
	sw $t6, -148($fp)	# spill _tmp56 from $t6 to $fp-148
	sw $t7, -156($fp)	# spill _tmp57 from $t7 to $fp-156
	sw $s0, -160($fp)	# spill _tmp58 from $s0 to $fp-160
	sw $s1, -164($fp)	# spill _tmp59 from $s1 to $fp-164
	beqz $s1, _L11	# branch if _tmp59 is zero 
	# _tmp60 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp61 = _tmp55 * _tmp60
	lw $t1, -152($fp)	# load _tmp55 from $fp-152 into $t1
	mul $t2, $t1, $t0	
	# _tmp62 = _tmp61 + _tmp60
	add $t3, $t2, $t0	
	# _tmp63 = names + _tmp62
	lw $t4, -8($fp)	# load names from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L12
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp60 from $t0 to $fp-168
	sw $t2, -172($fp)	# spill _tmp61 from $t2 to $fp-172
	sw $t3, -176($fp)	# spill _tmp62 from $t3 to $fp-176
	sw $t5, -176($fp)	# spill _tmp63 from $t5 to $fp-176
	b _L12		# unconditional branch
_L11:
	# _tmp64 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string8: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp64
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp64 from $t0 to $fp-180
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L12:
	# *(_tmp63) = _tmp53
	lw $t0, -140($fp)	# load _tmp53 from $fp-140 into $t0
	lw $t1, -176($fp)	# load _tmp63 from $fp-176 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp65 = "Julie"
	.data			# create string constant marked with label
	_string9: .asciiz "Julie"
	.text
	la $t2, _string9	# load label
	# _tmp66 = *(names)
	lw $t3, -8($fp)	# load names from $fp-8 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp67 = 3
	li $t5, 3		# load constant value 3 into $t5
	# _tmp68 = _tmp67 < _tmp66
	slt $t6, $t5, $t4	
	# _tmp69 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp70 = _tmp69 < _tmp67
	slt $s0, $t7, $t5	
	# _tmp71 = _tmp70 && _tmp68
	and $s1, $s0, $t6	
	# IfZ _tmp71 Goto _L13
	# (save modified registers before flow of control change)
	sw $t2, -184($fp)	# spill _tmp65 from $t2 to $fp-184
	sw $t4, -188($fp)	# spill _tmp66 from $t4 to $fp-188
	sw $t5, -196($fp)	# spill _tmp67 from $t5 to $fp-196
	sw $t6, -192($fp)	# spill _tmp68 from $t6 to $fp-192
	sw $t7, -200($fp)	# spill _tmp69 from $t7 to $fp-200
	sw $s0, -204($fp)	# spill _tmp70 from $s0 to $fp-204
	sw $s1, -208($fp)	# spill _tmp71 from $s1 to $fp-208
	beqz $s1, _L13	# branch if _tmp71 is zero 
	# _tmp72 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp73 = _tmp67 * _tmp72
	lw $t1, -196($fp)	# load _tmp67 from $fp-196 into $t1
	mul $t2, $t1, $t0	
	# _tmp74 = _tmp73 + _tmp72
	add $t3, $t2, $t0	
	# _tmp75 = names + _tmp74
	lw $t4, -8($fp)	# load names from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L14
	# (save modified registers before flow of control change)
	sw $t0, -212($fp)	# spill _tmp72 from $t0 to $fp-212
	sw $t2, -216($fp)	# spill _tmp73 from $t2 to $fp-216
	sw $t3, -220($fp)	# spill _tmp74 from $t3 to $fp-220
	sw $t5, -220($fp)	# spill _tmp75 from $t5 to $fp-220
	b _L14		# unconditional branch
_L13:
	# _tmp76 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp76
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -224($fp)	# spill _tmp76 from $t0 to $fp-224
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L14:
	# *(_tmp75) = _tmp65
	lw $t0, -184($fp)	# load _tmp65 from $fp-184 into $t0
	lw $t1, -220($fp)	# load _tmp75 from $fp-220 into $t1
	sw $t0, 0($t1) 	# store with offset
_L15:
	# _tmp77 = 1
	li $t0, 1		# load constant value 1 into $t0
	# IfZ _tmp77 Goto _L16
	# (save modified registers before flow of control change)
	sw $t0, -228($fp)	# spill _tmp77 from $t0 to $fp-228
	beqz $t0, _L16	# branch if _tmp77 is zero 
	# _tmp78 = "\nWho is your favorite CS143 staff member? "
	.data			# create string constant marked with label
	_string11: .asciiz "\nWho is your favorite CS143 staff member? "
	.text
	la $t0, _string11	# load label
	# PushParam _tmp78
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -232($fp)	# spill _tmp78 from $t0 to $fp-232
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp79 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PushParam _tmp79
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam names
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -8($fp)	# load names from $fp-8 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp80 = LCall __Wild
	# (save modified registers before flow of control change)
	sw $t0, -236($fp)	# spill _tmp79 from $t0 to $fp-236
	jal __Wild         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp80 Goto _L17
	# (save modified registers before flow of control change)
	sw $t0, -240($fp)	# spill _tmp80 from $t0 to $fp-240
	beqz $t0, _L17	# branch if _tmp80 is zero 
	# _tmp81 = "You just earned 1000 bonus points!\n"
	.data			# create string constant marked with label
	_string12: .asciiz "You just earned 1000 bonus points!\n"
	.text
	la $t0, _string12	# load label
	# PushParam _tmp81
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -244($fp)	# spill _tmp81 from $t0 to $fp-244
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L16
	b _L16		# unconditional branch
	# Goto _L18
	b _L18		# unconditional branch
_L17:
_L18:
	# _tmp82 = "That's not a good way to make points. Try again!\..."
	.data			# create string constant marked with label
	_string13: .asciiz "That's not a good way to make points. Try again!\n"
	.text
	la $t0, _string13	# load label
	# PushParam _tmp82
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -248($fp)	# spill _tmp82 from $t0 to $fp-248
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L15
	b _L15		# unconditional branch
_L16:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
