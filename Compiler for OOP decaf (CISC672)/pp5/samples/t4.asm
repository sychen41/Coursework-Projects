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
	
__Binky:
	# BeginFunc 84
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 84	# decrement sp to make space for locals/temps
	# _tmp0 = *(b)
	lw $t0, 8($fp)	# load b from $fp+8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1 = *(c)
	lw $t2, 12($fp)	# load c from $fp+12 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp2 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp3 = _tmp2 < _tmp1
	slt $t5, $t4, $t3	
	# _tmp4 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp5 = _tmp4 < _tmp2
	slt $t7, $t6, $t4	
	# _tmp6 = _tmp5 && _tmp3
	and $s0, $t7, $t5	
	# IfZ _tmp6 Goto _L0
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp0 from $t1 to $fp-8
	sw $t3, -16($fp)	# spill _tmp1 from $t3 to $fp-16
	sw $t4, -24($fp)	# spill _tmp2 from $t4 to $fp-24
	sw $t5, -20($fp)	# spill _tmp3 from $t5 to $fp-20
	sw $t6, -28($fp)	# spill _tmp4 from $t6 to $fp-28
	sw $t7, -32($fp)	# spill _tmp5 from $t7 to $fp-32
	sw $s0, -36($fp)	# spill _tmp6 from $s0 to $fp-36
	beqz $s0, _L0	# branch if _tmp6 is zero 
	# _tmp7 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp8 = _tmp2 * _tmp7
	lw $t1, -24($fp)	# load _tmp2 from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp9 = _tmp8 + _tmp7
	add $t3, $t2, $t0	
	# _tmp10 = c + _tmp9
	lw $t4, 12($fp)	# load c from $fp+12 into $t4
	add $t5, $t4, $t3	
	# Goto _L1
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp7 from $t0 to $fp-40
	sw $t2, -44($fp)	# spill _tmp8 from $t2 to $fp-44
	sw $t3, -48($fp)	# spill _tmp9 from $t3 to $fp-48
	sw $t5, -48($fp)	# spill _tmp10 from $t5 to $fp-48
	b _L1		# unconditional branch
_L0:
	# _tmp11 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string1: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp11
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp11 from $t0 to $fp-52
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L1:
	# _tmp12 = *(_tmp10)
	lw $t0, -48($fp)	# load _tmp10 from $fp-48 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp13 = _tmp12 < _tmp0
	lw $t2, -8($fp)	# load _tmp0 from $fp-8 into $t2
	slt $t3, $t1, $t2	
	# _tmp14 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp15 = _tmp14 < _tmp12
	slt $t5, $t4, $t1	
	# _tmp16 = _tmp15 && _tmp13
	and $t6, $t5, $t3	
	# IfZ _tmp16 Goto _L2
	# (save modified registers before flow of control change)
	sw $t1, -56($fp)	# spill _tmp12 from $t1 to $fp-56
	sw $t3, -12($fp)	# spill _tmp13 from $t3 to $fp-12
	sw $t4, -60($fp)	# spill _tmp14 from $t4 to $fp-60
	sw $t5, -64($fp)	# spill _tmp15 from $t5 to $fp-64
	sw $t6, -68($fp)	# spill _tmp16 from $t6 to $fp-68
	beqz $t6, _L2	# branch if _tmp16 is zero 
	# _tmp17 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp18 = _tmp12 * _tmp17
	lw $t1, -56($fp)	# load _tmp12 from $fp-56 into $t1
	mul $t2, $t1, $t0	
	# _tmp19 = _tmp18 + _tmp17
	add $t3, $t2, $t0	
	# _tmp20 = b + _tmp19
	lw $t4, 8($fp)	# load b from $fp+8 into $t4
	add $t5, $t4, $t3	
	# Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp17 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp18 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp19 from $t3 to $fp-80
	sw $t5, -80($fp)	# spill _tmp20 from $t5 to $fp-80
	b _L3		# unconditional branch
