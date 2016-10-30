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
	
__rndModule.Init:
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
__rndModule.Random:
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
__rndModule.RndInt:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp14 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp15 = *(_tmp14 + 4)
	lw $t2, 4($t1) 	# load with offset
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
	# VTable for class rndModule
	.data
	.align 2
	rndModule:		# label for class rndModule vtable
	.word __rndModule.Init
	.word __rndModule.Random
	.word __rndModule.RndInt
	.text
__Block.Init:
	# BeginFunc 36
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 36	# decrement sp to make space for locals/temps
	# _tmp18 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp19 = 8
	li $t1, 8		# load constant value 8 into $t1
	# _tmp20 = this + _tmp19
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp20) = _tmp18
	sw $t0, 0($t3) 	# store with offset
	# _tmp21 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp22 = 4
	li $t5, 4		# load constant value 4 into $t5
	# _tmp23 = this + _tmp22
	add $t6, $t2, $t5	
	# *(_tmp23) = _tmp21
	sw $t4, 0($t6) 	# store with offset
	# _tmp24 = 0
	li $t7, 0		# load constant value 0 into $t7
	# _tmp25 = 12
	li $s0, 12		# load constant value 12 into $s0
	# _tmp26 = this + _tmp25
	add $s1, $t2, $s0	
	# *(_tmp26) = _tmp24
	sw $t7, 0($s1) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Block.Uncover:
	# BeginFunc 12
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp27 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp28 = 12
	li $t1, 12		# load constant value 12 into $t1
	# _tmp29 = this + _tmp28
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp29) = _tmp27
	sw $t0, 0($t3) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Block.IsUncovered:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp30 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# Return _tmp30
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
__Block.SetMine:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp31 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp32 = this + _tmp31
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp32) = m
	lw $t3, 8($fp)	# load m from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Block.HasMine:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp33 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# Return _tmp33
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
__Block.IncrementAdjacents:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp34 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp35 = _tmp34 + i
	lw $t2, 8($fp)	# load i from $fp+8 into $t2
	add $t3, $t1, $t2	
	# _tmp36 = 4
	li $t4, 4		# load constant value 4 into $t4
	# _tmp37 = this + _tmp36
	add $t5, $t0, $t4	
	# *(_tmp37) = _tmp35
	sw $t3, 0($t5) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Block.SetAdjacents:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp38 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp39 = this + _tmp38
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp39) = i
	lw $t3, 8($fp)	# load i from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Block.NumAdjacents:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp40 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# Return _tmp40
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
__Block.PrintOutput:
	# BeginFunc 52
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 52	# decrement sp to make space for locals/temps
	# IfZ printSolution Goto _L0
	lw $t0, 8($fp)	# load printSolution from $fp+8 into $t0
	beqz $t0, _L0	# branch if printSolution is zero 
	# _tmp41 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# IfZ _tmp41 Goto _L2
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp41 from $t1 to $fp-8
	beqz $t1, _L2	# branch if _tmp41 is zero 
	# _tmp42 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp43 = *(this + 12)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 12($t1) 	# load with offset
	# _tmp44 = _tmp42 - _tmp43
	sub $t3, $t0, $t2	
	# IfZ _tmp44 Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp42 from $t0 to $fp-12
	sw $t2, -20($fp)	# spill _tmp43 from $t2 to $fp-20
	sw $t3, -16($fp)	# spill _tmp44 from $t3 to $fp-16
	beqz $t3, _L4	# branch if _tmp44 is zero 
	# _tmp45 = "x"
	.data			# create string constant marked with label
	_string1: .asciiz "x"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp45
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp45 from $t0 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L5
	b _L5		# unconditional branch
_L4:
	# _tmp46 = "%"
	.data			# create string constant marked with label
	_string2: .asciiz "%"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp46
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp46 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L5:
	# Goto _L3
	b _L3		# unconditional branch
_L2:
	# _tmp47 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# PushParam _tmp47
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp47 from $t1 to $fp-32
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L3:
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L1
	b _L1		# unconditional branch
_L0:
_L1:
	# _tmp48 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# IfZ _tmp48 Goto _L6
	# (save modified registers before flow of control change)
	sw $t1, -36($fp)	# spill _tmp48 from $t1 to $fp-36
	beqz $t1, _L6	# branch if _tmp48 is zero 
	# _tmp49 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp50 = *(this + 8)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 8($t1) 	# load with offset
	# _tmp51 = _tmp49 - _tmp50
	sub $t3, $t0, $t2	
	# IfZ _tmp51 Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp49 from $t0 to $fp-40
	sw $t2, -48($fp)	# spill _tmp50 from $t2 to $fp-48
	sw $t3, -44($fp)	# spill _tmp51 from $t3 to $fp-44
	beqz $t3, _L8	# branch if _tmp51 is zero 
	# _tmp52 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# PushParam _tmp52
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -52($fp)	# spill _tmp52 from $t1 to $fp-52
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L9
	b _L9		# unconditional branch
_L8:
_L9:
	# Goto _L7
	b _L7		# unconditional branch
_L6:
	# _tmp53 = "+"
	.data			# create string constant marked with label
	_string3: .asciiz "+"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp53
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp53 from $t0 to $fp-56
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L7:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Block
	.data
	.align 2
	Block:		# label for class Block vtable
	.word __Block.HasMine
	.word __Block.IncrementAdjacents
	.word __Block.Init
	.word __Block.IsUncovered
	.word __Block.NumAdjacents
	.word __Block.PrintOutput
	.word __Block.SetAdjacents
	.word __Block.SetMine
	.word __Block.Uncover
	.text
__Field.Init:
	# BeginFunc 440
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 440	# decrement sp to make space for locals/temps
	# _tmp54 = 12
	li $t0, 12		# load constant value 12 into $t0
	# _tmp55 = this + _tmp54
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp55) = h
	lw $t3, 8($fp)	# load h from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# _tmp56 = 24
	li $t4, 24		# load constant value 24 into $t4
	# _tmp57 = this + _tmp56
	add $t5, $t1, $t4	
	# *(_tmp57) = w
	lw $t6, 12($fp)	# load w from $fp+12 into $t6
	sw $t6, 0($t5) 	# store with offset
	# _tmp58 = 1
	li $t7, 1		# load constant value 1 into $t7
	# _tmp59 = 8
	li $s0, 8		# load constant value 8 into $s0
	# _tmp60 = this + _tmp59
	add $s1, $t1, $s0	
	# *(_tmp60) = _tmp58
	sw $t7, 0($s1) 	# store with offset
	# _tmp61 = h * w
	mul $s2, $t3, $t6	
	# _tmp62 = 20
	li $s3, 20		# load constant value 20 into $s3
	# _tmp63 = this + _tmp62
	add $s4, $t1, $s3	
	# *(_tmp63) = _tmp61
	sw $s2, 0($s4) 	# store with offset
	# _tmp64 = 0
	li $s5, 0		# load constant value 0 into $s5
	# _tmp65 = 16
	li $s6, 16		# load constant value 16 into $s6
	# _tmp66 = this + _tmp65
	add $s7, $t1, $s6	
	# *(_tmp66) = _tmp64
	sw $s5, 0($s7) 	# store with offset
	# _tmp67 = *(this + 24)
	lw $t8, 24($t1) 	# load with offset
	# _tmp68 = 0
	li $t9, 0		# load constant value 0 into $t9
	# _tmp69 = _tmp67 < _tmp68
	slt $t1, $t8, $t9	
	# _tmp70 = _tmp67 == _tmp68
	seq $t3, $t8, $t9	
	# _tmp71 = _tmp69 || _tmp70
	or $t6, $t1, $t3	
	# IfZ _tmp71 Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp54 from $t0 to $fp-16
	sw $t1, -76($fp)	# spill _tmp69 from $t1 to $fp-76
	sw $t2, -20($fp)	# spill _tmp55 from $t2 to $fp-20
	sw $t3, -80($fp)	# spill _tmp70 from $t3 to $fp-80
	sw $t4, -24($fp)	# spill _tmp56 from $t4 to $fp-24
	sw $t5, -28($fp)	# spill _tmp57 from $t5 to $fp-28
	sw $t6, -84($fp)	# spill _tmp71 from $t6 to $fp-84
	sw $t7, -32($fp)	# spill _tmp58 from $t7 to $fp-32
	sw $s0, -36($fp)	# spill _tmp59 from $s0 to $fp-36
	sw $s1, -40($fp)	# spill _tmp60 from $s1 to $fp-40
	sw $s2, -44($fp)	# spill _tmp61 from $s2 to $fp-44
	sw $s3, -48($fp)	# spill _tmp62 from $s3 to $fp-48
	sw $s4, -52($fp)	# spill _tmp63 from $s4 to $fp-52
	sw $s5, -56($fp)	# spill _tmp64 from $s5 to $fp-56
	sw $s6, -60($fp)	# spill _tmp65 from $s6 to $fp-60
	sw $s7, -64($fp)	# spill _tmp66 from $s7 to $fp-64
	sw $t8, -68($fp)	# spill _tmp67 from $t8 to $fp-68
	sw $t9, -72($fp)	# spill _tmp68 from $t9 to $fp-72
	beqz $t6, _L10	# branch if _tmp71 is zero 
	# _tmp72 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string4: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp72
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp72 from $t0 to $fp-88
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L10:
	# _tmp73 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp74 = _tmp67 * _tmp73
	lw $t1, -68($fp)	# load _tmp67 from $fp-68 into $t1
	mul $t2, $t1, $t0	
	# _tmp75 = _tmp74 + _tmp73
	add $t3, $t2, $t0	
	# PushParam _tmp75
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp76 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp73 from $t0 to $fp-92
	sw $t2, -96($fp)	# spill _tmp74 from $t2 to $fp-96
	sw $t3, -100($fp)	# spill _tmp75 from $t3 to $fp-100
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp76) = _tmp67
	lw $t1, -68($fp)	# load _tmp67 from $fp-68 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp77 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp78 = this + _tmp77
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp78) = _tmp76
	sw $t0, 0($t4) 	# store with offset
	# _tmp79 = 0
	li $t5, 0		# load constant value 0 into $t5
	# i = _tmp79
	move $t6, $t5		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp76 from $t0 to $fp-104
	sw $t2, -108($fp)	# spill _tmp77 from $t2 to $fp-108
	sw $t4, -112($fp)	# spill _tmp78 from $t4 to $fp-112
	sw $t5, -116($fp)	# spill _tmp79 from $t5 to $fp-116
	sw $t6, -8($fp)	# spill i from $t6 to $fp-8
_L11:
	# _tmp80 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp81 = i < _tmp80
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp81 Goto _L12
	# (save modified registers before flow of control change)
	sw $t1, -120($fp)	# spill _tmp80 from $t1 to $fp-120
	sw $t3, -124($fp)	# spill _tmp81 from $t3 to $fp-124
	beqz $t3, _L12	# branch if _tmp81 is zero 
	# _tmp82 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp83 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp84 = _tmp82 < _tmp83
	slt $t3, $t1, $t2	
	# _tmp85 = _tmp82 == _tmp83
	seq $t4, $t1, $t2	
	# _tmp86 = _tmp84 || _tmp85
	or $t5, $t3, $t4	
	# IfZ _tmp86 Goto _L13
	# (save modified registers before flow of control change)
	sw $t1, -128($fp)	# spill _tmp82 from $t1 to $fp-128
	sw $t2, -132($fp)	# spill _tmp83 from $t2 to $fp-132
	sw $t3, -136($fp)	# spill _tmp84 from $t3 to $fp-136
	sw $t4, -140($fp)	# spill _tmp85 from $t4 to $fp-140
	sw $t5, -144($fp)	# spill _tmp86 from $t5 to $fp-144
	beqz $t5, _L13	# branch if _tmp86 is zero 
	# _tmp87 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string5: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp87
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -148($fp)	# spill _tmp87 from $t0 to $fp-148
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L13:
	# _tmp88 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp89 = _tmp82 * _tmp88
	lw $t1, -128($fp)	# load _tmp82 from $fp-128 into $t1
	mul $t2, $t1, $t0	
	# _tmp90 = _tmp89 + _tmp88
	add $t3, $t2, $t0	
	# PushParam _tmp90
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp91 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp88 from $t0 to $fp-152
	sw $t2, -156($fp)	# spill _tmp89 from $t2 to $fp-156
	sw $t3, -160($fp)	# spill _tmp90 from $t3 to $fp-160
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp91) = _tmp82
	lw $t1, -128($fp)	# load _tmp82 from $fp-128 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp92 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp93 = *(_tmp92)
	lw $t4, 0($t3) 	# load with offset
	# _tmp94 = i < _tmp93
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp95 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp96 = _tmp95 < i
	slt $s0, $t7, $t5	
	# _tmp97 = _tmp96 && _tmp94
	and $s1, $s0, $t6	
	# IfZ _tmp97 Goto _L14
	# (save modified registers before flow of control change)
	sw $t0, -164($fp)	# spill _tmp91 from $t0 to $fp-164
	sw $t3, -168($fp)	# spill _tmp92 from $t3 to $fp-168
	sw $t4, -172($fp)	# spill _tmp93 from $t4 to $fp-172
	sw $t6, -176($fp)	# spill _tmp94 from $t6 to $fp-176
	sw $t7, -180($fp)	# spill _tmp95 from $t7 to $fp-180
	sw $s0, -184($fp)	# spill _tmp96 from $s0 to $fp-184
	sw $s1, -188($fp)	# spill _tmp97 from $s1 to $fp-188
	beqz $s1, _L14	# branch if _tmp97 is zero 
	# _tmp98 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp99 = i * _tmp98
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp100 = _tmp99 + _tmp98
	add $t3, $t2, $t0	
	# _tmp101 = _tmp92 + _tmp100
	lw $t4, -168($fp)	# load _tmp92 from $fp-168 into $t4
	add $t5, $t4, $t3	
	# Goto _L15
	# (save modified registers before flow of control change)
	sw $t0, -192($fp)	# spill _tmp98 from $t0 to $fp-192
	sw $t2, -196($fp)	# spill _tmp99 from $t2 to $fp-196
	sw $t3, -200($fp)	# spill _tmp100 from $t3 to $fp-200
	sw $t5, -200($fp)	# spill _tmp101 from $t5 to $fp-200
	b _L15		# unconditional branch
_L14:
	# _tmp102 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp102
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -204($fp)	# spill _tmp102 from $t0 to $fp-204
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L15:
	# *(_tmp101) = _tmp91
	lw $t0, -164($fp)	# load _tmp91 from $fp-164 into $t0
	lw $t1, -200($fp)	# load _tmp101 from $fp-200 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp103 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp104 = i + _tmp103
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	add $t4, $t3, $t2	
	# i = _tmp104
	move $t3, $t4		# copy value
	# Goto _L11
	# (save modified registers before flow of control change)
	sw $t2, -212($fp)	# spill _tmp103 from $t2 to $fp-212
	sw $t3, -8($fp)	# spill i from $t3 to $fp-8
	sw $t4, -208($fp)	# spill _tmp104 from $t4 to $fp-208
	b _L11		# unconditional branch
