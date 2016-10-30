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
	
__Random.Init:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp0 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1 = this + _tmp0
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp1) = seedVal
	lw $t3, 8($fp)	# load seedVal from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Random.GenRandom:
	# BeginFunc 48
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp2 = 65536
	li $t0, 65536		# load constant value 65536 into $t0
	# _tmp3 = 22221
	li $t1, 22221		# load constant value 22221 into $t1
	# _tmp4 = 10000
	li $t2, 10000		# load constant value 10000 into $t2
	# _tmp5 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp6 = _tmp5 % _tmp4
	rem $t5, $t4, $t2	
	# _tmp7 = 15625
	li $t6, 15625		# load constant value 15625 into $t6
	# _tmp8 = _tmp7 * _tmp6
	mul $t7, $t6, $t5	
	# _tmp9 = _tmp8 + _tmp3
	add $s0, $t7, $t1	
	# _tmp10 = _tmp9 % _tmp2
	rem $s1, $s0, $t0	
	# _tmp11 = 4
	li $s2, 4		# load constant value 4 into $s2
	# _tmp12 = this + _tmp11
	add $s3, $t3, $s2	
	# *(_tmp12) = _tmp10
	sw $s1, 0($s3) 	# store with offset
	# _tmp13 = *(this + 4)
	lw $s4, 4($t3) 	# load with offset
	# Return _tmp13
	move $v0, $s4		# assign return value into $v0
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
__Random.RndInt:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp14 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp15 = *(_tmp14)
	lw $t2, 0($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp16 = ACall _tmp15
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp14 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp15 from $t2 to $fp-16
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp17 = _tmp16 % max
	lw $t1, 8($fp)	# load max from $fp+8 into $t1
	rem $t2, $t0, $t1	
	# Return _tmp17
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
	# VTable for class Random
	.data
	.align 2
	Random:		# label for class Random vtable
	.word __Random.GenRandom
	.word __Random.Init
	.word __Random.RndInt
	.text
__Deck.Init:
	# BeginFunc 48
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp18 = 52
	li $t0, 52		# load constant value 52 into $t0
	# _tmp19 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp20 = _tmp18 < _tmp19
	slt $t2, $t0, $t1	
	# _tmp21 = _tmp18 == _tmp19
	seq $t3, $t0, $t1	
	# _tmp22 = _tmp20 || _tmp21
	or $t4, $t2, $t3	
	# IfZ _tmp22 Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp18 from $t0 to $fp-8
	sw $t1, -12($fp)	# spill _tmp19 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp20 from $t2 to $fp-16
	sw $t3, -20($fp)	# spill _tmp21 from $t3 to $fp-20
	sw $t4, -24($fp)	# spill _tmp22 from $t4 to $fp-24
	beqz $t4, _L0	# branch if _tmp22 is zero 
	# _tmp23 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string1: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp23
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp23 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L0:
	# _tmp24 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp25 = _tmp18 * _tmp24
	lw $t1, -8($fp)	# load _tmp18 from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp26 = _tmp25 + _tmp24
	add $t3, $t2, $t0	
	# PushParam _tmp26
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp27 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp24 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp25 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp26 from $t3 to $fp-40
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp27) = _tmp18
	lw $t1, -8($fp)	# load _tmp18 from $fp-8 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp28 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp29 = this + _tmp28
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp29) = _tmp27
	sw $t0, 0($t4) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Deck.Shuffle:
	# BeginFunc 340
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 340	# decrement sp to make space for locals/temps
	# _tmp30 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp31 = 8
	li $t1, 8		# load constant value 8 into $t1
	# _tmp32 = this + _tmp31
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp32) = _tmp30
	sw $t0, 0($t3) 	# store with offset
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp30 from $t0 to $fp-8
	sw $t1, -12($fp)	# spill _tmp31 from $t1 to $fp-12
	sw $t3, -16($fp)	# spill _tmp32 from $t3 to $fp-16
_L1:
	# _tmp33 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp34 = 52
	li $t2, 52		# load constant value 52 into $t2
	# _tmp35 = _tmp33 < _tmp34
	slt $t3, $t1, $t2	
	# IfZ _tmp35 Goto _L2
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp33 from $t1 to $fp-20
	sw $t2, -24($fp)	# spill _tmp34 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp35 from $t3 to $fp-28
	beqz $t3, _L2	# branch if _tmp35 is zero 
	# _tmp36 = 13
	li $t0, 13		# load constant value 13 into $t0
	# _tmp37 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp38 = *(this + 8)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 8($t2) 	# load with offset
	# _tmp39 = _tmp38 + _tmp37
	add $t4, $t3, $t1	
	# _tmp40 = _tmp39 % _tmp36
	rem $t5, $t4, $t0	
	# _tmp41 = *(this + 4)
	lw $t6, 4($t2) 	# load with offset
	# _tmp42 = *(_tmp41)
	lw $t7, 0($t6) 	# load with offset
	# _tmp43 = *(this + 8)
	lw $s0, 8($t2) 	# load with offset
	# _tmp44 = _tmp43 < _tmp42
	slt $s1, $s0, $t7	
	# _tmp45 = -1
	li $s2, -1		# load constant value -1 into $s2
	# _tmp46 = _tmp45 < _tmp43
	slt $s3, $s2, $s0	
	# _tmp47 = _tmp46 && _tmp44
	and $s4, $s3, $s1	
	# IfZ _tmp47 Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp36 from $t0 to $fp-36
	sw $t1, -44($fp)	# spill _tmp37 from $t1 to $fp-44
	sw $t3, -48($fp)	# spill _tmp38 from $t3 to $fp-48
	sw $t4, -40($fp)	# spill _tmp39 from $t4 to $fp-40
	sw $t5, -32($fp)	# spill _tmp40 from $t5 to $fp-32
	sw $t6, -52($fp)	# spill _tmp41 from $t6 to $fp-52
	sw $t7, -56($fp)	# spill _tmp42 from $t7 to $fp-56
	sw $s0, -64($fp)	# spill _tmp43 from $s0 to $fp-64
	sw $s1, -60($fp)	# spill _tmp44 from $s1 to $fp-60
	sw $s2, -68($fp)	# spill _tmp45 from $s2 to $fp-68
	sw $s3, -72($fp)	# spill _tmp46 from $s3 to $fp-72
	sw $s4, -76($fp)	# spill _tmp47 from $s4 to $fp-76
	beqz $s4, _L3	# branch if _tmp47 is zero 
	# _tmp48 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp49 = _tmp43 * _tmp48
	lw $t1, -64($fp)	# load _tmp43 from $fp-64 into $t1
	mul $t2, $t1, $t0	
	# _tmp50 = _tmp49 + _tmp48
	add $t3, $t2, $t0	
	# _tmp51 = _tmp41 + _tmp50
	lw $t4, -52($fp)	# load _tmp41 from $fp-52 into $t4
	add $t5, $t4, $t3	
	# Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp48 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp49 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp50 from $t3 to $fp-88
	sw $t5, -88($fp)	# spill _tmp51 from $t5 to $fp-88
	b _L4		# unconditional branch
_L3:
	# _tmp52 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string2: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp52
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp52 from $t0 to $fp-92
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L4:
	# *(_tmp51) = _tmp40
	lw $t0, -32($fp)	# load _tmp40 from $fp-32 into $t0
	lw $t1, -88($fp)	# load _tmp51 from $fp-88 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp53 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp54 = *(this + 8)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 8($t3) 	# load with offset
	# _tmp55 = _tmp54 + _tmp53
	add $t5, $t4, $t2	
	# _tmp56 = 8
	li $t6, 8		# load constant value 8 into $t6
	# _tmp57 = this + _tmp56
	add $t7, $t3, $t6	
	# *(_tmp57) = _tmp55
	sw $t5, 0($t7) 	# store with offset
	# Goto _L1
	# (save modified registers before flow of control change)
	sw $t2, -100($fp)	# spill _tmp53 from $t2 to $fp-100
	sw $t4, -104($fp)	# spill _tmp54 from $t4 to $fp-104
	sw $t5, -96($fp)	# spill _tmp55 from $t5 to $fp-96
	sw $t6, -108($fp)	# spill _tmp56 from $t6 to $fp-108
	sw $t7, -112($fp)	# spill _tmp57 from $t7 to $fp-112
	b _L1		# unconditional branch
_L2:
_L5:
	# _tmp58 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp59 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp60 = _tmp59 < _tmp58
	slt $t3, $t2, $t1	
	# IfZ _tmp60 Goto _L6
	# (save modified registers before flow of control change)
	sw $t1, -116($fp)	# spill _tmp58 from $t1 to $fp-116
	sw $t2, -120($fp)	# spill _tmp59 from $t2 to $fp-120
	sw $t3, -124($fp)	# spill _tmp60 from $t3 to $fp-124
	beqz $t3, _L6	# branch if _tmp60 is zero 
	# _tmp61 = *(gRnd)
	lw $t0, 4($gp)	# load gRnd from $gp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp62 = *(_tmp61 + 8)
	lw $t2, 8($t1) 	# load with offset
	# _tmp63 = *(this + 8)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 8($t3) 	# load with offset
	# PushParam _tmp63
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam gRnd
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp64 = ACall _tmp62
	# (save modified registers before flow of control change)
	sw $t1, -136($fp)	# spill _tmp61 from $t1 to $fp-136
	sw $t2, -140($fp)	# spill _tmp62 from $t2 to $fp-140
	sw $t4, -144($fp)	# spill _tmp63 from $t4 to $fp-144
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# r = _tmp64
	move $t1, $t0		# copy value
	# _tmp65 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp66 = *(this + 8)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 8($t3) 	# load with offset
	# _tmp67 = _tmp66 - _tmp65
	sub $t5, $t4, $t2	
	# _tmp68 = 8
	li $t6, 8		# load constant value 8 into $t6
	# _tmp69 = this + _tmp68
	add $t7, $t3, $t6	
	# *(_tmp69) = _tmp67
	sw $t5, 0($t7) 	# store with offset
	# _tmp70 = *(this + 4)
	lw $s0, 4($t3) 	# load with offset
	# _tmp71 = *(_tmp70)
	lw $s1, 0($s0) 	# load with offset
	# _tmp72 = *(this + 8)
	lw $s2, 8($t3) 	# load with offset
	# _tmp73 = _tmp72 < _tmp71
	slt $s3, $s2, $s1	
	# _tmp74 = -1
	li $s4, -1		# load constant value -1 into $s4
	# _tmp75 = _tmp74 < _tmp72
	slt $s5, $s4, $s2	
	# _tmp76 = _tmp75 && _tmp73
	and $s6, $s5, $s3	
	# IfZ _tmp76 Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -148($fp)	# spill _tmp64 from $t0 to $fp-148
	sw $t1, -128($fp)	# spill r from $t1 to $fp-128
	sw $t2, -156($fp)	# spill _tmp65 from $t2 to $fp-156
	sw $t4, -160($fp)	# spill _tmp66 from $t4 to $fp-160
	sw $t5, -152($fp)	# spill _tmp67 from $t5 to $fp-152
	sw $t6, -164($fp)	# spill _tmp68 from $t6 to $fp-164
	sw $t7, -168($fp)	# spill _tmp69 from $t7 to $fp-168
	sw $s0, -172($fp)	# spill _tmp70 from $s0 to $fp-172
	sw $s1, -176($fp)	# spill _tmp71 from $s1 to $fp-176
	sw $s2, -184($fp)	# spill _tmp72 from $s2 to $fp-184
	sw $s3, -180($fp)	# spill _tmp73 from $s3 to $fp-180
	sw $s4, -188($fp)	# spill _tmp74 from $s4 to $fp-188
	sw $s5, -192($fp)	# spill _tmp75 from $s5 to $fp-192
	sw $s6, -196($fp)	# spill _tmp76 from $s6 to $fp-196
	beqz $s6, _L7	# branch if _tmp76 is zero 
	# _tmp77 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp78 = _tmp72 * _tmp77
	lw $t1, -184($fp)	# load _tmp72 from $fp-184 into $t1
	mul $t2, $t1, $t0	
	# _tmp79 = _tmp78 + _tmp77
	add $t3, $t2, $t0	
	# _tmp80 = _tmp70 + _tmp79
	lw $t4, -172($fp)	# load _tmp70 from $fp-172 into $t4
	add $t5, $t4, $t3	
	# Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -200($fp)	# spill _tmp77 from $t0 to $fp-200
	sw $t2, -204($fp)	# spill _tmp78 from $t2 to $fp-204
	sw $t3, -208($fp)	# spill _tmp79 from $t3 to $fp-208
	sw $t5, -208($fp)	# spill _tmp80 from $t5 to $fp-208
	b _L8		# unconditional branch
_L7:
	# _tmp81 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string3: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp81
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -212($fp)	# spill _tmp81 from $t0 to $fp-212
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L8:
	# _tmp82 = *(_tmp80)
	lw $t0, -208($fp)	# load _tmp80 from $fp-208 into $t0
	lw $t1, 0($t0) 	# load with offset
	# temp = _tmp82
	move $t2, $t1		# copy value
	# _tmp83 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp84 = *(_tmp83)
	lw $t5, 0($t4) 	# load with offset
	# _tmp85 = r < _tmp84
	lw $t6, -128($fp)	# load r from $fp-128 into $t6
	slt $t7, $t6, $t5	
	# _tmp86 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp87 = _tmp86 < r
	slt $s1, $s0, $t6	
	# _tmp88 = _tmp87 && _tmp85
	and $s2, $s1, $t7	
	# IfZ _tmp88 Goto _L9
	# (save modified registers before flow of control change)
	sw $t1, -216($fp)	# spill _tmp82 from $t1 to $fp-216
	sw $t2, -132($fp)	# spill temp from $t2 to $fp-132
	sw $t4, -220($fp)	# spill _tmp83 from $t4 to $fp-220
	sw $t5, -224($fp)	# spill _tmp84 from $t5 to $fp-224
	sw $t7, -228($fp)	# spill _tmp85 from $t7 to $fp-228
	sw $s0, -232($fp)	# spill _tmp86 from $s0 to $fp-232
	sw $s1, -236($fp)	# spill _tmp87 from $s1 to $fp-236
	sw $s2, -240($fp)	# spill _tmp88 from $s2 to $fp-240
	beqz $s2, _L9	# branch if _tmp88 is zero 
	# _tmp89 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp90 = r * _tmp89
	lw $t1, -128($fp)	# load r from $fp-128 into $t1
	mul $t2, $t1, $t0	
	# _tmp91 = _tmp90 + _tmp89
	add $t3, $t2, $t0	
	# _tmp92 = _tmp83 + _tmp91
	lw $t4, -220($fp)	# load _tmp83 from $fp-220 into $t4
	add $t5, $t4, $t3	
	# Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -244($fp)	# spill _tmp89 from $t0 to $fp-244
	sw $t2, -248($fp)	# spill _tmp90 from $t2 to $fp-248
	sw $t3, -252($fp)	# spill _tmp91 from $t3 to $fp-252
	sw $t5, -252($fp)	# spill _tmp92 from $t5 to $fp-252
	b _L10		# unconditional branch
_L9:
	# _tmp93 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string4: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp93
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -256($fp)	# spill _tmp93 from $t0 to $fp-256
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L10:
	# _tmp94 = *(_tmp92)
	lw $t0, -252($fp)	# load _tmp92 from $fp-252 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp95 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp96 = *(_tmp95)
	lw $t4, 0($t3) 	# load with offset
	# _tmp97 = *(this + 8)
	lw $t5, 8($t2) 	# load with offset
	# _tmp98 = _tmp97 < _tmp96
	slt $t6, $t5, $t4	
	# _tmp99 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp100 = _tmp99 < _tmp97
	slt $s0, $t7, $t5	
	# _tmp101 = _tmp100 && _tmp98
	and $s1, $s0, $t6	
	# IfZ _tmp101 Goto _L11
	# (save modified registers before flow of control change)
	sw $t1, -260($fp)	# spill _tmp94 from $t1 to $fp-260
	sw $t3, -264($fp)	# spill _tmp95 from $t3 to $fp-264
	sw $t4, -268($fp)	# spill _tmp96 from $t4 to $fp-268
	sw $t5, -276($fp)	# spill _tmp97 from $t5 to $fp-276
	sw $t6, -272($fp)	# spill _tmp98 from $t6 to $fp-272
	sw $t7, -280($fp)	# spill _tmp99 from $t7 to $fp-280
	sw $s0, -284($fp)	# spill _tmp100 from $s0 to $fp-284
	sw $s1, -288($fp)	# spill _tmp101 from $s1 to $fp-288
	beqz $s1, _L11	# branch if _tmp101 is zero 
	# _tmp102 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp103 = _tmp97 * _tmp102
	lw $t1, -276($fp)	# load _tmp97 from $fp-276 into $t1
	mul $t2, $t1, $t0	
	# _tmp104 = _tmp103 + _tmp102
	add $t3, $t2, $t0	
	# _tmp105 = _tmp95 + _tmp104
	lw $t4, -264($fp)	# load _tmp95 from $fp-264 into $t4
	add $t5, $t4, $t3	
	# Goto _L12
	# (save modified registers before flow of control change)
	sw $t0, -292($fp)	# spill _tmp102 from $t0 to $fp-292
	sw $t2, -296($fp)	# spill _tmp103 from $t2 to $fp-296
	sw $t3, -300($fp)	# spill _tmp104 from $t3 to $fp-300
	sw $t5, -300($fp)	# spill _tmp105 from $t5 to $fp-300
	b _L12		# unconditional branch