_L2:
	# _tmp21 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string2: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp21
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp21 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L3:
	# _tmp22 = *(_tmp20)
	lw $t0, -80($fp)	# load _tmp20 from $fp-80 into $t0
	lw $t1, 0($t0) 	# load with offset
	# Return _tmp22
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
main:
	# BeginFunc 480
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 480	# decrement sp to make space for locals/temps
	# _tmp23 = 5
	li $t0, 5		# load constant value 5 into $t0
	# _tmp24 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp25 = _tmp23 < _tmp24
	slt $t2, $t0, $t1	
	# _tmp26 = _tmp23 == _tmp24
	seq $t3, $t0, $t1	
	# _tmp27 = _tmp25 || _tmp26
	or $t4, $t2, $t3	
	# IfZ _tmp27 Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp23 from $t0 to $fp-16
	sw $t1, -20($fp)	# spill _tmp24 from $t1 to $fp-20
	sw $t2, -24($fp)	# spill _tmp25 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp26 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp27 from $t4 to $fp-32
	beqz $t4, _L4	# branch if _tmp27 is zero 
	# _tmp28 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string3: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp28
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp28 from $t0 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L4:
	# _tmp29 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp30 = _tmp23 * _tmp29
	lw $t1, -16($fp)	# load _tmp23 from $fp-16 into $t1
	mul $t2, $t1, $t0	
	# _tmp31 = _tmp30 + _tmp29
	add $t3, $t2, $t0	
	# PushParam _tmp31
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp32 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp29 from $t0 to $fp-40
	sw $t2, -44($fp)	# spill _tmp30 from $t2 to $fp-44
	sw $t3, -48($fp)	# spill _tmp31 from $t3 to $fp-48
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp32) = _tmp23
	lw $t1, -16($fp)	# load _tmp23 from $fp-16 into $t1
	sw $t1, 0($t0) 	# store with offset
	# d = _tmp32
	move $t2, $t0		# copy value
	# _tmp33 = 12
	li $t3, 12		# load constant value 12 into $t3
	# _tmp34 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp35 = _tmp33 < _tmp34
	slt $t5, $t3, $t4	
	# _tmp36 = _tmp33 == _tmp34
	seq $t6, $t3, $t4	
	# _tmp37 = _tmp35 || _tmp36
	or $t7, $t5, $t6	
	# IfZ _tmp37 Goto _L5
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp32 from $t0 to $fp-52
	sw $t2, -12($fp)	# spill d from $t2 to $fp-12
	sw $t3, -56($fp)	# spill _tmp33 from $t3 to $fp-56
	sw $t4, -60($fp)	# spill _tmp34 from $t4 to $fp-60
	sw $t5, -64($fp)	# spill _tmp35 from $t5 to $fp-64
	sw $t6, -68($fp)	# spill _tmp36 from $t6 to $fp-68
	sw $t7, -72($fp)	# spill _tmp37 from $t7 to $fp-72
	beqz $t7, _L5	# branch if _tmp37 is zero 
	# _tmp38 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string4: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp38
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp38 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L5:
	# _tmp39 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp40 = _tmp33 * _tmp39
	lw $t1, -56($fp)	# load _tmp33 from $fp-56 into $t1
	mul $t2, $t1, $t0	
	# _tmp41 = _tmp40 + _tmp39
	add $t3, $t2, $t0	
	# PushParam _tmp41
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp42 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp39 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp40 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp41 from $t3 to $fp-88
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp42) = _tmp33
	lw $t1, -56($fp)	# load _tmp33 from $fp-56 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp43 = *(d)
	lw $t2, -12($fp)	# load d from $fp-12 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp44 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp45 = _tmp44 < _tmp43
	slt $t5, $t4, $t3	
	# _tmp46 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp47 = _tmp46 < _tmp44
	slt $t7, $t6, $t4	
	# _tmp48 = _tmp47 && _tmp45
	and $s0, $t7, $t5	
	# IfZ _tmp48 Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp42 from $t0 to $fp-92
	sw $t3, -96($fp)	# spill _tmp43 from $t3 to $fp-96
	sw $t4, -104($fp)	# spill _tmp44 from $t4 to $fp-104
	sw $t5, -100($fp)	# spill _tmp45 from $t5 to $fp-100
	sw $t6, -108($fp)	# spill _tmp46 from $t6 to $fp-108
	sw $t7, -112($fp)	# spill _tmp47 from $t7 to $fp-112
	sw $s0, -116($fp)	# spill _tmp48 from $s0 to $fp-116
	beqz $s0, _L6	# branch if _tmp48 is zero 
	# _tmp49 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp50 = _tmp44 * _tmp49
	lw $t1, -104($fp)	# load _tmp44 from $fp-104 into $t1
	mul $t2, $t1, $t0	
	# _tmp51 = _tmp50 + _tmp49
	add $t3, $t2, $t0	
	# _tmp52 = d + _tmp51
	lw $t4, -12($fp)	# load d from $fp-12 into $t4
	add $t5, $t4, $t3	
	# Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp49 from $t0 to $fp-120
	sw $t2, -124($fp)	# spill _tmp50 from $t2 to $fp-124
	sw $t3, -128($fp)	# spill _tmp51 from $t3 to $fp-128
	sw $t5, -128($fp)	# spill _tmp52 from $t5 to $fp-128
	b _L7		# unconditional branch
