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
	
__Stack.Init:
	# BeginFunc 72
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 72	# decrement sp to make space for locals/temps
	# _tmp0 = 100
	li $t0, 100		# load constant value 100 into $t0
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
	sw $t0, -8($fp)	# spill _tmp0 from $t0 to $fp-8
	sw $t1, -12($fp)	# spill _tmp1 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp2 from $t2 to $fp-16
	sw $t3, -20($fp)	# spill _tmp3 from $t3 to $fp-20
	sw $t4, -24($fp)	# spill _tmp4 from $t4 to $fp-24
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
	sw $t0, -28($fp)	# spill _tmp5 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L0:
	# _tmp6 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp7 = _tmp0 * _tmp6
	lw $t1, -8($fp)	# load _tmp0 from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp8 = _tmp7 + _tmp6
	add $t3, $t2, $t0	
	# PushParam _tmp8
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp9 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp6 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp7 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp8 from $t3 to $fp-40
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp9) = _tmp0
	lw $t1, -8($fp)	# load _tmp0 from $fp-8 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp10 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp11 = this + _tmp10
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp11) = _tmp9
	sw $t0, 0($t4) 	# store with offset
	# _tmp12 = 0
	li $t5, 0		# load constant value 0 into $t5
	# _tmp13 = 8
	li $t6, 8		# load constant value 8 into $t6
	# _tmp14 = this + _tmp13
	add $t7, $t3, $t6	
	# *(_tmp14) = _tmp12
	sw $t5, 0($t7) 	# store with offset
	# _tmp15 = *(this)
	lw $s0, 0($t3) 	# load with offset
	# _tmp16 = *(_tmp15 + 12)
	lw $s1, 12($s0) 	# load with offset
	# _tmp17 = 3
	li $s2, 3		# load constant value 3 into $s2
	# PushParam _tmp17
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s2, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# ACall _tmp16
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp9 from $t0 to $fp-44
	sw $t2, -48($fp)	# spill _tmp10 from $t2 to $fp-48
	sw $t4, -52($fp)	# spill _tmp11 from $t4 to $fp-52
	sw $t5, -56($fp)	# spill _tmp12 from $t5 to $fp-56
	sw $t6, -60($fp)	# spill _tmp13 from $t6 to $fp-60
	sw $t7, -64($fp)	# spill _tmp14 from $t7 to $fp-64
	sw $s0, -68($fp)	# spill _tmp15 from $s0 to $fp-68
	sw $s1, -72($fp)	# spill _tmp16 from $s1 to $fp-72
	sw $s2, -76($fp)	# spill _tmp17 from $s2 to $fp-76
	jalr $s1            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Stack.Push:
	# BeginFunc 64
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 64	# decrement sp to make space for locals/temps
	# _tmp18 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp19 = *(_tmp18)
	lw $t2, 0($t1) 	# load with offset
	# _tmp20 = *(this + 8)
	lw $t3, 8($t0) 	# load with offset
	# _tmp21 = _tmp20 < _tmp19
	slt $t4, $t3, $t2	
	# _tmp22 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp23 = _tmp22 < _tmp20
	slt $t6, $t5, $t3	
	# _tmp24 = _tmp23 && _tmp21
	and $t7, $t6, $t4	
	# IfZ _tmp24 Goto _L1
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp18 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp19 from $t2 to $fp-12
	sw $t3, -20($fp)	# spill _tmp20 from $t3 to $fp-20
	sw $t4, -16($fp)	# spill _tmp21 from $t4 to $fp-16
	sw $t5, -24($fp)	# spill _tmp22 from $t5 to $fp-24
	sw $t6, -28($fp)	# spill _tmp23 from $t6 to $fp-28
	sw $t7, -32($fp)	# spill _tmp24 from $t7 to $fp-32
	beqz $t7, _L1	# branch if _tmp24 is zero 
	# _tmp25 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp26 = _tmp20 * _tmp25
	lw $t1, -20($fp)	# load _tmp20 from $fp-20 into $t1
	mul $t2, $t1, $t0	
	# _tmp27 = _tmp26 + _tmp25
	add $t3, $t2, $t0	
	# _tmp28 = _tmp18 + _tmp27
	lw $t4, -8($fp)	# load _tmp18 from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp25 from $t0 to $fp-36
	sw $t2, -40($fp)	# spill _tmp26 from $t2 to $fp-40
	sw $t3, -44($fp)	# spill _tmp27 from $t3 to $fp-44
	sw $t5, -44($fp)	# spill _tmp28 from $t5 to $fp-44
	b _L2		# unconditional branch