_L11:
	# _tmp106 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string5: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp106
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -304($fp)	# spill _tmp106 from $t0 to $fp-304
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L12:
	# *(_tmp105) = _tmp94
	lw $t0, -260($fp)	# load _tmp94 from $fp-260 into $t0
	lw $t1, -300($fp)	# load _tmp105 from $fp-300 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp107 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp108 = *(_tmp107)
	lw $t4, 0($t3) 	# load with offset
	# _tmp109 = r < _tmp108
	lw $t5, -128($fp)	# load r from $fp-128 into $t5
	slt $t6, $t5, $t4	
	# _tmp110 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp111 = _tmp110 < r
	slt $s0, $t7, $t5	
	# _tmp112 = _tmp111 && _tmp109
	and $s1, $s0, $t6	
	# IfZ _tmp112 Goto _L13
	# (save modified registers before flow of control change)
	sw $t3, -308($fp)	# spill _tmp107 from $t3 to $fp-308
	sw $t4, -312($fp)	# spill _tmp108 from $t4 to $fp-312
	sw $t6, -316($fp)	# spill _tmp109 from $t6 to $fp-316
	sw $t7, -320($fp)	# spill _tmp110 from $t7 to $fp-320
	sw $s0, -324($fp)	# spill _tmp111 from $s0 to $fp-324
	sw $s1, -328($fp)	# spill _tmp112 from $s1 to $fp-328
	beqz $s1, _L13	# branch if _tmp112 is zero 
	# _tmp113 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp114 = r * _tmp113
	lw $t1, -128($fp)	# load r from $fp-128 into $t1
	mul $t2, $t1, $t0	
	# _tmp115 = _tmp114 + _tmp113
	add $t3, $t2, $t0	
	# _tmp116 = _tmp107 + _tmp115
	lw $t4, -308($fp)	# load _tmp107 from $fp-308 into $t4
	add $t5, $t4, $t3	
	# Goto _L14
	# (save modified registers before flow of control change)
	sw $t0, -332($fp)	# spill _tmp113 from $t0 to $fp-332
	sw $t2, -336($fp)	# spill _tmp114 from $t2 to $fp-336
	sw $t3, -340($fp)	# spill _tmp115 from $t3 to $fp-340
	sw $t5, -340($fp)	# spill _tmp116 from $t5 to $fp-340
	b _L14		# unconditional branch
_L13:
	# _tmp117 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp117
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -344($fp)	# spill _tmp117 from $t0 to $fp-344
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L14:
	# *(_tmp116) = temp
	lw $t0, -132($fp)	# load temp from $fp-132 into $t0
	lw $t1, -340($fp)	# load _tmp116 from $fp-340 into $t1
	sw $t0, 0($t1) 	# store with offset
	# Goto _L5
	b _L5		# unconditional branch
_L6:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Deck.GetCard:
	# BeginFunc 96
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 96	# decrement sp to make space for locals/temps
	# _tmp118 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp119 = 52
	li $t2, 52		# load constant value 52 into $t2
	# _tmp120 = _tmp119 < _tmp118
	slt $t3, $t2, $t1	
	# _tmp121 = _tmp118 == _tmp119
	seq $t4, $t1, $t2	
	# _tmp122 = _tmp120 || _tmp121
	or $t5, $t3, $t4	
	# IfZ _tmp122 Goto _L15
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp118 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp119 from $t2 to $fp-16
	sw $t3, -20($fp)	# spill _tmp120 from $t3 to $fp-20
	sw $t4, -24($fp)	# spill _tmp121 from $t4 to $fp-24
	sw $t5, -28($fp)	# spill _tmp122 from $t5 to $fp-28
	beqz $t5, _L15	# branch if _tmp122 is zero 
	# _tmp123 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp123
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L16
	b _L16		# unconditional branch
_L15:
_L16:
	# _tmp124 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp125 = *(_tmp124)
	lw $t2, 0($t1) 	# load with offset
	# _tmp126 = *(this + 8)
	lw $t3, 8($t0) 	# load with offset
	# _tmp127 = _tmp126 < _tmp125
	slt $t4, $t3, $t2	
	# _tmp128 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp129 = _tmp128 < _tmp126
	slt $t6, $t5, $t3	
	# _tmp130 = _tmp129 && _tmp127
	and $t7, $t6, $t4	
	# IfZ _tmp130 Goto _L17
	# (save modified registers before flow of control change)
	sw $t1, -36($fp)	# spill _tmp124 from $t1 to $fp-36
	sw $t2, -40($fp)	# spill _tmp125 from $t2 to $fp-40
	sw $t3, -48($fp)	# spill _tmp126 from $t3 to $fp-48
	sw $t4, -44($fp)	# spill _tmp127 from $t4 to $fp-44
	sw $t5, -52($fp)	# spill _tmp128 from $t5 to $fp-52
	sw $t6, -56($fp)	# spill _tmp129 from $t6 to $fp-56
	sw $t7, -60($fp)	# spill _tmp130 from $t7 to $fp-60
	beqz $t7, _L17	# branch if _tmp130 is zero 
	# _tmp131 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp132 = _tmp126 * _tmp131
	lw $t1, -48($fp)	# load _tmp126 from $fp-48 into $t1
	mul $t2, $t1, $t0	
	# _tmp133 = _tmp132 + _tmp131
	add $t3, $t2, $t0	
	# _tmp134 = _tmp124 + _tmp133
	lw $t4, -36($fp)	# load _tmp124 from $fp-36 into $t4
	add $t5, $t4, $t3	
	# Goto _L18
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp131 from $t0 to $fp-64
	sw $t2, -68($fp)	# spill _tmp132 from $t2 to $fp-68
	sw $t3, -72($fp)	# spill _tmp133 from $t3 to $fp-72
	sw $t5, -72($fp)	# spill _tmp134 from $t5 to $fp-72
	b _L18		# unconditional branch
_L17:
	# _tmp135 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string7: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp135
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp135 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L18:
	# _tmp136 = *(_tmp134)
	lw $t0, -72($fp)	# load _tmp134 from $fp-72 into $t0
	lw $t1, 0($t0) 	# load with offset
	# result = _tmp136
	move $t2, $t1		# copy value
	# _tmp137 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp138 = *(this + 8)
	lw $t4, 4($fp)	# load this from $fp+4 into $t4
	lw $t5, 8($t4) 	# load with offset
	# _tmp139 = _tmp138 + _tmp137
	add $t6, $t5, $t3	
	# _tmp140 = 8
	li $t7, 8		# load constant value 8 into $t7
	# _tmp141 = this + _tmp140
	add $s0, $t4, $t7	
	# *(_tmp141) = _tmp139
	sw $t6, 0($s0) 	# store with offset
	# Return result
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
	# VTable for class Deck
	.data
	.align 2
	Deck:		# label for class Deck vtable
	.word __Deck.GetCard
	.word __Deck.Init
	.word __Deck.Shuffle
	.text
__BJDeck.Init:
	# BeginFunc 176
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 176	# decrement sp to make space for locals/temps
	# _tmp142 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp143 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp144 = _tmp142 < _tmp143
	slt $t2, $t0, $t1	
	# _tmp145 = _tmp142 == _tmp143
	seq $t3, $t0, $t1	
	# _tmp146 = _tmp144 || _tmp145
	or $t4, $t2, $t3	
	# IfZ _tmp146 Goto _L19
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp142 from $t0 to $fp-12
	sw $t1, -16($fp)	# spill _tmp143 from $t1 to $fp-16
	sw $t2, -20($fp)	# spill _tmp144 from $t2 to $fp-20
	sw $t3, -24($fp)	# spill _tmp145 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp146 from $t4 to $fp-28
	beqz $t4, _L19	# branch if _tmp146 is zero 
	# _tmp147 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string8: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp147
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp147 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L19:
	# _tmp148 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp149 = _tmp142 * _tmp148
	lw $t1, -12($fp)	# load _tmp142 from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp150 = _tmp149 + _tmp148
	add $t3, $t2, $t0	
	# PushParam _tmp150
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp151 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp148 from $t0 to $fp-36
	sw $t2, -40($fp)	# spill _tmp149 from $t2 to $fp-40
	sw $t3, -44($fp)	# spill _tmp150 from $t3 to $fp-44
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp151) = _tmp142
	lw $t1, -12($fp)	# load _tmp142 from $fp-12 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp152 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp153 = this + _tmp152
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp153) = _tmp151
	sw $t0, 0($t4) 	# store with offset
	# _tmp154 = 0
	li $t5, 0		# load constant value 0 into $t5
	# i = _tmp154
	move $t6, $t5		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp151 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp152 from $t2 to $fp-52
	sw $t4, -56($fp)	# spill _tmp153 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp154 from $t5 to $fp-60
	sw $t6, -8($fp)	# spill i from $t6 to $fp-8
_L20:
	# _tmp155 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp156 = i < _tmp155
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp156 Goto _L21
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp155 from $t0 to $fp-64
	sw $t2, -68($fp)	# spill _tmp156 from $t2 to $fp-68
	beqz $t2, _L21	# branch if _tmp156 is zero 
	# _tmp157 = 12
	li $t0, 12		# load constant value 12 into $t0
	# PushParam _tmp157
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp158 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp157 from $t0 to $fp-72
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp159 = Deck
	la $t1, Deck	# load label
	# *(_tmp158) = _tmp159
	sw $t1, 0($t0) 	# store with offset
	# _tmp160 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp161 = *(_tmp160)
	lw $t4, 0($t3) 	# load with offset
	# _tmp162 = i < _tmp161
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp163 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp164 = _tmp163 < i
	slt $s0, $t7, $t5	
	# _tmp165 = _tmp164 && _tmp162
	and $s1, $s0, $t6	
	# IfZ _tmp165 Goto _L22
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp158 from $t0 to $fp-76
	sw $t1, -80($fp)	# spill _tmp159 from $t1 to $fp-80
	sw $t3, -84($fp)	# spill _tmp160 from $t3 to $fp-84
	sw $t4, -88($fp)	# spill _tmp161 from $t4 to $fp-88
	sw $t6, -92($fp)	# spill _tmp162 from $t6 to $fp-92
	sw $t7, -96($fp)	# spill _tmp163 from $t7 to $fp-96
	sw $s0, -100($fp)	# spill _tmp164 from $s0 to $fp-100
	sw $s1, -104($fp)	# spill _tmp165 from $s1 to $fp-104
	beqz $s1, _L22	# branch if _tmp165 is zero 
	# _tmp166 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp167 = i * _tmp166
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp168 = _tmp167 + _tmp166
	add $t3, $t2, $t0	
	# _tmp169 = _tmp160 + _tmp168
	lw $t4, -84($fp)	# load _tmp160 from $fp-84 into $t4
	add $t5, $t4, $t3	
	# Goto _L23
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp166 from $t0 to $fp-108
	sw $t2, -112($fp)	# spill _tmp167 from $t2 to $fp-112
	sw $t3, -116($fp)	# spill _tmp168 from $t3 to $fp-116
	sw $t5, -116($fp)	# spill _tmp169 from $t5 to $fp-116
	b _L23		# unconditional branch
_L22:
	# _tmp170 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string9: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp170
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp170 from $t0 to $fp-120
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L23:
	# *(_tmp169) = _tmp158
	lw $t0, -76($fp)	# load _tmp158 from $fp-76 into $t0
	lw $t1, -116($fp)	# load _tmp169 from $fp-116 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp171 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp172 = *(_tmp171)
	lw $t4, 0($t3) 	# load with offset
	# _tmp173 = i < _tmp172
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp174 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp175 = _tmp174 < i
	slt $s0, $t7, $t5	
	# _tmp176 = _tmp175 && _tmp173
	and $s1, $s0, $t6	
	# IfZ _tmp176 Goto _L24
	# (save modified registers before flow of control change)
	sw $t3, -124($fp)	# spill _tmp171 from $t3 to $fp-124
	sw $t4, -128($fp)	# spill _tmp172 from $t4 to $fp-128
	sw $t6, -132($fp)	# spill _tmp173 from $t6 to $fp-132
	sw $t7, -136($fp)	# spill _tmp174 from $t7 to $fp-136
	sw $s0, -140($fp)	# spill _tmp175 from $s0 to $fp-140
	sw $s1, -144($fp)	# spill _tmp176 from $s1 to $fp-144
	beqz $s1, _L24	# branch if _tmp176 is zero 
	# _tmp177 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp178 = i * _tmp177
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp179 = _tmp178 + _tmp177
	add $t3, $t2, $t0	
	# _tmp180 = _tmp171 + _tmp179
	lw $t4, -124($fp)	# load _tmp171 from $fp-124 into $t4
	add $t5, $t4, $t3	
	# Goto _L25
	# (save modified registers before flow of control change)
	sw $t0, -148($fp)	# spill _tmp177 from $t0 to $fp-148
	sw $t2, -152($fp)	# spill _tmp178 from $t2 to $fp-152
	sw $t3, -156($fp)	# spill _tmp179 from $t3 to $fp-156
	sw $t5, -156($fp)	# spill _tmp180 from $t5 to $fp-156
	b _L25		# unconditional branch
_L24:
	# _tmp181 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp181
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp181 from $t0 to $fp-160
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L25:
	# _tmp182 = *(_tmp180)
	lw $t0, -156($fp)	# load _tmp180 from $fp-156 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp183 = *(_tmp182)
	lw $t2, 0($t1) 	# load with offset
	# _tmp184 = *(_tmp183 + 4)
	lw $t3, 4($t2) 	# load with offset
	# PushParam _tmp182
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp184
	# (save modified registers before flow of control change)
	sw $t1, -164($fp)	# spill _tmp182 from $t1 to $fp-164
	sw $t2, -168($fp)	# spill _tmp183 from $t2 to $fp-168
	sw $t3, -172($fp)	# spill _tmp184 from $t3 to $fp-172
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp185 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp186 = i + _tmp185
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp186
	move $t1, $t2		# copy value
	# Goto _L20
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp185 from $t0 to $fp-180
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -176($fp)	# spill _tmp186 from $t2 to $fp-176
	b _L20		# unconditional branch
_L21:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__BJDeck.DealCard:
	# BeginFunc 168
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 168	# decrement sp to make space for locals/temps
	# _tmp187 = 0
	li $t0, 0		# load constant value 0 into $t0
	# c = _tmp187
	move $t1, $t0		# copy value
	# _tmp188 = *(this + 8)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 8($t2) 	# load with offset
	# _tmp189 = 52
	li $t4, 52		# load constant value 52 into $t4
	# _tmp190 = 8
	li $t5, 8		# load constant value 8 into $t5
	# _tmp191 = _tmp190 * _tmp189
	mul $t6, $t5, $t4	
	# _tmp192 = _tmp191 < _tmp188
	slt $t7, $t6, $t3	
	# _tmp193 = _tmp188 == _tmp191
	seq $s0, $t3, $t6	
	# _tmp194 = _tmp192 || _tmp193
	or $s1, $t7, $s0	
	# IfZ _tmp194 Goto _L26
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp187 from $t0 to $fp-12
	sw $t1, -8($fp)	# spill c from $t1 to $fp-8
	sw $t3, -16($fp)	# spill _tmp188 from $t3 to $fp-16
	sw $t4, -24($fp)	# spill _tmp189 from $t4 to $fp-24
	sw $t5, -28($fp)	# spill _tmp190 from $t5 to $fp-28
	sw $t6, -20($fp)	# spill _tmp191 from $t6 to $fp-20
	sw $t7, -32($fp)	# spill _tmp192 from $t7 to $fp-32
	sw $s0, -36($fp)	# spill _tmp193 from $s0 to $fp-36
	sw $s1, -40($fp)	# spill _tmp194 from $s1 to $fp-40
	beqz $s1, _L26	# branch if _tmp194 is zero 
	# _tmp195 = 11
	li $t0, 11		# load constant value 11 into $t0
	# Return _tmp195
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L27
	b _L27		# unconditional branch