_L6:
	# _tmp53 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string5: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp53
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp53 from $t0 to $fp-132
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L7:
	# *(_tmp52) = _tmp42
	lw $t0, -92($fp)	# load _tmp42 from $fp-92 into $t0
	lw $t1, -128($fp)	# load _tmp52 from $fp-128 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp54 = 10
	li $t2, 10		# load constant value 10 into $t2
	# _tmp55 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp56 = _tmp54 < _tmp55
	slt $t4, $t2, $t3	
	# _tmp57 = _tmp54 == _tmp55
	seq $t5, $t2, $t3	
	# _tmp58 = _tmp56 || _tmp57
	or $t6, $t4, $t5	
	# IfZ _tmp58 Goto _L8
	# (save modified registers before flow of control change)
	sw $t2, -136($fp)	# spill _tmp54 from $t2 to $fp-136
	sw $t3, -140($fp)	# spill _tmp55 from $t3 to $fp-140
	sw $t4, -144($fp)	# spill _tmp56 from $t4 to $fp-144
	sw $t5, -148($fp)	# spill _tmp57 from $t5 to $fp-148
	sw $t6, -152($fp)	# spill _tmp58 from $t6 to $fp-152
	beqz $t6, _L8	# branch if _tmp58 is zero 
	# _tmp59 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp59
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -156($fp)	# spill _tmp59 from $t0 to $fp-156
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L8:
	# _tmp60 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp61 = _tmp54 * _tmp60
	lw $t1, -136($fp)	# load _tmp54 from $fp-136 into $t1
	mul $t2, $t1, $t0	
	# _tmp62 = _tmp61 + _tmp60
	add $t3, $t2, $t0	
	# PushParam _tmp62
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp63 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp60 from $t0 to $fp-160
	sw $t2, -164($fp)	# spill _tmp61 from $t2 to $fp-164
	sw $t3, -168($fp)	# spill _tmp62 from $t3 to $fp-168
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp63) = _tmp54
	lw $t1, -136($fp)	# load _tmp54 from $fp-136 into $t1
	sw $t1, 0($t0) 	# store with offset
	# c = _tmp63
	move $t2, $t0		# copy value
	# _tmp64 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp65 = 4
	li $t4, 4		# load constant value 4 into $t4
	# _tmp66 = 3
	li $t5, 3		# load constant value 3 into $t5
	# _tmp67 = 5
	li $t6, 5		# load constant value 5 into $t6
	# _tmp68 = _tmp67 * _tmp66
	mul $t7, $t6, $t5	
	# _tmp69 = _tmp68 / _tmp65
	div $s0, $t7, $t4	
	# _tmp70 = _tmp69 % _tmp64
	rem $s1, $s0, $t3	
	# _tmp71 = 4
	li $s2, 4		# load constant value 4 into $s2
	# _tmp72 = _tmp71 + _tmp70
	add $s3, $s2, $s1	
	# _tmp73 = *(c)
	lw $s4, 0($t2) 	# load with offset
	# _tmp74 = 0
	li $s5, 0		# load constant value 0 into $s5
	# _tmp75 = _tmp74 < _tmp73
	slt $s6, $s5, $s4	
	# _tmp76 = -1
	li $s7, -1		# load constant value -1 into $s7
	# _tmp77 = _tmp76 < _tmp74
	slt $t8, $s7, $s5	
	# _tmp78 = _tmp77 && _tmp75
	and $t9, $t8, $s6	
	# IfZ _tmp78 Goto _L9
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp63 from $t0 to $fp-172
	sw $t2, -8($fp)	# spill c from $t2 to $fp-8
	sw $t3, -184($fp)	# spill _tmp64 from $t3 to $fp-184
	sw $t4, -192($fp)	# spill _tmp65 from $t4 to $fp-192
	sw $t5, -200($fp)	# spill _tmp66 from $t5 to $fp-200
	sw $t6, -204($fp)	# spill _tmp67 from $t6 to $fp-204
	sw $t7, -196($fp)	# spill _tmp68 from $t7 to $fp-196
	sw $s0, -188($fp)	# spill _tmp69 from $s0 to $fp-188
	sw $s1, -180($fp)	# spill _tmp70 from $s1 to $fp-180
	sw $s2, -208($fp)	# spill _tmp71 from $s2 to $fp-208
	sw $s3, -176($fp)	# spill _tmp72 from $s3 to $fp-176
	sw $s4, -212($fp)	# spill _tmp73 from $s4 to $fp-212
	sw $s5, -220($fp)	# spill _tmp74 from $s5 to $fp-220
	sw $s6, -216($fp)	# spill _tmp75 from $s6 to $fp-216
	sw $s7, -224($fp)	# spill _tmp76 from $s7 to $fp-224
	sw $t8, -228($fp)	# spill _tmp77 from $t8 to $fp-228
	sw $t9, -232($fp)	# spill _tmp78 from $t9 to $fp-232
	beqz $t9, _L9	# branch if _tmp78 is zero 
	# _tmp79 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp80 = _tmp74 * _tmp79
	lw $t1, -220($fp)	# load _tmp74 from $fp-220 into $t1
	mul $t2, $t1, $t0	
	# _tmp81 = _tmp80 + _tmp79
	add $t3, $t2, $t0	
	# _tmp82 = c + _tmp81
	lw $t4, -8($fp)	# load c from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -236($fp)	# spill _tmp79 from $t0 to $fp-236
	sw $t2, -240($fp)	# spill _tmp80 from $t2 to $fp-240
	sw $t3, -244($fp)	# spill _tmp81 from $t3 to $fp-244
	sw $t5, -244($fp)	# spill _tmp82 from $t5 to $fp-244
	b _L10		# unconditional branch