_L1:
	# _tmp29 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string2: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp29
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp29 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L2:
	# *(_tmp28) = i
	lw $t0, 8($fp)	# load i from $fp+8 into $t0
	lw $t1, -44($fp)	# load _tmp28 from $fp-44 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp30 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp31 = *(this + 8)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 8($t3) 	# load with offset
	# _tmp32 = _tmp31 + _tmp30
	add $t5, $t4, $t2	
	# _tmp33 = 8
	li $t6, 8		# load constant value 8 into $t6
	# _tmp34 = this + _tmp33
	add $t7, $t3, $t6	
	# *(_tmp34) = _tmp32
	sw $t5, 0($t7) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Stack.Pop:
	# BeginFunc 80
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 80	# decrement sp to make space for locals/temps
	# _tmp35 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp36 = *(_tmp35)
	lw $t2, 0($t1) 	# load with offset
	# _tmp37 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp38 = *(this + 8)
	lw $t4, 8($t0) 	# load with offset
	# _tmp39 = _tmp38 - _tmp37
	sub $t5, $t4, $t3	
	# _tmp40 = _tmp39 < _tmp36
	slt $t6, $t5, $t2	
	# _tmp41 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp42 = _tmp41 < _tmp39
	slt $s0, $t7, $t5	
	# _tmp43 = _tmp42 && _tmp40
	and $s1, $s0, $t6	
	# IfZ _tmp43 Goto _L3
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp35 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp36 from $t2 to $fp-16
	sw $t3, -28($fp)	# spill _tmp37 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp38 from $t4 to $fp-32
	sw $t5, -24($fp)	# spill _tmp39 from $t5 to $fp-24
	sw $t6, -20($fp)	# spill _tmp40 from $t6 to $fp-20
	sw $t7, -36($fp)	# spill _tmp41 from $t7 to $fp-36
	sw $s0, -40($fp)	# spill _tmp42 from $s0 to $fp-40
	sw $s1, -44($fp)	# spill _tmp43 from $s1 to $fp-44
	beqz $s1, _L3	# branch if _tmp43 is zero 
	# _tmp44 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp45 = _tmp39 * _tmp44
	lw $t1, -24($fp)	# load _tmp39 from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp46 = _tmp45 + _tmp44
	add $t3, $t2, $t0	
	# _tmp47 = _tmp35 + _tmp46
	lw $t4, -12($fp)	# load _tmp35 from $fp-12 into $t4
	add $t5, $t4, $t3	
	# Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp44 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp45 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp46 from $t3 to $fp-56
	sw $t5, -56($fp)	# spill _tmp47 from $t5 to $fp-56
	b _L4		# unconditional branch
_L3:
	# _tmp48 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string3: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp48
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp48 from $t0 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L4:
	# _tmp49 = *(_tmp47)
	lw $t0, -56($fp)	# load _tmp47 from $fp-56 into $t0
	lw $t1, 0($t0) 	# load with offset
	# val = _tmp49
	move $t2, $t1		# copy value
	# _tmp50 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp51 = *(this + 8)
	lw $t4, 4($fp)	# load this from $fp+4 into $t4
	lw $t5, 8($t4) 	# load with offset
	# _tmp52 = _tmp51 - _tmp50
	sub $t6, $t5, $t3	
	# _tmp53 = 8
	li $t7, 8		# load constant value 8 into $t7
	# _tmp54 = this + _tmp53
	add $s0, $t4, $t7	
	# *(_tmp54) = _tmp52
	sw $t6, 0($s0) 	# store with offset
	# Return val
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
__Stack.NumElems:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp55 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# Return _tmp55
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
	# VTable for class Stack
	.data
	.align 2
	Stack:		# label for class Stack vtable
	.word __Stack.Init
	.word __Stack.NumElems
	.word __Stack.Pop
	.word __Stack.Push
	.text