_L26:
_L27:
_L28:
	# _tmp196 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp197 = c == _tmp196
	lw $t1, -8($fp)	# load c from $fp-8 into $t1
	seq $t2, $t1, $t0	
	# IfZ _tmp197 Goto _L29
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp196 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp197 from $t2 to $fp-52
	beqz $t2, _L29	# branch if _tmp197 is zero 
	# _tmp198 = *(gRnd)
	lw $t0, 4($gp)	# load gRnd from $gp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp199 = *(_tmp198 + 8)
	lw $t2, 8($t1) 	# load with offset
	# _tmp200 = 8
	li $t3, 8		# load constant value 8 into $t3
	# PushParam _tmp200
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam gRnd
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp201 = ACall _tmp199
	# (save modified registers before flow of control change)
	sw $t1, -60($fp)	# spill _tmp198 from $t1 to $fp-60
	sw $t2, -64($fp)	# spill _tmp199 from $t2 to $fp-64
	sw $t3, -68($fp)	# spill _tmp200 from $t3 to $fp-68
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# d = _tmp201
	move $t1, $t0		# copy value
	# _tmp202 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp203 = *(_tmp202)
	lw $t4, 0($t3) 	# load with offset
	# _tmp204 = d < _tmp203
	slt $t5, $t1, $t4	
	# _tmp205 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp206 = _tmp205 < d
	slt $t7, $t6, $t1	
	# _tmp207 = _tmp206 && _tmp204
	and $s0, $t7, $t5	
	# IfZ _tmp207 Goto _L30
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp201 from $t0 to $fp-72
	sw $t1, -56($fp)	# spill d from $t1 to $fp-56
	sw $t3, -76($fp)	# spill _tmp202 from $t3 to $fp-76
	sw $t4, -80($fp)	# spill _tmp203 from $t4 to $fp-80
	sw $t5, -84($fp)	# spill _tmp204 from $t5 to $fp-84
	sw $t6, -88($fp)	# spill _tmp205 from $t6 to $fp-88
	sw $t7, -92($fp)	# spill _tmp206 from $t7 to $fp-92
	sw $s0, -96($fp)	# spill _tmp207 from $s0 to $fp-96
	beqz $s0, _L30	# branch if _tmp207 is zero 
	# _tmp208 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp209 = d * _tmp208
	lw $t1, -56($fp)	# load d from $fp-56 into $t1
	mul $t2, $t1, $t0	
	# _tmp210 = _tmp209 + _tmp208
	add $t3, $t2, $t0	
	# _tmp211 = _tmp202 + _tmp210
	lw $t4, -76($fp)	# load _tmp202 from $fp-76 into $t4
	add $t5, $t4, $t3	
	# Goto _L31
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp208 from $t0 to $fp-100
	sw $t2, -104($fp)	# spill _tmp209 from $t2 to $fp-104
	sw $t3, -108($fp)	# spill _tmp210 from $t3 to $fp-108
	sw $t5, -108($fp)	# spill _tmp211 from $t5 to $fp-108
	b _L31		# unconditional branch
_L30:
	# _tmp212 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string11: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string11	# load label
	# PushParam _tmp212
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp212 from $t0 to $fp-112
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L31:
	# _tmp213 = *(_tmp211)
	lw $t0, -108($fp)	# load _tmp211 from $fp-108 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp214 = *(_tmp213)
	lw $t2, 0($t1) 	# load with offset
	# _tmp215 = *(_tmp214)
	lw $t3, 0($t2) 	# load with offset
	# PushParam _tmp213
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp216 = ACall _tmp215
	# (save modified registers before flow of control change)
	sw $t1, -116($fp)	# spill _tmp213 from $t1 to $fp-116
	sw $t2, -120($fp)	# spill _tmp214 from $t2 to $fp-120
	sw $t3, -124($fp)	# spill _tmp215 from $t3 to $fp-124
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# c = _tmp216
	move $t1, $t0		# copy value
	# Goto _L28
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp216 from $t0 to $fp-128
	sw $t1, -8($fp)	# spill c from $t1 to $fp-8
	b _L28		# unconditional branch
_L29:
	# _tmp217 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp218 = _tmp217 < c
	lw $t1, -8($fp)	# load c from $fp-8 into $t1
	slt $t2, $t0, $t1	
	# IfZ _tmp218 Goto _L32
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp217 from $t0 to $fp-132
	sw $t2, -136($fp)	# spill _tmp218 from $t2 to $fp-136
	beqz $t2, _L32	# branch if _tmp218 is zero 
	# _tmp219 = 10
	li $t0, 10		# load constant value 10 into $t0
	# c = _tmp219
	move $t1, $t0		# copy value
	# Goto _L33
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp219 from $t0 to $fp-140
	sw $t1, -8($fp)	# spill c from $t1 to $fp-8
	b _L33		# unconditional branch
_L32:
	# _tmp220 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp221 = c == _tmp220
	lw $t1, -8($fp)	# load c from $fp-8 into $t1
	seq $t2, $t1, $t0	
	# IfZ _tmp221 Goto _L34
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp220 from $t0 to $fp-144
	sw $t2, -148($fp)	# spill _tmp221 from $t2 to $fp-148
	beqz $t2, _L34	# branch if _tmp221 is zero 
	# _tmp222 = 11
	li $t0, 11		# load constant value 11 into $t0
	# c = _tmp222
	move $t1, $t0		# copy value
	# Goto _L35
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp222 from $t0 to $fp-152
	sw $t1, -8($fp)	# spill c from $t1 to $fp-8
	b _L35		# unconditional branch
_L34:
_L35:
_L33:
	# _tmp223 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp224 = *(this + 8)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 8($t1) 	# load with offset
	# _tmp225 = _tmp224 + _tmp223
	add $t3, $t2, $t0	
	# _tmp226 = 8
	li $t4, 8		# load constant value 8 into $t4
	# _tmp227 = this + _tmp226
	add $t5, $t1, $t4	
	# *(_tmp227) = _tmp225
	sw $t3, 0($t5) 	# store with offset
	# Return c
	lw $t6, -8($fp)	# load c from $fp-8 into $t6
	move $v0, $t6		# assign return value into $v0
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
__BJDeck.Shuffle:
	# BeginFunc 96
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 96	# decrement sp to make space for locals/temps
	# _tmp228 = "Shuffling..."
	.data			# create string constant marked with label
	_string12: .asciiz "Shuffling..."
	.text
	la $t0, _string12	# load label
	# PushParam _tmp228
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp228 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp229 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp229
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp229 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L36:
	# _tmp230 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp231 = i < _tmp230
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp231 Goto _L37
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp230 from $t0 to $fp-20
	sw $t2, -24($fp)	# spill _tmp231 from $t2 to $fp-24
	beqz $t2, _L37	# branch if _tmp231 is zero 
	# _tmp232 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp233 = *(_tmp232)
	lw $t2, 0($t1) 	# load with offset
	# _tmp234 = i < _tmp233
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp235 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp236 = _tmp235 < i
	slt $t6, $t5, $t3	
	# _tmp237 = _tmp236 && _tmp234
	and $t7, $t6, $t4	
	# IfZ _tmp237 Goto _L38
	# (save modified registers before flow of control change)
	sw $t1, -28($fp)	# spill _tmp232 from $t1 to $fp-28
	sw $t2, -32($fp)	# spill _tmp233 from $t2 to $fp-32
	sw $t4, -36($fp)	# spill _tmp234 from $t4 to $fp-36
	sw $t5, -40($fp)	# spill _tmp235 from $t5 to $fp-40
	sw $t6, -44($fp)	# spill _tmp236 from $t6 to $fp-44
	sw $t7, -48($fp)	# spill _tmp237 from $t7 to $fp-48
	beqz $t7, _L38	# branch if _tmp237 is zero 
	# _tmp238 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp239 = i * _tmp238
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp240 = _tmp239 + _tmp238
	add $t3, $t2, $t0	
	# _tmp241 = _tmp232 + _tmp240
	lw $t4, -28($fp)	# load _tmp232 from $fp-28 into $t4
	add $t5, $t4, $t3	
	# Goto _L39
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp238 from $t0 to $fp-52
	sw $t2, -56($fp)	# spill _tmp239 from $t2 to $fp-56
	sw $t3, -60($fp)	# spill _tmp240 from $t3 to $fp-60
	sw $t5, -60($fp)	# spill _tmp241 from $t5 to $fp-60
	b _L39		# unconditional branch
_L38:
	# _tmp242 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string13: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string13	# load label
	# PushParam _tmp242
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp242 from $t0 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L39:
	# _tmp243 = *(_tmp241)
	lw $t0, -60($fp)	# load _tmp241 from $fp-60 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp244 = *(_tmp243)
	lw $t2, 0($t1) 	# load with offset
	# _tmp245 = *(_tmp244 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp243
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp245
	# (save modified registers before flow of control change)
	sw $t1, -68($fp)	# spill _tmp243 from $t1 to $fp-68
	sw $t2, -72($fp)	# spill _tmp244 from $t2 to $fp-72
	sw $t3, -76($fp)	# spill _tmp245 from $t3 to $fp-76
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp246 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp247 = i + _tmp246
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp247
	move $t1, $t2		# copy value
	# Goto _L36
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp246 from $t0 to $fp-84
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -80($fp)	# spill _tmp247 from $t2 to $fp-80
	b _L36		# unconditional branch
_L37:
	# _tmp248 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp249 = 8
	li $t1, 8		# load constant value 8 into $t1
	# _tmp250 = this + _tmp249
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp250) = _tmp248
	sw $t0, 0($t3) 	# store with offset
	# _tmp251 = "done.\n"
	.data			# create string constant marked with label
	_string14: .asciiz "done.\n"
	.text
	la $t4, _string14	# load label
	# PushParam _tmp251
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp248 from $t0 to $fp-88
	sw $t1, -92($fp)	# spill _tmp249 from $t1 to $fp-92
	sw $t3, -96($fp)	# spill _tmp250 from $t3 to $fp-96
	sw $t4, -100($fp)	# spill _tmp251 from $t4 to $fp-100
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__BJDeck.NumCardsRemaining:
	# BeginFunc 20
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 20	# decrement sp to make space for locals/temps
	# _tmp252 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp253 = 52
	li $t2, 52		# load constant value 52 into $t2
	# _tmp254 = 8
	li $t3, 8		# load constant value 8 into $t3
	# _tmp255 = _tmp254 * _tmp253
	mul $t4, $t3, $t2	
	# _tmp256 = _tmp255 - _tmp252
	sub $t5, $t4, $t1	
	# Return _tmp256
	move $v0, $t5		# assign return value into $v0
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
	# VTable for class BJDeck
	.data
	.align 2
	BJDeck:		# label for class BJDeck vtable
	.word __BJDeck.DealCard
	.word __BJDeck.Init
	.word __BJDeck.NumCardsRemaining
	.word __BJDeck.Shuffle
	.text
__Player.Init:
	# BeginFunc 32
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 32	# decrement sp to make space for locals/temps
	# _tmp257 = 1000
	li $t0, 1000		# load constant value 1000 into $t0
	# _tmp258 = 12
	li $t1, 12		# load constant value 12 into $t1
	# _tmp259 = this + _tmp258
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp259) = _tmp257
	sw $t0, 0($t3) 	# store with offset
	# _tmp260 = "What is the name of player #"
	.data			# create string constant marked with label
	_string15: .asciiz "What is the name of player #"
	.text
	la $t4, _string15	# load label
	# PushParam _tmp260
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp257 from $t0 to $fp-8
	sw $t1, -12($fp)	# spill _tmp258 from $t1 to $fp-12
	sw $t3, -16($fp)	# spill _tmp259 from $t3 to $fp-16
	sw $t4, -20($fp)	# spill _tmp260 from $t4 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam num
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, 8($fp)	# load num from $fp+8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp261 = "? "
	.data			# create string constant marked with label
	_string16: .asciiz "? "
	.text
	la $t0, _string16	# load label
	# PushParam _tmp261
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp261 from $t0 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp262 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# _tmp263 = 16
	li $t1, 16		# load constant value 16 into $t1
	# _tmp264 = this + _tmp263
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp264) = _tmp262
	sw $t0, 0($t3) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Player.Hit:
	# BeginFunc 160
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 160	# decrement sp to make space for locals/temps
	# _tmp265 = *(deck)
	lw $t0, 8($fp)	# load deck from $fp+8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp266 = *(_tmp265)
	lw $t2, 0($t1) 	# load with offset
	# PushParam deck
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp267 = ACall _tmp266
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp265 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp266 from $t2 to $fp-16
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# card = _tmp267
	move $t1, $t0		# copy value
	# _tmp268 = *(this + 16)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 16($t2) 	# load with offset
	# PushParam _tmp268
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp267 from $t0 to $fp-20
	sw $t1, -8($fp)	# spill card from $t1 to $fp-8
	sw $t3, -24($fp)	# spill _tmp268 from $t3 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp269 = " was dealt a "
	.data			# create string constant marked with label
	_string17: .asciiz " was dealt a "
	.text
	la $t0, _string17	# load label
	# PushParam _tmp269
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp269 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam card
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load card from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp270 = ".\n"
	.data			# create string constant marked with label
	_string18: .asciiz ".\n"
	.text
	la $t0, _string18	# load label
	# PushParam _tmp270
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp270 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp271 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp272 = _tmp271 + card
	lw $t2, -8($fp)	# load card from $fp-8 into $t2
	add $t3, $t1, $t2	
	# _tmp273 = 24
	li $t4, 24		# load constant value 24 into $t4
	# _tmp274 = this + _tmp273
	add $t5, $t0, $t4	
	# *(_tmp274) = _tmp272
	sw $t3, 0($t5) 	# store with offset
	# _tmp275 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp276 = *(this + 20)
	lw $t7, 20($t0) 	# load with offset
	# _tmp277 = _tmp276 + _tmp275
	add $s0, $t7, $t6	
	# _tmp278 = 20
	li $s1, 20		# load constant value 20 into $s1
	# _tmp279 = this + _tmp278
	add $s2, $t0, $s1	
	# *(_tmp279) = _tmp277
	sw $s0, 0($s2) 	# store with offset
	# _tmp280 = 11
	li $s3, 11		# load constant value 11 into $s3
	# _tmp281 = card == _tmp280
	seq $s4, $t2, $s3	
	# IfZ _tmp281 Goto _L40
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp271 from $t1 to $fp-40
	sw $t3, -36($fp)	# spill _tmp272 from $t3 to $fp-36
	sw $t4, -44($fp)	# spill _tmp273 from $t4 to $fp-44
	sw $t5, -48($fp)	# spill _tmp274 from $t5 to $fp-48
	sw $t6, -56($fp)	# spill _tmp275 from $t6 to $fp-56
	sw $t7, -60($fp)	# spill _tmp276 from $t7 to $fp-60
	sw $s0, -52($fp)	# spill _tmp277 from $s0 to $fp-52
	sw $s1, -64($fp)	# spill _tmp278 from $s1 to $fp-64
	sw $s2, -68($fp)	# spill _tmp279 from $s2 to $fp-68
	sw $s3, -72($fp)	# spill _tmp280 from $s3 to $fp-72
	sw $s4, -76($fp)	# spill _tmp281 from $s4 to $fp-76
	beqz $s4, _L40	# branch if _tmp281 is zero 
	# _tmp282 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp283 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp284 = _tmp283 + _tmp282
	add $t3, $t2, $t0	
	# _tmp285 = 4
	li $t4, 4		# load constant value 4 into $t4
	# _tmp286 = this + _tmp285
	add $t5, $t1, $t4	
	# *(_tmp286) = _tmp284
	sw $t3, 0($t5) 	# store with offset
	# Goto _L41
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp282 from $t0 to $fp-84
	sw $t2, -88($fp)	# spill _tmp283 from $t2 to $fp-88
	sw $t3, -80($fp)	# spill _tmp284 from $t3 to $fp-80
	sw $t4, -92($fp)	# spill _tmp285 from $t4 to $fp-92
	sw $t5, -96($fp)	# spill _tmp286 from $t5 to $fp-96
	b _L41		# unconditional branch
