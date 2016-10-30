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
	
__ReadArray:
	# BeginFunc 124
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 124	# decrement sp to make space for locals/temps
	# _tmp0 = "How many scores? "
	.data			# create string constant marked with label
	_string1: .asciiz "How many scores? "
	.text
	la $t0, _string1	# load label
	# PushParam _tmp0
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp0 from $t0 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp1 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# numScores = _tmp1
	move $t1, $t0		# copy value
	# _tmp2 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp3 = numScores < _tmp2
	slt $t3, $t1, $t2	
	# _tmp4 = numScores == _tmp2
	seq $t4, $t1, $t2	
	# _tmp5 = _tmp3 || _tmp4
	or $t5, $t3, $t4	
	# IfZ _tmp5 Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp1 from $t0 to $fp-28
	sw $t1, -20($fp)	# spill numScores from $t1 to $fp-20
	sw $t2, -32($fp)	# spill _tmp2 from $t2 to $fp-32
	sw $t3, -36($fp)	# spill _tmp3 from $t3 to $fp-36
	sw $t4, -40($fp)	# spill _tmp4 from $t4 to $fp-40
	sw $t5, -44($fp)	# spill _tmp5 from $t5 to $fp-44
	beqz $t5, _L0	# branch if _tmp5 is zero 
	# _tmp6 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string2: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp6
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp6 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L0:
	# _tmp7 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp8 = numScores * _tmp7
	lw $t1, -20($fp)	# load numScores from $fp-20 into $t1
	mul $t2, $t1, $t0	
	# _tmp9 = _tmp8 + _tmp7
	add $t3, $t2, $t0	
	# PushParam _tmp9
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp10 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp7 from $t0 to $fp-52
	sw $t2, -56($fp)	# spill _tmp8 from $t2 to $fp-56
	sw $t3, -60($fp)	# spill _tmp9 from $t3 to $fp-60
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp10) = numScores
	lw $t1, -20($fp)	# load numScores from $fp-20 into $t1
	sw $t1, 0($t0) 	# store with offset
	# arr = _tmp10
	move $t2, $t0		# copy value
	# _tmp11 = 0
	li $t3, 0		# load constant value 0 into $t3
	# i = _tmp11
	move $t4, $t3		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp10 from $t0 to $fp-64
	sw $t2, -16($fp)	# spill arr from $t2 to $fp-16
	sw $t3, -68($fp)	# spill _tmp11 from $t3 to $fp-68
	sw $t4, -8($fp)	# spill i from $t4 to $fp-8
_L1:
	# _tmp12 = *(arr)
	lw $t0, -16($fp)	# load arr from $fp-16 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp13 = i < _tmp12
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp13 Goto _L2
	# (save modified registers before flow of control change)
	sw $t1, -72($fp)	# spill _tmp12 from $t1 to $fp-72
	sw $t3, -76($fp)	# spill _tmp13 from $t3 to $fp-76
	beqz $t3, _L2	# branch if _tmp13 is zero 
	# _tmp14 = "Enter next number: "
	.data			# create string constant marked with label
	_string3: .asciiz "Enter next number: "
	.text
	la $t0, _string3	# load label
	# PushParam _tmp14
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp14 from $t0 to $fp-80
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp15 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# num = _tmp15
	move $t1, $t0		# copy value
	# _tmp16 = *(arr)
	lw $t2, -16($fp)	# load arr from $fp-16 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp17 = i < _tmp16
	lw $t4, -8($fp)	# load i from $fp-8 into $t4
	slt $t5, $t4, $t3	
	# _tmp18 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp19 = _tmp18 < i
	slt $t7, $t6, $t4	
	# _tmp20 = _tmp19 && _tmp17
	and $s0, $t7, $t5	
	# IfZ _tmp20 Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp15 from $t0 to $fp-84
	sw $t1, -12($fp)	# spill num from $t1 to $fp-12
	sw $t3, -88($fp)	# spill _tmp16 from $t3 to $fp-88
	sw $t5, -92($fp)	# spill _tmp17 from $t5 to $fp-92
	sw $t6, -96($fp)	# spill _tmp18 from $t6 to $fp-96
	sw $t7, -100($fp)	# spill _tmp19 from $t7 to $fp-100
	sw $s0, -104($fp)	# spill _tmp20 from $s0 to $fp-104
	beqz $s0, _L3	# branch if _tmp20 is zero 
	# _tmp21 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp22 = i * _tmp21
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp23 = _tmp22 + _tmp21
	add $t3, $t2, $t0	
	# _tmp24 = arr + _tmp23
	lw $t4, -16($fp)	# load arr from $fp-16 into $t4
	add $t5, $t4, $t3	
	# Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp21 from $t0 to $fp-108
	sw $t2, -112($fp)	# spill _tmp22 from $t2 to $fp-112
	sw $t3, -116($fp)	# spill _tmp23 from $t3 to $fp-116
	sw $t5, -116($fp)	# spill _tmp24 from $t5 to $fp-116
	b _L4		# unconditional branch
