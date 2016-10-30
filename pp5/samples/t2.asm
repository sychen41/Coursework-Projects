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
	
__tester:
	# BeginFunc 180
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 180	# decrement sp to make space for locals/temps
	# _tmp0 = 1
	li $t0, 1		# load constant value 1 into $t0
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
	# b = _tmp9
	move $t2, $t0		# copy value
	# _tmp10 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp11 = sz < _tmp10
	lw $t4, 4($fp)	# load sz from $fp+4 into $t4
	slt $t5, $t4, $t3	
	# _tmp12 = sz == _tmp10
	seq $t6, $t4, $t3	
	# _tmp13 = _tmp11 || _tmp12
	or $t7, $t5, $t6	
	# IfZ _tmp13 Goto _L1
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp9 from $t0 to $fp-52
	sw $t2, 4($gp)	# spill b from $t2 to $gp+4
	sw $t3, -56($fp)	# spill _tmp10 from $t3 to $fp-56
	sw $t5, -60($fp)	# spill _tmp11 from $t5 to $fp-60
	sw $t6, -64($fp)	# spill _tmp12 from $t6 to $fp-64
	sw $t7, -68($fp)	# spill _tmp13 from $t7 to $fp-68
	beqz $t7, _L1	# branch if _tmp13 is zero 
	# _tmp14 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string2: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp14
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp14 from $t0 to $fp-72
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L1:
	# _tmp15 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp16 = sz * _tmp15
	lw $t1, 4($fp)	# load sz from $fp+4 into $t1
	mul $t2, $t1, $t0	
	# _tmp17 = _tmp16 + _tmp15
	add $t3, $t2, $t0	
	# PushParam _tmp17
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp18 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp15 from $t0 to $fp-76
	sw $t2, -80($fp)	# spill _tmp16 from $t2 to $fp-80
	sw $t3, -84($fp)	# spill _tmp17 from $t3 to $fp-84
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp18) = sz
	lw $t1, 4($fp)	# load sz from $fp+4 into $t1
	sw $t1, 0($t0) 	# store with offset
	# result = _tmp18
	move $t2, $t0		# copy value
	# _tmp19 = 0
	li $t3, 0		# load constant value 0 into $t3
	# i = _tmp19
	move $t4, $t3		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp18 from $t0 to $fp-88
	sw $t2, -12($fp)	# spill result from $t2 to $fp-12
	sw $t3, -92($fp)	# spill _tmp19 from $t3 to $fp-92
	sw $t4, -8($fp)	# spill i from $t4 to $fp-8
_L2:
	# _tmp20 = i < sz
	lw $t0, -8($fp)	# load i from $fp-8 into $t0
	lw $t1, 4($fp)	# load sz from $fp+4 into $t1
	slt $t2, $t0, $t1	
	# IfZ _tmp20 Goto _L3
	# (save modified registers before flow of control change)
	sw $t2, -96($fp)	# spill _tmp20 from $t2 to $fp-96
	beqz $t2, _L3	# branch if _tmp20 is zero 
	# _tmp21 = *(result)
	lw $t0, -12($fp)	# load result from $fp-12 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp22 = i < _tmp21
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# _tmp23 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp24 = _tmp23 < i
	slt $t5, $t4, $t2	
	# _tmp25 = _tmp24 && _tmp22
	and $t6, $t5, $t3	
	# IfZ _tmp25 Goto _L4
	# (save modified registers before flow of control change)
	sw $t1, -100($fp)	# spill _tmp21 from $t1 to $fp-100
	sw $t3, -104($fp)	# spill _tmp22 from $t3 to $fp-104
	sw $t4, -108($fp)	# spill _tmp23 from $t4 to $fp-108
	sw $t5, -112($fp)	# spill _tmp24 from $t5 to $fp-112
	sw $t6, -116($fp)	# spill _tmp25 from $t6 to $fp-116
	beqz $t6, _L4	# branch if _tmp25 is zero 
	# _tmp26 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp27 = i * _tmp26
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp28 = _tmp27 + _tmp26
	add $t3, $t2, $t0	
	# _tmp29 = result + _tmp28
	lw $t4, -12($fp)	# load result from $fp-12 into $t4
	add $t5, $t4, $t3	
	# Goto _L5
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp26 from $t0 to $fp-120
	sw $t2, -124($fp)	# spill _tmp27 from $t2 to $fp-124
	sw $t3, -128($fp)	# spill _tmp28 from $t3 to $fp-128
	sw $t5, -128($fp)	# spill _tmp29 from $t5 to $fp-128
	b _L5		# unconditional branch
_L4:
	# _tmp30 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string3: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp30
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp30 from $t0 to $fp-132
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L5:
	# *(_tmp29) = i
	lw $t0, -8($fp)	# load i from $fp-8 into $t0
	lw $t1, -128($fp)	# load _tmp29 from $fp-128 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp31 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp32 = i + _tmp31
	add $t3, $t0, $t2	
	# i = _tmp32
	move $t0, $t3		# copy value
	# Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill i from $t0 to $fp-8
	sw $t2, -140($fp)	# spill _tmp31 from $t2 to $fp-140
	sw $t3, -136($fp)	# spill _tmp32 from $t3 to $fp-136
	b _L2		# unconditional branch