_L40:
_L41:
_L42:
	# _tmp287 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp288 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp289 = _tmp288 < _tmp287
	slt $t3, $t2, $t1	
	# _tmp290 = *(this + 24)
	lw $t4, 24($t0) 	# load with offset
	# _tmp291 = 21
	li $t5, 21		# load constant value 21 into $t5
	# _tmp292 = _tmp291 < _tmp290
	slt $t6, $t5, $t4	
	# _tmp293 = _tmp292 && _tmp289
	and $t7, $t6, $t3	
	# IfZ _tmp293 Goto _L43
	# (save modified registers before flow of control change)
	sw $t1, -104($fp)	# spill _tmp287 from $t1 to $fp-104
	sw $t2, -108($fp)	# spill _tmp288 from $t2 to $fp-108
	sw $t3, -112($fp)	# spill _tmp289 from $t3 to $fp-112
	sw $t4, -116($fp)	# spill _tmp290 from $t4 to $fp-116
	sw $t5, -120($fp)	# spill _tmp291 from $t5 to $fp-120
	sw $t6, -124($fp)	# spill _tmp292 from $t6 to $fp-124
	sw $t7, -100($fp)	# spill _tmp293 from $t7 to $fp-100
	beqz $t7, _L43	# branch if _tmp293 is zero 
	# _tmp294 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp295 = *(this + 24)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 24($t1) 	# load with offset
	# _tmp296 = _tmp295 - _tmp294
	sub $t3, $t2, $t0	
	# _tmp297 = 24
	li $t4, 24		# load constant value 24 into $t4
	# _tmp298 = this + _tmp297
	add $t5, $t1, $t4	
	# *(_tmp298) = _tmp296
	sw $t3, 0($t5) 	# store with offset
	# _tmp299 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp300 = *(this + 4)
	lw $t7, 4($t1) 	# load with offset
	# _tmp301 = _tmp300 - _tmp299
	sub $s0, $t7, $t6	
	# _tmp302 = 4
	li $s1, 4		# load constant value 4 into $s1
	# _tmp303 = this + _tmp302
	add $s2, $t1, $s1	
	# *(_tmp303) = _tmp301
	sw $s0, 0($s2) 	# store with offset
	# Goto _L42
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp294 from $t0 to $fp-132
	sw $t2, -136($fp)	# spill _tmp295 from $t2 to $fp-136
	sw $t3, -128($fp)	# spill _tmp296 from $t3 to $fp-128
	sw $t4, -140($fp)	# spill _tmp297 from $t4 to $fp-140
	sw $t5, -144($fp)	# spill _tmp298 from $t5 to $fp-144
	sw $t6, -152($fp)	# spill _tmp299 from $t6 to $fp-152
	sw $t7, -156($fp)	# spill _tmp300 from $t7 to $fp-156
	sw $s0, -148($fp)	# spill _tmp301 from $s0 to $fp-148
	sw $s1, -160($fp)	# spill _tmp302 from $s1 to $fp-160
	sw $s2, -164($fp)	# spill _tmp303 from $s2 to $fp-164
	b _L42		# unconditional branch
_L43:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Player.DoubleDown:
	# BeginFunc 112
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 112	# decrement sp to make space for locals/temps
	# _tmp304 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp305 = 11
	li $t2, 11		# load constant value 11 into $t2
	# _tmp306 = _tmp304 < _tmp305
	slt $t3, $t1, $t2	
	# _tmp307 = _tmp305 < _tmp304
	slt $t4, $t2, $t1	
	# _tmp308 = _tmp306 || _tmp307
	or $t5, $t3, $t4	
	# _tmp309 = *(this + 24)
	lw $t6, 24($t0) 	# load with offset
	# _tmp310 = 10
	li $t7, 10		# load constant value 10 into $t7
	# _tmp311 = _tmp309 < _tmp310
	slt $s0, $t6, $t7	
	# _tmp312 = _tmp310 < _tmp309
	slt $s1, $t7, $t6	
	# _tmp313 = _tmp311 || _tmp312
	or $s2, $s0, $s1	
	# _tmp314 = _tmp313 && _tmp308
	and $s3, $s2, $t5	
	# IfZ _tmp314 Goto _L44
	# (save modified registers before flow of control change)
	sw $t1, -16($fp)	# spill _tmp304 from $t1 to $fp-16
	sw $t2, -20($fp)	# spill _tmp305 from $t2 to $fp-20
	sw $t3, -24($fp)	# spill _tmp306 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp307 from $t4 to $fp-28
	sw $t5, -32($fp)	# spill _tmp308 from $t5 to $fp-32
	sw $t6, -36($fp)	# spill _tmp309 from $t6 to $fp-36
	sw $t7, -40($fp)	# spill _tmp310 from $t7 to $fp-40
	sw $s0, -44($fp)	# spill _tmp311 from $s0 to $fp-44
	sw $s1, -48($fp)	# spill _tmp312 from $s1 to $fp-48
	sw $s2, -52($fp)	# spill _tmp313 from $s2 to $fp-52
	sw $s3, -12($fp)	# spill _tmp314 from $s3 to $fp-12
	beqz $s3, _L44	# branch if _tmp314 is zero 
	# _tmp315 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp315
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L45
	b _L45		# unconditional branch
_L44:
_L45:
	# _tmp316 = "Would you like to double down?"
	.data			# create string constant marked with label
	_string19: .asciiz "Would you like to double down?"
	.text
	la $t0, _string19	# load label
	# PushParam _tmp316
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp317 = LCall __GetYesOrNo
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp316 from $t0 to $fp-60
	jal __GetYesOrNo   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp317 Goto _L46
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp317 from $t0 to $fp-64
	beqz $t0, _L46	# branch if _tmp317 is zero 
	# _tmp318 = 2
	li $t0, 2		# load constant value 2 into $t0
	# _tmp319 = *(this + 8)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 8($t1) 	# load with offset
	# _tmp320 = _tmp319 * _tmp318
	mul $t3, $t2, $t0	
	# _tmp321 = 8
	li $t4, 8		# load constant value 8 into $t4
	# _tmp322 = this + _tmp321
	add $t5, $t1, $t4	
	# *(_tmp322) = _tmp320
	sw $t3, 0($t5) 	# store with offset
	# _tmp323 = *(this)
	lw $t6, 0($t1) 	# load with offset
	# _tmp324 = *(_tmp323 + 12)
	lw $t7, 12($t6) 	# load with offset
	# PushParam deck
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $s0, 8($fp)	# load deck from $fp+8 into $s0
	sw $s0, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp324
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp318 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp319 from $t2 to $fp-76
	sw $t3, -68($fp)	# spill _tmp320 from $t3 to $fp-68
	sw $t4, -80($fp)	# spill _tmp321 from $t4 to $fp-80
	sw $t5, -84($fp)	# spill _tmp322 from $t5 to $fp-84
	sw $t6, -88($fp)	# spill _tmp323 from $t6 to $fp-88
	sw $t7, -92($fp)	# spill _tmp324 from $t7 to $fp-92
	jalr $t7            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp325 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp325
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp325 from $t1 to $fp-96
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp326 = ", your total is "
	.data			# create string constant marked with label
	_string20: .asciiz ", your total is "
	.text
	la $t0, _string20	# load label
	# PushParam _tmp326
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp326 from $t0 to $fp-100
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp327 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# PushParam _tmp327
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -104($fp)	# spill _tmp327 from $t1 to $fp-104
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp328 = ".\n"
	.data			# create string constant marked with label
	_string21: .asciiz ".\n"
	.text
	la $t0, _string21	# load label
	# PushParam _tmp328
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp328 from $t0 to $fp-108
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp329 = 1
	li $t0, 1		# load constant value 1 into $t0
	# Return _tmp329
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L47
	b _L47		# unconditional branch
_L46:
_L47:
	# _tmp330 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp330
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
__Player.TakeTurn:
	# BeginFunc 192
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 192	# decrement sp to make space for locals/temps
	# _tmp331 = "\n"
	.data			# create string constant marked with label
	_string22: .asciiz "\n"
	.text
	la $t0, _string22	# load label
	# PushParam _tmp331
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp331 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp332 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp332
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -16($fp)	# spill _tmp332 from $t1 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp333 = "'s turn.\n"
	.data			# create string constant marked with label
	_string23: .asciiz "'s turn.\n"
	.text
	la $t0, _string23	# load label
	# PushParam _tmp333
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp333 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp334 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp335 = 24
	li $t1, 24		# load constant value 24 into $t1
	# _tmp336 = this + _tmp335
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp336) = _tmp334
	sw $t0, 0($t3) 	# store with offset
	# _tmp337 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp338 = 4
	li $t5, 4		# load constant value 4 into $t5
	# _tmp339 = this + _tmp338
	add $t6, $t2, $t5	
	# *(_tmp339) = _tmp337
	sw $t4, 0($t6) 	# store with offset
	# _tmp340 = 0
	li $t7, 0		# load constant value 0 into $t7
	# _tmp341 = 20
	li $s0, 20		# load constant value 20 into $s0
	# _tmp342 = this + _tmp341
	add $s1, $t2, $s0	
	# *(_tmp342) = _tmp340
	sw $t7, 0($s1) 	# store with offset
	# _tmp343 = *(this)
	lw $s2, 0($t2) 	# load with offset
	# _tmp344 = *(_tmp343 + 12)
	lw $s3, 12($s2) 	# load with offset
	# PushParam deck
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $s4, 8($fp)	# load deck from $fp+8 into $s4
	sw $s4, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp344
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp334 from $t0 to $fp-24
	sw $t1, -28($fp)	# spill _tmp335 from $t1 to $fp-28
	sw $t3, -32($fp)	# spill _tmp336 from $t3 to $fp-32
	sw $t4, -36($fp)	# spill _tmp337 from $t4 to $fp-36
	sw $t5, -40($fp)	# spill _tmp338 from $t5 to $fp-40
	sw $t6, -44($fp)	# spill _tmp339 from $t6 to $fp-44
	sw $t7, -48($fp)	# spill _tmp340 from $t7 to $fp-48
	sw $s0, -52($fp)	# spill _tmp341 from $s0 to $fp-52
	sw $s1, -56($fp)	# spill _tmp342 from $s1 to $fp-56
	sw $s2, -60($fp)	# spill _tmp343 from $s2 to $fp-60
	sw $s3, -64($fp)	# spill _tmp344 from $s3 to $fp-64
	jalr $s3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp345 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp346 = *(_tmp345 + 12)
	lw $t2, 12($t1) 	# load with offset
	# PushParam deck
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 8($fp)	# load deck from $fp+8 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp346
	# (save modified registers before flow of control change)
	sw $t1, -68($fp)	# spill _tmp345 from $t1 to $fp-68
	sw $t2, -72($fp)	# spill _tmp346 from $t2 to $fp-72
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp347 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp348 = *(this)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 0($t1) 	# load with offset
	# _tmp349 = *(_tmp348)
	lw $t3, 0($t2) 	# load with offset
	# PushParam deck
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load deck from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp350 = ACall _tmp349
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp347 from $t0 to $fp-76
	sw $t2, -84($fp)	# spill _tmp348 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp349 from $t3 to $fp-88
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp351 = _tmp347 - _tmp350
	lw $t1, -76($fp)	# load _tmp347 from $fp-76 into $t1
	sub $t2, $t1, $t0	
	# IfZ _tmp351 Goto _L48
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp350 from $t0 to $fp-92
	sw $t2, -80($fp)	# spill _tmp351 from $t2 to $fp-80
	beqz $t2, _L48	# branch if _tmp351 is zero 
	# _tmp352 = 1
	li $t0, 1		# load constant value 1 into $t0
	# stillGoing = _tmp352
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp352 from $t0 to $fp-96
	sw $t1, -8($fp)	# spill stillGoing from $t1 to $fp-8
_L50:
	# _tmp353 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp354 = 21
	li $t2, 21		# load constant value 21 into $t2
	# _tmp355 = _tmp353 < _tmp354
	slt $t3, $t1, $t2	
	# _tmp356 = _tmp353 == _tmp354
	seq $t4, $t1, $t2	
	# _tmp357 = _tmp355 || _tmp356
	or $t5, $t3, $t4	
	# _tmp358 = _tmp357 && stillGoing
	lw $t6, -8($fp)	# load stillGoing from $fp-8 into $t6
	and $t7, $t5, $t6	
	# IfZ _tmp358 Goto _L51
	# (save modified registers before flow of control change)
	sw $t1, -104($fp)	# spill _tmp353 from $t1 to $fp-104
	sw $t2, -108($fp)	# spill _tmp354 from $t2 to $fp-108
	sw $t3, -112($fp)	# spill _tmp355 from $t3 to $fp-112
	sw $t4, -116($fp)	# spill _tmp356 from $t4 to $fp-116
	sw $t5, -120($fp)	# spill _tmp357 from $t5 to $fp-120
	sw $t7, -100($fp)	# spill _tmp358 from $t7 to $fp-100
	beqz $t7, _L51	# branch if _tmp358 is zero 
	# _tmp359 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp359
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -124($fp)	# spill _tmp359 from $t1 to $fp-124
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp360 = ", your total is "
	.data			# create string constant marked with label
	_string24: .asciiz ", your total is "
	.text
	la $t0, _string24	# load label
	# PushParam _tmp360
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp360 from $t0 to $fp-128
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp361 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# PushParam _tmp361
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -132($fp)	# spill _tmp361 from $t1 to $fp-132
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp362 = ".\n"
	.data			# create string constant marked with label
	_string25: .asciiz ".\n"
	.text
	la $t0, _string25	# load label
	# PushParam _tmp362
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -136($fp)	# spill _tmp362 from $t0 to $fp-136
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp363 = "Would you like a hit?"
	.data			# create string constant marked with label
	_string26: .asciiz "Would you like a hit?"
	.text
	la $t0, _string26	# load label
	# PushParam _tmp363
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp364 = LCall __GetYesOrNo
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp363 from $t0 to $fp-140
	jal __GetYesOrNo   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# stillGoing = _tmp364
	move $t1, $t0		# copy value
	# IfZ stillGoing Goto _L52
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp364 from $t0 to $fp-144
	sw $t1, -8($fp)	# spill stillGoing from $t1 to $fp-8
	beqz $t1, _L52	# branch if stillGoing is zero 
	# _tmp365 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp366 = *(_tmp365 + 12)
	lw $t2, 12($t1) 	# load with offset
	# PushParam deck
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 8($fp)	# load deck from $fp+8 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp366
	# (save modified registers before flow of control change)
	sw $t1, -148($fp)	# spill _tmp365 from $t1 to $fp-148
	sw $t2, -152($fp)	# spill _tmp366 from $t2 to $fp-152
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L53
	b _L53		# unconditional branch
_L52:
_L53:
	# Goto _L50
	b _L50		# unconditional branch
_L51:
	# Goto _L49
	b _L49		# unconditional branch
_L48:
_L49:
	# _tmp367 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp368 = 21
	li $t2, 21		# load constant value 21 into $t2
	# _tmp369 = _tmp368 < _tmp367
	slt $t3, $t2, $t1	
	# IfZ _tmp369 Goto _L54
	# (save modified registers before flow of control change)
	sw $t1, -156($fp)	# spill _tmp367 from $t1 to $fp-156
	sw $t2, -160($fp)	# spill _tmp368 from $t2 to $fp-160
	sw $t3, -164($fp)	# spill _tmp369 from $t3 to $fp-164
	beqz $t3, _L54	# branch if _tmp369 is zero 
	# _tmp370 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp370
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -168($fp)	# spill _tmp370 from $t1 to $fp-168
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp371 = " busts with the big "
	.data			# create string constant marked with label
	_string27: .asciiz " busts with the big "
	.text
	la $t0, _string27	# load label
	# PushParam _tmp371
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp371 from $t0 to $fp-172
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp372 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# PushParam _tmp372
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -176($fp)	# spill _tmp372 from $t1 to $fp-176
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp373 = "!\n"
	.data			# create string constant marked with label
	_string28: .asciiz "!\n"
	.text
	la $t0, _string28	# load label
	# PushParam _tmp373
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp373 from $t0 to $fp-180
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L55
	b _L55		# unconditional branch