_L12:
	# _tmp105 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp105
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -216($fp)	# spill _tmp105 from $t0 to $fp-216
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L16:
	# _tmp106 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp107 = i < _tmp106
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp107 Goto _L17
	# (save modified registers before flow of control change)
	sw $t1, -220($fp)	# spill _tmp106 from $t1 to $fp-220
	sw $t3, -224($fp)	# spill _tmp107 from $t3 to $fp-224
	beqz $t3, _L17	# branch if _tmp107 is zero 
	# _tmp108 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp108
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -228($fp)	# spill _tmp108 from $t0 to $fp-228
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L18:
	# _tmp109 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp110 = j < _tmp109
	lw $t2, -12($fp)	# load j from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp110 Goto _L19
	# (save modified registers before flow of control change)
	sw $t1, -232($fp)	# spill _tmp109 from $t1 to $fp-232
	sw $t3, -236($fp)	# spill _tmp110 from $t3 to $fp-236
	beqz $t3, _L19	# branch if _tmp110 is zero 
	# _tmp111 = 16
	li $t0, 16		# load constant value 16 into $t0
	# PushParam _tmp111
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp112 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -240($fp)	# spill _tmp111 from $t0 to $fp-240
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp113 = Block
	la $t1, Block	# load label
	# *(_tmp112) = _tmp113
	sw $t1, 0($t0) 	# store with offset
	# _tmp114 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp115 = *(_tmp114)
	lw $t4, 0($t3) 	# load with offset
	# _tmp116 = i < _tmp115
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp117 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp118 = _tmp117 < i
	slt $s0, $t7, $t5	
	# _tmp119 = _tmp118 && _tmp116
	and $s1, $s0, $t6	
	# IfZ _tmp119 Goto _L20
	# (save modified registers before flow of control change)
	sw $t0, -244($fp)	# spill _tmp112 from $t0 to $fp-244
	sw $t1, -248($fp)	# spill _tmp113 from $t1 to $fp-248
	sw $t3, -252($fp)	# spill _tmp114 from $t3 to $fp-252
	sw $t4, -256($fp)	# spill _tmp115 from $t4 to $fp-256
	sw $t6, -260($fp)	# spill _tmp116 from $t6 to $fp-260
	sw $t7, -264($fp)	# spill _tmp117 from $t7 to $fp-264
	sw $s0, -268($fp)	# spill _tmp118 from $s0 to $fp-268
	sw $s1, -272($fp)	# spill _tmp119 from $s1 to $fp-272
	beqz $s1, _L20	# branch if _tmp119 is zero 
	# _tmp120 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp121 = i * _tmp120
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp122 = _tmp121 + _tmp120
	add $t3, $t2, $t0	
	# _tmp123 = _tmp114 + _tmp122
	lw $t4, -252($fp)	# load _tmp114 from $fp-252 into $t4
	add $t5, $t4, $t3	
	# Goto _L21
	# (save modified registers before flow of control change)
	sw $t0, -276($fp)	# spill _tmp120 from $t0 to $fp-276
	sw $t2, -280($fp)	# spill _tmp121 from $t2 to $fp-280
	sw $t3, -284($fp)	# spill _tmp122 from $t3 to $fp-284
	sw $t5, -284($fp)	# spill _tmp123 from $t5 to $fp-284
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
	sw $t0, -288($fp)	# spill _tmp124 from $t0 to $fp-288
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L21:
	# _tmp125 = *(_tmp123)
	lw $t0, -284($fp)	# load _tmp123 from $fp-284 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp126 = *(_tmp125)
	lw $t2, 0($t1) 	# load with offset
	# _tmp127 = j < _tmp126
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp128 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp129 = _tmp128 < j
	slt $t6, $t5, $t3	
	# _tmp130 = _tmp129 && _tmp127
	and $t7, $t6, $t4	
	# IfZ _tmp130 Goto _L22
	# (save modified registers before flow of control change)
	sw $t1, -292($fp)	# spill _tmp125 from $t1 to $fp-292
	sw $t2, -296($fp)	# spill _tmp126 from $t2 to $fp-296
	sw $t4, -300($fp)	# spill _tmp127 from $t4 to $fp-300
	sw $t5, -304($fp)	# spill _tmp128 from $t5 to $fp-304
	sw $t6, -308($fp)	# spill _tmp129 from $t6 to $fp-308
	sw $t7, -312($fp)	# spill _tmp130 from $t7 to $fp-312
	beqz $t7, _L22	# branch if _tmp130 is zero 
	# _tmp131 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp132 = j * _tmp131
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp133 = _tmp132 + _tmp131
	add $t3, $t2, $t0	
	# _tmp134 = _tmp125 + _tmp133
	lw $t4, -292($fp)	# load _tmp125 from $fp-292 into $t4
	add $t5, $t4, $t3	
	# Goto _L23
	# (save modified registers before flow of control change)
	sw $t0, -316($fp)	# spill _tmp131 from $t0 to $fp-316
	sw $t2, -320($fp)	# spill _tmp132 from $t2 to $fp-320
	sw $t3, -324($fp)	# spill _tmp133 from $t3 to $fp-324
	sw $t5, -324($fp)	# spill _tmp134 from $t5 to $fp-324
	b _L23		# unconditional branch
_L22:
	# _tmp135 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string8: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp135
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -328($fp)	# spill _tmp135 from $t0 to $fp-328
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L23:
	# *(_tmp134) = _tmp112
	lw $t0, -244($fp)	# load _tmp112 from $fp-244 into $t0
	lw $t1, -324($fp)	# load _tmp134 from $fp-324 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp136 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp137 = *(_tmp136)
	lw $t4, 0($t3) 	# load with offset
	# _tmp138 = i < _tmp137
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp139 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp140 = _tmp139 < i
	slt $s0, $t7, $t5	
	# _tmp141 = _tmp140 && _tmp138
	and $s1, $s0, $t6	
	# IfZ _tmp141 Goto _L24
	# (save modified registers before flow of control change)
	sw $t3, -332($fp)	# spill _tmp136 from $t3 to $fp-332
	sw $t4, -336($fp)	# spill _tmp137 from $t4 to $fp-336
	sw $t6, -340($fp)	# spill _tmp138 from $t6 to $fp-340
	sw $t7, -344($fp)	# spill _tmp139 from $t7 to $fp-344
	sw $s0, -348($fp)	# spill _tmp140 from $s0 to $fp-348
	sw $s1, -352($fp)	# spill _tmp141 from $s1 to $fp-352
	beqz $s1, _L24	# branch if _tmp141 is zero 
	# _tmp142 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp143 = i * _tmp142
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp144 = _tmp143 + _tmp142
	add $t3, $t2, $t0	
	# _tmp145 = _tmp136 + _tmp144
	lw $t4, -332($fp)	# load _tmp136 from $fp-332 into $t4
	add $t5, $t4, $t3	
	# Goto _L25
	# (save modified registers before flow of control change)
	sw $t0, -356($fp)	# spill _tmp142 from $t0 to $fp-356
	sw $t2, -360($fp)	# spill _tmp143 from $t2 to $fp-360
	sw $t3, -364($fp)	# spill _tmp144 from $t3 to $fp-364
	sw $t5, -364($fp)	# spill _tmp145 from $t5 to $fp-364
	b _L25		# unconditional branch
_L24:
	# _tmp146 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string9: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp146
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -368($fp)	# spill _tmp146 from $t0 to $fp-368
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L25:
	# _tmp147 = *(_tmp145)
	lw $t0, -364($fp)	# load _tmp145 from $fp-364 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp148 = *(_tmp147)
	lw $t2, 0($t1) 	# load with offset
	# _tmp149 = j < _tmp148
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp150 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp151 = _tmp150 < j
	slt $t6, $t5, $t3	
	# _tmp152 = _tmp151 && _tmp149
	and $t7, $t6, $t4	
	# IfZ _tmp152 Goto _L26
	# (save modified registers before flow of control change)
	sw $t1, -372($fp)	# spill _tmp147 from $t1 to $fp-372
	sw $t2, -376($fp)	# spill _tmp148 from $t2 to $fp-376
	sw $t4, -380($fp)	# spill _tmp149 from $t4 to $fp-380
	sw $t5, -384($fp)	# spill _tmp150 from $t5 to $fp-384
	sw $t6, -388($fp)	# spill _tmp151 from $t6 to $fp-388
	sw $t7, -392($fp)	# spill _tmp152 from $t7 to $fp-392
	beqz $t7, _L26	# branch if _tmp152 is zero 
	# _tmp153 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp154 = j * _tmp153
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp155 = _tmp154 + _tmp153
	add $t3, $t2, $t0	
	# _tmp156 = _tmp147 + _tmp155
	lw $t4, -372($fp)	# load _tmp147 from $fp-372 into $t4
	add $t5, $t4, $t3	
	# Goto _L27
	# (save modified registers before flow of control change)
	sw $t0, -396($fp)	# spill _tmp153 from $t0 to $fp-396
	sw $t2, -400($fp)	# spill _tmp154 from $t2 to $fp-400
	sw $t3, -404($fp)	# spill _tmp155 from $t3 to $fp-404
	sw $t5, -404($fp)	# spill _tmp156 from $t5 to $fp-404
	b _L27		# unconditional branch
_L26:
	# _tmp157 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp157
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -408($fp)	# spill _tmp157 from $t0 to $fp-408
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L27:
	# _tmp158 = *(_tmp156)
	lw $t0, -404($fp)	# load _tmp156 from $fp-404 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp159 = *(_tmp158)
	lw $t2, 0($t1) 	# load with offset
	# _tmp160 = *(_tmp159 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp158
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp160
	# (save modified registers before flow of control change)
	sw $t1, -412($fp)	# spill _tmp158 from $t1 to $fp-412
	sw $t2, -416($fp)	# spill _tmp159 from $t2 to $fp-416
	sw $t3, -420($fp)	# spill _tmp160 from $t3 to $fp-420
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp161 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp162 = j + _tmp161
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp162
	move $t1, $t2		# copy value
	# Goto _L18
	# (save modified registers before flow of control change)
	sw $t0, -428($fp)	# spill _tmp161 from $t0 to $fp-428
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -424($fp)	# spill _tmp162 from $t2 to $fp-424
	b _L18		# unconditional branch
_L19:
	# _tmp163 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp164 = i + _tmp163
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp164
	move $t1, $t2		# copy value
	# Goto _L16
	# (save modified registers before flow of control change)
	sw $t0, -436($fp)	# spill _tmp163 from $t0 to $fp-436
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -432($fp)	# spill _tmp164 from $t2 to $fp-432
	b _L16		# unconditional branch