_L3:
	# _tmp25 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string4: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp25
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp25 from $t0 to $fp-120
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L4:
	# *(_tmp24) = num
	lw $t0, -12($fp)	# load num from $fp-12 into $t0
	lw $t1, -116($fp)	# load _tmp24 from $fp-116 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp26 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp27 = i + _tmp26
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	add $t4, $t3, $t2	
	# i = _tmp27
	move $t3, $t4		# copy value
	# Goto _L1
	# (save modified registers before flow of control change)
	sw $t2, -128($fp)	# spill _tmp26 from $t2 to $fp-128
	sw $t3, -8($fp)	# spill i from $t3 to $fp-8
	sw $t4, -124($fp)	# spill _tmp27 from $t4 to $fp-124
	b _L1		# unconditional branch
_L2:
	# Return arr
	lw $t0, -16($fp)	# load arr from $fp-16 into $t0
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
__Sort:
	# BeginFunc 284
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 284	# decrement sp to make space for locals/temps
	# _tmp28 = 1
	li $t0, 1		# load constant value 1 into $t0
	# i = _tmp28
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp28 from $t0 to $fp-20
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L5:
	# _tmp29 = *(arr)
	lw $t0, 4($fp)	# load arr from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp30 = i < _tmp29
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp30 Goto _L6
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp29 from $t1 to $fp-24
	sw $t3, -28($fp)	# spill _tmp30 from $t3 to $fp-28
	beqz $t3, _L6	# branch if _tmp30 is zero 
	# _tmp31 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp32 = i - _tmp31
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	sub $t2, $t1, $t0	
	# j = _tmp32
	move $t3, $t2		# copy value
	# _tmp33 = *(arr)
	lw $t4, 4($fp)	# load arr from $fp+4 into $t4
	lw $t5, 0($t4) 	# load with offset
	# _tmp34 = i < _tmp33
	slt $t6, $t1, $t5	
	# _tmp35 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp36 = _tmp35 < i
	slt $s0, $t7, $t1	
	# _tmp37 = _tmp36 && _tmp34
	and $s1, $s0, $t6	
	# IfZ _tmp37 Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp31 from $t0 to $fp-36
	sw $t2, -32($fp)	# spill _tmp32 from $t2 to $fp-32
	sw $t3, -12($fp)	# spill j from $t3 to $fp-12
	sw $t5, -40($fp)	# spill _tmp33 from $t5 to $fp-40
	sw $t6, -44($fp)	# spill _tmp34 from $t6 to $fp-44
	sw $t7, -48($fp)	# spill _tmp35 from $t7 to $fp-48
	sw $s0, -52($fp)	# spill _tmp36 from $s0 to $fp-52
	sw $s1, -56($fp)	# spill _tmp37 from $s1 to $fp-56
	beqz $s1, _L7	# branch if _tmp37 is zero 
	# _tmp38 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp39 = i * _tmp38
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp40 = _tmp39 + _tmp38
	add $t3, $t2, $t0	
	# _tmp41 = arr + _tmp40
	lw $t4, 4($fp)	# load arr from $fp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp38 from $t0 to $fp-60
	sw $t2, -64($fp)	# spill _tmp39 from $t2 to $fp-64
	sw $t3, -68($fp)	# spill _tmp40 from $t3 to $fp-68
	sw $t5, -68($fp)	# spill _tmp41 from $t5 to $fp-68
	b _L8		# unconditional branch