_L9:
	# _tmp83 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string7: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp83
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -248($fp)	# spill _tmp83 from $t0 to $fp-248
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L10:
	# *(_tmp82) = _tmp72
	lw $t0, -176($fp)	# load _tmp72 from $fp-176 into $t0
	lw $t1, -244($fp)	# load _tmp82 from $fp-244 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp84 = 55
	li $t2, 55		# load constant value 55 into $t2
	# _tmp85 = *(d)
	lw $t3, -12($fp)	# load d from $fp-12 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp86 = 0
	li $t5, 0		# load constant value 0 into $t5
	# _tmp87 = _tmp86 < _tmp85
	slt $t6, $t5, $t4	
	# _tmp88 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp89 = _tmp88 < _tmp86
	slt $s0, $t7, $t5	
	# _tmp90 = _tmp89 && _tmp87
	and $s1, $s0, $t6	
	# IfZ _tmp90 Goto _L11
	# (save modified registers before flow of control change)
	sw $t2, -252($fp)	# spill _tmp84 from $t2 to $fp-252
	sw $t4, -256($fp)	# spill _tmp85 from $t4 to $fp-256
	sw $t5, -264($fp)	# spill _tmp86 from $t5 to $fp-264
	sw $t6, -260($fp)	# spill _tmp87 from $t6 to $fp-260
	sw $t7, -268($fp)	# spill _tmp88 from $t7 to $fp-268
	sw $s0, -272($fp)	# spill _tmp89 from $s0 to $fp-272
	sw $s1, -276($fp)	# spill _tmp90 from $s1 to $fp-276
	beqz $s1, _L11	# branch if _tmp90 is zero 
	# _tmp91 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp92 = _tmp86 * _tmp91
	lw $t1, -264($fp)	# load _tmp86 from $fp-264 into $t1
	mul $t2, $t1, $t0	
	# _tmp93 = _tmp92 + _tmp91
	add $t3, $t2, $t0	
	# _tmp94 = d + _tmp93
	lw $t4, -12($fp)	# load d from $fp-12 into $t4
	add $t5, $t4, $t3	
	# Goto _L12
	# (save modified registers before flow of control change)
	sw $t0, -280($fp)	# spill _tmp91 from $t0 to $fp-280
	sw $t2, -284($fp)	# spill _tmp92 from $t2 to $fp-284
	sw $t3, -288($fp)	# spill _tmp93 from $t3 to $fp-288
	sw $t5, -288($fp)	# spill _tmp94 from $t5 to $fp-288
	b _L12		# unconditional branch