main:
	# BeginFunc 136
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 136	# decrement sp to make space for locals/temps
	# _tmp56 = 12
	li $t0, 12		# load constant value 12 into $t0
	# PushParam _tmp56
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp57 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp56 from $t0 to $fp-12
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp58 = Stack
	la $t1, Stack	# load label
	# *(_tmp57) = _tmp58
	sw $t1, 0($t0) 	# store with offset
	# s = _tmp57
	move $t2, $t0		# copy value
	# _tmp59 = *(s)
	lw $t3, 0($t2) 	# load with offset
	# _tmp60 = *(_tmp59)
	lw $t4, 0($t3) 	# load with offset
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp60
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp57 from $t0 to $fp-16
	sw $t1, -20($fp)	# spill _tmp58 from $t1 to $fp-20
	sw $t2, -8($fp)	# spill s from $t2 to $fp-8
	sw $t3, -24($fp)	# spill _tmp59 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp60 from $t4 to $fp-28
	jalr $t4            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp61 = *(s)
	lw $t0, -8($fp)	# load s from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp62 = *(_tmp61 + 12)
	lw $t2, 12($t1) 	# load with offset
	# _tmp63 = 3
	li $t3, 3		# load constant value 3 into $t3
	# PushParam _tmp63
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp62
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp61 from $t1 to $fp-32
	sw $t2, -36($fp)	# spill _tmp62 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp63 from $t3 to $fp-40
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp64 = *(s)
	lw $t0, -8($fp)	# load s from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp65 = *(_tmp64 + 12)
	lw $t2, 12($t1) 	# load with offset
	# _tmp66 = 7
	li $t3, 7		# load constant value 7 into $t3
	# PushParam _tmp66
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp65
	# (save modified registers before flow of control change)
	sw $t1, -44($fp)	# spill _tmp64 from $t1 to $fp-44
	sw $t2, -48($fp)	# spill _tmp65 from $t2 to $fp-48
	sw $t3, -52($fp)	# spill _tmp66 from $t3 to $fp-52
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp67 = *(s)
	lw $t0, -8($fp)	# load s from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp68 = *(_tmp67 + 12)
	lw $t2, 12($t1) 	# load with offset
	# _tmp69 = 4
	li $t3, 4		# load constant value 4 into $t3
	# PushParam _tmp69
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp68
	# (save modified registers before flow of control change)
	sw $t1, -56($fp)	# spill _tmp67 from $t1 to $fp-56
	sw $t2, -60($fp)	# spill _tmp68 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp69 from $t3 to $fp-64
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp70 = *(s)
	lw $t0, -8($fp)	# load s from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp71 = *(_tmp70 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp72 = ACall _tmp71
	# (save modified registers before flow of control change)
	sw $t1, -68($fp)	# spill _tmp70 from $t1 to $fp-68
	sw $t2, -72($fp)	# spill _tmp71 from $t2 to $fp-72
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp72
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp72 from $t0 to $fp-76
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp73 = " "
	.data			# create string constant marked with label
	_string4: .asciiz " "
	.text
	la $t0, _string4	# load label
	# PushParam _tmp73
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp73 from $t0 to $fp-80
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp74 = *(s)
	lw $t0, -8($fp)	# load s from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp75 = *(_tmp74 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp76 = ACall _tmp75
	# (save modified registers before flow of control change)
	sw $t1, -84($fp)	# spill _tmp74 from $t1 to $fp-84
	sw $t2, -88($fp)	# spill _tmp75 from $t2 to $fp-88
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp76
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp76 from $t0 to $fp-92
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp77 = " "
	.data			# create string constant marked with label
	_string5: .asciiz " "
	.text
	la $t0, _string5	# load label
	# PushParam _tmp77
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp77 from $t0 to $fp-96
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp78 = *(s)
	lw $t0, -8($fp)	# load s from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp79 = *(_tmp78 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp80 = ACall _tmp79
	# (save modified registers before flow of control change)
	sw $t1, -100($fp)	# spill _tmp78 from $t1 to $fp-100
	sw $t2, -104($fp)	# spill _tmp79 from $t2 to $fp-104
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp80
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp80 from $t0 to $fp-108
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp81 = " "
	.data			# create string constant marked with label
	_string6: .asciiz " "
	.text
	la $t0, _string6	# load label
	# PushParam _tmp81
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp81 from $t0 to $fp-112
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp82 = *(s)
	lw $t0, -8($fp)	# load s from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp83 = *(_tmp82 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp84 = ACall _tmp83
	# (save modified registers before flow of control change)
	sw $t1, -116($fp)	# spill _tmp82 from $t1 to $fp-116
	sw $t2, -120($fp)	# spill _tmp83 from $t2 to $fp-120
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp84
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp84 from $t0 to $fp-124
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp85 = " "
	.data			# create string constant marked with label
	_string7: .asciiz " "
	.text
	la $t0, _string7	# load label
	# PushParam _tmp85
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp85 from $t0 to $fp-128
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp86 = *(s)
	lw $t0, -8($fp)	# load s from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp87 = *(_tmp86 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp88 = ACall _tmp87
	# (save modified registers before flow of control change)
	sw $t1, -132($fp)	# spill _tmp86 from $t1 to $fp-132
	sw $t2, -136($fp)	# spill _tmp87 from $t2 to $fp-136
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp88
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp88 from $t0 to $fp-140
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