_L7:
	# _tmp42 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string5: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp42
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp42 from $t0 to $fp-72
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L8:
	# _tmp43 = *(_tmp41)
	lw $t0, -68($fp)	# load _tmp41 from $fp-68 into $t0
	lw $t1, 0($t0) 	# load with offset
	# val = _tmp43
	move $t2, $t1		# copy value
	# (save modified registers before flow of control change)
	sw $t1, -76($fp)	# spill _tmp43 from $t1 to $fp-76
	sw $t2, -16($fp)	# spill val from $t2 to $fp-16
_L9:
	# _tmp44 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp45 = _tmp44 < j
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	slt $t2, $t0, $t1	
	# _tmp46 = j == _tmp44
	seq $t3, $t1, $t0	
	# _tmp47 = _tmp45 || _tmp46
	or $t4, $t2, $t3	
	# IfZ _tmp47 Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp44 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp45 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp46 from $t3 to $fp-88
	sw $t4, -92($fp)	# spill _tmp47 from $t4 to $fp-92
	beqz $t4, _L10	# branch if _tmp47 is zero 
	# _tmp48 = *(arr)
	lw $t0, 4($fp)	# load arr from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp49 = j < _tmp48
	lw $t2, -12($fp)	# load j from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# _tmp50 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp51 = _tmp50 < j
	slt $t5, $t4, $t2	
	# _tmp52 = _tmp51 && _tmp49
	and $t6, $t5, $t3	
	# IfZ _tmp52 Goto _L13
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp48 from $t1 to $fp-96
	sw $t3, -100($fp)	# spill _tmp49 from $t3 to $fp-100
	sw $t4, -104($fp)	# spill _tmp50 from $t4 to $fp-104
	sw $t5, -108($fp)	# spill _tmp51 from $t5 to $fp-108
	sw $t6, -112($fp)	# spill _tmp52 from $t6 to $fp-112
	beqz $t6, _L13	# branch if _tmp52 is zero 
	# _tmp53 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp54 = j * _tmp53
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp55 = _tmp54 + _tmp53
	add $t3, $t2, $t0	
	# _tmp56 = arr + _tmp55
	lw $t4, 4($fp)	# load arr from $fp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L14
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp53 from $t0 to $fp-116
	sw $t2, -120($fp)	# spill _tmp54 from $t2 to $fp-120
	sw $t3, -124($fp)	# spill _tmp55 from $t3 to $fp-124
	sw $t5, -124($fp)	# spill _tmp56 from $t5 to $fp-124
	b _L14		# unconditional branch
_L13:
	# _tmp57 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp57
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp57 from $t0 to $fp-128
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L14:
	# _tmp58 = *(_tmp56)
	lw $t0, -124($fp)	# load _tmp56 from $fp-124 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp59 = _tmp58 < val
	lw $t2, -16($fp)	# load val from $fp-16 into $t2
	slt $t3, $t1, $t2	
	# _tmp60 = val == _tmp58
	seq $t4, $t2, $t1	
	# _tmp61 = _tmp59 || _tmp60
	or $t5, $t3, $t4	
	# IfZ _tmp61 Goto _L11
	# (save modified registers before flow of control change)
	sw $t1, -132($fp)	# spill _tmp58 from $t1 to $fp-132
	sw $t3, -136($fp)	# spill _tmp59 from $t3 to $fp-136
	sw $t4, -140($fp)	# spill _tmp60 from $t4 to $fp-140
	sw $t5, -144($fp)	# spill _tmp61 from $t5 to $fp-144
	beqz $t5, _L11	# branch if _tmp61 is zero 
	# Goto _L10
	b _L10		# unconditional branch
	# Goto _L12
	b _L12		# unconditional branch