_L11:
	# _tmp95 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string8: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp95
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -292($fp)	# spill _tmp95 from $t0 to $fp-292
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L12:
	# _tmp96 = *(_tmp94)
	lw $t0, -288($fp)	# load _tmp94 from $fp-288 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp97 = *(_tmp96)
	lw $t2, 0($t1) 	# load with offset
	# _tmp98 = *(c)
	lw $t3, -8($fp)	# load c from $fp-8 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp99 = 0
	li $t5, 0		# load constant value 0 into $t5
	# _tmp100 = _tmp99 < _tmp98
	slt $t6, $t5, $t4	
	# _tmp101 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp102 = _tmp101 < _tmp99
	slt $s0, $t7, $t5	
	# _tmp103 = _tmp102 && _tmp100
	and $s1, $s0, $t6	
	# IfZ _tmp103 Goto _L13
	# (save modified registers before flow of control change)
	sw $t1, -296($fp)	# spill _tmp96 from $t1 to $fp-296
	sw $t2, -300($fp)	# spill _tmp97 from $t2 to $fp-300
	sw $t4, -308($fp)	# spill _tmp98 from $t4 to $fp-308
	sw $t5, -316($fp)	# spill _tmp99 from $t5 to $fp-316
	sw $t6, -312($fp)	# spill _tmp100 from $t6 to $fp-312
	sw $t7, -320($fp)	# spill _tmp101 from $t7 to $fp-320
	sw $s0, -324($fp)	# spill _tmp102 from $s0 to $fp-324
	sw $s1, -328($fp)	# spill _tmp103 from $s1 to $fp-328
	beqz $s1, _L13	# branch if _tmp103 is zero 
	# _tmp104 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp105 = _tmp99 * _tmp104
	lw $t1, -316($fp)	# load _tmp99 from $fp-316 into $t1
	mul $t2, $t1, $t0	
	# _tmp106 = _tmp105 + _tmp104
	add $t3, $t2, $t0	
	# _tmp107 = c + _tmp106
	lw $t4, -8($fp)	# load c from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L14
	# (save modified registers before flow of control change)
	sw $t0, -332($fp)	# spill _tmp104 from $t0 to $fp-332
	sw $t2, -336($fp)	# spill _tmp105 from $t2 to $fp-336
	sw $t3, -340($fp)	# spill _tmp106 from $t3 to $fp-340
	sw $t5, -340($fp)	# spill _tmp107 from $t5 to $fp-340
	b _L14		# unconditional branch