_L17:
	# _tmp165 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp166 = *(_tmp165 + 24)
	lw $t2, 24($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp166
	# (save modified registers before flow of control change)
	sw $t1, -440($fp)	# spill _tmp165 from $t1 to $fp-440
	sw $t2, -444($fp)	# spill _tmp166 from $t2 to $fp-444
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Field.GetWidth:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp167 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# Return _tmp167
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
__Field.GetHeight:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp168 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# Return _tmp168
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
__Field.PlantMines:
	# BeginFunc 56
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 56	# decrement sp to make space for locals/temps
	# _tmp169 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp169
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp169 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L28:
	# _tmp170 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp171 = i < _tmp170
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp171 Goto _L29
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp170 from $t1 to $fp-20
	sw $t3, -24($fp)	# spill _tmp171 from $t3 to $fp-24
	beqz $t3, _L29	# branch if _tmp171 is zero 
	# _tmp172 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp172
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp172 from $t0 to $fp-28
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L30:
	# _tmp173 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp174 = j < _tmp173
	lw $t2, -12($fp)	# load j from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp174 Goto _L31
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp173 from $t1 to $fp-32
	sw $t3, -36($fp)	# spill _tmp174 from $t3 to $fp-36
	beqz $t3, _L31	# branch if _tmp174 is zero 
	# _tmp175 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp176 = *(_tmp175 + 28)
	lw $t2, 28($t1) 	# load with offset
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
	# ACall _tmp176
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp175 from $t1 to $fp-40
	sw $t2, -44($fp)	# spill _tmp176 from $t2 to $fp-44
	jalr $t2            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp177 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp178 = j + _tmp177
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp178
	move $t1, $t2		# copy value
	# Goto _L30
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp177 from $t0 to $fp-52
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -48($fp)	# spill _tmp178 from $t2 to $fp-48
	b _L30		# unconditional branch
_L31:
	# _tmp179 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp180 = i + _tmp179
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp180
	move $t1, $t2		# copy value
	# Goto _L28
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp179 from $t0 to $fp-60
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -56($fp)	# spill _tmp180 from $t2 to $fp-56
	b _L28		# unconditional branch
_L29:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Field.PlantOneMine:
	# BeginFunc 480
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 480	# decrement sp to make space for locals/temps
	# _tmp181 = *(gRnd)
	lw $t0, 8($gp)	# load gRnd from $gp+8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp182 = *(_tmp181 + 8)
	lw $t2, 8($t1) 	# load with offset
	# _tmp183 = 100
	li $t3, 100		# load constant value 100 into $t3
	# PushParam _tmp183
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam gRnd
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp184 = ACall _tmp182
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp181 from $t1 to $fp-20
	sw $t2, -24($fp)	# spill _tmp182 from $t2 to $fp-24
	sw $t3, -28($fp)	# spill _tmp183 from $t3 to $fp-28
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# rand = _tmp184
	move $t1, $t0		# copy value
	# _tmp185 = rand < probOfMine
	lw $t2, 0($gp)	# load probOfMine from $gp+0 into $t2
	slt $t3, $t1, $t2	
	# IfZ _tmp185 Goto _L32
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp184 from $t0 to $fp-32
	sw $t1, -16($fp)	# spill rand from $t1 to $fp-16
	sw $t3, -36($fp)	# spill _tmp185 from $t3 to $fp-36
	beqz $t3, _L32	# branch if _tmp185 is zero 
	# _tmp186 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp187 = *(_tmp186)
	lw $t2, 0($t1) 	# load with offset
	# _tmp188 = i < _tmp187
	lw $t3, 8($fp)	# load i from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp189 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp190 = _tmp189 < i
	slt $t6, $t5, $t3	
	# _tmp191 = _tmp190 && _tmp188
	and $t7, $t6, $t4	
	# IfZ _tmp191 Goto _L34
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp186 from $t1 to $fp-40
	sw $t2, -44($fp)	# spill _tmp187 from $t2 to $fp-44
	sw $t4, -48($fp)	# spill _tmp188 from $t4 to $fp-48
	sw $t5, -52($fp)	# spill _tmp189 from $t5 to $fp-52
	sw $t6, -56($fp)	# spill _tmp190 from $t6 to $fp-56
	sw $t7, -60($fp)	# spill _tmp191 from $t7 to $fp-60
	beqz $t7, _L34	# branch if _tmp191 is zero 
	# _tmp192 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp193 = i * _tmp192
	lw $t1, 8($fp)	# load i from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp194 = _tmp193 + _tmp192
	add $t3, $t2, $t0	
	# _tmp195 = _tmp186 + _tmp194
	lw $t4, -40($fp)	# load _tmp186 from $fp-40 into $t4
	add $t5, $t4, $t3	
	# Goto _L35
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp192 from $t0 to $fp-64
	sw $t2, -68($fp)	# spill _tmp193 from $t2 to $fp-68
	sw $t3, -72($fp)	# spill _tmp194 from $t3 to $fp-72
	sw $t5, -72($fp)	# spill _tmp195 from $t5 to $fp-72
	b _L35		# unconditional branch
_L34:
	# _tmp196 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string11: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string11	# load label
	# PushParam _tmp196
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp196 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L35:
	# _tmp197 = *(_tmp195)
	lw $t0, -72($fp)	# load _tmp195 from $fp-72 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp198 = *(_tmp197)
	lw $t2, 0($t1) 	# load with offset
	# _tmp199 = j < _tmp198
	lw $t3, 12($fp)	# load j from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp200 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp201 = _tmp200 < j
	slt $t6, $t5, $t3	
	# _tmp202 = _tmp201 && _tmp199
	and $t7, $t6, $t4	
	# IfZ _tmp202 Goto _L36
	# (save modified registers before flow of control change)
	sw $t1, -80($fp)	# spill _tmp197 from $t1 to $fp-80
	sw $t2, -84($fp)	# spill _tmp198 from $t2 to $fp-84
	sw $t4, -88($fp)	# spill _tmp199 from $t4 to $fp-88
	sw $t5, -92($fp)	# spill _tmp200 from $t5 to $fp-92
	sw $t6, -96($fp)	# spill _tmp201 from $t6 to $fp-96
	sw $t7, -100($fp)	# spill _tmp202 from $t7 to $fp-100
	beqz $t7, _L36	# branch if _tmp202 is zero 
	# _tmp203 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp204 = j * _tmp203
	lw $t1, 12($fp)	# load j from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp205 = _tmp204 + _tmp203
	add $t3, $t2, $t0	
	# _tmp206 = _tmp197 + _tmp205
	lw $t4, -80($fp)	# load _tmp197 from $fp-80 into $t4
	add $t5, $t4, $t3	
	# Goto _L37
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp203 from $t0 to $fp-104
	sw $t2, -108($fp)	# spill _tmp204 from $t2 to $fp-108
	sw $t3, -112($fp)	# spill _tmp205 from $t3 to $fp-112
	sw $t5, -112($fp)	# spill _tmp206 from $t5 to $fp-112
	b _L37		# unconditional branch
_L36:
	# _tmp207 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string12: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string12	# load label
	# PushParam _tmp207
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp207 from $t0 to $fp-116
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L37:
	# _tmp208 = *(_tmp206)
	lw $t0, -112($fp)	# load _tmp206 from $fp-112 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp209 = *(_tmp208)
	lw $t2, 0($t1) 	# load with offset
	# _tmp210 = *(_tmp209 + 28)
	lw $t3, 28($t2) 	# load with offset
	# _tmp211 = 1
	li $t4, 1		# load constant value 1 into $t4
	# PushParam _tmp211
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp208
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp210
	# (save modified registers before flow of control change)
	sw $t1, -120($fp)	# spill _tmp208 from $t1 to $fp-120
	sw $t2, -124($fp)	# spill _tmp209 from $t2 to $fp-124
	sw $t3, -128($fp)	# spill _tmp210 from $t3 to $fp-128
	sw $t4, -132($fp)	# spill _tmp211 from $t4 to $fp-132
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp212 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp213 = *(this + 20)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 20($t1) 	# load with offset
	# _tmp214 = _tmp213 - _tmp212
	sub $t3, $t2, $t0	
	# _tmp215 = 20
	li $t4, 20		# load constant value 20 into $t4
	# _tmp216 = this + _tmp215
	add $t5, $t1, $t4	
	# *(_tmp216) = _tmp214
	sw $t3, 0($t5) 	# store with offset
	# _tmp217 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp218 = i - _tmp217
	lw $t7, 8($fp)	# load i from $fp+8 into $t7
	sub $s0, $t7, $t6	
	# x = _tmp218
	move $s1, $s0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp212 from $t0 to $fp-140
	sw $t2, -144($fp)	# spill _tmp213 from $t2 to $fp-144
	sw $t3, -136($fp)	# spill _tmp214 from $t3 to $fp-136
	sw $t4, -148($fp)	# spill _tmp215 from $t4 to $fp-148
	sw $t5, -152($fp)	# spill _tmp216 from $t5 to $fp-152
	sw $t6, -160($fp)	# spill _tmp217 from $t6 to $fp-160
	sw $s0, -156($fp)	# spill _tmp218 from $s0 to $fp-156
	sw $s1, -8($fp)	# spill x from $s1 to $fp-8
_L38:
	# _tmp219 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp220 = i + _tmp219
	lw $t1, 8($fp)	# load i from $fp+8 into $t1
	add $t2, $t1, $t0	
	# _tmp221 = x < _tmp220
	lw $t3, -8($fp)	# load x from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp222 = x == _tmp220
	seq $t5, $t3, $t2	
	# _tmp223 = _tmp221 || _tmp222
	or $t6, $t4, $t5	
	# IfZ _tmp223 Goto _L39
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp219 from $t0 to $fp-168
	sw $t2, -164($fp)	# spill _tmp220 from $t2 to $fp-164
	sw $t4, -172($fp)	# spill _tmp221 from $t4 to $fp-172
	sw $t5, -176($fp)	# spill _tmp222 from $t5 to $fp-176
	sw $t6, -180($fp)	# spill _tmp223 from $t6 to $fp-180
	beqz $t6, _L39	# branch if _tmp223 is zero 
	# _tmp224 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp225 = j - _tmp224
	lw $t1, 12($fp)	# load j from $fp+12 into $t1
	sub $t2, $t1, $t0	
	# y = _tmp225
	move $t3, $t2		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp224 from $t0 to $fp-188
	sw $t2, -184($fp)	# spill _tmp225 from $t2 to $fp-184
	sw $t3, -12($fp)	# spill y from $t3 to $fp-12
_L40:
	# _tmp226 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp227 = j + _tmp226
	lw $t1, 12($fp)	# load j from $fp+12 into $t1
	add $t2, $t1, $t0	
	# _tmp228 = y < _tmp227
	lw $t3, -12($fp)	# load y from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp229 = y == _tmp227
	seq $t5, $t3, $t2	
	# _tmp230 = _tmp228 || _tmp229
	or $t6, $t4, $t5	
	# IfZ _tmp230 Goto _L41
	# (save modified registers before flow of control change)
	sw $t0, -196($fp)	# spill _tmp226 from $t0 to $fp-196
	sw $t2, -192($fp)	# spill _tmp227 from $t2 to $fp-192
	sw $t4, -200($fp)	# spill _tmp228 from $t4 to $fp-200
	sw $t5, -204($fp)	# spill _tmp229 from $t5 to $fp-204
	sw $t6, -208($fp)	# spill _tmp230 from $t6 to $fp-208
	beqz $t6, _L41	# branch if _tmp230 is zero 
	# _tmp231 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp232 = y < _tmp231
	lw $t2, -12($fp)	# load y from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# _tmp233 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp234 = _tmp233 < y
	slt $t5, $t4, $t2	
	# _tmp235 = y == _tmp233
	seq $t6, $t2, $t4	
	# _tmp236 = _tmp234 || _tmp235
	or $t7, $t5, $t6	
	# _tmp237 = *(this + 24)
	lw $s0, 24($t0) 	# load with offset
	# _tmp238 = x < _tmp237
	lw $s1, -8($fp)	# load x from $fp-8 into $s1
	slt $s2, $s1, $s0	
	# _tmp239 = 0
	li $s3, 0		# load constant value 0 into $s3
	# _tmp240 = _tmp239 < x
	slt $s4, $s3, $s1	
	# _tmp241 = x == _tmp239
	seq $s5, $s1, $s3	
	# _tmp242 = _tmp240 || _tmp241
	or $s6, $s4, $s5	
	# _tmp243 = _tmp242 && _tmp238
	and $s7, $s6, $s2	
	# _tmp244 = _tmp243 && _tmp236
	and $t8, $s7, $t7	
	# _tmp245 = _tmp244 && _tmp232
	and $t9, $t8, $t3	
	# IfZ _tmp245 Goto _L42
	# (save modified registers before flow of control change)
	sw $t1, -216($fp)	# spill _tmp231 from $t1 to $fp-216
	sw $t3, -220($fp)	# spill _tmp232 from $t3 to $fp-220
	sw $t4, -228($fp)	# spill _tmp233 from $t4 to $fp-228
	sw $t5, -232($fp)	# spill _tmp234 from $t5 to $fp-232
	sw $t6, -236($fp)	# spill _tmp235 from $t6 to $fp-236
	sw $t7, -240($fp)	# spill _tmp236 from $t7 to $fp-240
	sw $s0, -248($fp)	# spill _tmp237 from $s0 to $fp-248
	sw $s2, -252($fp)	# spill _tmp238 from $s2 to $fp-252
	sw $s3, -256($fp)	# spill _tmp239 from $s3 to $fp-256
	sw $s4, -260($fp)	# spill _tmp240 from $s4 to $fp-260
	sw $s5, -264($fp)	# spill _tmp241 from $s5 to $fp-264
	sw $s6, -268($fp)	# spill _tmp242 from $s6 to $fp-268
	sw $s7, -244($fp)	# spill _tmp243 from $s7 to $fp-244
	sw $t8, -224($fp)	# spill _tmp244 from $t8 to $fp-224
	sw $t9, -212($fp)	# spill _tmp245 from $t9 to $fp-212
	beqz $t9, _L42	# branch if _tmp245 is zero 
	# _tmp246 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp247 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp248 = *(_tmp247)
	lw $t3, 0($t2) 	# load with offset
	# _tmp249 = x < _tmp248
	lw $t4, -8($fp)	# load x from $fp-8 into $t4
	slt $t5, $t4, $t3	
	# _tmp250 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp251 = _tmp250 < x
	slt $t7, $t6, $t4	
	# _tmp252 = _tmp251 && _tmp249
	and $s0, $t7, $t5	
	# IfZ _tmp252 Goto _L46
	# (save modified registers before flow of control change)
	sw $t0, -272($fp)	# spill _tmp246 from $t0 to $fp-272
	sw $t2, -280($fp)	# spill _tmp247 from $t2 to $fp-280
	sw $t3, -284($fp)	# spill _tmp248 from $t3 to $fp-284
	sw $t5, -288($fp)	# spill _tmp249 from $t5 to $fp-288
	sw $t6, -292($fp)	# spill _tmp250 from $t6 to $fp-292
	sw $t7, -296($fp)	# spill _tmp251 from $t7 to $fp-296
	sw $s0, -300($fp)	# spill _tmp252 from $s0 to $fp-300
	beqz $s0, _L46	# branch if _tmp252 is zero 
	# _tmp253 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp254 = x * _tmp253
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp255 = _tmp254 + _tmp253
	add $t3, $t2, $t0	
	# _tmp256 = _tmp247 + _tmp255
	lw $t4, -280($fp)	# load _tmp247 from $fp-280 into $t4
	add $t5, $t4, $t3	
	# Goto _L47
	# (save modified registers before flow of control change)
	sw $t0, -304($fp)	# spill _tmp253 from $t0 to $fp-304
	sw $t2, -308($fp)	# spill _tmp254 from $t2 to $fp-308
	sw $t3, -312($fp)	# spill _tmp255 from $t3 to $fp-312
	sw $t5, -312($fp)	# spill _tmp256 from $t5 to $fp-312
	b _L47		# unconditional branch
_L46:
	# _tmp257 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string13: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string13	# load label
	# PushParam _tmp257
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -316($fp)	# spill _tmp257 from $t0 to $fp-316
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L47:
	# _tmp258 = *(_tmp256)
	lw $t0, -312($fp)	# load _tmp256 from $fp-312 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp259 = *(_tmp258)
	lw $t2, 0($t1) 	# load with offset
	# _tmp260 = y < _tmp259
	lw $t3, -12($fp)	# load y from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp261 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp262 = _tmp261 < y
	slt $t6, $t5, $t3	
	# _tmp263 = _tmp262 && _tmp260
	and $t7, $t6, $t4	
	# IfZ _tmp263 Goto _L48
	# (save modified registers before flow of control change)
	sw $t1, -320($fp)	# spill _tmp258 from $t1 to $fp-320
	sw $t2, -324($fp)	# spill _tmp259 from $t2 to $fp-324
	sw $t4, -328($fp)	# spill _tmp260 from $t4 to $fp-328
	sw $t5, -332($fp)	# spill _tmp261 from $t5 to $fp-332
	sw $t6, -336($fp)	# spill _tmp262 from $t6 to $fp-336
	sw $t7, -340($fp)	# spill _tmp263 from $t7 to $fp-340
	beqz $t7, _L48	# branch if _tmp263 is zero 
	# _tmp264 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp265 = y * _tmp264
	lw $t1, -12($fp)	# load y from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp266 = _tmp265 + _tmp264
	add $t3, $t2, $t0	
	# _tmp267 = _tmp258 + _tmp266
	lw $t4, -320($fp)	# load _tmp258 from $fp-320 into $t4
	add $t5, $t4, $t3	
	# Goto _L49
	# (save modified registers before flow of control change)
	sw $t0, -344($fp)	# spill _tmp264 from $t0 to $fp-344
	sw $t2, -348($fp)	# spill _tmp265 from $t2 to $fp-348
	sw $t3, -352($fp)	# spill _tmp266 from $t3 to $fp-352
	sw $t5, -352($fp)	# spill _tmp267 from $t5 to $fp-352
	b _L49		# unconditional branch
_L48:
	# _tmp268 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string14: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string14	# load label
	# PushParam _tmp268
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -356($fp)	# spill _tmp268 from $t0 to $fp-356
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L49:
	# _tmp269 = *(_tmp267)
	lw $t0, -352($fp)	# load _tmp267 from $fp-352 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp270 = *(_tmp269)
	lw $t2, 0($t1) 	# load with offset
	# _tmp271 = *(_tmp270)
	lw $t3, 0($t2) 	# load with offset
	# PushParam _tmp269
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp272 = ACall _tmp271
	# (save modified registers before flow of control change)
	sw $t1, -360($fp)	# spill _tmp269 from $t1 to $fp-360
	sw $t2, -364($fp)	# spill _tmp270 from $t2 to $fp-364
	sw $t3, -368($fp)	# spill _tmp271 from $t3 to $fp-368
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp273 = _tmp246 - _tmp272
	lw $t1, -272($fp)	# load _tmp246 from $fp-272 into $t1
	sub $t2, $t1, $t0	
	# IfZ _tmp273 Goto _L44
	# (save modified registers before flow of control change)
	sw $t0, -372($fp)	# spill _tmp272 from $t0 to $fp-372
	sw $t2, -276($fp)	# spill _tmp273 from $t2 to $fp-276
	beqz $t2, _L44	# branch if _tmp273 is zero 
	# _tmp274 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp275 = *(_tmp274)
	lw $t2, 0($t1) 	# load with offset
	# _tmp276 = x < _tmp275
	lw $t3, -8($fp)	# load x from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp277 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp278 = _tmp277 < x
	slt $t6, $t5, $t3	
	# _tmp279 = _tmp278 && _tmp276
	and $t7, $t6, $t4	
	# IfZ _tmp279 Goto _L50
	# (save modified registers before flow of control change)
	sw $t1, -376($fp)	# spill _tmp274 from $t1 to $fp-376
	sw $t2, -380($fp)	# spill _tmp275 from $t2 to $fp-380
	sw $t4, -384($fp)	# spill _tmp276 from $t4 to $fp-384
	sw $t5, -388($fp)	# spill _tmp277 from $t5 to $fp-388
	sw $t6, -392($fp)	# spill _tmp278 from $t6 to $fp-392
	sw $t7, -396($fp)	# spill _tmp279 from $t7 to $fp-396
	beqz $t7, _L50	# branch if _tmp279 is zero 
	# _tmp280 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp281 = x * _tmp280
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp282 = _tmp281 + _tmp280
	add $t3, $t2, $t0	
	# _tmp283 = _tmp274 + _tmp282
	lw $t4, -376($fp)	# load _tmp274 from $fp-376 into $t4
	add $t5, $t4, $t3	
	# Goto _L51
	# (save modified registers before flow of control change)
	sw $t0, -400($fp)	# spill _tmp280 from $t0 to $fp-400
	sw $t2, -404($fp)	# spill _tmp281 from $t2 to $fp-404
	sw $t3, -408($fp)	# spill _tmp282 from $t3 to $fp-408
	sw $t5, -408($fp)	# spill _tmp283 from $t5 to $fp-408
	b _L51		# unconditional branch
_L50:
	# _tmp284 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string15: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string15	# load label
	# PushParam _tmp284
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -412($fp)	# spill _tmp284 from $t0 to $fp-412
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L51:
	# _tmp285 = *(_tmp283)
	lw $t0, -408($fp)	# load _tmp283 from $fp-408 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp286 = *(_tmp285)
	lw $t2, 0($t1) 	# load with offset
	# _tmp287 = y < _tmp286
	lw $t3, -12($fp)	# load y from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp288 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp289 = _tmp288 < y
	slt $t6, $t5, $t3	
	# _tmp290 = _tmp289 && _tmp287
	and $t7, $t6, $t4	
	# IfZ _tmp290 Goto _L52
	# (save modified registers before flow of control change)
	sw $t1, -416($fp)	# spill _tmp285 from $t1 to $fp-416
	sw $t2, -420($fp)	# spill _tmp286 from $t2 to $fp-420
	sw $t4, -424($fp)	# spill _tmp287 from $t4 to $fp-424
	sw $t5, -428($fp)	# spill _tmp288 from $t5 to $fp-428
	sw $t6, -432($fp)	# spill _tmp289 from $t6 to $fp-432
	sw $t7, -436($fp)	# spill _tmp290 from $t7 to $fp-436
	beqz $t7, _L52	# branch if _tmp290 is zero 
	# _tmp291 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp292 = y * _tmp291
	lw $t1, -12($fp)	# load y from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp293 = _tmp292 + _tmp291
	add $t3, $t2, $t0	
	# _tmp294 = _tmp285 + _tmp293
	lw $t4, -416($fp)	# load _tmp285 from $fp-416 into $t4
	add $t5, $t4, $t3	
	# Goto _L53
	# (save modified registers before flow of control change)
	sw $t0, -440($fp)	# spill _tmp291 from $t0 to $fp-440
	sw $t2, -444($fp)	# spill _tmp292 from $t2 to $fp-444
	sw $t3, -448($fp)	# spill _tmp293 from $t3 to $fp-448
	sw $t5, -448($fp)	# spill _tmp294 from $t5 to $fp-448
	b _L53		# unconditional branch
_L52:
	# _tmp295 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string16: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string16	# load label
	# PushParam _tmp295
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -452($fp)	# spill _tmp295 from $t0 to $fp-452
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L53:
	# _tmp296 = *(_tmp294)
	lw $t0, -448($fp)	# load _tmp294 from $fp-448 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp297 = *(_tmp296)
	lw $t2, 0($t1) 	# load with offset
	# _tmp298 = *(_tmp297 + 4)
	lw $t3, 4($t2) 	# load with offset
	# _tmp299 = 1
	li $t4, 1		# load constant value 1 into $t4
	# PushParam _tmp299
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp296
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp298
	# (save modified registers before flow of control change)
	sw $t1, -456($fp)	# spill _tmp296 from $t1 to $fp-456
	sw $t2, -460($fp)	# spill _tmp297 from $t2 to $fp-460
	sw $t3, -464($fp)	# spill _tmp298 from $t3 to $fp-464
	sw $t4, -468($fp)	# spill _tmp299 from $t4 to $fp-468
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L45
	b _L45		# unconditional branch
_L44:
_L45:
	# Goto _L43
	b _L43		# unconditional branch
_L42:
_L43:
	# _tmp300 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp301 = y + _tmp300
	lw $t1, -12($fp)	# load y from $fp-12 into $t1
	add $t2, $t1, $t0	
	# y = _tmp301
	move $t1, $t2		# copy value
	# Goto _L40
	# (save modified registers before flow of control change)
	sw $t0, -476($fp)	# spill _tmp300 from $t0 to $fp-476
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
	sw $t2, -472($fp)	# spill _tmp301 from $t2 to $fp-472
	b _L40		# unconditional branch
_L41:
	# _tmp302 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp303 = x + _tmp302
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	add $t2, $t1, $t0	
	# x = _tmp303
	move $t1, $t2		# copy value
	# Goto _L38
	# (save modified registers before flow of control change)
	sw $t0, -484($fp)	# spill _tmp302 from $t0 to $fp-484
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -480($fp)	# spill _tmp303 from $t2 to $fp-480
	b _L38		# unconditional branch
_L39:
	# Goto _L33
	b _L33		# unconditional branch
_L32:
_L33:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Field.PrintField:
	# BeginFunc 212
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 212	# decrement sp to make space for locals/temps
	# _tmp304 = "   "
	.data			# create string constant marked with label
	_string17: .asciiz "   "
	.text
	la $t0, _string17	# load label
	# PushParam _tmp304
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp304 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp305 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp305
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp305 from $t0 to $fp-20
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L54:
	# _tmp306 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp307 = i < _tmp306
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp307 Goto _L55
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp306 from $t1 to $fp-24
	sw $t3, -28($fp)	# spill _tmp307 from $t3 to $fp-28
	beqz $t3, _L55	# branch if _tmp307 is zero 
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load i from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp308 = " "
	.data			# create string constant marked with label
	_string18: .asciiz " "
	.text
	la $t0, _string18	# load label
	# PushParam _tmp308
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp308 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp309 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp310 = i + _tmp309
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp310
	move $t1, $t2		# copy value
	# Goto _L54
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp309 from $t0 to $fp-40
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -36($fp)	# spill _tmp310 from $t2 to $fp-36
	b _L54		# unconditional branch
_L55:
	# _tmp311 = "\n +"
	.data			# create string constant marked with label
	_string19: .asciiz "\n +"
	.text
	la $t0, _string19	# load label
	# PushParam _tmp311
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp311 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp312 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp312
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp312 from $t0 to $fp-48
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L56:
	# _tmp313 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp314 = i < _tmp313
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp314 Goto _L57
	# (save modified registers before flow of control change)
	sw $t1, -52($fp)	# spill _tmp313 from $t1 to $fp-52
	sw $t3, -56($fp)	# spill _tmp314 from $t3 to $fp-56
	beqz $t3, _L57	# branch if _tmp314 is zero 
	# _tmp315 = "--"
	.data			# create string constant marked with label
	_string20: .asciiz "--"
	.text
	la $t0, _string20	# load label
	# PushParam _tmp315
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp315 from $t0 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp316 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp317 = i + _tmp316
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp317
	move $t1, $t2		# copy value
	# Goto _L56
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp316 from $t0 to $fp-68
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -64($fp)	# spill _tmp317 from $t2 to $fp-64
	b _L56		# unconditional branch
_L57:
	# _tmp318 = "\n"
	.data			# create string constant marked with label
	_string21: .asciiz "\n"
	.text
	la $t0, _string21	# load label
	# PushParam _tmp318
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp318 from $t0 to $fp-72
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp319 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp319
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp319 from $t0 to $fp-76
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L58:
	# _tmp320 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp321 = j < _tmp320
	lw $t2, -12($fp)	# load j from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp321 Goto _L59
	# (save modified registers before flow of control change)
	sw $t1, -80($fp)	# spill _tmp320 from $t1 to $fp-80
	sw $t3, -84($fp)	# spill _tmp321 from $t3 to $fp-84
	beqz $t3, _L59	# branch if _tmp321 is zero 
	# PushParam j
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load j from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp322 = "| "
	.data			# create string constant marked with label
	_string22: .asciiz "| "
	.text
	la $t0, _string22	# load label
	# PushParam _tmp322
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp322 from $t0 to $fp-88
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp323 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp323
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp323 from $t0 to $fp-92
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L60:
	# _tmp324 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp325 = i < _tmp324
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp325 Goto _L61
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp324 from $t1 to $fp-96
	sw $t3, -100($fp)	# spill _tmp325 from $t3 to $fp-100
	beqz $t3, _L61	# branch if _tmp325 is zero 
	# _tmp326 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp327 = *(_tmp326)
	lw $t2, 0($t1) 	# load with offset
	# _tmp328 = i < _tmp327
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp329 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp330 = _tmp329 < i
	slt $t6, $t5, $t3	
	# _tmp331 = _tmp330 && _tmp328
	and $t7, $t6, $t4	
	# IfZ _tmp331 Goto _L62
	# (save modified registers before flow of control change)
	sw $t1, -104($fp)	# spill _tmp326 from $t1 to $fp-104
	sw $t2, -108($fp)	# spill _tmp327 from $t2 to $fp-108
	sw $t4, -112($fp)	# spill _tmp328 from $t4 to $fp-112
	sw $t5, -116($fp)	# spill _tmp329 from $t5 to $fp-116
	sw $t6, -120($fp)	# spill _tmp330 from $t6 to $fp-120
	sw $t7, -124($fp)	# spill _tmp331 from $t7 to $fp-124
	beqz $t7, _L62	# branch if _tmp331 is zero 
	# _tmp332 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp333 = i * _tmp332
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp334 = _tmp333 + _tmp332
	add $t3, $t2, $t0	
	# _tmp335 = _tmp326 + _tmp334
	lw $t4, -104($fp)	# load _tmp326 from $fp-104 into $t4
	add $t5, $t4, $t3	
	# Goto _L63
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp332 from $t0 to $fp-128
	sw $t2, -132($fp)	# spill _tmp333 from $t2 to $fp-132
	sw $t3, -136($fp)	# spill _tmp334 from $t3 to $fp-136
	sw $t5, -136($fp)	# spill _tmp335 from $t5 to $fp-136
	b _L63		# unconditional branch
_L62:
	# _tmp336 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string23: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string23	# load label
	# PushParam _tmp336
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp336 from $t0 to $fp-140
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L63:
	# _tmp337 = *(_tmp335)
	lw $t0, -136($fp)	# load _tmp335 from $fp-136 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp338 = *(_tmp337)
	lw $t2, 0($t1) 	# load with offset
	# _tmp339 = j < _tmp338
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp340 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp341 = _tmp340 < j
	slt $t6, $t5, $t3	
	# _tmp342 = _tmp341 && _tmp339
	and $t7, $t6, $t4	
	# IfZ _tmp342 Goto _L64
	# (save modified registers before flow of control change)
	sw $t1, -144($fp)	# spill _tmp337 from $t1 to $fp-144
	sw $t2, -148($fp)	# spill _tmp338 from $t2 to $fp-148
	sw $t4, -152($fp)	# spill _tmp339 from $t4 to $fp-152
	sw $t5, -156($fp)	# spill _tmp340 from $t5 to $fp-156
	sw $t6, -160($fp)	# spill _tmp341 from $t6 to $fp-160
	sw $t7, -164($fp)	# spill _tmp342 from $t7 to $fp-164
	beqz $t7, _L64	# branch if _tmp342 is zero 
	# _tmp343 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp344 = j * _tmp343
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp345 = _tmp344 + _tmp343
	add $t3, $t2, $t0	
	# _tmp346 = _tmp337 + _tmp345
	lw $t4, -144($fp)	# load _tmp337 from $fp-144 into $t4
	add $t5, $t4, $t3	
	# Goto _L65
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp343 from $t0 to $fp-168
	sw $t2, -172($fp)	# spill _tmp344 from $t2 to $fp-172
	sw $t3, -176($fp)	# spill _tmp345 from $t3 to $fp-176
	sw $t5, -176($fp)	# spill _tmp346 from $t5 to $fp-176
	b _L65		# unconditional branch
_L64:
	# _tmp347 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string24: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string24	# load label
	# PushParam _tmp347
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp347 from $t0 to $fp-180
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L65:
	# _tmp348 = *(_tmp346)
	lw $t0, -176($fp)	# load _tmp346 from $fp-176 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp349 = *(_tmp348)
	lw $t2, 0($t1) 	# load with offset
	# _tmp350 = *(_tmp349 + 20)
	lw $t3, 20($t2) 	# load with offset
	# PushParam printSolution
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load printSolution from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp348
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp350
	# (save modified registers before flow of control change)
	sw $t1, -184($fp)	# spill _tmp348 from $t1 to $fp-184
	sw $t2, -188($fp)	# spill _tmp349 from $t2 to $fp-188
	sw $t3, -192($fp)	# spill _tmp350 from $t3 to $fp-192
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp351 = " "
	.data			# create string constant marked with label
	_string25: .asciiz " "
	.text
	la $t0, _string25	# load label
	# PushParam _tmp351
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -196($fp)	# spill _tmp351 from $t0 to $fp-196
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp352 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp353 = i + _tmp352
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp353
	move $t1, $t2		# copy value
	# Goto _L60
	# (save modified registers before flow of control change)
	sw $t0, -204($fp)	# spill _tmp352 from $t0 to $fp-204
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -200($fp)	# spill _tmp353 from $t2 to $fp-200
	b _L60		# unconditional branch
_L61:
	# _tmp354 = "\n |\n"
	.data			# create string constant marked with label
	_string26: .asciiz "\n |\n"
	.text
	la $t0, _string26	# load label
	# PushParam _tmp354
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -208($fp)	# spill _tmp354 from $t0 to $fp-208
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp355 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp356 = j + _tmp355
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp356
	move $t1, $t2		# copy value
	# Goto _L58
	# (save modified registers before flow of control change)
	sw $t0, -216($fp)	# spill _tmp355 from $t0 to $fp-216
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -212($fp)	# spill _tmp356 from $t2 to $fp-212
	b _L58		# unconditional branch
_L59:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Field.Expand:
	# BeginFunc 576
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 576	# decrement sp to make space for locals/temps
	# _tmp357 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp358 = *(_tmp357)
	lw $t2, 0($t1) 	# load with offset
	# _tmp359 = x < _tmp358
	lw $t3, 8($fp)	# load x from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp360 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp361 = _tmp360 < x
	slt $t6, $t5, $t3	
	# _tmp362 = _tmp361 && _tmp359
	and $t7, $t6, $t4	
	# IfZ _tmp362 Goto _L68
	# (save modified registers before flow of control change)
	sw $t1, -16($fp)	# spill _tmp357 from $t1 to $fp-16
	sw $t2, -20($fp)	# spill _tmp358 from $t2 to $fp-20
	sw $t4, -24($fp)	# spill _tmp359 from $t4 to $fp-24
	sw $t5, -28($fp)	# spill _tmp360 from $t5 to $fp-28
	sw $t6, -32($fp)	# spill _tmp361 from $t6 to $fp-32
	sw $t7, -36($fp)	# spill _tmp362 from $t7 to $fp-36
	beqz $t7, _L68	# branch if _tmp362 is zero 
	# _tmp363 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp364 = x * _tmp363
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp365 = _tmp364 + _tmp363
	add $t3, $t2, $t0	
	# _tmp366 = _tmp357 + _tmp365
	lw $t4, -16($fp)	# load _tmp357 from $fp-16 into $t4
	add $t5, $t4, $t3	
	# Goto _L69
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp363 from $t0 to $fp-40
	sw $t2, -44($fp)	# spill _tmp364 from $t2 to $fp-44
	sw $t3, -48($fp)	# spill _tmp365 from $t3 to $fp-48
	sw $t5, -48($fp)	# spill _tmp366 from $t5 to $fp-48
	b _L69		# unconditional branch
_L68:
	# _tmp367 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string27: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string27	# load label
	# PushParam _tmp367
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp367 from $t0 to $fp-52
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L69:
	# _tmp368 = *(_tmp366)
	lw $t0, -48($fp)	# load _tmp366 from $fp-48 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp369 = *(_tmp368)
	lw $t2, 0($t1) 	# load with offset
	# _tmp370 = y < _tmp369
	lw $t3, 12($fp)	# load y from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp371 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp372 = _tmp371 < y
	slt $t6, $t5, $t3	
	# _tmp373 = _tmp372 && _tmp370
	and $t7, $t6, $t4	
	# IfZ _tmp373 Goto _L70
	# (save modified registers before flow of control change)
	sw $t1, -56($fp)	# spill _tmp368 from $t1 to $fp-56
	sw $t2, -60($fp)	# spill _tmp369 from $t2 to $fp-60
	sw $t4, -64($fp)	# spill _tmp370 from $t4 to $fp-64
	sw $t5, -68($fp)	# spill _tmp371 from $t5 to $fp-68
	sw $t6, -72($fp)	# spill _tmp372 from $t6 to $fp-72
	sw $t7, -76($fp)	# spill _tmp373 from $t7 to $fp-76
	beqz $t7, _L70	# branch if _tmp373 is zero 
	# _tmp374 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp375 = y * _tmp374
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp376 = _tmp375 + _tmp374
	add $t3, $t2, $t0	
	# _tmp377 = _tmp368 + _tmp376
	lw $t4, -56($fp)	# load _tmp368 from $fp-56 into $t4
	add $t5, $t4, $t3	
	# Goto _L71
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp374 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp375 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp376 from $t3 to $fp-88
	sw $t5, -88($fp)	# spill _tmp377 from $t5 to $fp-88
	b _L71		# unconditional branch
_L70:
	# _tmp378 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string28: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string28	# load label
	# PushParam _tmp378
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp378 from $t0 to $fp-92
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L71:
	# _tmp379 = *(_tmp377)
	lw $t0, -88($fp)	# load _tmp377 from $fp-88 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp380 = *(_tmp379)
	lw $t2, 0($t1) 	# load with offset
	# _tmp381 = *(_tmp380 + 12)
	lw $t3, 12($t2) 	# load with offset
	# PushParam _tmp379
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp382 = ACall _tmp381
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp379 from $t1 to $fp-96
	sw $t2, -100($fp)	# spill _tmp380 from $t2 to $fp-100
	sw $t3, -104($fp)	# spill _tmp381 from $t3 to $fp-104
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp382 Goto _L66
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp382 from $t0 to $fp-108
	beqz $t0, _L66	# branch if _tmp382 is zero 
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L67
	b _L67		# unconditional branch
_L66:
_L67:
	# _tmp383 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp384 = *(_tmp383)
	lw $t2, 0($t1) 	# load with offset
	# _tmp385 = x < _tmp384
	lw $t3, 8($fp)	# load x from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp386 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp387 = _tmp386 < x
	slt $t6, $t5, $t3	
	# _tmp388 = _tmp387 && _tmp385
	and $t7, $t6, $t4	
	# IfZ _tmp388 Goto _L72
	# (save modified registers before flow of control change)
	sw $t1, -112($fp)	# spill _tmp383 from $t1 to $fp-112
	sw $t2, -116($fp)	# spill _tmp384 from $t2 to $fp-116
	sw $t4, -120($fp)	# spill _tmp385 from $t4 to $fp-120
	sw $t5, -124($fp)	# spill _tmp386 from $t5 to $fp-124
	sw $t6, -128($fp)	# spill _tmp387 from $t6 to $fp-128
	sw $t7, -132($fp)	# spill _tmp388 from $t7 to $fp-132
	beqz $t7, _L72	# branch if _tmp388 is zero 
	# _tmp389 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp390 = x * _tmp389
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp391 = _tmp390 + _tmp389
	add $t3, $t2, $t0	
	# _tmp392 = _tmp383 + _tmp391
	lw $t4, -112($fp)	# load _tmp383 from $fp-112 into $t4
	add $t5, $t4, $t3	
	# Goto _L73
	# (save modified registers before flow of control change)
	sw $t0, -136($fp)	# spill _tmp389 from $t0 to $fp-136
	sw $t2, -140($fp)	# spill _tmp390 from $t2 to $fp-140
	sw $t3, -144($fp)	# spill _tmp391 from $t3 to $fp-144
	sw $t5, -144($fp)	# spill _tmp392 from $t5 to $fp-144
	b _L73		# unconditional branch
_L72:
	# _tmp393 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string29: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string29	# load label
	# PushParam _tmp393
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -148($fp)	# spill _tmp393 from $t0 to $fp-148
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L73:
	# _tmp394 = *(_tmp392)
	lw $t0, -144($fp)	# load _tmp392 from $fp-144 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp395 = *(_tmp394)
	lw $t2, 0($t1) 	# load with offset
	# _tmp396 = y < _tmp395
	lw $t3, 12($fp)	# load y from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp397 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp398 = _tmp397 < y
	slt $t6, $t5, $t3	
	# _tmp399 = _tmp398 && _tmp396
	and $t7, $t6, $t4	
	# IfZ _tmp399 Goto _L74
	# (save modified registers before flow of control change)
	sw $t1, -152($fp)	# spill _tmp394 from $t1 to $fp-152
	sw $t2, -156($fp)	# spill _tmp395 from $t2 to $fp-156
	sw $t4, -160($fp)	# spill _tmp396 from $t4 to $fp-160
	sw $t5, -164($fp)	# spill _tmp397 from $t5 to $fp-164
	sw $t6, -168($fp)	# spill _tmp398 from $t6 to $fp-168
	sw $t7, -172($fp)	# spill _tmp399 from $t7 to $fp-172
	beqz $t7, _L74	# branch if _tmp399 is zero 
	# _tmp400 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp401 = y * _tmp400
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp402 = _tmp401 + _tmp400
	add $t3, $t2, $t0	
	# _tmp403 = _tmp394 + _tmp402
	lw $t4, -152($fp)	# load _tmp394 from $fp-152 into $t4
	add $t5, $t4, $t3	
	# Goto _L75
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp400 from $t0 to $fp-176
	sw $t2, -180($fp)	# spill _tmp401 from $t2 to $fp-180
	sw $t3, -184($fp)	# spill _tmp402 from $t3 to $fp-184
	sw $t5, -184($fp)	# spill _tmp403 from $t5 to $fp-184
	b _L75		# unconditional branch
_L74:
	# _tmp404 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string30: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string30	# load label
	# PushParam _tmp404
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp404 from $t0 to $fp-188
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L75:
	# _tmp405 = *(_tmp403)
	lw $t0, -184($fp)	# load _tmp403 from $fp-184 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp406 = *(_tmp405)
	lw $t2, 0($t1) 	# load with offset
	# _tmp407 = *(_tmp406 + 32)
	lw $t3, 32($t2) 	# load with offset
	# PushParam _tmp405
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp407
	# (save modified registers before flow of control change)
	sw $t1, -192($fp)	# spill _tmp405 from $t1 to $fp-192
	sw $t2, -196($fp)	# spill _tmp406 from $t2 to $fp-196
	sw $t3, -200($fp)	# spill _tmp407 from $t3 to $fp-200
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp408 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp409 = *(_tmp408)
	lw $t2, 0($t1) 	# load with offset
	# _tmp410 = x < _tmp409
	lw $t3, 8($fp)	# load x from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp411 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp412 = _tmp411 < x
	slt $t6, $t5, $t3	
	# _tmp413 = _tmp412 && _tmp410
	and $t7, $t6, $t4	
	# IfZ _tmp413 Goto _L78
	# (save modified registers before flow of control change)
	sw $t1, -204($fp)	# spill _tmp408 from $t1 to $fp-204
	sw $t2, -208($fp)	# spill _tmp409 from $t2 to $fp-208
	sw $t4, -212($fp)	# spill _tmp410 from $t4 to $fp-212
	sw $t5, -216($fp)	# spill _tmp411 from $t5 to $fp-216
	sw $t6, -220($fp)	# spill _tmp412 from $t6 to $fp-220
	sw $t7, -224($fp)	# spill _tmp413 from $t7 to $fp-224
	beqz $t7, _L78	# branch if _tmp413 is zero 
	# _tmp414 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp415 = x * _tmp414
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp416 = _tmp415 + _tmp414
	add $t3, $t2, $t0	
	# _tmp417 = _tmp408 + _tmp416
	lw $t4, -204($fp)	# load _tmp408 from $fp-204 into $t4
	add $t5, $t4, $t3	
	# Goto _L79
	# (save modified registers before flow of control change)
	sw $t0, -228($fp)	# spill _tmp414 from $t0 to $fp-228
	sw $t2, -232($fp)	# spill _tmp415 from $t2 to $fp-232
	sw $t3, -236($fp)	# spill _tmp416 from $t3 to $fp-236
	sw $t5, -236($fp)	# spill _tmp417 from $t5 to $fp-236
	b _L79		# unconditional branch
_L78:
	# _tmp418 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string31: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string31	# load label
	# PushParam _tmp418
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -240($fp)	# spill _tmp418 from $t0 to $fp-240
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L79:
	# _tmp419 = *(_tmp417)
	lw $t0, -236($fp)	# load _tmp417 from $fp-236 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp420 = *(_tmp419)
	lw $t2, 0($t1) 	# load with offset
	# _tmp421 = y < _tmp420
	lw $t3, 12($fp)	# load y from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp422 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp423 = _tmp422 < y
	slt $t6, $t5, $t3	
	# _tmp424 = _tmp423 && _tmp421
	and $t7, $t6, $t4	
	# IfZ _tmp424 Goto _L80
	# (save modified registers before flow of control change)
	sw $t1, -244($fp)	# spill _tmp419 from $t1 to $fp-244
	sw $t2, -248($fp)	# spill _tmp420 from $t2 to $fp-248
	sw $t4, -252($fp)	# spill _tmp421 from $t4 to $fp-252
	sw $t5, -256($fp)	# spill _tmp422 from $t5 to $fp-256
	sw $t6, -260($fp)	# spill _tmp423 from $t6 to $fp-260
	sw $t7, -264($fp)	# spill _tmp424 from $t7 to $fp-264
	beqz $t7, _L80	# branch if _tmp424 is zero 
	# _tmp425 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp426 = y * _tmp425
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp427 = _tmp426 + _tmp425
	add $t3, $t2, $t0	
	# _tmp428 = _tmp419 + _tmp427
	lw $t4, -244($fp)	# load _tmp419 from $fp-244 into $t4
	add $t5, $t4, $t3	
	# Goto _L81
	# (save modified registers before flow of control change)
	sw $t0, -268($fp)	# spill _tmp425 from $t0 to $fp-268
	sw $t2, -272($fp)	# spill _tmp426 from $t2 to $fp-272
	sw $t3, -276($fp)	# spill _tmp427 from $t3 to $fp-276
	sw $t5, -276($fp)	# spill _tmp428 from $t5 to $fp-276
	b _L81		# unconditional branch
_L80:
	# _tmp429 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string32: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string32	# load label
	# PushParam _tmp429
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -280($fp)	# spill _tmp429 from $t0 to $fp-280
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L81:
	# _tmp430 = *(_tmp428)
	lw $t0, -276($fp)	# load _tmp428 from $fp-276 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp431 = *(_tmp430)
	lw $t2, 0($t1) 	# load with offset
	# _tmp432 = *(_tmp431)
	lw $t3, 0($t2) 	# load with offset
	# PushParam _tmp430
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp433 = ACall _tmp432
	# (save modified registers before flow of control change)
	sw $t1, -284($fp)	# spill _tmp430 from $t1 to $fp-284
	sw $t2, -288($fp)	# spill _tmp431 from $t2 to $fp-288
	sw $t3, -292($fp)	# spill _tmp432 from $t3 to $fp-292
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp433 Goto _L76
	# (save modified registers before flow of control change)
	sw $t0, -296($fp)	# spill _tmp433 from $t0 to $fp-296
	beqz $t0, _L76	# branch if _tmp433 is zero 
	# _tmp434 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp435 = 8
	li $t1, 8		# load constant value 8 into $t1
	# _tmp436 = this + _tmp435
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp436) = _tmp434
	sw $t0, 0($t3) 	# store with offset
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L77
	b _L77		# unconditional branch