_L11:
_L12:
	# _tmp62 = *(arr)
	lw $t0, 4($fp)	# load arr from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp63 = j < _tmp62
	lw $t2, -12($fp)	# load j from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# _tmp64 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp65 = _tmp64 < j
	slt $t5, $t4, $t2	
	# _tmp66 = _tmp65 && _tmp63
	and $t6, $t5, $t3	
	# IfZ _tmp66 Goto _L15
	# (save modified registers before flow of control change)
	sw $t1, -148($fp)	# spill _tmp62 from $t1 to $fp-148
	sw $t3, -152($fp)	# spill _tmp63 from $t3 to $fp-152
	sw $t4, -156($fp)	# spill _tmp64 from $t4 to $fp-156
	sw $t5, -160($fp)	# spill _tmp65 from $t5 to $fp-160
	sw $t6, -164($fp)	# spill _tmp66 from $t6 to $fp-164
	beqz $t6, _L15	# branch if _tmp66 is zero 
	# _tmp67 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp68 = j * _tmp67
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp69 = _tmp68 + _tmp67
	add $t3, $t2, $t0	
	# _tmp70 = arr + _tmp69
	lw $t4, 4($fp)	# load arr from $fp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L16
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp67 from $t0 to $fp-168
	sw $t2, -172($fp)	# spill _tmp68 from $t2 to $fp-172
	sw $t3, -176($fp)	# spill _tmp69 from $t3 to $fp-176
	sw $t5, -176($fp)	# spill _tmp70 from $t5 to $fp-176
	b _L16		# unconditional branch
_L15:
	# _tmp71 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string7: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp71
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp71 from $t0 to $fp-180
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L16:
	# _tmp72 = *(_tmp70)
	lw $t0, -176($fp)	# load _tmp70 from $fp-176 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp73 = *(arr)
	lw $t2, 4($fp)	# load arr from $fp+4 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp74 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp75 = j + _tmp74
	lw $t5, -12($fp)	# load j from $fp-12 into $t5
	add $t6, $t5, $t4	
	# _tmp76 = _tmp75 < _tmp73
	slt $t7, $t6, $t3	
	# _tmp77 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp78 = _tmp77 < _tmp75
	slt $s1, $s0, $t6	
	# _tmp79 = _tmp78 && _tmp76
	and $s2, $s1, $t7	
	# IfZ _tmp79 Goto _L17
	# (save modified registers before flow of control change)
	sw $t1, -184($fp)	# spill _tmp72 from $t1 to $fp-184
	sw $t3, -188($fp)	# spill _tmp73 from $t3 to $fp-188
	sw $t4, -200($fp)	# spill _tmp74 from $t4 to $fp-200
	sw $t6, -196($fp)	# spill _tmp75 from $t6 to $fp-196
	sw $t7, -192($fp)	# spill _tmp76 from $t7 to $fp-192
	sw $s0, -204($fp)	# spill _tmp77 from $s0 to $fp-204
	sw $s1, -208($fp)	# spill _tmp78 from $s1 to $fp-208
	sw $s2, -212($fp)	# spill _tmp79 from $s2 to $fp-212
	beqz $s2, _L17	# branch if _tmp79 is zero 
	# _tmp80 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp81 = _tmp75 * _tmp80
	lw $t1, -196($fp)	# load _tmp75 from $fp-196 into $t1
	mul $t2, $t1, $t0	
	# _tmp82 = _tmp81 + _tmp80
	add $t3, $t2, $t0	
	# _tmp83 = arr + _tmp82
	lw $t4, 4($fp)	# load arr from $fp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L18
	# (save modified registers before flow of control change)
	sw $t0, -216($fp)	# spill _tmp80 from $t0 to $fp-216
	sw $t2, -220($fp)	# spill _tmp81 from $t2 to $fp-220
	sw $t3, -224($fp)	# spill _tmp82 from $t3 to $fp-224
	sw $t5, -224($fp)	# spill _tmp83 from $t5 to $fp-224
	b _L18		# unconditional branch