_L54:
	# _tmp374 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp374
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -184($fp)	# spill _tmp374 from $t1 to $fp-184
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp375 = " stays at "
	.data			# create string constant marked with label
	_string29: .asciiz " stays at "
	.text
	la $t0, _string29	# load label
	# PushParam _tmp375
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp375 from $t0 to $fp-188
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp376 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# PushParam _tmp376
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -192($fp)	# spill _tmp376 from $t1 to $fp-192
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp377 = ".\n"
	.data			# create string constant marked with label
	_string30: .asciiz ".\n"
	.text
	la $t0, _string30	# load label
	# PushParam _tmp377
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -196($fp)	# spill _tmp377 from $t0 to $fp-196
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L55:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Player.HasMoney:
	# BeginFunc 12
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp378 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp379 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp380 = _tmp379 < _tmp378
	slt $t3, $t2, $t1	
	# Return _tmp380
	move $v0, $t3		# assign return value into $v0
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
__Player.PrintMoney:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp381 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp381
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp381 from $t1 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp382 = ", you have $"
	.data			# create string constant marked with label
	_string31: .asciiz ", you have $"
	.text
	la $t0, _string31	# load label
	# PushParam _tmp382
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp382 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp383 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# PushParam _tmp383
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -16($fp)	# spill _tmp383 from $t1 to $fp-16
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp384 = ".\n"
	.data			# create string constant marked with label
	_string32: .asciiz ".\n"
	.text
	la $t0, _string32	# load label
	# PushParam _tmp384
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp384 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Player.PlaceBet:
	# BeginFunc 72
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 72	# decrement sp to make space for locals/temps
	# _tmp385 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp386 = 8
	li $t1, 8		# load constant value 8 into $t1
	# _tmp387 = this + _tmp386
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp387) = _tmp385
	sw $t0, 0($t3) 	# store with offset
	# _tmp388 = *(this)
	lw $t4, 0($t2) 	# load with offset
	# _tmp389 = *(_tmp388 + 24)
	lw $t5, 24($t4) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp389
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp385 from $t0 to $fp-8
	sw $t1, -12($fp)	# spill _tmp386 from $t1 to $fp-12
	sw $t3, -16($fp)	# spill _tmp387 from $t3 to $fp-16
	sw $t4, -20($fp)	# spill _tmp388 from $t4 to $fp-20
	sw $t5, -24($fp)	# spill _tmp389 from $t5 to $fp-24
	jalr $t5            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L56:
	# _tmp390 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp391 = *(this + 12)
	lw $t2, 12($t0) 	# load with offset
	# _tmp392 = _tmp391 < _tmp390
	slt $t3, $t2, $t1	
	# _tmp393 = *(this + 8)
	lw $t4, 8($t0) 	# load with offset
	# _tmp394 = 0
	li $t5, 0		# load constant value 0 into $t5
	# _tmp395 = _tmp393 < _tmp394
	slt $t6, $t4, $t5	
	# _tmp396 = _tmp393 == _tmp394
	seq $t7, $t4, $t5	
	# _tmp397 = _tmp395 || _tmp396
	or $s0, $t6, $t7	
	# _tmp398 = _tmp397 || _tmp392
	or $s1, $s0, $t3	
	# IfZ _tmp398 Goto _L57
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp390 from $t1 to $fp-32
	sw $t2, -36($fp)	# spill _tmp391 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp392 from $t3 to $fp-40
	sw $t4, -44($fp)	# spill _tmp393 from $t4 to $fp-44
	sw $t5, -48($fp)	# spill _tmp394 from $t5 to $fp-48
	sw $t6, -52($fp)	# spill _tmp395 from $t6 to $fp-52
	sw $t7, -56($fp)	# spill _tmp396 from $t7 to $fp-56
	sw $s0, -60($fp)	# spill _tmp397 from $s0 to $fp-60
	sw $s1, -28($fp)	# spill _tmp398 from $s1 to $fp-28
	beqz $s1, _L57	# branch if _tmp398 is zero 
	# _tmp399 = "How much would you like to bet? "
	.data			# create string constant marked with label
	_string33: .asciiz "How much would you like to bet? "
	.text
	la $t0, _string33	# load label
	# PushParam _tmp399
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp399 from $t0 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp400 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# _tmp401 = 8
	li $t1, 8		# load constant value 8 into $t1
	# _tmp402 = this + _tmp401
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp402) = _tmp400
	sw $t0, 0($t3) 	# store with offset
	# Goto _L56
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp400 from $t0 to $fp-68
	sw $t1, -72($fp)	# spill _tmp401 from $t1 to $fp-72
	sw $t3, -76($fp)	# spill _tmp402 from $t3 to $fp-76
	b _L56		# unconditional branch
_L57:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Player.GetTotal:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp403 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# Return _tmp403
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
__Player.Resolve:
	# BeginFunc 208
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 208	# decrement sp to make space for locals/temps
	# _tmp404 = 0
	li $t0, 0		# load constant value 0 into $t0
	# win = _tmp404
	move $t1, $t0		# copy value
	# _tmp405 = 0
	li $t2, 0		# load constant value 0 into $t2
	# lose = _tmp405
	move $t3, $t2		# copy value
	# _tmp406 = *(this + 20)
	lw $t4, 4($fp)	# load this from $fp+4 into $t4
	lw $t5, 20($t4) 	# load with offset
	# _tmp407 = 2
	li $t6, 2		# load constant value 2 into $t6
	# _tmp408 = _tmp406 == _tmp407
	seq $t7, $t5, $t6	
	# _tmp409 = *(this + 24)
	lw $s0, 24($t4) 	# load with offset
	# _tmp410 = 21
	li $s1, 21		# load constant value 21 into $s1
	# _tmp411 = _tmp409 == _tmp410
	seq $s2, $s0, $s1	
	# _tmp412 = _tmp411 && _tmp408
	and $s3, $s2, $t7	
	# IfZ _tmp412 Goto _L58
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp404 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill win from $t1 to $fp-8
	sw $t2, -20($fp)	# spill _tmp405 from $t2 to $fp-20
	sw $t3, -12($fp)	# spill lose from $t3 to $fp-12
	sw $t5, -28($fp)	# spill _tmp406 from $t5 to $fp-28
	sw $t6, -32($fp)	# spill _tmp407 from $t6 to $fp-32
	sw $t7, -36($fp)	# spill _tmp408 from $t7 to $fp-36
	sw $s0, -40($fp)	# spill _tmp409 from $s0 to $fp-40
	sw $s1, -44($fp)	# spill _tmp410 from $s1 to $fp-44
	sw $s2, -48($fp)	# spill _tmp411 from $s2 to $fp-48
	sw $s3, -24($fp)	# spill _tmp412 from $s3 to $fp-24
	beqz $s3, _L58	# branch if _tmp412 is zero 
	# _tmp413 = 2
	li $t0, 2		# load constant value 2 into $t0
	# win = _tmp413
	move $t1, $t0		# copy value
	# Goto _L59
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp413 from $t0 to $fp-52
	sw $t1, -8($fp)	# spill win from $t1 to $fp-8
	b _L59		# unconditional branch
_L58:
	# _tmp414 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp415 = 21
	li $t2, 21		# load constant value 21 into $t2
	# _tmp416 = _tmp415 < _tmp414
	slt $t3, $t2, $t1	
	# IfZ _tmp416 Goto _L60
	# (save modified registers before flow of control change)
	sw $t1, -56($fp)	# spill _tmp414 from $t1 to $fp-56
	sw $t2, -60($fp)	# spill _tmp415 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp416 from $t3 to $fp-64
	beqz $t3, _L60	# branch if _tmp416 is zero 
	# _tmp417 = 1
	li $t0, 1		# load constant value 1 into $t0
	# lose = _tmp417
	move $t1, $t0		# copy value
	# Goto _L61
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp417 from $t0 to $fp-68
	sw $t1, -12($fp)	# spill lose from $t1 to $fp-12
	b _L61		# unconditional branch
_L60:
	# _tmp418 = 21
	li $t0, 21		# load constant value 21 into $t0
	# _tmp419 = _tmp418 < dealer
	lw $t1, 8($fp)	# load dealer from $fp+8 into $t1
	slt $t2, $t0, $t1	
	# IfZ _tmp419 Goto _L62
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp418 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp419 from $t2 to $fp-76
	beqz $t2, _L62	# branch if _tmp419 is zero 
	# _tmp420 = 1
	li $t0, 1		# load constant value 1 into $t0
	# win = _tmp420
	move $t1, $t0		# copy value
	# Goto _L63
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp420 from $t0 to $fp-80
	sw $t1, -8($fp)	# spill win from $t1 to $fp-8
	b _L63		# unconditional branch
_L62:
	# _tmp421 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp422 = dealer < _tmp421
	lw $t2, 8($fp)	# load dealer from $fp+8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp422 Goto _L64
	# (save modified registers before flow of control change)
	sw $t1, -84($fp)	# spill _tmp421 from $t1 to $fp-84
	sw $t3, -88($fp)	# spill _tmp422 from $t3 to $fp-88
	beqz $t3, _L64	# branch if _tmp422 is zero 
	# _tmp423 = 1
	li $t0, 1		# load constant value 1 into $t0
	# win = _tmp423
	move $t1, $t0		# copy value
	# Goto _L65
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp423 from $t0 to $fp-92
	sw $t1, -8($fp)	# spill win from $t1 to $fp-8
	b _L65		# unconditional branch
_L64:
	# _tmp424 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp425 = _tmp424 < dealer
	lw $t2, 8($fp)	# load dealer from $fp+8 into $t2
	slt $t3, $t1, $t2	
	# IfZ _tmp425 Goto _L66
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp424 from $t1 to $fp-96
	sw $t3, -100($fp)	# spill _tmp425 from $t3 to $fp-100
	beqz $t3, _L66	# branch if _tmp425 is zero 
	# _tmp426 = 1
	li $t0, 1		# load constant value 1 into $t0
	# lose = _tmp426
	move $t1, $t0		# copy value
	# Goto _L67
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp426 from $t0 to $fp-104
	sw $t1, -12($fp)	# spill lose from $t1 to $fp-12
	b _L67		# unconditional branch
_L66:
_L67:
_L65:
_L63:
_L61:
_L59:
	# _tmp427 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp428 = _tmp427 < win
	lw $t1, -8($fp)	# load win from $fp-8 into $t1
	slt $t2, $t0, $t1	
	# _tmp429 = win == _tmp427
	seq $t3, $t1, $t0	
	# _tmp430 = _tmp428 || _tmp429
	or $t4, $t2, $t3	
	# IfZ _tmp430 Goto _L68
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp427 from $t0 to $fp-108
	sw $t2, -112($fp)	# spill _tmp428 from $t2 to $fp-112
	sw $t3, -116($fp)	# spill _tmp429 from $t3 to $fp-116
	sw $t4, -120($fp)	# spill _tmp430 from $t4 to $fp-120
	beqz $t4, _L68	# branch if _tmp430 is zero 
	# _tmp431 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp431
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -124($fp)	# spill _tmp431 from $t1 to $fp-124
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp432 = ", you won $"
	.data			# create string constant marked with label
	_string34: .asciiz ", you won $"
	.text
	la $t0, _string34	# load label
	# PushParam _tmp432
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp432 from $t0 to $fp-128
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp433 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# PushParam _tmp433
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -132($fp)	# spill _tmp433 from $t1 to $fp-132
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp434 = ".\n"
	.data			# create string constant marked with label
	_string35: .asciiz ".\n"
	.text
	la $t0, _string35	# load label
	# PushParam _tmp434
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -136($fp)	# spill _tmp434 from $t0 to $fp-136
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L69
	b _L69		# unconditional branch
_L68:
	# _tmp435 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp436 = _tmp435 < lose
	lw $t1, -12($fp)	# load lose from $fp-12 into $t1
	slt $t2, $t0, $t1	
	# _tmp437 = lose == _tmp435
	seq $t3, $t1, $t0	
	# _tmp438 = _tmp436 || _tmp437
	or $t4, $t2, $t3	
	# IfZ _tmp438 Goto _L70
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp435 from $t0 to $fp-140
	sw $t2, -144($fp)	# spill _tmp436 from $t2 to $fp-144
	sw $t3, -148($fp)	# spill _tmp437 from $t3 to $fp-148
	sw $t4, -152($fp)	# spill _tmp438 from $t4 to $fp-152
	beqz $t4, _L70	# branch if _tmp438 is zero 
	# _tmp439 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp439
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -156($fp)	# spill _tmp439 from $t1 to $fp-156
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp440 = ", you lost $"
	.data			# create string constant marked with label
	_string36: .asciiz ", you lost $"
	.text
	la $t0, _string36	# load label
	# PushParam _tmp440
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp440 from $t0 to $fp-160
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp441 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# PushParam _tmp441
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -164($fp)	# spill _tmp441 from $t1 to $fp-164
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp442 = ".\n"
	.data			# create string constant marked with label
	_string37: .asciiz ".\n"
	.text
	la $t0, _string37	# load label
	# PushParam _tmp442
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp442 from $t0 to $fp-168
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L71
	b _L71		# unconditional branch
_L70:
	# _tmp443 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp443
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -172($fp)	# spill _tmp443 from $t1 to $fp-172
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp444 = ", you push!\n"
	.data			# create string constant marked with label
	_string38: .asciiz ", you push!\n"
	.text
	la $t0, _string38	# load label
	# PushParam _tmp444
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp444 from $t0 to $fp-176
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L71:
_L69:
	# _tmp445 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp446 = win * _tmp445
	lw $t2, -8($fp)	# load win from $fp-8 into $t2
	mul $t3, $t2, $t1	
	# win = _tmp446
	move $t2, $t3		# copy value
	# _tmp447 = *(this + 8)
	lw $t4, 8($t0) 	# load with offset
	# _tmp448 = lose * _tmp447
	lw $t5, -12($fp)	# load lose from $fp-12 into $t5
	mul $t6, $t5, $t4	
	# lose = _tmp448
	move $t5, $t6		# copy value
	# _tmp449 = *(this + 12)
	lw $t7, 12($t0) 	# load with offset
	# _tmp450 = _tmp449 + win
	add $s0, $t7, $t2	
	# _tmp451 = _tmp450 - lose
	sub $s1, $s0, $t5	
	# _tmp452 = 12
	li $s2, 12		# load constant value 12 into $s2
	# _tmp453 = this + _tmp452
	add $s3, $t0, $s2	
	# *(_tmp453) = _tmp451
	sw $s1, 0($s3) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Player
	.data
	.align 2
	Player:		# label for class Player vtable
	.word __Player.DoubleDown
	.word __Player.GetTotal
	.word __Player.HasMoney
	.word __Player.Hit
	.word __Player.Init
	.word __Player.PlaceBet
	.word __Player.PrintMoney
	.word __Player.Resolve
	.word __Player.TakeTurn
	.text