_L76:
_L77:
	# _tmp437 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp438 = *(this + 16)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 16($t1) 	# load with offset
	# _tmp439 = _tmp438 + _tmp437
	add $t3, $t2, $t0	
	# _tmp440 = 16
	li $t4, 16		# load constant value 16 into $t4
	# _tmp441 = this + _tmp440
	add $t5, $t1, $t4	
	# *(_tmp441) = _tmp439
	sw $t3, 0($t5) 	# store with offset
	# _tmp442 = *(this + 4)
	lw $t6, 4($t1) 	# load with offset
	# _tmp443 = *(_tmp442)
	lw $t7, 0($t6) 	# load with offset
	# _tmp444 = x < _tmp443
	lw $s0, 8($fp)	# load x from $fp+8 into $s0
	slt $s1, $s0, $t7	
	# _tmp445 = -1
	li $s2, -1		# load constant value -1 into $s2
	# _tmp446 = _tmp445 < x
	slt $s3, $s2, $s0	
	# _tmp447 = _tmp446 && _tmp444
	and $s4, $s3, $s1	
	# IfZ _tmp447 Goto _L84
	# (save modified registers before flow of control change)
	sw $t0, -316($fp)	# spill _tmp437 from $t0 to $fp-316
	sw $t2, -320($fp)	# spill _tmp438 from $t2 to $fp-320
	sw $t3, -312($fp)	# spill _tmp439 from $t3 to $fp-312
	sw $t4, -324($fp)	# spill _tmp440 from $t4 to $fp-324
	sw $t5, -328($fp)	# spill _tmp441 from $t5 to $fp-328
	sw $t6, -332($fp)	# spill _tmp442 from $t6 to $fp-332
	sw $t7, -336($fp)	# spill _tmp443 from $t7 to $fp-336
	sw $s1, -340($fp)	# spill _tmp444 from $s1 to $fp-340
	sw $s2, -344($fp)	# spill _tmp445 from $s2 to $fp-344
	sw $s3, -348($fp)	# spill _tmp446 from $s3 to $fp-348
	sw $s4, -352($fp)	# spill _tmp447 from $s4 to $fp-352
	beqz $s4, _L84	# branch if _tmp447 is zero 
	# _tmp448 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp449 = x * _tmp448
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp450 = _tmp449 + _tmp448
	add $t3, $t2, $t0	
	# _tmp451 = _tmp442 + _tmp450
	lw $t4, -332($fp)	# load _tmp442 from $fp-332 into $t4
	add $t5, $t4, $t3	
	# Goto _L85
	# (save modified registers before flow of control change)
	sw $t0, -356($fp)	# spill _tmp448 from $t0 to $fp-356
	sw $t2, -360($fp)	# spill _tmp449 from $t2 to $fp-360
	sw $t3, -364($fp)	# spill _tmp450 from $t3 to $fp-364
	sw $t5, -364($fp)	# spill _tmp451 from $t5 to $fp-364
	b _L85		# unconditional branch