_L17:
	# _tmp84 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string8: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp84
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -228($fp)	# spill _tmp84 from $t0 to $fp-228
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L18:
	# *(_tmp83) = _tmp72
	lw $t0, -184($fp)	# load _tmp72 from $fp-184 into $t0
	lw $t1, -224($fp)	# load _tmp83 from $fp-224 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp85 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp86 = j - _tmp85
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	sub $t4, $t3, $t2	
	# j = _tmp86
	move $t3, $t4		# copy value
	# Goto _L9
	# (save modified registers before flow of control change)
	sw $t2, -236($fp)	# spill _tmp85 from $t2 to $fp-236
	sw $t3, -12($fp)	# spill j from $t3 to $fp-12
	sw $t4, -232($fp)	# spill _tmp86 from $t4 to $fp-232
	b _L9		# unconditional branch
_L10:
	# _tmp87 = *(arr)
	lw $t0, 4($fp)	# load arr from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp88 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp89 = j + _tmp88
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	add $t4, $t3, $t2	
	# _tmp90 = _tmp89 < _tmp87
	slt $t5, $t4, $t1	
	# _tmp91 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp92 = _tmp91 < _tmp89
	slt $t7, $t6, $t4	
	# _tmp93 = _tmp92 && _tmp90
	and $s0, $t7, $t5	
	# IfZ _tmp93 Goto _L19
	# (save modified registers before flow of control change)
	sw $t1, -240($fp)	# spill _tmp87 from $t1 to $fp-240
	sw $t2, -252($fp)	# spill _tmp88 from $t2 to $fp-252
	sw $t4, -248($fp)	# spill _tmp89 from $t4 to $fp-248
	sw $t5, -244($fp)	# spill _tmp90 from $t5 to $fp-244
	sw $t6, -256($fp)	# spill _tmp91 from $t6 to $fp-256
	sw $t7, -260($fp)	# spill _tmp92 from $t7 to $fp-260
	sw $s0, -264($fp)	# spill _tmp93 from $s0 to $fp-264
	beqz $s0, _L19	# branch if _tmp93 is zero 
	# _tmp94 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp95 = _tmp89 * _tmp94
	lw $t1, -248($fp)	# load _tmp89 from $fp-248 into $t1
	mul $t2, $t1, $t0	
	# _tmp96 = _tmp95 + _tmp94
	add $t3, $t2, $t0	
	# _tmp97 = arr + _tmp96
	lw $t4, 4($fp)	# load arr from $fp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L20
	# (save modified registers before flow of control change)
	sw $t0, -268($fp)	# spill _tmp94 from $t0 to $fp-268
	sw $t2, -272($fp)	# spill _tmp95 from $t2 to $fp-272
	sw $t3, -276($fp)	# spill _tmp96 from $t3 to $fp-276
	sw $t5, -276($fp)	# spill _tmp97 from $t5 to $fp-276
	b _L20		# unconditional branch
_L19:
	# _tmp98 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string9: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp98
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -280($fp)	# spill _tmp98 from $t0 to $fp-280
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L20:
	# *(_tmp97) = val
	lw $t0, -16($fp)	# load val from $fp-16 into $t0
	lw $t1, -276($fp)	# load _tmp97 from $fp-276 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp99 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp100 = i + _tmp99
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	add $t4, $t3, $t2	
	# i = _tmp100
	move $t3, $t4		# copy value
	# Goto _L5
	# (save modified registers before flow of control change)
	sw $t2, -288($fp)	# spill _tmp99 from $t2 to $fp-288
	sw $t3, -8($fp)	# spill i from $t3 to $fp-8
	sw $t4, -284($fp)	# spill _tmp100 from $t4 to $fp-284
	b _L5		# unconditional branch