_L3:
	# _tmp33 = "Done"
	.data			# create string constant marked with label
	_string4: .asciiz "Done"
	.text
	la $t0, _string4	# load label
	# _tmp34 = *(b)
	lw $t1, 4($gp)	# load b from $gp+4 into $t1
	lw $t2, 0($t1) 	# load with offset
	# _tmp35 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp36 = _tmp35 < _tmp34
	slt $t4, $t3, $t2	
	# _tmp37 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp38 = _tmp37 < _tmp35
	slt $t6, $t5, $t3	
	# _tmp39 = _tmp38 && _tmp36
	and $t7, $t6, $t4	
	# IfZ _tmp39 Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp33 from $t0 to $fp-144
	sw $t2, -148($fp)	# spill _tmp34 from $t2 to $fp-148
	sw $t3, -156($fp)	# spill _tmp35 from $t3 to $fp-156
	sw $t4, -152($fp)	# spill _tmp36 from $t4 to $fp-152
	sw $t5, -160($fp)	# spill _tmp37 from $t5 to $fp-160
	sw $t6, -164($fp)	# spill _tmp38 from $t6 to $fp-164
	sw $t7, -168($fp)	# spill _tmp39 from $t7 to $fp-168
	beqz $t7, _L6	# branch if _tmp39 is zero 
	# _tmp40 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp41 = _tmp35 * _tmp40
	lw $t1, -156($fp)	# load _tmp35 from $fp-156 into $t1
	mul $t2, $t1, $t0	
	# _tmp42 = _tmp41 + _tmp40
	add $t3, $t2, $t0	
	# _tmp43 = b + _tmp42
	lw $t4, 4($gp)	# load b from $gp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp40 from $t0 to $fp-172
	sw $t2, -176($fp)	# spill _tmp41 from $t2 to $fp-176
	sw $t3, -180($fp)	# spill _tmp42 from $t3 to $fp-180
	sw $t5, -180($fp)	# spill _tmp43 from $t5 to $fp-180
	b _L7		# unconditional branch
_L6:
	# _tmp44 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string5: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp44
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -184($fp)	# spill _tmp44 from $t0 to $fp-184
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L7:
	# *(_tmp43) = _tmp33
	lw $t0, -144($fp)	# load _tmp33 from $fp-144 into $t0
	lw $t1, -180($fp)	# load _tmp43 from $fp-180 into $t1
	sw $t0, 0($t1) 	# store with offset
	# Return result
	lw $t2, -12($fp)	# load result from $fp-12 into $t2
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
	# BeginFunc 156
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 156	# decrement sp to make space for locals/temps
	# _tmp45 = 8
	li $t0, 8		# load constant value 8 into $t0
	# PushParam _tmp45
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp46 = LCall __tester
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp45 from $t0 to $fp-12
	jal __tester       	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# d = _tmp46
	move $t1, $t0		# copy value
	# _tmp47 = *(d)
	lw $t2, 0($t1) 	# load with offset
	# _tmp48 = *(d)
	lw $t3, 0($t1) 	# load with offset
	# _tmp49 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp50 = _tmp49 < _tmp48
	slt $t5, $t4, $t3	
	# _tmp51 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp52 = _tmp51 < _tmp49
	slt $t7, $t6, $t4	
	# _tmp53 = _tmp52 && _tmp50
	and $s0, $t7, $t5	
	# IfZ _tmp53 Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp46 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill d from $t1 to $fp-8
	sw $t2, -20($fp)	# spill _tmp47 from $t2 to $fp-20
	sw $t3, -28($fp)	# spill _tmp48 from $t3 to $fp-28
	sw $t4, -36($fp)	# spill _tmp49 from $t4 to $fp-36
	sw $t5, -32($fp)	# spill _tmp50 from $t5 to $fp-32
	sw $t6, -40($fp)	# spill _tmp51 from $t6 to $fp-40
	sw $t7, -44($fp)	# spill _tmp52 from $t7 to $fp-44
	sw $s0, -48($fp)	# spill _tmp53 from $s0 to $fp-48
	beqz $s0, _L8	# branch if _tmp53 is zero 
	# _tmp54 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp55 = _tmp49 * _tmp54
	lw $t1, -36($fp)	# load _tmp49 from $fp-36 into $t1
	mul $t2, $t1, $t0	
	# _tmp56 = _tmp55 + _tmp54
	add $t3, $t2, $t0	
	# _tmp57 = d + _tmp56
	lw $t4, -8($fp)	# load d from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L9
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp54 from $t0 to $fp-52
	sw $t2, -56($fp)	# spill _tmp55 from $t2 to $fp-56
	sw $t3, -60($fp)	# spill _tmp56 from $t3 to $fp-60
	sw $t5, -60($fp)	# spill _tmp57 from $t5 to $fp-60
	b _L9		# unconditional branch