_L84:
	# _tmp452 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string33: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string33	# load label
	# PushParam _tmp452
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -368($fp)	# spill _tmp452 from $t0 to $fp-368
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L85:
	# _tmp453 = *(_tmp451)
	lw $t0, -364($fp)	# load _tmp451 from $fp-364 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp454 = *(_tmp453)
	lw $t2, 0($t1) 	# load with offset
	# _tmp455 = y < _tmp454
	lw $t3, 12($fp)	# load y from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp456 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp457 = _tmp456 < y
	slt $t6, $t5, $t3	
	# _tmp458 = _tmp457 && _tmp455
	and $t7, $t6, $t4	
	# IfZ _tmp458 Goto _L86
	# (save modified registers before flow of control change)
	sw $t1, -372($fp)	# spill _tmp453 from $t1 to $fp-372
	sw $t2, -376($fp)	# spill _tmp454 from $t2 to $fp-376
	sw $t4, -380($fp)	# spill _tmp455 from $t4 to $fp-380
	sw $t5, -384($fp)	# spill _tmp456 from $t5 to $fp-384
	sw $t6, -388($fp)	# spill _tmp457 from $t6 to $fp-388
	sw $t7, -392($fp)	# spill _tmp458 from $t7 to $fp-392
	beqz $t7, _L86	# branch if _tmp458 is zero 
	# _tmp459 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp460 = y * _tmp459
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp461 = _tmp460 + _tmp459
	add $t3, $t2, $t0	
	# _tmp462 = _tmp453 + _tmp461
	lw $t4, -372($fp)	# load _tmp453 from $fp-372 into $t4
	add $t5, $t4, $t3	
	# Goto _L87
	# (save modified registers before flow of control change)
	sw $t0, -396($fp)	# spill _tmp459 from $t0 to $fp-396
	sw $t2, -400($fp)	# spill _tmp460 from $t2 to $fp-400
	sw $t3, -404($fp)	# spill _tmp461 from $t3 to $fp-404
	sw $t5, -404($fp)	# spill _tmp462 from $t5 to $fp-404
	b _L87		# unconditional branch