_L6:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__PrintArray:
	# BeginFunc 76
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 76	# decrement sp to make space for locals/temps
	# _tmp101 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp101
	move $t1, $t0		# copy value
	# _tmp102 = "Sorted results: "
	.data			# create string constant marked with label
	_string10: .asciiz "Sorted results: "
	.text
	la $t2, _string10	# load label
	# PushParam _tmp102
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp101 from $t0 to $fp-12
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -16($fp)	# spill _tmp102 from $t2 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L21:
	# _tmp103 = *(arr)
	lw $t0, 4($fp)	# load arr from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp104 = i < _tmp103
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp104 Goto _L22
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp103 from $t1 to $fp-20
	sw $t3, -24($fp)	# spill _tmp104 from $t3 to $fp-24
	beqz $t3, _L22	# branch if _tmp104 is zero 
	# _tmp105 = *(arr)
	lw $t0, 4($fp)	# load arr from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp106 = i < _tmp105
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# _tmp107 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp108 = _tmp107 < i
	slt $t5, $t4, $t2	
	# _tmp109 = _tmp108 && _tmp106
	and $t6, $t5, $t3	
	# IfZ _tmp109 Goto _L23
	# (save modified registers before flow of control change)
	sw $t1, -28($fp)	# spill _tmp105 from $t1 to $fp-28
	sw $t3, -32($fp)	# spill _tmp106 from $t3 to $fp-32
	sw $t4, -36($fp)	# spill _tmp107 from $t4 to $fp-36
	sw $t5, -40($fp)	# spill _tmp108 from $t5 to $fp-40
	sw $t6, -44($fp)	# spill _tmp109 from $t6 to $fp-44
	beqz $t6, _L23	# branch if _tmp109 is zero 
	# _tmp110 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp111 = i * _tmp110
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp112 = _tmp111 + _tmp110
	add $t3, $t2, $t0	
	# _tmp113 = arr + _tmp112
	lw $t4, 4($fp)	# load arr from $fp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L24
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp110 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp111 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp112 from $t3 to $fp-56
	sw $t5, -56($fp)	# spill _tmp113 from $t5 to $fp-56
	b _L24		# unconditional branch
_L23:
	# _tmp114 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string11: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string11	# load label
	# PushParam _tmp114
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp114 from $t0 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L24:
	# _tmp115 = *(_tmp113)
	lw $t0, -56($fp)	# load _tmp113 from $fp-56 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam _tmp115
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -64($fp)	# spill _tmp115 from $t1 to $fp-64
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp116 = " "
	.data			# create string constant marked with label
	_string12: .asciiz " "
	.text
	la $t0, _string12	# load label
	# PushParam _tmp116
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp116 from $t0 to $fp-68
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp117 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp118 = i + _tmp117
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp118
	move $t1, $t2		# copy value
	# Goto _L21
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp117 from $t0 to $fp-76
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -72($fp)	# spill _tmp118 from $t2 to $fp-72
	b _L21		# unconditional branch
_L22:
	# _tmp119 = "\n"
	.data			# create string constant marked with label
	_string13: .asciiz "\n"
	.text
	la $t0, _string13	# load label
	# PushParam _tmp119
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp119 from $t0 to $fp-80
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
main:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp120 = "\nThis program will read in a bunch of numbers an..."
	.data			# create string constant marked with label
	_string14: .asciiz "\nThis program will read in a bunch of numbers and print them\n"
	.text
	la $t0, _string14	# load label
	# PushParam _tmp120
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp120 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp121 = "back out in sorted order.\n\n"
	.data			# create string constant marked with label
	_string15: .asciiz "back out in sorted order.\n\n"
	.text
	la $t0, _string15	# load label
	# PushParam _tmp121
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp121 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp122 = LCall __ReadArray
	jal __ReadArray    	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# arr = _tmp122
	move $t1, $t0		# copy value
	# PushParam arr
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall __Sort
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp122 from $t0 to $fp-20
	sw $t1, -8($fp)	# spill arr from $t1 to $fp-8
	jal __Sort         	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam arr
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load arr from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall __PrintArray
	jal __PrintArray   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