__Dealer.Init:
	# BeginFunc 48
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp454 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp455 = 24
	li $t1, 24		# load constant value 24 into $t1
	# _tmp456 = this + _tmp455
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp456) = _tmp454
	sw $t0, 0($t3) 	# store with offset
	# _tmp457 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp458 = 4
	li $t5, 4		# load constant value 4 into $t5
	# _tmp459 = this + _tmp458
	add $t6, $t2, $t5	
	# *(_tmp459) = _tmp457
	sw $t4, 0($t6) 	# store with offset
	# _tmp460 = 0
	li $t7, 0		# load constant value 0 into $t7
	# _tmp461 = 20
	li $s0, 20		# load constant value 20 into $s0
	# _tmp462 = this + _tmp461
	add $s1, $t2, $s0	
	# *(_tmp462) = _tmp460
	sw $t7, 0($s1) 	# store with offset
	# _tmp463 = "Dealer"
	.data			# create string constant marked with label
	_string39: .asciiz "Dealer"
	.text
	la $s2, _string39	# load label
	# _tmp464 = 16
	li $s3, 16		# load constant value 16 into $s3
	# _tmp465 = this + _tmp464
	add $s4, $t2, $s3	
	# *(_tmp465) = _tmp463
	sw $s2, 0($s4) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Dealer.TakeTurn:
	# BeginFunc 84
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 84	# decrement sp to make space for locals/temps
	# _tmp466 = "\n"
	.data			# create string constant marked with label
	_string40: .asciiz "\n"
	.text
	la $t0, _string40	# load label
	# PushParam _tmp466
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp466 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp467 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp467
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp467 from $t1 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp468 = "'s turn.\n"
	.data			# create string constant marked with label
	_string41: .asciiz "'s turn.\n"
	.text
	la $t0, _string41	# load label
	# PushParam _tmp468
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp468 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L72:
	# _tmp469 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp470 = 16
	li $t2, 16		# load constant value 16 into $t2
	# _tmp471 = _tmp469 < _tmp470
	slt $t3, $t1, $t2	
	# _tmp472 = _tmp469 == _tmp470
	seq $t4, $t1, $t2	
	# _tmp473 = _tmp471 || _tmp472
	or $t5, $t3, $t4	
	# IfZ _tmp473 Goto _L73
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp469 from $t1 to $fp-20
	sw $t2, -24($fp)	# spill _tmp470 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp471 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp472 from $t4 to $fp-32
	sw $t5, -36($fp)	# spill _tmp473 from $t5 to $fp-36
	beqz $t5, _L73	# branch if _tmp473 is zero 
	# _tmp474 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp475 = *(_tmp474 + 12)
	lw $t2, 12($t1) 	# load with offset
	# PushParam deck
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 8($fp)	# load deck from $fp+8 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp475
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp474 from $t1 to $fp-40
	sw $t2, -44($fp)	# spill _tmp475 from $t2 to $fp-44
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L72
	b _L72		# unconditional branch
_L73:
	# _tmp476 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp477 = 21
	li $t2, 21		# load constant value 21 into $t2
	# _tmp478 = _tmp477 < _tmp476
	slt $t3, $t2, $t1	
	# IfZ _tmp478 Goto _L74
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp476 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp477 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp478 from $t3 to $fp-56
	beqz $t3, _L74	# branch if _tmp478 is zero 
	# _tmp479 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp479
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -60($fp)	# spill _tmp479 from $t1 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp480 = " busts with the big "
	.data			# create string constant marked with label
	_string42: .asciiz " busts with the big "
	.text
	la $t0, _string42	# load label
	# PushParam _tmp480
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp480 from $t0 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp481 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# PushParam _tmp481
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -68($fp)	# spill _tmp481 from $t1 to $fp-68
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp482 = "!\n"
	.data			# create string constant marked with label
	_string43: .asciiz "!\n"
	.text
	la $t0, _string43	# load label
	# PushParam _tmp482
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp482 from $t0 to $fp-72
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L75
	b _L75		# unconditional branch
_L74:
	# _tmp483 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp483
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -76($fp)	# spill _tmp483 from $t1 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp484 = " stays at "
	.data			# create string constant marked with label
	_string44: .asciiz " stays at "
	.text
	la $t0, _string44	# load label
	# PushParam _tmp484
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp484 from $t0 to $fp-80
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp485 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# PushParam _tmp485
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -84($fp)	# spill _tmp485 from $t1 to $fp-84
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp486 = ".\n"
	.data			# create string constant marked with label
	_string45: .asciiz ".\n"
	.text
	la $t0, _string45	# load label
	# PushParam _tmp486
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp486 from $t0 to $fp-88
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L75:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Dealer
	.data
	.align 2
	Dealer:		# label for class Dealer vtable
	.word __Player.DoubleDown
	.word __Player.GetTotal
	.word __Player.HasMoney
	.word __Player.Hit
	.word __Dealer.Init
	.word __Player.PlaceBet
	.word __Player.PrintMoney
	.word __Player.Resolve
	.word __Dealer.TakeTurn
	.text
__House.SetupGame:
	# BeginFunc 100
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 100	# decrement sp to make space for locals/temps
	# _tmp487 = "\nWelcome to CS143 BlackJack!\n"
	.data			# create string constant marked with label
	_string46: .asciiz "\nWelcome to CS143 BlackJack!\n"
	.text
	la $t0, _string46	# load label
	# PushParam _tmp487
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp487 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp488 = "---------------------------\n"
	.data			# create string constant marked with label
	_string47: .asciiz "---------------------------\n"
	.text
	la $t0, _string47	# load label
	# PushParam _tmp488
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp488 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp489 = 8
	li $t0, 8		# load constant value 8 into $t0
	# PushParam _tmp489
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp490 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp489 from $t0 to $fp-16
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp491 = Random
	la $t1, Random	# load label
	# *(_tmp490) = _tmp491
	sw $t1, 0($t0) 	# store with offset
	# gRnd = _tmp490
	move $t2, $t0		# copy value
	# _tmp492 = "Please enter a random number seed: "
	.data			# create string constant marked with label
	_string48: .asciiz "Please enter a random number seed: "
	.text
	la $t3, _string48	# load label
	# PushParam _tmp492
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp490 from $t0 to $fp-20
	sw $t1, -24($fp)	# spill _tmp491 from $t1 to $fp-24
	sw $t2, 4($gp)	# spill gRnd from $t2 to $gp+4
	sw $t3, -28($fp)	# spill _tmp492 from $t3 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp493 = *(gRnd)
	lw $t0, 4($gp)	# load gRnd from $gp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp494 = *(_tmp493 + 4)
	lw $t2, 4($t1) 	# load with offset
	# _tmp495 = LCall _ReadInteger
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp493 from $t1 to $fp-32
	sw $t2, -36($fp)	# spill _tmp494 from $t2 to $fp-36
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PushParam _tmp495
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, 4($gp)	# load gRnd from $gp+4 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp494
	lw $t2, -36($fp)	# load _tmp494 from $fp-36 into $t2
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp495 from $t0 to $fp-40
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp496 = 12
	li $t0, 12		# load constant value 12 into $t0
	# PushParam _tmp496
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp497 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp496 from $t0 to $fp-44
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp498 = BJDeck
	la $t1, BJDeck	# load label
	# *(_tmp497) = _tmp498
	sw $t1, 0($t0) 	# store with offset
	# _tmp499 = 8
	li $t2, 8		# load constant value 8 into $t2
	# _tmp500 = this + _tmp499
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp500) = _tmp497
	sw $t0, 0($t4) 	# store with offset
	# _tmp501 = 28
	li $t5, 28		# load constant value 28 into $t5
	# PushParam _tmp501
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# _tmp502 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp497 from $t0 to $fp-48
	sw $t1, -52($fp)	# spill _tmp498 from $t1 to $fp-52
	sw $t2, -56($fp)	# spill _tmp499 from $t2 to $fp-56
	sw $t4, -60($fp)	# spill _tmp500 from $t4 to $fp-60
	sw $t5, -64($fp)	# spill _tmp501 from $t5 to $fp-64
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp503 = Dealer
	la $t1, Dealer	# load label
	# *(_tmp502) = _tmp503
	sw $t1, 0($t0) 	# store with offset
	# _tmp504 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp505 = this + _tmp504
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp505) = _tmp502
	sw $t0, 0($t4) 	# store with offset
	# _tmp506 = *(this + 8)
	lw $t5, 8($t3) 	# load with offset
	# _tmp507 = *(_tmp506)
	lw $t6, 0($t5) 	# load with offset
	# _tmp508 = *(_tmp507 + 4)
	lw $t7, 4($t6) 	# load with offset
	# PushParam _tmp506
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# ACall _tmp508
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp502 from $t0 to $fp-68
	sw $t1, -72($fp)	# spill _tmp503 from $t1 to $fp-72
	sw $t2, -76($fp)	# spill _tmp504 from $t2 to $fp-76
	sw $t4, -80($fp)	# spill _tmp505 from $t4 to $fp-80
	sw $t5, -84($fp)	# spill _tmp506 from $t5 to $fp-84
	sw $t6, -88($fp)	# spill _tmp507 from $t6 to $fp-88
	sw $t7, -92($fp)	# spill _tmp508 from $t7 to $fp-92
	jalr $t7            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp509 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp510 = *(_tmp509)
	lw $t2, 0($t1) 	# load with offset
	# _tmp511 = *(_tmp510 + 12)
	lw $t3, 12($t2) 	# load with offset
	# PushParam _tmp509
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp511
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp509 from $t1 to $fp-96
	sw $t2, -100($fp)	# spill _tmp510 from $t2 to $fp-100
	sw $t3, -104($fp)	# spill _tmp511 from $t3 to $fp-104
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__House.SetupPlayers:
	# BeginFunc 196
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 196	# decrement sp to make space for locals/temps
	# _tmp512 = "How many players do we have today? "
	.data			# create string constant marked with label
	_string49: .asciiz "How many players do we have today? "
	.text
	la $t0, _string49	# load label
	# PushParam _tmp512
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp512 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp513 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# numPlayers = _tmp513
	move $t1, $t0		# copy value
	# _tmp514 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp515 = numPlayers < _tmp514
	slt $t3, $t1, $t2	
	# _tmp516 = numPlayers == _tmp514
	seq $t4, $t1, $t2	
	# _tmp517 = _tmp515 || _tmp516
	or $t5, $t3, $t4	
	# IfZ _tmp517 Goto _L76
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp513 from $t0 to $fp-20
	sw $t1, -12($fp)	# spill numPlayers from $t1 to $fp-12
	sw $t2, -24($fp)	# spill _tmp514 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp515 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp516 from $t4 to $fp-32
	sw $t5, -36($fp)	# spill _tmp517 from $t5 to $fp-36
	beqz $t5, _L76	# branch if _tmp517 is zero 
	# _tmp518 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string50: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string50	# load label
	# PushParam _tmp518
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp518 from $t0 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L76:
	# _tmp519 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp520 = numPlayers * _tmp519
	lw $t1, -12($fp)	# load numPlayers from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp521 = _tmp520 + _tmp519
	add $t3, $t2, $t0	
	# PushParam _tmp521
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp522 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp519 from $t0 to $fp-44
	sw $t2, -48($fp)	# spill _tmp520 from $t2 to $fp-48
	sw $t3, -52($fp)	# spill _tmp521 from $t3 to $fp-52
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp522) = numPlayers
	lw $t1, -12($fp)	# load numPlayers from $fp-12 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp523 = 12
	li $t2, 12		# load constant value 12 into $t2
	# _tmp524 = this + _tmp523
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp524) = _tmp522
	sw $t0, 0($t4) 	# store with offset
	# _tmp525 = 0
	li $t5, 0		# load constant value 0 into $t5
	# i = _tmp525
	move $t6, $t5		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp522 from $t0 to $fp-56
	sw $t2, -60($fp)	# spill _tmp523 from $t2 to $fp-60
	sw $t4, -64($fp)	# spill _tmp524 from $t4 to $fp-64
	sw $t5, -68($fp)	# spill _tmp525 from $t5 to $fp-68
	sw $t6, -8($fp)	# spill i from $t6 to $fp-8
_L77:
	# _tmp526 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp527 = *(_tmp526)
	lw $t2, 0($t1) 	# load with offset
	# _tmp528 = i < _tmp527
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# IfZ _tmp528 Goto _L78
	# (save modified registers before flow of control change)
	sw $t1, -76($fp)	# spill _tmp526 from $t1 to $fp-76
	sw $t2, -72($fp)	# spill _tmp527 from $t2 to $fp-72
	sw $t4, -80($fp)	# spill _tmp528 from $t4 to $fp-80
	beqz $t4, _L78	# branch if _tmp528 is zero 
	# _tmp529 = 28
	li $t0, 28		# load constant value 28 into $t0
	# PushParam _tmp529
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp530 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp529 from $t0 to $fp-84
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp531 = Player
	la $t1, Player	# load label
	# *(_tmp530) = _tmp531
	sw $t1, 0($t0) 	# store with offset
	# _tmp532 = *(this + 12)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 12($t2) 	# load with offset
	# _tmp533 = *(_tmp532)
	lw $t4, 0($t3) 	# load with offset
	# _tmp534 = i < _tmp533
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp535 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp536 = _tmp535 < i
	slt $s0, $t7, $t5	
	# _tmp537 = _tmp536 && _tmp534
	and $s1, $s0, $t6	
	# IfZ _tmp537 Goto _L79
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp530 from $t0 to $fp-88
	sw $t1, -92($fp)	# spill _tmp531 from $t1 to $fp-92
	sw $t3, -96($fp)	# spill _tmp532 from $t3 to $fp-96
	sw $t4, -100($fp)	# spill _tmp533 from $t4 to $fp-100
	sw $t6, -104($fp)	# spill _tmp534 from $t6 to $fp-104
	sw $t7, -108($fp)	# spill _tmp535 from $t7 to $fp-108
	sw $s0, -112($fp)	# spill _tmp536 from $s0 to $fp-112
	sw $s1, -116($fp)	# spill _tmp537 from $s1 to $fp-116
	beqz $s1, _L79	# branch if _tmp537 is zero 
	# _tmp538 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp539 = i * _tmp538
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp540 = _tmp539 + _tmp538
	add $t3, $t2, $t0	
	# _tmp541 = _tmp532 + _tmp540
	lw $t4, -96($fp)	# load _tmp532 from $fp-96 into $t4
	add $t5, $t4, $t3	
	# Goto _L80
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp538 from $t0 to $fp-120
	sw $t2, -124($fp)	# spill _tmp539 from $t2 to $fp-124
	sw $t3, -128($fp)	# spill _tmp540 from $t3 to $fp-128
	sw $t5, -128($fp)	# spill _tmp541 from $t5 to $fp-128
	b _L80		# unconditional branch
_L79:
	# _tmp542 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string51: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string51	# load label
	# PushParam _tmp542
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp542 from $t0 to $fp-132
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L80:
	# *(_tmp541) = _tmp530
	lw $t0, -88($fp)	# load _tmp530 from $fp-88 into $t0
	lw $t1, -128($fp)	# load _tmp541 from $fp-128 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp543 = *(this + 12)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 12($t2) 	# load with offset
	# _tmp544 = *(_tmp543)
	lw $t4, 0($t3) 	# load with offset
	# _tmp545 = i < _tmp544
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp546 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp547 = _tmp546 < i
	slt $s0, $t7, $t5	
	# _tmp548 = _tmp547 && _tmp545
	and $s1, $s0, $t6	
	# IfZ _tmp548 Goto _L81
	# (save modified registers before flow of control change)
	sw $t3, -136($fp)	# spill _tmp543 from $t3 to $fp-136
	sw $t4, -140($fp)	# spill _tmp544 from $t4 to $fp-140
	sw $t6, -144($fp)	# spill _tmp545 from $t6 to $fp-144
	sw $t7, -148($fp)	# spill _tmp546 from $t7 to $fp-148
	sw $s0, -152($fp)	# spill _tmp547 from $s0 to $fp-152
	sw $s1, -156($fp)	# spill _tmp548 from $s1 to $fp-156
	beqz $s1, _L81	# branch if _tmp548 is zero 
	# _tmp549 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp550 = i * _tmp549
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp551 = _tmp550 + _tmp549
	add $t3, $t2, $t0	
	# _tmp552 = _tmp543 + _tmp551
	lw $t4, -136($fp)	# load _tmp543 from $fp-136 into $t4
	add $t5, $t4, $t3	
	# Goto _L82
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp549 from $t0 to $fp-160
	sw $t2, -164($fp)	# spill _tmp550 from $t2 to $fp-164
	sw $t3, -168($fp)	# spill _tmp551 from $t3 to $fp-168
	sw $t5, -168($fp)	# spill _tmp552 from $t5 to $fp-168
	b _L82		# unconditional branch