_L86:
	# _tmp463 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string34: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string34	# load label
	# PushParam _tmp463
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -408($fp)	# spill _tmp463 from $t0 to $fp-408
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L87:
	# _tmp464 = *(_tmp462)
	lw $t0, -404($fp)	# load _tmp462 from $fp-404 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp465 = *(_tmp464)
	lw $t2, 0($t1) 	# load with offset
	# _tmp466 = *(_tmp465 + 16)
	lw $t3, 16($t2) 	# load with offset
	# PushParam _tmp464
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp467 = ACall _tmp466
	# (save modified registers before flow of control change)
	sw $t1, -412($fp)	# spill _tmp464 from $t1 to $fp-412
	sw $t2, -416($fp)	# spill _tmp465 from $t2 to $fp-416
	sw $t3, -420($fp)	# spill _tmp466 from $t3 to $fp-420
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp468 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp469 = _tmp467 < _tmp468
	slt $t2, $t0, $t1	
	# _tmp470 = _tmp468 < _tmp467
	slt $t3, $t1, $t0	
	# _tmp471 = _tmp469 || _tmp470
	or $t4, $t2, $t3	
	# IfZ _tmp471 Goto _L82
	# (save modified registers before flow of control change)
	sw $t0, -424($fp)	# spill _tmp467 from $t0 to $fp-424
	sw $t1, -428($fp)	# spill _tmp468 from $t1 to $fp-428
	sw $t2, -432($fp)	# spill _tmp469 from $t2 to $fp-432
	sw $t3, -436($fp)	# spill _tmp470 from $t3 to $fp-436
	sw $t4, -440($fp)	# spill _tmp471 from $t4 to $fp-440
	beqz $t4, _L82	# branch if _tmp471 is zero 
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L83
	b _L83		# unconditional branch
_L82:
_L83:
	# _tmp472 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp473 = x - _tmp472
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	sub $t2, $t1, $t0	
	# i = _tmp473
	move $t3, $t2		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -448($fp)	# spill _tmp472 from $t0 to $fp-448
	sw $t2, -444($fp)	# spill _tmp473 from $t2 to $fp-444
	sw $t3, -8($fp)	# spill i from $t3 to $fp-8
_L88:
	# _tmp474 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp475 = x + _tmp474
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	add $t2, $t1, $t0	
	# _tmp476 = i < _tmp475
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp477 = i == _tmp475
	seq $t5, $t3, $t2	
	# _tmp478 = _tmp476 || _tmp477
	or $t6, $t4, $t5	
	# IfZ _tmp478 Goto _L89
	# (save modified registers before flow of control change)
	sw $t0, -456($fp)	# spill _tmp474 from $t0 to $fp-456
	sw $t2, -452($fp)	# spill _tmp475 from $t2 to $fp-452
	sw $t4, -460($fp)	# spill _tmp476 from $t4 to $fp-460
	sw $t5, -464($fp)	# spill _tmp477 from $t5 to $fp-464
	sw $t6, -468($fp)	# spill _tmp478 from $t6 to $fp-468
	beqz $t6, _L89	# branch if _tmp478 is zero 
	# _tmp479 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp480 = y - _tmp479
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	sub $t2, $t1, $t0	
	# j = _tmp480
	move $t3, $t2		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -476($fp)	# spill _tmp479 from $t0 to $fp-476
	sw $t2, -472($fp)	# spill _tmp480 from $t2 to $fp-472
	sw $t3, -12($fp)	# spill j from $t3 to $fp-12
_L90:
	# _tmp481 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp482 = y + _tmp481
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	add $t2, $t1, $t0	
	# _tmp483 = j < _tmp482
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp484 = j == _tmp482
	seq $t5, $t3, $t2	
	# _tmp485 = _tmp483 || _tmp484
	or $t6, $t4, $t5	
	# IfZ _tmp485 Goto _L91
	# (save modified registers before flow of control change)
	sw $t0, -484($fp)	# spill _tmp481 from $t0 to $fp-484
	sw $t2, -480($fp)	# spill _tmp482 from $t2 to $fp-480
	sw $t4, -488($fp)	# spill _tmp483 from $t4 to $fp-488
	sw $t5, -492($fp)	# spill _tmp484 from $t5 to $fp-492
	sw $t6, -496($fp)	# spill _tmp485 from $t6 to $fp-496
	beqz $t6, _L91	# branch if _tmp485 is zero 
	# _tmp486 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp487 = j < _tmp486
	lw $t2, -12($fp)	# load j from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# _tmp488 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp489 = _tmp488 < j
	slt $t5, $t4, $t2	
	# _tmp490 = j == _tmp488
	seq $t6, $t2, $t4	
	# _tmp491 = _tmp489 || _tmp490
	or $t7, $t5, $t6	
	# _tmp492 = *(this + 24)
	lw $s0, 24($t0) 	# load with offset
	# _tmp493 = i < _tmp492
	lw $s1, -8($fp)	# load i from $fp-8 into $s1
	slt $s2, $s1, $s0	
	# _tmp494 = 0
	li $s3, 0		# load constant value 0 into $s3
	# _tmp495 = _tmp494 < i
	slt $s4, $s3, $s1	
	# _tmp496 = i == _tmp494
	seq $s5, $s1, $s3	
	# _tmp497 = _tmp495 || _tmp496
	or $s6, $s4, $s5	
	# _tmp498 = _tmp497 && _tmp493
	and $s7, $s6, $s2	
	# _tmp499 = _tmp498 && _tmp491
	and $t8, $s7, $t7	
	# _tmp500 = _tmp499 && _tmp487
	and $t9, $t8, $t3	
	# IfZ _tmp500 Goto _L92
	# (save modified registers before flow of control change)
	sw $t1, -504($fp)	# spill _tmp486 from $t1 to $fp-504
	sw $t3, -508($fp)	# spill _tmp487 from $t3 to $fp-508
	sw $t4, -516($fp)	# spill _tmp488 from $t4 to $fp-516
	sw $t5, -520($fp)	# spill _tmp489 from $t5 to $fp-520
	sw $t6, -524($fp)	# spill _tmp490 from $t6 to $fp-524
	sw $t7, -528($fp)	# spill _tmp491 from $t7 to $fp-528
	sw $s0, -536($fp)	# spill _tmp492 from $s0 to $fp-536
	sw $s2, -540($fp)	# spill _tmp493 from $s2 to $fp-540
	sw $s3, -544($fp)	# spill _tmp494 from $s3 to $fp-544
	sw $s4, -548($fp)	# spill _tmp495 from $s4 to $fp-548
	sw $s5, -552($fp)	# spill _tmp496 from $s5 to $fp-552
	sw $s6, -556($fp)	# spill _tmp497 from $s6 to $fp-556
	sw $s7, -532($fp)	# spill _tmp498 from $s7 to $fp-532
	sw $t8, -512($fp)	# spill _tmp499 from $t8 to $fp-512
	sw $t9, -500($fp)	# spill _tmp500 from $t9 to $fp-500
	beqz $t9, _L92	# branch if _tmp500 is zero 
	# _tmp501 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp502 = *(_tmp501)
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
	# ACall _tmp502
	# (save modified registers before flow of control change)
	sw $t1, -560($fp)	# spill _tmp501 from $t1 to $fp-560
	sw $t2, -564($fp)	# spill _tmp502 from $t2 to $fp-564
	jalr $t2            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# Goto _L93
	b _L93		# unconditional branch
_L92:
_L93:
	# _tmp503 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp504 = j + _tmp503
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp504
	move $t1, $t2		# copy value
	# Goto _L90
	# (save modified registers before flow of control change)
	sw $t0, -572($fp)	# spill _tmp503 from $t0 to $fp-572
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -568($fp)	# spill _tmp504 from $t2 to $fp-568
	b _L90		# unconditional branch
_L91:
	# _tmp505 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp506 = i + _tmp505
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp506
	move $t1, $t2		# copy value
	# Goto _L88
	# (save modified registers before flow of control change)
	sw $t0, -580($fp)	# spill _tmp505 from $t0 to $fp-580
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -576($fp)	# spill _tmp506 from $t2 to $fp-576
	b _L88		# unconditional branch
_L89:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Field.HasNotBlownUp:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp507 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# Return _tmp507
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
__Field.HasClearedEverything:
	# BeginFunc 12
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp508 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# _tmp509 = *(this + 20)
	lw $t2, 20($t0) 	# load with offset
	# _tmp510 = _tmp508 == _tmp509
	seq $t3, $t1, $t2	
	# Return _tmp510
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
	# VTable for class Field
	.data
	.align 2
	Field:		# label for class Field vtable
	.word __Field.Expand
	.word __Field.GetHeight
	.word __Field.GetWidth
	.word __Field.HasClearedEverything
	.word __Field.HasNotBlownUp
	.word __Field.Init
	.word __Field.PlantMines
	.word __Field.PlantOneMine
	.word __Field.PrintField
	.text