_L13:
	# _tmp108 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string9: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp108
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -344($fp)	# spill _tmp108 from $t0 to $fp-344
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L14:
	# _tmp109 = *(_tmp107)
	lw $t0, -340($fp)	# load _tmp107 from $fp-340 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp110 = _tmp109 < _tmp97
	lw $t2, -300($fp)	# load _tmp97 from $fp-300 into $t2
	slt $t3, $t1, $t2	
	# _tmp111 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp112 = _tmp111 < _tmp109
	slt $t5, $t4, $t1	
	# _tmp113 = _tmp112 && _tmp110
	and $t6, $t5, $t3	
	# IfZ _tmp113 Goto _L15
	# (save modified registers before flow of control change)
	sw $t1, -348($fp)	# spill _tmp109 from $t1 to $fp-348
	sw $t3, -304($fp)	# spill _tmp110 from $t3 to $fp-304
	sw $t4, -352($fp)	# spill _tmp111 from $t4 to $fp-352
	sw $t5, -356($fp)	# spill _tmp112 from $t5 to $fp-356
	sw $t6, -360($fp)	# spill _tmp113 from $t6 to $fp-360
	beqz $t6, _L15	# branch if _tmp113 is zero 
	# _tmp114 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp115 = _tmp109 * _tmp114
	lw $t1, -348($fp)	# load _tmp109 from $fp-348 into $t1
	mul $t2, $t1, $t0	
	# _tmp116 = _tmp115 + _tmp114
	add $t3, $t2, $t0	
	# _tmp117 = _tmp96 + _tmp116
	lw $t4, -296($fp)	# load _tmp96 from $fp-296 into $t4
	add $t5, $t4, $t3	
	# Goto _L16
	# (save modified registers before flow of control change)
	sw $t0, -364($fp)	# spill _tmp114 from $t0 to $fp-364
	sw $t2, -368($fp)	# spill _tmp115 from $t2 to $fp-368
	sw $t3, -372($fp)	# spill _tmp116 from $t3 to $fp-372
	sw $t5, -372($fp)	# spill _tmp117 from $t5 to $fp-372
	b _L16		# unconditional branch
_L15:
	# _tmp118 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp118
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -376($fp)	# spill _tmp118 from $t0 to $fp-376
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L16:
	# *(_tmp117) = _tmp84
	lw $t0, -252($fp)	# load _tmp84 from $fp-252 into $t0
	lw $t1, -372($fp)	# load _tmp117 from $fp-372 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp119 = *(c)
	lw $t2, -8($fp)	# load c from $fp-8 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp120 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp121 = _tmp120 < _tmp119
	slt $t5, $t4, $t3	
	# _tmp122 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp123 = _tmp122 < _tmp120
	slt $t7, $t6, $t4	
	# _tmp124 = _tmp123 && _tmp121
	and $s0, $t7, $t5	
	# IfZ _tmp124 Goto _L17
	# (save modified registers before flow of control change)
	sw $t3, -380($fp)	# spill _tmp119 from $t3 to $fp-380
	sw $t4, -388($fp)	# spill _tmp120 from $t4 to $fp-388
	sw $t5, -384($fp)	# spill _tmp121 from $t5 to $fp-384
	sw $t6, -392($fp)	# spill _tmp122 from $t6 to $fp-392
	sw $t7, -396($fp)	# spill _tmp123 from $t7 to $fp-396
	sw $s0, -400($fp)	# spill _tmp124 from $s0 to $fp-400
	beqz $s0, _L17	# branch if _tmp124 is zero 
	# _tmp125 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp126 = _tmp120 * _tmp125
	lw $t1, -388($fp)	# load _tmp120 from $fp-388 into $t1
	mul $t2, $t1, $t0	
	# _tmp127 = _tmp126 + _tmp125
	add $t3, $t2, $t0	
	# _tmp128 = c + _tmp127
	lw $t4, -8($fp)	# load c from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L18
	# (save modified registers before flow of control change)
	sw $t0, -404($fp)	# spill _tmp125 from $t0 to $fp-404
	sw $t2, -408($fp)	# spill _tmp126 from $t2 to $fp-408
	sw $t3, -412($fp)	# spill _tmp127 from $t3 to $fp-412
	sw $t5, -412($fp)	# spill _tmp128 from $t5 to $fp-412
	b _L18		# unconditional branch