_L81:
	# _tmp553 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string52: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string52	# load label
	# PushParam _tmp553
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp553 from $t0 to $fp-172
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L82:
	# _tmp554 = *(_tmp552)
	lw $t0, -168($fp)	# load _tmp552 from $fp-168 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp555 = *(_tmp554)
	lw $t2, 0($t1) 	# load with offset
	# _tmp556 = *(_tmp555 + 16)
	lw $t3, 16($t2) 	# load with offset
	# _tmp557 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp558 = i + _tmp557
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	add $t6, $t5, $t4	
	# PushParam _tmp558
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam _tmp554
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp556
	# (save modified registers before flow of control change)
	sw $t1, -176($fp)	# spill _tmp554 from $t1 to $fp-176
	sw $t2, -180($fp)	# spill _tmp555 from $t2 to $fp-180
	sw $t3, -184($fp)	# spill _tmp556 from $t3 to $fp-184
	sw $t4, -192($fp)	# spill _tmp557 from $t4 to $fp-192
	sw $t6, -188($fp)	# spill _tmp558 from $t6 to $fp-188
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp559 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp560 = i + _tmp559
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp560
	move $t1, $t2		# copy value
	# Goto _L77
	# (save modified registers before flow of control change)
	sw $t0, -200($fp)	# spill _tmp559 from $t0 to $fp-200
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -196($fp)	# spill _tmp560 from $t2 to $fp-196
	b _L77		# unconditional branch
_L78:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__House.TakeAllBets:
	# BeginFunc 140
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 140	# decrement sp to make space for locals/temps
	# _tmp561 = "\nFirst, let's take bets.\n"
	.data			# create string constant marked with label
	_string53: .asciiz "\nFirst, let's take bets.\n"
	.text
	la $t0, _string53	# load label
	# PushParam _tmp561
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp561 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp562 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp562
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp562 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L83:
	# _tmp563 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp564 = *(_tmp563)
	lw $t2, 0($t1) 	# load with offset
	# _tmp565 = i < _tmp564
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# IfZ _tmp565 Goto _L84
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp563 from $t1 to $fp-24
	sw $t2, -20($fp)	# spill _tmp564 from $t2 to $fp-20
	sw $t4, -28($fp)	# spill _tmp565 from $t4 to $fp-28
	beqz $t4, _L84	# branch if _tmp565 is zero 
	# _tmp566 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp567 = *(_tmp566)
	lw $t2, 0($t1) 	# load with offset
	# _tmp568 = i < _tmp567
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp569 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp570 = _tmp569 < i
	slt $t6, $t5, $t3	
	# _tmp571 = _tmp570 && _tmp568
	and $t7, $t6, $t4	
	# IfZ _tmp571 Goto _L87
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp566 from $t1 to $fp-32
	sw $t2, -36($fp)	# spill _tmp567 from $t2 to $fp-36
	sw $t4, -40($fp)	# spill _tmp568 from $t4 to $fp-40
	sw $t5, -44($fp)	# spill _tmp569 from $t5 to $fp-44
	sw $t6, -48($fp)	# spill _tmp570 from $t6 to $fp-48
	sw $t7, -52($fp)	# spill _tmp571 from $t7 to $fp-52
	beqz $t7, _L87	# branch if _tmp571 is zero 
	# _tmp572 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp573 = i * _tmp572
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp574 = _tmp573 + _tmp572
	add $t3, $t2, $t0	
	# _tmp575 = _tmp566 + _tmp574
	lw $t4, -32($fp)	# load _tmp566 from $fp-32 into $t4
	add $t5, $t4, $t3	
	# Goto _L88
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp572 from $t0 to $fp-56
	sw $t2, -60($fp)	# spill _tmp573 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp574 from $t3 to $fp-64
	sw $t5, -64($fp)	# spill _tmp575 from $t5 to $fp-64
	b _L88		# unconditional branch
_L87:
	# _tmp576 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string54: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string54	# load label
	# PushParam _tmp576
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp576 from $t0 to $fp-68
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L88:
	# _tmp577 = *(_tmp575)
	lw $t0, -64($fp)	# load _tmp575 from $fp-64 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp578 = *(_tmp577)
	lw $t2, 0($t1) 	# load with offset
	# _tmp579 = *(_tmp578 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp577
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp580 = ACall _tmp579
	# (save modified registers before flow of control change)
	sw $t1, -72($fp)	# spill _tmp577 from $t1 to $fp-72
	sw $t2, -76($fp)	# spill _tmp578 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp579 from $t3 to $fp-80
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp580 Goto _L85
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp580 from $t0 to $fp-84
	beqz $t0, _L85	# branch if _tmp580 is zero 
	# _tmp581 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp582 = *(_tmp581)
	lw $t2, 0($t1) 	# load with offset
	# _tmp583 = i < _tmp582
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp584 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp585 = _tmp584 < i
	slt $t6, $t5, $t3	
	# _tmp586 = _tmp585 && _tmp583
	and $t7, $t6, $t4	
	# IfZ _tmp586 Goto _L89
	# (save modified registers before flow of control change)
	sw $t1, -88($fp)	# spill _tmp581 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp582 from $t2 to $fp-92
	sw $t4, -96($fp)	# spill _tmp583 from $t4 to $fp-96
	sw $t5, -100($fp)	# spill _tmp584 from $t5 to $fp-100
	sw $t6, -104($fp)	# spill _tmp585 from $t6 to $fp-104
	sw $t7, -108($fp)	# spill _tmp586 from $t7 to $fp-108
	beqz $t7, _L89	# branch if _tmp586 is zero 
	# _tmp587 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp588 = i * _tmp587
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp589 = _tmp588 + _tmp587
	add $t3, $t2, $t0	
	# _tmp590 = _tmp581 + _tmp589
	lw $t4, -88($fp)	# load _tmp581 from $fp-88 into $t4
	add $t5, $t4, $t3	
	# Goto _L90
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp587 from $t0 to $fp-112
	sw $t2, -116($fp)	# spill _tmp588 from $t2 to $fp-116
	sw $t3, -120($fp)	# spill _tmp589 from $t3 to $fp-120
	sw $t5, -120($fp)	# spill _tmp590 from $t5 to $fp-120
	b _L90		# unconditional branch
_L89:
	# _tmp591 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string55: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string55	# load label
	# PushParam _tmp591
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp591 from $t0 to $fp-124
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L90:
	# _tmp592 = *(_tmp590)
	lw $t0, -120($fp)	# load _tmp590 from $fp-120 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp593 = *(_tmp592)
	lw $t2, 0($t1) 	# load with offset
	# _tmp594 = *(_tmp593 + 20)
	lw $t3, 20($t2) 	# load with offset
	# PushParam _tmp592
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp594
	# (save modified registers before flow of control change)
	sw $t1, -128($fp)	# spill _tmp592 from $t1 to $fp-128
	sw $t2, -132($fp)	# spill _tmp593 from $t2 to $fp-132
	sw $t3, -136($fp)	# spill _tmp594 from $t3 to $fp-136
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L86
	b _L86		# unconditional branch
_L85:
_L86:
	# _tmp595 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp596 = i + _tmp595
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp596
	move $t1, $t2		# copy value
	# Goto _L83
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp595 from $t0 to $fp-144
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -140($fp)	# spill _tmp596 from $t2 to $fp-140
	b _L83		# unconditional branch
_L84:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__House.TakeAllTurns:
	# BeginFunc 140
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 140	# decrement sp to make space for locals/temps
	# _tmp597 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp597
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp597 from $t0 to $fp-12
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L91:
	# _tmp598 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp599 = *(_tmp598)
	lw $t2, 0($t1) 	# load with offset
	# _tmp600 = i < _tmp599
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# IfZ _tmp600 Goto _L92
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp598 from $t1 to $fp-20
	sw $t2, -16($fp)	# spill _tmp599 from $t2 to $fp-16
	sw $t4, -24($fp)	# spill _tmp600 from $t4 to $fp-24
	beqz $t4, _L92	# branch if _tmp600 is zero 
	# _tmp601 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp602 = *(_tmp601)
	lw $t2, 0($t1) 	# load with offset
	# _tmp603 = i < _tmp602
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp604 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp605 = _tmp604 < i
	slt $t6, $t5, $t3	
	# _tmp606 = _tmp605 && _tmp603
	and $t7, $t6, $t4	
	# IfZ _tmp606 Goto _L95
	# (save modified registers before flow of control change)
	sw $t1, -28($fp)	# spill _tmp601 from $t1 to $fp-28
	sw $t2, -32($fp)	# spill _tmp602 from $t2 to $fp-32
	sw $t4, -36($fp)	# spill _tmp603 from $t4 to $fp-36
	sw $t5, -40($fp)	# spill _tmp604 from $t5 to $fp-40
	sw $t6, -44($fp)	# spill _tmp605 from $t6 to $fp-44
	sw $t7, -48($fp)	# spill _tmp606 from $t7 to $fp-48
	beqz $t7, _L95	# branch if _tmp606 is zero 
	# _tmp607 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp608 = i * _tmp607
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp609 = _tmp608 + _tmp607
	add $t3, $t2, $t0	
	# _tmp610 = _tmp601 + _tmp609
	lw $t4, -28($fp)	# load _tmp601 from $fp-28 into $t4
	add $t5, $t4, $t3	
	# Goto _L96
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp607 from $t0 to $fp-52
	sw $t2, -56($fp)	# spill _tmp608 from $t2 to $fp-56
	sw $t3, -60($fp)	# spill _tmp609 from $t3 to $fp-60
	sw $t5, -60($fp)	# spill _tmp610 from $t5 to $fp-60
	b _L96		# unconditional branch
_L95:
	# _tmp611 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string56: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string56	# load label
	# PushParam _tmp611
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp611 from $t0 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L96:
	# _tmp612 = *(_tmp610)
	lw $t0, -60($fp)	# load _tmp610 from $fp-60 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp613 = *(_tmp612)
	lw $t2, 0($t1) 	# load with offset
	# _tmp614 = *(_tmp613 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp612
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp615 = ACall _tmp614
	# (save modified registers before flow of control change)
	sw $t1, -68($fp)	# spill _tmp612 from $t1 to $fp-68
	sw $t2, -72($fp)	# spill _tmp613 from $t2 to $fp-72
	sw $t3, -76($fp)	# spill _tmp614 from $t3 to $fp-76
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp615 Goto _L93
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp615 from $t0 to $fp-80
	beqz $t0, _L93	# branch if _tmp615 is zero 
	# _tmp616 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp617 = *(_tmp616)
	lw $t2, 0($t1) 	# load with offset
	# _tmp618 = i < _tmp617
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp619 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp620 = _tmp619 < i
	slt $t6, $t5, $t3	
	# _tmp621 = _tmp620 && _tmp618
	and $t7, $t6, $t4	
	# IfZ _tmp621 Goto _L97
	# (save modified registers before flow of control change)
	sw $t1, -84($fp)	# spill _tmp616 from $t1 to $fp-84
	sw $t2, -88($fp)	# spill _tmp617 from $t2 to $fp-88
	sw $t4, -92($fp)	# spill _tmp618 from $t4 to $fp-92
	sw $t5, -96($fp)	# spill _tmp619 from $t5 to $fp-96
	sw $t6, -100($fp)	# spill _tmp620 from $t6 to $fp-100
	sw $t7, -104($fp)	# spill _tmp621 from $t7 to $fp-104
	beqz $t7, _L97	# branch if _tmp621 is zero 
	# _tmp622 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp623 = i * _tmp622
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp624 = _tmp623 + _tmp622
	add $t3, $t2, $t0	
	# _tmp625 = _tmp616 + _tmp624
	lw $t4, -84($fp)	# load _tmp616 from $fp-84 into $t4
	add $t5, $t4, $t3	
	# Goto _L98
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp622 from $t0 to $fp-108
	sw $t2, -112($fp)	# spill _tmp623 from $t2 to $fp-112
	sw $t3, -116($fp)	# spill _tmp624 from $t3 to $fp-116
	sw $t5, -116($fp)	# spill _tmp625 from $t5 to $fp-116
	b _L98		# unconditional branch
_L97:
	# _tmp626 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string57: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string57	# load label
	# PushParam _tmp626
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp626 from $t0 to $fp-120
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L98:
	# _tmp627 = *(_tmp625)
	lw $t0, -116($fp)	# load _tmp625 from $fp-116 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp628 = *(_tmp627)
	lw $t2, 0($t1) 	# load with offset
	# _tmp629 = *(_tmp628 + 32)
	lw $t3, 32($t2) 	# load with offset
	# _tmp630 = *(this + 8)
	lw $t4, 4($fp)	# load this from $fp+4 into $t4
	lw $t5, 8($t4) 	# load with offset
	# PushParam _tmp630
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam _tmp627
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp629
	# (save modified registers before flow of control change)
	sw $t1, -124($fp)	# spill _tmp627 from $t1 to $fp-124
	sw $t2, -128($fp)	# spill _tmp628 from $t2 to $fp-128
	sw $t3, -132($fp)	# spill _tmp629 from $t3 to $fp-132
	sw $t5, -136($fp)	# spill _tmp630 from $t5 to $fp-136
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L94
	b _L94		# unconditional branch
_L93:
_L94:
	# _tmp631 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp632 = i + _tmp631
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp632
	move $t1, $t2		# copy value
	# Goto _L91
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp631 from $t0 to $fp-144
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -140($fp)	# spill _tmp632 from $t2 to $fp-140
	b _L91		# unconditional branch
_L92:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__House.ResolveAllPlayers:
	# BeginFunc 156
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 156	# decrement sp to make space for locals/temps
	# _tmp633 = "\nTime to resolve bets.\n"
	.data			# create string constant marked with label
	_string58: .asciiz "\nTime to resolve bets.\n"
	.text
	la $t0, _string58	# load label
	# PushParam _tmp633
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp633 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp634 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp634
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp634 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L99:
	# _tmp635 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp636 = *(_tmp635)
	lw $t2, 0($t1) 	# load with offset
	# _tmp637 = i < _tmp636
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# IfZ _tmp637 Goto _L100
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp635 from $t1 to $fp-24
	sw $t2, -20($fp)	# spill _tmp636 from $t2 to $fp-20
	sw $t4, -28($fp)	# spill _tmp637 from $t4 to $fp-28
	beqz $t4, _L100	# branch if _tmp637 is zero 
	# _tmp638 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp639 = *(_tmp638)
	lw $t2, 0($t1) 	# load with offset
	# _tmp640 = i < _tmp639
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp641 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp642 = _tmp641 < i
	slt $t6, $t5, $t3	
	# _tmp643 = _tmp642 && _tmp640
	and $t7, $t6, $t4	
	# IfZ _tmp643 Goto _L103
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp638 from $t1 to $fp-32
	sw $t2, -36($fp)	# spill _tmp639 from $t2 to $fp-36
	sw $t4, -40($fp)	# spill _tmp640 from $t4 to $fp-40
	sw $t5, -44($fp)	# spill _tmp641 from $t5 to $fp-44
	sw $t6, -48($fp)	# spill _tmp642 from $t6 to $fp-48
	sw $t7, -52($fp)	# spill _tmp643 from $t7 to $fp-52
	beqz $t7, _L103	# branch if _tmp643 is zero 
	# _tmp644 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp645 = i * _tmp644
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp646 = _tmp645 + _tmp644
	add $t3, $t2, $t0	
	# _tmp647 = _tmp638 + _tmp646
	lw $t4, -32($fp)	# load _tmp638 from $fp-32 into $t4
	add $t5, $t4, $t3	
	# Goto _L104
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp644 from $t0 to $fp-56
	sw $t2, -60($fp)	# spill _tmp645 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp646 from $t3 to $fp-64
	sw $t5, -64($fp)	# spill _tmp647 from $t5 to $fp-64
	b _L104		# unconditional branch
_L103:
	# _tmp648 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string59: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string59	# load label
	# PushParam _tmp648
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp648 from $t0 to $fp-68
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L104:
	# _tmp649 = *(_tmp647)
	lw $t0, -64($fp)	# load _tmp647 from $fp-64 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp650 = *(_tmp649)
	lw $t2, 0($t1) 	# load with offset
	# _tmp651 = *(_tmp650 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp649
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp652 = ACall _tmp651
	# (save modified registers before flow of control change)
	sw $t1, -72($fp)	# spill _tmp649 from $t1 to $fp-72
	sw $t2, -76($fp)	# spill _tmp650 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp651 from $t3 to $fp-80
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp652 Goto _L101
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp652 from $t0 to $fp-84
	beqz $t0, _L101	# branch if _tmp652 is zero 
	# _tmp653 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp654 = *(_tmp653)
	lw $t2, 0($t1) 	# load with offset
	# _tmp655 = i < _tmp654
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp656 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp657 = _tmp656 < i
	slt $t6, $t5, $t3	
	# _tmp658 = _tmp657 && _tmp655
	and $t7, $t6, $t4	
	# IfZ _tmp658 Goto _L105
	# (save modified registers before flow of control change)
	sw $t1, -88($fp)	# spill _tmp653 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp654 from $t2 to $fp-92
	sw $t4, -96($fp)	# spill _tmp655 from $t4 to $fp-96
	sw $t5, -100($fp)	# spill _tmp656 from $t5 to $fp-100
	sw $t6, -104($fp)	# spill _tmp657 from $t6 to $fp-104
	sw $t7, -108($fp)	# spill _tmp658 from $t7 to $fp-108
	beqz $t7, _L105	# branch if _tmp658 is zero 
	# _tmp659 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp660 = i * _tmp659
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp661 = _tmp660 + _tmp659
	add $t3, $t2, $t0	
	# _tmp662 = _tmp653 + _tmp661
	lw $t4, -88($fp)	# load _tmp653 from $fp-88 into $t4
	add $t5, $t4, $t3	
	# Goto _L106
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp659 from $t0 to $fp-112
	sw $t2, -116($fp)	# spill _tmp660 from $t2 to $fp-116
	sw $t3, -120($fp)	# spill _tmp661 from $t3 to $fp-120
	sw $t5, -120($fp)	# spill _tmp662 from $t5 to $fp-120
	b _L106		# unconditional branch