_L8:
	# _tmp58 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp58
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp58 from $t0 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L9:
	# _tmp59 = *(_tmp57)
	lw $t0, -60($fp)	# load _tmp57 from $fp-60 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp60 = _tmp59 < _tmp47
	lw $t2, -20($fp)	# load _tmp47 from $fp-20 into $t2
	slt $t3, $t1, $t2	
	# _tmp61 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp62 = _tmp61 < _tmp59
	slt $t5, $t4, $t1	
	# _tmp63 = _tmp62 && _tmp60
	and $t6, $t5, $t3	
	# IfZ _tmp63 Goto _L10
	# (save modified registers before flow of control change)
	sw $t1, -68($fp)	# spill _tmp59 from $t1 to $fp-68
	sw $t3, -24($fp)	# spill _tmp60 from $t3 to $fp-24
	sw $t4, -72($fp)	# spill _tmp61 from $t4 to $fp-72
	sw $t5, -76($fp)	# spill _tmp62 from $t5 to $fp-76
	sw $t6, -80($fp)	# spill _tmp63 from $t6 to $fp-80
	beqz $t6, _L10	# branch if _tmp63 is zero 
	# _tmp64 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp65 = _tmp59 * _tmp64
	lw $t1, -68($fp)	# load _tmp59 from $fp-68 into $t1
	mul $t2, $t1, $t0	
	# _tmp66 = _tmp65 + _tmp64
	add $t3, $t2, $t0	
	# _tmp67 = d + _tmp66
	lw $t4, -8($fp)	# load d from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L11
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp64 from $t0 to $fp-84
	sw $t2, -88($fp)	# spill _tmp65 from $t2 to $fp-88
	sw $t3, -92($fp)	# spill _tmp66 from $t3 to $fp-92
	sw $t5, -92($fp)	# spill _tmp67 from $t5 to $fp-92
	b _L11		# unconditional branch
_L10:
	# _tmp68 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string7: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp68
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp68 from $t0 to $fp-96
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L11:
	# _tmp69 = *(_tmp67)
	lw $t0, -92($fp)	# load _tmp67 from $fp-92 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam _tmp69
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -100($fp)	# spill _tmp69 from $t1 to $fp-100
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp70 = "\n"
	.data			# create string constant marked with label
	_string8: .asciiz "\n"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp70
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp70 from $t0 to $fp-104
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp71 = *(d)
	lw $t0, -8($fp)	# load d from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam _tmp71
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -108($fp)	# spill _tmp71 from $t1 to $fp-108
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp72 = "\n"
	.data			# create string constant marked with label
	_string9: .asciiz "\n"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp72
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp72 from $t0 to $fp-112
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp73 = *(b)
	lw $t0, 4($gp)	# load b from $gp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp74 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp75 = _tmp74 < _tmp73
	slt $t3, $t2, $t1	
	# _tmp76 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp77 = _tmp76 < _tmp74
	slt $t5, $t4, $t2	
	# _tmp78 = _tmp77 && _tmp75
	and $t6, $t5, $t3	
	# IfZ _tmp78 Goto _L12
	# (save modified registers before flow of control change)
	sw $t1, -116($fp)	# spill _tmp73 from $t1 to $fp-116
	sw $t2, -124($fp)	# spill _tmp74 from $t2 to $fp-124
	sw $t3, -120($fp)	# spill _tmp75 from $t3 to $fp-120
	sw $t4, -128($fp)	# spill _tmp76 from $t4 to $fp-128
	sw $t5, -132($fp)	# spill _tmp77 from $t5 to $fp-132
	sw $t6, -136($fp)	# spill _tmp78 from $t6 to $fp-136
	beqz $t6, _L12	# branch if _tmp78 is zero 
	# _tmp79 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp80 = _tmp74 * _tmp79
	lw $t1, -124($fp)	# load _tmp74 from $fp-124 into $t1
	mul $t2, $t1, $t0	
	# _tmp81 = _tmp80 + _tmp79
	add $t3, $t2, $t0	
	# _tmp82 = b + _tmp81
	lw $t4, 4($gp)	# load b from $gp+4 into $t4
	add $t5, $t4, $t3	
	# Goto _L13
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp79 from $t0 to $fp-140
	sw $t2, -144($fp)	# spill _tmp80 from $t2 to $fp-144
	sw $t3, -148($fp)	# spill _tmp81 from $t3 to $fp-148
	sw $t5, -148($fp)	# spill _tmp82 from $t5 to $fp-148
	b _L13		# unconditional branch
_L12:
	# _tmp83 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp83
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp83 from $t0 to $fp-152
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L13:
	# _tmp84 = *(_tmp82)
	lw $t0, -148($fp)	# load _tmp82 from $fp-148 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam _tmp84
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -156($fp)	# spill _tmp84 from $t1 to $fp-156
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp85 = "\n"
	.data			# create string constant marked with label
	_string11: .asciiz "\n"
	.text
	la $t0, _string11	# load label
	# PushParam _tmp85
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp85 from $t0 to $fp-160
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