_L17:
	# _tmp129 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string11: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string11	# load label
	# PushParam _tmp129
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -416($fp)	# spill _tmp129 from $t0 to $fp-416
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L18:
	# _tmp130 = *(_tmp128)
	lw $t0, -412($fp)	# load _tmp128 from $fp-412 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam _tmp130
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -420($fp)	# spill _tmp130 from $t1 to $fp-420
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp131 = " "
	.data			# create string constant marked with label
	_string12: .asciiz " "
	.text
	la $t0, _string12	# load label
	# PushParam _tmp131
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -424($fp)	# spill _tmp131 from $t0 to $fp-424
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam c
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load c from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp132 = *(d)
	lw $t1, -12($fp)	# load d from $fp-12 into $t1
	lw $t2, 0($t1) 	# load with offset
	# _tmp133 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp134 = _tmp133 < _tmp132
	slt $t4, $t3, $t2	
	# _tmp135 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp136 = _tmp135 < _tmp133
	slt $t6, $t5, $t3	
	# _tmp137 = _tmp136 && _tmp134
	and $t7, $t6, $t4	
	# IfZ _tmp137 Goto _L19
	# (save modified registers before flow of control change)
	sw $t2, -432($fp)	# spill _tmp132 from $t2 to $fp-432
	sw $t3, -440($fp)	# spill _tmp133 from $t3 to $fp-440
	sw $t4, -436($fp)	# spill _tmp134 from $t4 to $fp-436
	sw $t5, -444($fp)	# spill _tmp135 from $t5 to $fp-444
	sw $t6, -448($fp)	# spill _tmp136 from $t6 to $fp-448
	sw $t7, -452($fp)	# spill _tmp137 from $t7 to $fp-452
	beqz $t7, _L19	# branch if _tmp137 is zero 
	# _tmp138 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp139 = _tmp133 * _tmp138
	lw $t1, -440($fp)	# load _tmp133 from $fp-440 into $t1
	mul $t2, $t1, $t0	
	# _tmp140 = _tmp139 + _tmp138
	add $t3, $t2, $t0	
	# _tmp141 = d + _tmp140
	lw $t4, -12($fp)	# load d from $fp-12 into $t4
	add $t5, $t4, $t3	
	# Goto _L20
	# (save modified registers before flow of control change)
	sw $t0, -456($fp)	# spill _tmp138 from $t0 to $fp-456
	sw $t2, -460($fp)	# spill _tmp139 from $t2 to $fp-460
	sw $t3, -464($fp)	# spill _tmp140 from $t3 to $fp-464
	sw $t5, -464($fp)	# spill _tmp141 from $t5 to $fp-464
	b _L20		# unconditional branch
_L19:
	# _tmp142 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string13: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string13	# load label
	# PushParam _tmp142
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -468($fp)	# spill _tmp142 from $t0 to $fp-468
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L20:
	# _tmp143 = *(_tmp141)
	lw $t0, -464($fp)	# load _tmp141 from $fp-464 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam _tmp143
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp144 = 100
	li $t2, 100		# load constant value 100 into $t2
	# PushParam _tmp144
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp145 = LCall __Binky
	# (save modified registers before flow of control change)
	sw $t1, -472($fp)	# spill _tmp143 from $t1 to $fp-472
	sw $t2, -476($fp)	# spill _tmp144 from $t2 to $fp-476
	jal __Binky        	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp146 = 2
	li $t1, 2		# load constant value 2 into $t1
	# _tmp147 = _tmp146 * _tmp145
	mul $t2, $t1, $t0	
	# PushParam _tmp147
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -480($fp)	# spill _tmp145 from $t0 to $fp-480
	sw $t1, -484($fp)	# spill _tmp146 from $t1 to $fp-484
	sw $t2, -428($fp)	# spill _tmp147 from $t2 to $fp-428
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