_L105:
	# _tmp663 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string60: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string60	# load label
	# PushParam _tmp663
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp663 from $t0 to $fp-124
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L106:
	# _tmp664 = *(_tmp662)
	lw $t0, -120($fp)	# load _tmp662 from $fp-120 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp665 = *(_tmp664)
	lw $t2, 0($t1) 	# load with offset
	# _tmp666 = *(_tmp665 + 28)
	lw $t3, 28($t2) 	# load with offset
	# _tmp667 = *(this + 4)
	lw $t4, 4($fp)	# load this from $fp+4 into $t4
	lw $t5, 4($t4) 	# load with offset
	# _tmp668 = *(_tmp667)
	lw $t6, 0($t5) 	# load with offset
	# _tmp669 = *(_tmp668 + 4)
	lw $t7, 4($t6) 	# load with offset
	# PushParam _tmp667
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# _tmp670 = ACall _tmp669
	# (save modified registers before flow of control change)
	sw $t1, -128($fp)	# spill _tmp664 from $t1 to $fp-128
	sw $t2, -132($fp)	# spill _tmp665 from $t2 to $fp-132
	sw $t3, -136($fp)	# spill _tmp666 from $t3 to $fp-136
	sw $t5, -140($fp)	# spill _tmp667 from $t5 to $fp-140
	sw $t6, -144($fp)	# spill _tmp668 from $t6 to $fp-144
	sw $t7, -148($fp)	# spill _tmp669 from $t7 to $fp-148
	jalr $t7            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp670
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp664
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -128($fp)	# load _tmp664 from $fp-128 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp666
	lw $t2, -136($fp)	# load _tmp666 from $fp-136 into $t2
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp670 from $t0 to $fp-152
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L102
	b _L102		# unconditional branch
_L101:
_L102:
	# _tmp671 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp672 = i + _tmp671
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp672
	move $t1, $t2		# copy value
	# Goto _L99
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp671 from $t0 to $fp-160
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -156($fp)	# spill _tmp672 from $t2 to $fp-156
	b _L99		# unconditional branch
_L100:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__House.PrintAllMoney:
	# BeginFunc 80
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 80	# decrement sp to make space for locals/temps
	# _tmp673 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp673
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp673 from $t0 to $fp-12
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L107:
	# _tmp674 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp675 = *(_tmp674)
	lw $t2, 0($t1) 	# load with offset
	# _tmp676 = i < _tmp675
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# IfZ _tmp676 Goto _L108
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp674 from $t1 to $fp-20
	sw $t2, -16($fp)	# spill _tmp675 from $t2 to $fp-16
	sw $t4, -24($fp)	# spill _tmp676 from $t4 to $fp-24
	beqz $t4, _L108	# branch if _tmp676 is zero 
	# _tmp677 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp678 = *(_tmp677)
	lw $t2, 0($t1) 	# load with offset
	# _tmp679 = i < _tmp678
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp680 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp681 = _tmp680 < i
	slt $t6, $t5, $t3	
	# _tmp682 = _tmp681 && _tmp679
	and $t7, $t6, $t4	
	# IfZ _tmp682 Goto _L109
	# (save modified registers before flow of control change)
	sw $t1, -28($fp)	# spill _tmp677 from $t1 to $fp-28
	sw $t2, -32($fp)	# spill _tmp678 from $t2 to $fp-32
	sw $t4, -36($fp)	# spill _tmp679 from $t4 to $fp-36
	sw $t5, -40($fp)	# spill _tmp680 from $t5 to $fp-40
	sw $t6, -44($fp)	# spill _tmp681 from $t6 to $fp-44
	sw $t7, -48($fp)	# spill _tmp682 from $t7 to $fp-48
	beqz $t7, _L109	# branch if _tmp682 is zero 
	# _tmp683 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp684 = i * _tmp683
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp685 = _tmp684 + _tmp683
	add $t3, $t2, $t0	
	# _tmp686 = _tmp677 + _tmp685
	lw $t4, -28($fp)	# load _tmp677 from $fp-28 into $t4
	add $t5, $t4, $t3	
	# Goto _L110
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp683 from $t0 to $fp-52
	sw $t2, -56($fp)	# spill _tmp684 from $t2 to $fp-56
	sw $t3, -60($fp)	# spill _tmp685 from $t3 to $fp-60
	sw $t5, -60($fp)	# spill _tmp686 from $t5 to $fp-60
	b _L110		# unconditional branch
_L109:
	# _tmp687 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string61: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string61	# load label
	# PushParam _tmp687
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp687 from $t0 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L110:
	# _tmp688 = *(_tmp686)
	lw $t0, -60($fp)	# load _tmp686 from $fp-60 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp689 = *(_tmp688)
	lw $t2, 0($t1) 	# load with offset
	# _tmp690 = *(_tmp689 + 24)
	lw $t3, 24($t2) 	# load with offset
	# PushParam _tmp688
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp690
	# (save modified registers before flow of control change)
	sw $t1, -68($fp)	# spill _tmp688 from $t1 to $fp-68
	sw $t2, -72($fp)	# spill _tmp689 from $t2 to $fp-72
	sw $t3, -76($fp)	# spill _tmp690 from $t3 to $fp-76
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp691 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp692 = i + _tmp691
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp692
	move $t1, $t2		# copy value
	# Goto _L107
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp691 from $t0 to $fp-84
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -80($fp)	# spill _tmp692 from $t2 to $fp-80
	b _L107		# unconditional branch
_L108:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__House.PlayOneGame:
	# BeginFunc 112
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 112	# decrement sp to make space for locals/temps
	# _tmp693 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp694 = *(_tmp693)
	lw $t2, 0($t1) 	# load with offset
	# _tmp695 = *(_tmp694 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp693
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp696 = ACall _tmp695
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp693 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp694 from $t2 to $fp-12
	sw $t3, -16($fp)	# spill _tmp695 from $t3 to $fp-16
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp697 = 26
	li $t1, 26		# load constant value 26 into $t1
	# _tmp698 = _tmp696 < _tmp697
	slt $t2, $t0, $t1	
	# IfZ _tmp698 Goto _L111
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp696 from $t0 to $fp-20
	sw $t1, -24($fp)	# spill _tmp697 from $t1 to $fp-24
	sw $t2, -28($fp)	# spill _tmp698 from $t2 to $fp-28
	beqz $t2, _L111	# branch if _tmp698 is zero 
	# _tmp699 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp700 = *(_tmp699)
	lw $t2, 0($t1) 	# load with offset
	# _tmp701 = *(_tmp700 + 12)
	lw $t3, 12($t2) 	# load with offset
	# PushParam _tmp699
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp701
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp699 from $t1 to $fp-32
	sw $t2, -36($fp)	# spill _tmp700 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp701 from $t3 to $fp-40
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L112
	b _L112		# unconditional branch
_L111:
_L112:
	# _tmp702 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp703 = *(_tmp702 + 20)
	lw $t2, 20($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp703
	# (save modified registers before flow of control change)
	sw $t1, -44($fp)	# spill _tmp702 from $t1 to $fp-44
	sw $t2, -48($fp)	# spill _tmp703 from $t2 to $fp-48
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp704 = "\nDealer starts. "
	.data			# create string constant marked with label
	_string62: .asciiz "\nDealer starts. "
	.text
	la $t0, _string62	# load label
	# PushParam _tmp704
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp704 from $t0 to $fp-52
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp705 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp706 = *(_tmp705)
	lw $t2, 0($t1) 	# load with offset
	# _tmp707 = *(_tmp706 + 16)
	lw $t3, 16($t2) 	# load with offset
	# _tmp708 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp708
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp705
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp707
	# (save modified registers before flow of control change)
	sw $t1, -56($fp)	# spill _tmp705 from $t1 to $fp-56
	sw $t2, -60($fp)	# spill _tmp706 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp707 from $t3 to $fp-64
	sw $t4, -68($fp)	# spill _tmp708 from $t4 to $fp-68
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp709 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp710 = *(_tmp709)
	lw $t2, 0($t1) 	# load with offset
	# _tmp711 = *(_tmp710 + 12)
	lw $t3, 12($t2) 	# load with offset
	# _tmp712 = *(this + 8)
	lw $t4, 8($t0) 	# load with offset
	# PushParam _tmp712
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp709
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp711
	# (save modified registers before flow of control change)
	sw $t1, -72($fp)	# spill _tmp709 from $t1 to $fp-72
	sw $t2, -76($fp)	# spill _tmp710 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp711 from $t3 to $fp-80
	sw $t4, -84($fp)	# spill _tmp712 from $t4 to $fp-84
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp713 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp714 = *(_tmp713 + 24)
	lw $t2, 24($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp714
	# (save modified registers before flow of control change)
	sw $t1, -88($fp)	# spill _tmp713 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp714 from $t2 to $fp-92
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp715 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp716 = *(_tmp715)
	lw $t2, 0($t1) 	# load with offset
	# _tmp717 = *(_tmp716 + 32)
	lw $t3, 32($t2) 	# load with offset
	# _tmp718 = *(this + 8)
	lw $t4, 8($t0) 	# load with offset
	# PushParam _tmp718
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp715
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp717
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp715 from $t1 to $fp-96
	sw $t2, -100($fp)	# spill _tmp716 from $t2 to $fp-100
	sw $t3, -104($fp)	# spill _tmp717 from $t3 to $fp-104
	sw $t4, -108($fp)	# spill _tmp718 from $t4 to $fp-108
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp719 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp720 = *(_tmp719 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp720
	# (save modified registers before flow of control change)
	sw $t1, -112($fp)	# spill _tmp719 from $t1 to $fp-112
	sw $t2, -116($fp)	# spill _tmp720 from $t2 to $fp-116
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class House
	.data
	.align 2
	House:		# label for class House vtable
	.word __House.PlayOneGame
	.word __House.PrintAllMoney
	.word __House.ResolveAllPlayers
	.word __House.SetupGame
	.word __House.SetupPlayers
	.word __House.TakeAllBets
	.word __House.TakeAllTurns
	.text
__GetYesOrNo:
	# BeginFunc 32
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 32	# decrement sp to make space for locals/temps
	# PushParam prompt
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, 4($fp)	# load prompt from $fp+4 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp721 = " (y/n) "
	.data			# create string constant marked with label
	_string63: .asciiz " (y/n) "
	.text
	la $t0, _string63	# load label
	# PushParam _tmp721
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp721 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp722 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# answer = _tmp722
	move $t1, $t0		# copy value
	# _tmp723 = "Y"
	.data			# create string constant marked with label
	_string64: .asciiz "Y"
	.text
	la $t2, _string64	# load label
	# PushParam _tmp723
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam answer
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp724 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp722 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill answer from $t1 to $fp-8
	sw $t2, -28($fp)	# spill _tmp723 from $t2 to $fp-28
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp725 = "y"
	.data			# create string constant marked with label
	_string65: .asciiz "y"
	.text
	la $t1, _string65	# load label
	# PushParam _tmp725
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam answer
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, -8($fp)	# load answer from $fp-8 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp726 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp724 from $t0 to $fp-24
	sw $t1, -36($fp)	# spill _tmp725 from $t1 to $fp-36
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp727 = _tmp726 || _tmp724
	lw $t1, -24($fp)	# load _tmp724 from $fp-24 into $t1
	or $t2, $t0, $t1	
	# Return _tmp727
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
	# BeginFunc 76
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 76	# decrement sp to make space for locals/temps
	# _tmp728 = 1
	li $t0, 1		# load constant value 1 into $t0
	# keepPlaying = _tmp728
	move $t1, $t0		# copy value
	# _tmp729 = 16
	li $t2, 16		# load constant value 16 into $t2
	# PushParam _tmp729
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp730 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp728 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill keepPlaying from $t1 to $fp-8
	sw $t2, -20($fp)	# spill _tmp729 from $t2 to $fp-20
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp731 = House
	la $t1, House	# load label
	# *(_tmp730) = _tmp731
	sw $t1, 0($t0) 	# store with offset
	# house = _tmp730
	move $t2, $t0		# copy value
	# _tmp732 = *(house)
	lw $t3, 0($t2) 	# load with offset
	# _tmp733 = *(_tmp732 + 12)
	lw $t4, 12($t3) 	# load with offset
	# PushParam house
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp733
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp730 from $t0 to $fp-24
	sw $t1, -28($fp)	# spill _tmp731 from $t1 to $fp-28
	sw $t2, -12($fp)	# spill house from $t2 to $fp-12
	sw $t3, -32($fp)	# spill _tmp732 from $t3 to $fp-32
	sw $t4, -36($fp)	# spill _tmp733 from $t4 to $fp-36
	jalr $t4            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp734 = *(house)
	lw $t0, -12($fp)	# load house from $fp-12 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp735 = *(_tmp734 + 16)
	lw $t2, 16($t1) 	# load with offset
	# PushParam house
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp735
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp734 from $t1 to $fp-40
	sw $t2, -44($fp)	# spill _tmp735 from $t2 to $fp-44
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L113:
	# IfZ keepPlaying Goto _L114
	lw $t0, -8($fp)	# load keepPlaying from $fp-8 into $t0
	beqz $t0, _L114	# branch if keepPlaying is zero 
	# _tmp736 = *(house)
	lw $t0, -12($fp)	# load house from $fp-12 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp737 = *(_tmp736)
	lw $t2, 0($t1) 	# load with offset
	# PushParam house
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp737
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp736 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp737 from $t2 to $fp-52
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp738 = "\nDo you want to play another hand?"
	.data			# create string constant marked with label
	_string66: .asciiz "\nDo you want to play another hand?"
	.text
	la $t0, _string66	# load label
	# PushParam _tmp738
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp739 = LCall __GetYesOrNo
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp738 from $t0 to $fp-56
	jal __GetYesOrNo   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# keepPlaying = _tmp739
	move $t1, $t0		# copy value
	# Goto _L113
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp739 from $t0 to $fp-60
	sw $t1, -8($fp)	# spill keepPlaying from $t1 to $fp-8
	b _L113		# unconditional branch
_L114:
	# _tmp740 = *(house)
	lw $t0, -12($fp)	# load house from $fp-12 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp741 = *(_tmp740 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam house
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp741
	# (save modified registers before flow of control change)
	sw $t1, -64($fp)	# spill _tmp740 from $t1 to $fp-64
	sw $t2, -68($fp)	# spill _tmp741 from $t2 to $fp-68
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp742 = "Thank you for playing...come again soon.\n"
	.data			# create string constant marked with label
	_string67: .asciiz "Thank you for playing...come again soon.\n"
	.text
	la $t0, _string67	# load label
	# PushParam _tmp742
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp742 from $t0 to $fp-72
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp743 = "\nCS143 BlackJack Copyright (c) 1999 by Peter Mor..."
	.data			# create string constant marked with label
	_string68: .asciiz "\nCS143 BlackJack Copyright (c) 1999 by Peter Mork.\n"
	.text
	la $t0, _string68	# load label
	# PushParam _tmp743
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp743 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp744 = "(2001 mods by jdz)\n"
	.data			# create string constant marked with label
	_string69: .asciiz "(2001 mods by jdz)\n"
	.text
	la $t0, _string69	# load label
	# PushParam _tmp744
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp744 from $t0 to $fp-80
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