__Game.Init:
	# BeginFunc 32
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 32	# decrement sp to make space for locals/temps
	# _tmp511 = 28
	li $t0, 28		# load constant value 28 into $t0
	# PushParam _tmp511
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp512 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp511 from $t0 to $fp-8
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp513 = Field
	la $t1, Field	# load label
	# *(_tmp512) = _tmp513
	sw $t1, 0($t0) 	# store with offset
	# _tmp514 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp515 = this + _tmp514
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp515) = _tmp512
	sw $t0, 0($t4) 	# store with offset
	# _tmp516 = *(this + 4)
	lw $t5, 4($t3) 	# load with offset
	# _tmp517 = *(_tmp516)
	lw $t6, 0($t5) 	# load with offset
	# _tmp518 = *(_tmp517 + 20)
	lw $t7, 20($t6) 	# load with offset
	# PushParam height
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $s0, 12($fp)	# load height from $fp+12 into $s0
	sw $s0, 4($sp)	# copy param value to stack
	# PushParam width
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $s1, 8($fp)	# load width from $fp+8 into $s1
	sw $s1, 4($sp)	# copy param value to stack
	# PushParam _tmp516
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# ACall _tmp518
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp512 from $t0 to $fp-12
	sw $t1, -16($fp)	# spill _tmp513 from $t1 to $fp-16
	sw $t2, -20($fp)	# spill _tmp514 from $t2 to $fp-20
	sw $t4, -24($fp)	# spill _tmp515 from $t4 to $fp-24
	sw $t5, -28($fp)	# spill _tmp516 from $t5 to $fp-28
	sw $t6, -32($fp)	# spill _tmp517 from $t6 to $fp-32
	sw $t7, -36($fp)	# spill _tmp518 from $t7 to $fp-36
	jalr $t7            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Game.PlayGame:
	# BeginFunc 260
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 260	# decrement sp to make space for locals/temps
_L94:
	# _tmp519 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp520 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp521 = *(_tmp520)
	lw $t3, 0($t2) 	# load with offset
	# _tmp522 = *(_tmp521 + 12)
	lw $t4, 12($t3) 	# load with offset
	# PushParam _tmp520
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp523 = ACall _tmp522
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp519 from $t0 to $fp-20
	sw $t2, -28($fp)	# spill _tmp520 from $t2 to $fp-28
	sw $t3, -32($fp)	# spill _tmp521 from $t3 to $fp-32
	sw $t4, -36($fp)	# spill _tmp522 from $t4 to $fp-36
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp524 = _tmp519 - _tmp523
	lw $t1, -20($fp)	# load _tmp519 from $fp-20 into $t1
	sub $t2, $t1, $t0	
	# _tmp525 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp526 = *(_tmp525)
	lw $t5, 0($t4) 	# load with offset
	# _tmp527 = *(_tmp526 + 16)
	lw $t6, 16($t5) 	# load with offset
	# PushParam _tmp525
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp528 = ACall _tmp527
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp523 from $t0 to $fp-40
	sw $t2, -24($fp)	# spill _tmp524 from $t2 to $fp-24
	sw $t4, -44($fp)	# spill _tmp525 from $t4 to $fp-44
	sw $t5, -48($fp)	# spill _tmp526 from $t5 to $fp-48
	sw $t6, -52($fp)	# spill _tmp527 from $t6 to $fp-52
	jalr $t6            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp529 = _tmp528 && _tmp524
	lw $t1, -24($fp)	# load _tmp524 from $fp-24 into $t1
	and $t2, $t0, $t1	
	# IfZ _tmp529 Goto _L95
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp528 from $t0 to $fp-56
	sw $t2, -16($fp)	# spill _tmp529 from $t2 to $fp-16
	beqz $t2, _L95	# branch if _tmp529 is zero 
	# _tmp530 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp531 = *(_tmp530)
	lw $t2, 0($t1) 	# load with offset
	# _tmp532 = *(_tmp531 + 32)
	lw $t3, 32($t2) 	# load with offset
	# _tmp533 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp533
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp530
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp532
	# (save modified registers before flow of control change)
	sw $t1, -60($fp)	# spill _tmp530 from $t1 to $fp-60
	sw $t2, -64($fp)	# spill _tmp531 from $t2 to $fp-64
	sw $t3, -68($fp)	# spill _tmp532 from $t3 to $fp-68
	sw $t4, -72($fp)	# spill _tmp533 from $t4 to $fp-72
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp534 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp535 = *(_tmp534 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp536 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp537 = *(this + 4)
	lw $t4, 4($t0) 	# load with offset
	# _tmp538 = *(_tmp537)
	lw $t5, 0($t4) 	# load with offset
	# _tmp539 = *(_tmp538 + 8)
	lw $t6, 8($t5) 	# load with offset
	# PushParam _tmp537
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp540 = ACall _tmp539
	# (save modified registers before flow of control change)
	sw $t1, -76($fp)	# spill _tmp534 from $t1 to $fp-76
	sw $t2, -80($fp)	# spill _tmp535 from $t2 to $fp-80
	sw $t3, -88($fp)	# spill _tmp536 from $t3 to $fp-88
	sw $t4, -92($fp)	# spill _tmp537 from $t4 to $fp-92
	sw $t5, -96($fp)	# spill _tmp538 from $t5 to $fp-96
	sw $t6, -100($fp)	# spill _tmp539 from $t6 to $fp-100
	jalr $t6            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp541 = _tmp540 - _tmp536
	lw $t1, -88($fp)	# load _tmp536 from $fp-88 into $t1
	sub $t2, $t0, $t1	
	# PushParam _tmp541
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp542 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp543 = 3
	li $t4, 3		# load constant value 3 into $t4
	# _tmp544 = _tmp542 - _tmp543
	sub $t5, $t3, $t4	
	# PushParam _tmp544
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# _tmp545 = "Enter horizontal coordinate, -1 to quit, -2 for h..."
	.data			# create string constant marked with label
	_string35: .asciiz "Enter horizontal coordinate, -1 to quit, -2 for help, -3 for grid: "
	.text
	la $t6, _string35	# load label
	# PushParam _tmp545
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t7, 4($fp)	# load this from $fp+4 into $t7
	sw $t7, 4($sp)	# copy param value to stack
	# _tmp546 = ACall _tmp535
	lw $s0, -80($fp)	# load _tmp535 from $fp-80 into $s0
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp540 from $t0 to $fp-104
	sw $t2, -84($fp)	# spill _tmp541 from $t2 to $fp-84
	sw $t3, -108($fp)	# spill _tmp542 from $t3 to $fp-108
	sw $t4, -116($fp)	# spill _tmp543 from $t4 to $fp-116
	sw $t5, -112($fp)	# spill _tmp544 from $t5 to $fp-112
	sw $t6, -120($fp)	# spill _tmp545 from $t6 to $fp-120
	jalr $s0            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# x = _tmp546
	move $t1, $t0		# copy value
	# _tmp547 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp548 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp549 = _tmp547 - _tmp548
	sub $t4, $t2, $t3	
	# _tmp550 = x == _tmp549
	seq $t5, $t1, $t4	
	# IfZ _tmp550 Goto _L96
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp546 from $t0 to $fp-124
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -128($fp)	# spill _tmp547 from $t2 to $fp-128
	sw $t3, -136($fp)	# spill _tmp548 from $t3 to $fp-136
	sw $t4, -132($fp)	# spill _tmp549 from $t4 to $fp-132
	sw $t5, -140($fp)	# spill _tmp550 from $t5 to $fp-140
	beqz $t5, _L96	# branch if _tmp550 is zero 
	# Goto _L95
	b _L95		# unconditional branch
	# Goto _L97
	b _L97		# unconditional branch
_L96:
_L97:
	# _tmp551 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp552 = *(_tmp551 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp553 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp554 = *(this + 4)
	lw $t4, 4($t0) 	# load with offset
	# _tmp555 = *(_tmp554)
	lw $t5, 0($t4) 	# load with offset
	# _tmp556 = *(_tmp555 + 4)
	lw $t6, 4($t5) 	# load with offset
	# PushParam _tmp554
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# _tmp557 = ACall _tmp556
	# (save modified registers before flow of control change)
	sw $t1, -144($fp)	# spill _tmp551 from $t1 to $fp-144
	sw $t2, -148($fp)	# spill _tmp552 from $t2 to $fp-148
	sw $t3, -156($fp)	# spill _tmp553 from $t3 to $fp-156
	sw $t4, -160($fp)	# spill _tmp554 from $t4 to $fp-160
	sw $t5, -164($fp)	# spill _tmp555 from $t5 to $fp-164
	sw $t6, -168($fp)	# spill _tmp556 from $t6 to $fp-168
	jalr $t6            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp558 = _tmp557 - _tmp553
	lw $t1, -156($fp)	# load _tmp553 from $fp-156 into $t1
	sub $t2, $t0, $t1	
	# PushParam _tmp558
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp559 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp560 = 3
	li $t4, 3		# load constant value 3 into $t4
	# _tmp561 = _tmp559 - _tmp560
	sub $t5, $t3, $t4	
	# PushParam _tmp561
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# _tmp562 = "Enter vertical coordinate, -1 to quit, -2 for hel..."
	.data			# create string constant marked with label
	_string36: .asciiz "Enter vertical coordinate, -1 to quit, -2 for help, -3 for grid: "
	.text
	la $t6, _string36	# load label
	# PushParam _tmp562
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t7, 4($fp)	# load this from $fp+4 into $t7
	sw $t7, 4($sp)	# copy param value to stack
	# _tmp563 = ACall _tmp552
	lw $s0, -148($fp)	# load _tmp552 from $fp-148 into $s0
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp557 from $t0 to $fp-172
	sw $t2, -152($fp)	# spill _tmp558 from $t2 to $fp-152
	sw $t3, -176($fp)	# spill _tmp559 from $t3 to $fp-176
	sw $t4, -184($fp)	# spill _tmp560 from $t4 to $fp-184
	sw $t5, -180($fp)	# spill _tmp561 from $t5 to $fp-180
	sw $t6, -188($fp)	# spill _tmp562 from $t6 to $fp-188
	jalr $s0            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# y = _tmp563
	move $t1, $t0		# copy value
	# _tmp564 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp565 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp566 = _tmp564 - _tmp565
	sub $t4, $t2, $t3	
	# _tmp567 = y == _tmp566
	seq $t5, $t1, $t4	
	# IfZ _tmp567 Goto _L98
	# (save modified registers before flow of control change)
	sw $t0, -192($fp)	# spill _tmp563 from $t0 to $fp-192
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
	sw $t2, -196($fp)	# spill _tmp564 from $t2 to $fp-196
	sw $t3, -204($fp)	# spill _tmp565 from $t3 to $fp-204
	sw $t4, -200($fp)	# spill _tmp566 from $t4 to $fp-200
	sw $t5, -208($fp)	# spill _tmp567 from $t5 to $fp-208
	beqz $t5, _L98	# branch if _tmp567 is zero 
	# Goto _L95
	b _L95		# unconditional branch
	# Goto _L99
	b _L99		# unconditional branch
_L98:
_L99:
	# _tmp568 = "Clearing ("
	.data			# create string constant marked with label
	_string37: .asciiz "Clearing ("
	.text
	la $t0, _string37	# load label
	# PushParam _tmp568
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -212($fp)	# spill _tmp568 from $t0 to $fp-212
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load x from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp569 = ", "
	.data			# create string constant marked with label
	_string38: .asciiz ", "
	.text
	la $t0, _string38	# load label
	# PushParam _tmp569
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -216($fp)	# spill _tmp569 from $t0 to $fp-216
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load y from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp570 = ")\n"
	.data			# create string constant marked with label
	_string39: .asciiz ")\n"
	.text
	la $t0, _string39	# load label
	# PushParam _tmp570
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -220($fp)	# spill _tmp570 from $t0 to $fp-220
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp571 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp572 = *(_tmp571)
	lw $t2, 0($t1) 	# load with offset
	# _tmp573 = *(_tmp572)
	lw $t3, 0($t2) 	# load with offset
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load y from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load x from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam _tmp571
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp573
	# (save modified registers before flow of control change)
	sw $t1, -224($fp)	# spill _tmp571 from $t1 to $fp-224
	sw $t2, -228($fp)	# spill _tmp572 from $t2 to $fp-228
	sw $t3, -232($fp)	# spill _tmp573 from $t3 to $fp-232
	jalr $t3            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# Goto _L94
	b _L94		# unconditional branch
_L95:
	# _tmp574 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp575 = *(_tmp574)
	lw $t2, 0($t1) 	# load with offset
	# _tmp576 = *(_tmp575 + 16)
	lw $t3, 16($t2) 	# load with offset
	# PushParam _tmp574
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp577 = ACall _tmp576
	# (save modified registers before flow of control change)
	sw $t1, -236($fp)	# spill _tmp574 from $t1 to $fp-236
	sw $t2, -240($fp)	# spill _tmp575 from $t2 to $fp-240
	sw $t3, -244($fp)	# spill _tmp576 from $t3 to $fp-244
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp577 Goto _L100
	# (save modified registers before flow of control change)
	sw $t0, -248($fp)	# spill _tmp577 from $t0 to $fp-248
	beqz $t0, _L100	# branch if _tmp577 is zero 
	# _tmp578 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp579 = *(_tmp578 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp579
	# (save modified registers before flow of control change)
	sw $t1, -252($fp)	# spill _tmp578 from $t1 to $fp-252
	sw $t2, -256($fp)	# spill _tmp579 from $t2 to $fp-256
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L101
	b _L101		# unconditional branch
_L100:
	# _tmp580 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp581 = *(_tmp580)
	lw $t2, 0($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp581
	# (save modified registers before flow of control change)
	sw $t1, -260($fp)	# spill _tmp580 from $t1 to $fp-260
	sw $t2, -264($fp)	# spill _tmp581 from $t2 to $fp-264
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L101:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Game.PromptForInt:
	# BeginFunc 116
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 116	# decrement sp to make space for locals/temps
_L102:
	# _tmp582 = 1
	li $t0, 1		# load constant value 1 into $t0
	# IfZ _tmp582 Goto _L103
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp582 from $t0 to $fp-12
	beqz $t0, _L103	# branch if _tmp582 is zero 
	# PushParam prompt
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, 8($fp)	# load prompt from $fp+8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp583 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# x = _tmp583
	move $t1, $t0		# copy value
	# _tmp584 = x < max
	lw $t2, 16($fp)	# load max from $fp+16 into $t2
	slt $t3, $t1, $t2	
	# _tmp585 = x == max
	seq $t4, $t1, $t2	
	# _tmp586 = _tmp584 || _tmp585
	or $t5, $t3, $t4	
	# _tmp587 = min < x
	lw $t6, 12($fp)	# load min from $fp+12 into $t6
	slt $t7, $t6, $t1	
	# _tmp588 = x == min
	seq $s0, $t1, $t6	
	# _tmp589 = _tmp587 || _tmp588
	or $s1, $t7, $s0	
	# _tmp590 = _tmp589 && _tmp586
	and $s2, $s1, $t5	
	# IfZ _tmp590 Goto _L104
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp583 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t3, -24($fp)	# spill _tmp584 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp585 from $t4 to $fp-28
	sw $t5, -32($fp)	# spill _tmp586 from $t5 to $fp-32
	sw $t7, -36($fp)	# spill _tmp587 from $t7 to $fp-36
	sw $s0, -40($fp)	# spill _tmp588 from $s0 to $fp-40
	sw $s1, -44($fp)	# spill _tmp589 from $s1 to $fp-44
	sw $s2, -20($fp)	# spill _tmp590 from $s2 to $fp-20
	beqz $s2, _L104	# branch if _tmp590 is zero 
	# _tmp591 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp592 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp593 = _tmp591 - _tmp592
	sub $t2, $t0, $t1	
	# _tmp594 = x == _tmp593
	lw $t3, -8($fp)	# load x from $fp-8 into $t3
	seq $t4, $t3, $t2	
	# IfZ _tmp594 Goto _L106
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp591 from $t0 to $fp-48
	sw $t1, -56($fp)	# spill _tmp592 from $t1 to $fp-56
	sw $t2, -52($fp)	# spill _tmp593 from $t2 to $fp-52
	sw $t4, -60($fp)	# spill _tmp594 from $t4 to $fp-60
	beqz $t4, _L106	# branch if _tmp594 is zero 
	# _tmp595 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp596 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp597 = _tmp595 - _tmp596
	sub $t2, $t0, $t1	
	# Return _tmp597
	move $v0, $t2		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L107
	b _L107		# unconditional branch
_L106:
_L107:
	# _tmp598 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp599 = 2
	li $t1, 2		# load constant value 2 into $t1
	# _tmp600 = _tmp598 - _tmp599
	sub $t2, $t0, $t1	
	# _tmp601 = x == _tmp600
	lw $t3, -8($fp)	# load x from $fp-8 into $t3
	seq $t4, $t3, $t2	
	# IfZ _tmp601 Goto _L108
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp598 from $t0 to $fp-76
	sw $t1, -84($fp)	# spill _tmp599 from $t1 to $fp-84
	sw $t2, -80($fp)	# spill _tmp600 from $t2 to $fp-80
	sw $t4, -88($fp)	# spill _tmp601 from $t4 to $fp-88
	beqz $t4, _L108	# branch if _tmp601 is zero 
	# LCall __PrintHelp
	jal __PrintHelp    	# jump to function
	# Goto _L109
	b _L109		# unconditional branch
_L108:
	# _tmp602 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp603 = 3
	li $t1, 3		# load constant value 3 into $t1
	# _tmp604 = _tmp602 - _tmp603
	sub $t2, $t0, $t1	
	# _tmp605 = x == _tmp604
	lw $t3, -8($fp)	# load x from $fp-8 into $t3
	seq $t4, $t3, $t2	
	# IfZ _tmp605 Goto _L110
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp602 from $t0 to $fp-92
	sw $t1, -100($fp)	# spill _tmp603 from $t1 to $fp-100
	sw $t2, -96($fp)	# spill _tmp604 from $t2 to $fp-96
	sw $t4, -104($fp)	# spill _tmp605 from $t4 to $fp-104
	beqz $t4, _L110	# branch if _tmp605 is zero 
	# _tmp606 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp607 = *(_tmp606)
	lw $t2, 0($t1) 	# load with offset
	# _tmp608 = *(_tmp607 + 32)
	lw $t3, 32($t2) 	# load with offset
	# _tmp609 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp609
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp606
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp608
	# (save modified registers before flow of control change)
	sw $t1, -108($fp)	# spill _tmp606 from $t1 to $fp-108
	sw $t2, -112($fp)	# spill _tmp607 from $t2 to $fp-112
	sw $t3, -116($fp)	# spill _tmp608 from $t3 to $fp-116
	sw $t4, -120($fp)	# spill _tmp609 from $t4 to $fp-120
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L111
	b _L111		# unconditional branch
_L110:
	# Return x
	lw $t0, -8($fp)	# load x from $fp-8 into $t0
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
_L111:
_L109:
	# Goto _L105
	b _L105		# unconditional branch
_L104:
_L105:
	# Goto _L102
	b _L102		# unconditional branch
_L103:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Game.AnnounceWin:
	# BeginFunc 40
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# _tmp610 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp611 = *(_tmp610)
	lw $t2, 0($t1) 	# load with offset
	# _tmp612 = *(_tmp611 + 32)
	lw $t3, 32($t2) 	# load with offset
	# _tmp613 = 1
	li $t4, 1		# load constant value 1 into $t4
	# PushParam _tmp613
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp610
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp612
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp610 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp611 from $t2 to $fp-12
	sw $t3, -16($fp)	# spill _tmp612 from $t3 to $fp-16
	sw $t4, -20($fp)	# spill _tmp613 from $t4 to $fp-20
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp614 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp615 = *(_tmp614)
	lw $t2, 0($t1) 	# load with offset
	# _tmp616 = *(_tmp615 + 12)
	lw $t3, 12($t2) 	# load with offset
	# PushParam _tmp614
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp617 = ACall _tmp616
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp614 from $t1 to $fp-24
	sw $t2, -28($fp)	# spill _tmp615 from $t2 to $fp-28
	sw $t3, -32($fp)	# spill _tmp616 from $t3 to $fp-32
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp617 Goto _L112
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp617 from $t0 to $fp-36
	beqz $t0, _L112	# branch if _tmp617 is zero 
	# _tmp618 = "You win!  Good job.\n"
	.data			# create string constant marked with label
	_string40: .asciiz "You win!  Good job.\n"
	.text
	la $t0, _string40	# load label
	# PushParam _tmp618
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp618 from $t0 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L113
	b _L113		# unconditional branch
_L112:
	# _tmp619 = "Quitter!!\n"
	.data			# create string constant marked with label
	_string41: .asciiz "Quitter!!\n"
	.text
	la $t0, _string41	# load label
	# PushParam _tmp619
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp619 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L113:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Game.AnnounceLoss:
	# BeginFunc 20
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 20	# decrement sp to make space for locals/temps
	# _tmp620 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp621 = *(_tmp620)
	lw $t2, 0($t1) 	# load with offset
	# _tmp622 = *(_tmp621 + 32)
	lw $t3, 32($t2) 	# load with offset
	# _tmp623 = 1
	li $t4, 1		# load constant value 1 into $t4
	# PushParam _tmp623
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp620
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp622
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp620 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp621 from $t2 to $fp-12
	sw $t3, -16($fp)	# spill _tmp622 from $t3 to $fp-16
	sw $t4, -20($fp)	# spill _tmp623 from $t4 to $fp-20
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp624 = "Ha ha!! You blew up!!  Ha ha!!\n"
	.data			# create string constant marked with label
	_string42: .asciiz "Ha ha!! You blew up!!  Ha ha!!\n"
	.text
	la $t0, _string42	# load label
	# PushParam _tmp624
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp624 from $t0 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Game
	.data
	.align 2
	Game:		# label for class Game vtable
	.word __Game.AnnounceLoss
	.word __Game.AnnounceWin
	.word __Game.Init
	.word __Game.PlayGame
	.word __Game.PromptForInt
	.text
__PrintHelp:
	# BeginFunc 72
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 72	# decrement sp to make space for locals/temps
	# _tmp625 = "Welcome to Low-Fat Decaf Minesweeper!\n"
	.data			# create string constant marked with label
	_string43: .asciiz "Welcome to Low-Fat Decaf Minesweeper!\n"
	.text
	la $t0, _string43	# load label
	# PushParam _tmp625
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp625 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp626 = "On the screen you will see a grid that represents..."
	.data			# create string constant marked with label
	_string44: .asciiz "On the screen you will see a grid that represents your field.\n"
	.text
	la $t0, _string44	# load label
	# PushParam _tmp626
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp626 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp627 = "In each location there may or may not be a mine h..."
	.data			# create string constant marked with label
	_string45: .asciiz "In each location there may or may not be a mine hidden.  In \n"
	.text
	la $t0, _string45	# load label
	# PushParam _tmp627
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp627 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp628 = "order to clear the field, enter in the coordinate..."
	.data			# create string constant marked with label
	_string46: .asciiz "order to clear the field, enter in the coordinates of the \n"
	.text
	la $t0, _string46	# load label
	# PushParam _tmp628
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp628 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp629 = "location you want to uncover.\n\n"
	.data			# create string constant marked with label
	_string47: .asciiz "location you want to uncover.\n\n"
	.text
	la $t0, _string47	# load label
	# PushParam _tmp629
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp629 from $t0 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp630 = "As you clear mines, the grid will change.  There ..."
	.data			# create string constant marked with label
	_string48: .asciiz "As you clear mines, the grid will change.  There are two symbols:\n"
	.text
	la $t0, _string48	# load label
	# PushParam _tmp630
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp630 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp631 = "    '+'  - you haven't uncovered this location ye..."
	.data			# create string constant marked with label
	_string49: .asciiz "    '+'  - you haven't uncovered this location yet\n"
	.text
	la $t0, _string49	# load label
	# PushParam _tmp631
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp631 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp632 = "a number - there is no mine here, but there are t..."
	.data			# create string constant marked with label
	_string50: .asciiz "a number - there is no mine here, but there are the specified \n"
	.text
	la $t0, _string50	# load label
	# PushParam _tmp632
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp632 from $t0 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp633 = "           number of mines directly adjacent to t..."
	.data			# create string constant marked with label
	_string51: .asciiz "           number of mines directly adjacent to this location\n"
	.text
	la $t0, _string51	# load label
	# PushParam _tmp633
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp633 from $t0 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp634 = "           (including diagonals)\n"
	.data			# create string constant marked with label
	_string52: .asciiz "           (including diagonals)\n"
	.text
	la $t0, _string52	# load label
	# PushParam _tmp634
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp634 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp635 = "The field will keep on expanding from the point y..."
	.data			# create string constant marked with label
	_string53: .asciiz "The field will keep on expanding from the point you specified\n"
	.text
	la $t0, _string53	# load label
	# PushParam _tmp635
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp635 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp636 = "and clear all adjacent points that have no mines...."
	.data			# create string constant marked with label
	_string54: .asciiz "and clear all adjacent points that have no mines.\n\n"
	.text
	la $t0, _string54	# load label
	# PushParam _tmp636
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp636 from $t0 to $fp-52
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp637 = "If you uncover a location with a mine, you die, a..."
	.data			# create string constant marked with label
	_string55: .asciiz "If you uncover a location with a mine, you die, and the solution\n"
	.text
	la $t0, _string55	# load label
	# PushParam _tmp637
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp637 from $t0 to $fp-56
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp638 = "will be printed.  The solution will show these sy..."
	.data			# create string constant marked with label
	_string56: .asciiz "will be printed.  The solution will show these symbols: \n"
	.text
	la $t0, _string56	# load label
	# PushParam _tmp638
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp638 from $t0 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp639 = "    'x'  - this location has a mine\n"
	.data			# create string constant marked with label
	_string57: .asciiz "    'x'  - this location has a mine\n"
	.text
	la $t0, _string57	# load label
	# PushParam _tmp639
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp639 from $t0 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp640 = "    '%'  - this is where you blew up\n"
	.data			# create string constant marked with label
	_string58: .asciiz "    '%'  - this is where you blew up\n"
	.text
	la $t0, _string58	# load label
	# PushParam _tmp640
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp640 from $t0 to $fp-68
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp641 = "a number - same as before\n\n"
	.data			# create string constant marked with label
	_string59: .asciiz "a number - same as before\n\n"
	.text
	la $t0, _string59	# load label
	# PushParam _tmp641
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp641 from $t0 to $fp-72
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp642 = "You win when you have uncovered all locations wit..."
	.data			# create string constant marked with label
	_string60: .asciiz "You win when you have uncovered all locations without a mine.\n"
	.text
	la $t0, _string60	# load label
	# PushParam _tmp642
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp642 from $t0 to $fp-76
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
	# BeginFunc 92
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 92	# decrement sp to make space for locals/temps
	# _tmp643 = 8
	li $t0, 8		# load constant value 8 into $t0
	# PushParam _tmp643
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp644 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp643 from $t0 to $fp-20
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp645 = rndModule
	la $t1, rndModule	# load label
	# *(_tmp644) = _tmp645
	sw $t1, 0($t0) 	# store with offset
	# gRnd = _tmp644
	move $t2, $t0		# copy value
	# _tmp646 = "Please enter in a random seed: "
	.data			# create string constant marked with label
	_string61: .asciiz "Please enter in a random seed: "
	.text
	la $t3, _string61	# load label
	# PushParam _tmp646
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp644 from $t0 to $fp-24
	sw $t1, -28($fp)	# spill _tmp645 from $t1 to $fp-28
	sw $t2, 8($gp)	# spill gRnd from $t2 to $gp+8
	sw $t3, -32($fp)	# spill _tmp646 from $t3 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp647 = *(gRnd)
	lw $t0, 8($gp)	# load gRnd from $gp+8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp648 = *(_tmp647)
	lw $t2, 0($t1) 	# load with offset
	# _tmp649 = LCall _ReadInteger
	# (save modified registers before flow of control change)
	sw $t1, -36($fp)	# spill _tmp647 from $t1 to $fp-36
	sw $t2, -40($fp)	# spill _tmp648 from $t2 to $fp-40
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PushParam _tmp649
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, 8($gp)	# load gRnd from $gp+8 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp648
	lw $t2, -40($fp)	# load _tmp648 from $fp-40 into $t2
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp649 from $t0 to $fp-44
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp650 = "How much of the field do you want to have mines? ..."
	.data			# create string constant marked with label
	_string62: .asciiz "How much of the field do you want to have mines? (0%-100%) "
	.text
	la $t0, _string62	# load label
	# PushParam _tmp650
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp650 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp651 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# probOfMine = _tmp651
	move $t1, $t0		# copy value
	# _tmp652 = "How wide do you want the field to be? "
	.data			# create string constant marked with label
	_string63: .asciiz "How wide do you want the field to be? "
	.text
	la $t2, _string63	# load label
	# PushParam _tmp652
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp651 from $t0 to $fp-52
	sw $t1, 0($gp)	# spill probOfMine from $t1 to $gp+0
	sw $t2, -56($fp)	# spill _tmp652 from $t2 to $fp-56
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp653 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# w = _tmp653
	move $t1, $t0		# copy value
	# _tmp654 = "How tall do you want the field to be? "
	.data			# create string constant marked with label
	_string64: .asciiz "How tall do you want the field to be? "
	.text
	la $t2, _string64	# load label
	# PushParam _tmp654
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp653 from $t0 to $fp-60
	sw $t1, -8($fp)	# spill w from $t1 to $fp-8
	sw $t2, -64($fp)	# spill _tmp654 from $t2 to $fp-64
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp655 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# h = _tmp655
	move $t1, $t0		# copy value
	# _tmp656 = 8
	li $t2, 8		# load constant value 8 into $t2
	# PushParam _tmp656
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp657 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp655 from $t0 to $fp-68
	sw $t1, -12($fp)	# spill h from $t1 to $fp-12
	sw $t2, -72($fp)	# spill _tmp656 from $t2 to $fp-72
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp658 = Game
	la $t1, Game	# load label
	# *(_tmp657) = _tmp658
	sw $t1, 0($t0) 	# store with offset
	# g = _tmp657
	move $t2, $t0		# copy value
	# _tmp659 = *(g)
	lw $t3, 0($t2) 	# load with offset
	# _tmp660 = *(_tmp659 + 8)
	lw $t4, 8($t3) 	# load with offset
	# PushParam h
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -12($fp)	# load h from $fp-12 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam w
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, -8($fp)	# load w from $fp-8 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam g
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp660
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp657 from $t0 to $fp-76
	sw $t1, -80($fp)	# spill _tmp658 from $t1 to $fp-80
	sw $t2, -16($fp)	# spill g from $t2 to $fp-16
	sw $t3, -84($fp)	# spill _tmp659 from $t3 to $fp-84
	sw $t4, -88($fp)	# spill _tmp660 from $t4 to $fp-88
	jalr $t4            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp661 = *(g)
	lw $t0, -16($fp)	# load g from $fp-16 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp662 = *(_tmp661 + 12)
	lw $t2, 12($t1) 	# load with offset
	# PushParam g
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp662
	# (save modified registers before flow of control change)
	sw $t1, -92($fp)	# spill _tmp661 from $t1 to $fp-92
	sw $t2, -96($fp)	# spill _tmp662 from $t2 to $fp-96
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
