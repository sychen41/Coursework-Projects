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
__cell.Init:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp18 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp19 = this + _tmp18
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp19) = state
	lw $t3, 8($fp)	# load state from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__cell.GetState:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp20 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# Return _tmp20
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
__cell.SetState:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp21 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp22 = this + _tmp21
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp22) = state
	lw $t3, 8($fp)	# load state from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class cell
	.data
	.align 2
	cell:		# label for class cell vtable
	.word __cell.GetState
	.word __cell.Init
	.word __cell.SetState
	.text
__column.GetY:
	# BeginFunc 44
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 44	# decrement sp to make space for locals/temps
	# _tmp23 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp24 = *(_tmp23)
	lw $t2, 0($t1) 	# load with offset
	# _tmp25 = y < _tmp24
	lw $t3, 8($fp)	# load y from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp26 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp27 = _tmp26 < y
	slt $t6, $t5, $t3	
	# _tmp28 = _tmp27 && _tmp25
	and $t7, $t6, $t4	
	# IfZ _tmp28 Goto _L0
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp23 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp24 from $t2 to $fp-12
	sw $t4, -16($fp)	# spill _tmp25 from $t4 to $fp-16
	sw $t5, -20($fp)	# spill _tmp26 from $t5 to $fp-20
	sw $t6, -24($fp)	# spill _tmp27 from $t6 to $fp-24
	sw $t7, -28($fp)	# spill _tmp28 from $t7 to $fp-28
	beqz $t7, _L0	# branch if _tmp28 is zero 
	# _tmp29 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp30 = y * _tmp29
	lw $t1, 8($fp)	# load y from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp31 = _tmp30 + _tmp29
	add $t3, $t2, $t0	
	# _tmp32 = _tmp23 + _tmp31
	lw $t4, -8($fp)	# load _tmp23 from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L1
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp29 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp30 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp31 from $t3 to $fp-40
	sw $t5, -40($fp)	# spill _tmp32 from $t5 to $fp-40
	b _L1		# unconditional branch
_L0:
	# _tmp33 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string1: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp33
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp33 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L1:
	# _tmp34 = *(_tmp32)
	lw $t0, -40($fp)	# load _tmp32 from $fp-40 into $t0
	lw $t1, 0($t0) 	# load with offset
	# Return _tmp34
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
__column.SetY:
	# BeginFunc 40
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# _tmp35 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp36 = *(_tmp35)
	lw $t2, 0($t1) 	# load with offset
	# _tmp37 = y < _tmp36
	lw $t3, 8($fp)	# load y from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp38 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp39 = _tmp38 < y
	slt $t6, $t5, $t3	
	# _tmp40 = _tmp39 && _tmp37
	and $t7, $t6, $t4	
	# IfZ _tmp40 Goto _L2
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp35 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp36 from $t2 to $fp-12
	sw $t4, -16($fp)	# spill _tmp37 from $t4 to $fp-16
	sw $t5, -20($fp)	# spill _tmp38 from $t5 to $fp-20
	sw $t6, -24($fp)	# spill _tmp39 from $t6 to $fp-24
	sw $t7, -28($fp)	# spill _tmp40 from $t7 to $fp-28
	beqz $t7, _L2	# branch if _tmp40 is zero 
	# _tmp41 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp42 = y * _tmp41
	lw $t1, 8($fp)	# load y from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp43 = _tmp42 + _tmp41
	add $t3, $t2, $t0	
	# _tmp44 = _tmp35 + _tmp43
	lw $t4, -8($fp)	# load _tmp35 from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp41 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp42 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp43 from $t3 to $fp-40
	sw $t5, -40($fp)	# spill _tmp44 from $t5 to $fp-40
	b _L3		# unconditional branch
_L2:
	# _tmp45 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string2: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string2	# load label
	# PushParam _tmp45
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp45 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L3:
	# *(_tmp44) = c
	lw $t0, 12($fp)	# load c from $fp+12 into $t0
	lw $t1, -40($fp)	# load _tmp44 from $fp-40 into $t1
	sw $t0, 0($t1) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__column.Init:
	# BeginFunc 180
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 180	# decrement sp to make space for locals/temps
	# _tmp46 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp47 = length < _tmp46
	lw $t1, 8($fp)	# load length from $fp+8 into $t1
	slt $t2, $t1, $t0	
	# _tmp48 = length == _tmp46
	seq $t3, $t1, $t0	
	# _tmp49 = _tmp47 || _tmp48
	or $t4, $t2, $t3	
	# IfZ _tmp49 Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp46 from $t0 to $fp-12
	sw $t2, -16($fp)	# spill _tmp47 from $t2 to $fp-16
	sw $t3, -20($fp)	# spill _tmp48 from $t3 to $fp-20
	sw $t4, -24($fp)	# spill _tmp49 from $t4 to $fp-24
	beqz $t4, _L4	# branch if _tmp49 is zero 
	# _tmp50 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string3: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp50
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp50 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L4:
	# _tmp51 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp52 = length * _tmp51
	lw $t1, 8($fp)	# load length from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp53 = _tmp52 + _tmp51
	add $t3, $t2, $t0	
	# PushParam _tmp53
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp54 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp51 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp52 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp53 from $t3 to $fp-40
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp54) = length
	lw $t1, 8($fp)	# load length from $fp+8 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp55 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp56 = this + _tmp55
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp56) = _tmp54
	sw $t0, 0($t4) 	# store with offset
	# _tmp57 = 8
	li $t5, 8		# load constant value 8 into $t5
	# _tmp58 = this + _tmp57
	add $t6, $t3, $t5	
	# *(_tmp58) = length
	sw $t1, 0($t6) 	# store with offset
	# _tmp59 = 0
	li $t7, 0		# load constant value 0 into $t7
	# y = _tmp59
	move $s0, $t7		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp54 from $t0 to $fp-44
	sw $t2, -48($fp)	# spill _tmp55 from $t2 to $fp-48
	sw $t4, -52($fp)	# spill _tmp56 from $t4 to $fp-52
	sw $t5, -56($fp)	# spill _tmp57 from $t5 to $fp-56
	sw $t6, -60($fp)	# spill _tmp58 from $t6 to $fp-60
	sw $t7, -64($fp)	# spill _tmp59 from $t7 to $fp-64
	sw $s0, -8($fp)	# spill y from $s0 to $fp-8
_L5:
	# _tmp60 = y < length
	lw $t0, -8($fp)	# load y from $fp-8 into $t0
	lw $t1, 8($fp)	# load length from $fp+8 into $t1
	slt $t2, $t0, $t1	
	# IfZ _tmp60 Goto _L6
	# (save modified registers before flow of control change)
	sw $t2, -68($fp)	# spill _tmp60 from $t2 to $fp-68
	beqz $t2, _L6	# branch if _tmp60 is zero 
	# _tmp61 = 8
	li $t0, 8		# load constant value 8 into $t0
	# PushParam _tmp61
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp62 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp61 from $t0 to $fp-72
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp63 = cell
	la $t1, cell	# load label
	# *(_tmp62) = _tmp63
	sw $t1, 0($t0) 	# store with offset
	# _tmp64 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp65 = *(_tmp64)
	lw $t4, 0($t3) 	# load with offset
	# _tmp66 = y < _tmp65
	lw $t5, -8($fp)	# load y from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp67 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp68 = _tmp67 < y
	slt $s0, $t7, $t5	
	# _tmp69 = _tmp68 && _tmp66
	and $s1, $s0, $t6	
	# IfZ _tmp69 Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp62 from $t0 to $fp-76
	sw $t1, -80($fp)	# spill _tmp63 from $t1 to $fp-80
	sw $t3, -84($fp)	# spill _tmp64 from $t3 to $fp-84
	sw $t4, -88($fp)	# spill _tmp65 from $t4 to $fp-88
	sw $t6, -92($fp)	# spill _tmp66 from $t6 to $fp-92
	sw $t7, -96($fp)	# spill _tmp67 from $t7 to $fp-96
	sw $s0, -100($fp)	# spill _tmp68 from $s0 to $fp-100
	sw $s1, -104($fp)	# spill _tmp69 from $s1 to $fp-104
	beqz $s1, _L7	# branch if _tmp69 is zero 
	# _tmp70 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp71 = y * _tmp70
	lw $t1, -8($fp)	# load y from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp72 = _tmp71 + _tmp70
	add $t3, $t2, $t0	
	# _tmp73 = _tmp64 + _tmp72
	lw $t4, -84($fp)	# load _tmp64 from $fp-84 into $t4
	add $t5, $t4, $t3	
	# Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp70 from $t0 to $fp-108
	sw $t2, -112($fp)	# spill _tmp71 from $t2 to $fp-112
	sw $t3, -116($fp)	# spill _tmp72 from $t3 to $fp-116
	sw $t5, -116($fp)	# spill _tmp73 from $t5 to $fp-116
	b _L8		# unconditional branch
_L7:
	# _tmp74 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string4: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp74
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp74 from $t0 to $fp-120
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L8:
	# *(_tmp73) = _tmp62
	lw $t0, -76($fp)	# load _tmp62 from $fp-76 into $t0
	lw $t1, -116($fp)	# load _tmp73 from $fp-116 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp75 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp76 = *(_tmp75)
	lw $t4, 0($t3) 	# load with offset
	# _tmp77 = y < _tmp76
	lw $t5, -8($fp)	# load y from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp78 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp79 = _tmp78 < y
	slt $s0, $t7, $t5	
	# _tmp80 = _tmp79 && _tmp77
	and $s1, $s0, $t6	
	# IfZ _tmp80 Goto _L9
	# (save modified registers before flow of control change)
	sw $t3, -124($fp)	# spill _tmp75 from $t3 to $fp-124
	sw $t4, -128($fp)	# spill _tmp76 from $t4 to $fp-128
	sw $t6, -132($fp)	# spill _tmp77 from $t6 to $fp-132
	sw $t7, -136($fp)	# spill _tmp78 from $t7 to $fp-136
	sw $s0, -140($fp)	# spill _tmp79 from $s0 to $fp-140
	sw $s1, -144($fp)	# spill _tmp80 from $s1 to $fp-144
	beqz $s1, _L9	# branch if _tmp80 is zero 
	# _tmp81 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp82 = y * _tmp81
	lw $t1, -8($fp)	# load y from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp83 = _tmp82 + _tmp81
	add $t3, $t2, $t0	
	# _tmp84 = _tmp75 + _tmp83
	lw $t4, -124($fp)	# load _tmp75 from $fp-124 into $t4
	add $t5, $t4, $t3	
	# Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -148($fp)	# spill _tmp81 from $t0 to $fp-148
	sw $t2, -152($fp)	# spill _tmp82 from $t2 to $fp-152
	sw $t3, -156($fp)	# spill _tmp83 from $t3 to $fp-156
	sw $t5, -156($fp)	# spill _tmp84 from $t5 to $fp-156
	b _L10		# unconditional branch
_L9:
	# _tmp85 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string5: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp85
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp85 from $t0 to $fp-160
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L10:
	# _tmp86 = *(_tmp84)
	lw $t0, -156($fp)	# load _tmp84 from $fp-156 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp87 = *(_tmp86)
	lw $t2, 0($t1) 	# load with offset
	# _tmp88 = *(_tmp87 + 4)
	lw $t3, 4($t2) 	# load with offset
	# _tmp89 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp89
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp86
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp88
	# (save modified registers before flow of control change)
	sw $t1, -164($fp)	# spill _tmp86 from $t1 to $fp-164
	sw $t2, -168($fp)	# spill _tmp87 from $t2 to $fp-168
	sw $t3, -172($fp)	# spill _tmp88 from $t3 to $fp-172
	sw $t4, -176($fp)	# spill _tmp89 from $t4 to $fp-176
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp90 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp91 = y + _tmp90
	lw $t1, -8($fp)	# load y from $fp-8 into $t1
	add $t2, $t1, $t0	
	# y = _tmp91
	move $t1, $t2		# copy value
	# Goto _L5
	# (save modified registers before flow of control change)
	sw $t0, -184($fp)	# spill _tmp90 from $t0 to $fp-184
	sw $t1, -8($fp)	# spill y from $t1 to $fp-8
	sw $t2, -180($fp)	# spill _tmp91 from $t2 to $fp-180
	b _L5		# unconditional branch
_L6:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class column
	.data
	.align 2
	column:		# label for class column vtable
	.word __column.GetY
	.word __column.Init
	.word __column.SetY
	.text
__matrix.Init:
	# BeginFunc 188
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 188	# decrement sp to make space for locals/temps
	# _tmp92 = 12
	li $t0, 12		# load constant value 12 into $t0
	# _tmp93 = this + _tmp92
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp93) = y_dim
	lw $t3, 12($fp)	# load y_dim from $fp+12 into $t3
	sw $t3, 0($t2) 	# store with offset
	# _tmp94 = 8
	li $t4, 8		# load constant value 8 into $t4
	# _tmp95 = this + _tmp94
	add $t5, $t1, $t4	
	# *(_tmp95) = x_dim
	lw $t6, 8($fp)	# load x_dim from $fp+8 into $t6
	sw $t6, 0($t5) 	# store with offset
	# _tmp96 = 0
	li $t7, 0		# load constant value 0 into $t7
	# _tmp97 = x_dim < _tmp96
	slt $s0, $t6, $t7	
	# _tmp98 = x_dim == _tmp96
	seq $s1, $t6, $t7	
	# _tmp99 = _tmp97 || _tmp98
	or $s2, $s0, $s1	
	# IfZ _tmp99 Goto _L11
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp92 from $t0 to $fp-16
	sw $t2, -20($fp)	# spill _tmp93 from $t2 to $fp-20
	sw $t4, -24($fp)	# spill _tmp94 from $t4 to $fp-24
	sw $t5, -28($fp)	# spill _tmp95 from $t5 to $fp-28
	sw $t7, -32($fp)	# spill _tmp96 from $t7 to $fp-32
	sw $s0, -36($fp)	# spill _tmp97 from $s0 to $fp-36
	sw $s1, -40($fp)	# spill _tmp98 from $s1 to $fp-40
	sw $s2, -44($fp)	# spill _tmp99 from $s2 to $fp-44
	beqz $s2, _L11	# branch if _tmp99 is zero 
	# _tmp100 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp100
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp100 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L11:
	# _tmp101 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp102 = x_dim * _tmp101
	lw $t1, 8($fp)	# load x_dim from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp103 = _tmp102 + _tmp101
	add $t3, $t2, $t0	
	# PushParam _tmp103
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp104 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp101 from $t0 to $fp-52
	sw $t2, -56($fp)	# spill _tmp102 from $t2 to $fp-56
	sw $t3, -60($fp)	# spill _tmp103 from $t3 to $fp-60
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp104) = x_dim
	lw $t1, 8($fp)	# load x_dim from $fp+8 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp105 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp106 = this + _tmp105
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp106) = _tmp104
	sw $t0, 0($t4) 	# store with offset
	# _tmp107 = 0
	li $t5, 0		# load constant value 0 into $t5
	# x = _tmp107
	move $t6, $t5		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp104 from $t0 to $fp-64
	sw $t2, -68($fp)	# spill _tmp105 from $t2 to $fp-68
	sw $t4, -72($fp)	# spill _tmp106 from $t4 to $fp-72
	sw $t5, -76($fp)	# spill _tmp107 from $t5 to $fp-76
	sw $t6, -8($fp)	# spill x from $t6 to $fp-8
_L12:
	# _tmp108 = x < x_dim
	lw $t0, -8($fp)	# load x from $fp-8 into $t0
	lw $t1, 8($fp)	# load x_dim from $fp+8 into $t1
	slt $t2, $t0, $t1	
	# IfZ _tmp108 Goto _L13
	# (save modified registers before flow of control change)
	sw $t2, -80($fp)	# spill _tmp108 from $t2 to $fp-80
	beqz $t2, _L13	# branch if _tmp108 is zero 
	# _tmp109 = 12
	li $t0, 12		# load constant value 12 into $t0
	# PushParam _tmp109
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp110 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp109 from $t0 to $fp-84
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp111 = column
	la $t1, column	# load label
	# *(_tmp110) = _tmp111
	sw $t1, 0($t0) 	# store with offset
	# _tmp112 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp113 = *(_tmp112)
	lw $t4, 0($t3) 	# load with offset
	# _tmp114 = x < _tmp113
	lw $t5, -8($fp)	# load x from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp115 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp116 = _tmp115 < x
	slt $s0, $t7, $t5	
	# _tmp117 = _tmp116 && _tmp114
	and $s1, $s0, $t6	
	# IfZ _tmp117 Goto _L14
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp110 from $t0 to $fp-88
	sw $t1, -92($fp)	# spill _tmp111 from $t1 to $fp-92
	sw $t3, -96($fp)	# spill _tmp112 from $t3 to $fp-96
	sw $t4, -100($fp)	# spill _tmp113 from $t4 to $fp-100
	sw $t6, -104($fp)	# spill _tmp114 from $t6 to $fp-104
	sw $t7, -108($fp)	# spill _tmp115 from $t7 to $fp-108
	sw $s0, -112($fp)	# spill _tmp116 from $s0 to $fp-112
	sw $s1, -116($fp)	# spill _tmp117 from $s1 to $fp-116
	beqz $s1, _L14	# branch if _tmp117 is zero 
	# _tmp118 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp119 = x * _tmp118
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp120 = _tmp119 + _tmp118
	add $t3, $t2, $t0	
	# _tmp121 = _tmp112 + _tmp120
	lw $t4, -96($fp)	# load _tmp112 from $fp-96 into $t4
	add $t5, $t4, $t3	
	# Goto _L15
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp118 from $t0 to $fp-120
	sw $t2, -124($fp)	# spill _tmp119 from $t2 to $fp-124
	sw $t3, -128($fp)	# spill _tmp120 from $t3 to $fp-128
	sw $t5, -128($fp)	# spill _tmp121 from $t5 to $fp-128
	b _L15		# unconditional branch
_L14:
	# _tmp122 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string7: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp122
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp122 from $t0 to $fp-132
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L15:
	# *(_tmp121) = _tmp110
	lw $t0, -88($fp)	# load _tmp110 from $fp-88 into $t0
	lw $t1, -128($fp)	# load _tmp121 from $fp-128 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp123 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp124 = *(_tmp123)
	lw $t4, 0($t3) 	# load with offset
	# _tmp125 = x < _tmp124
	lw $t5, -8($fp)	# load x from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp126 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp127 = _tmp126 < x
	slt $s0, $t7, $t5	
	# _tmp128 = _tmp127 && _tmp125
	and $s1, $s0, $t6	
	# IfZ _tmp128 Goto _L16
	# (save modified registers before flow of control change)
	sw $t3, -136($fp)	# spill _tmp123 from $t3 to $fp-136
	sw $t4, -140($fp)	# spill _tmp124 from $t4 to $fp-140
	sw $t6, -144($fp)	# spill _tmp125 from $t6 to $fp-144
	sw $t7, -148($fp)	# spill _tmp126 from $t7 to $fp-148
	sw $s0, -152($fp)	# spill _tmp127 from $s0 to $fp-152
	sw $s1, -156($fp)	# spill _tmp128 from $s1 to $fp-156
	beqz $s1, _L16	# branch if _tmp128 is zero 
	# _tmp129 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp130 = x * _tmp129
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp131 = _tmp130 + _tmp129
	add $t3, $t2, $t0	
	# _tmp132 = _tmp123 + _tmp131
	lw $t4, -136($fp)	# load _tmp123 from $fp-136 into $t4
	add $t5, $t4, $t3	
	# Goto _L17
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp129 from $t0 to $fp-160
	sw $t2, -164($fp)	# spill _tmp130 from $t2 to $fp-164
	sw $t3, -168($fp)	# spill _tmp131 from $t3 to $fp-168
	sw $t5, -168($fp)	# spill _tmp132 from $t5 to $fp-168
	b _L17		# unconditional branch
_L16:
	# _tmp133 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string8: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp133
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp133 from $t0 to $fp-172
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L17:
	# _tmp134 = *(_tmp132)
	lw $t0, -168($fp)	# load _tmp132 from $fp-168 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp135 = *(_tmp134)
	lw $t2, 0($t1) 	# load with offset
	# _tmp136 = *(_tmp135 + 4)
	lw $t3, 4($t2) 	# load with offset
	# PushParam y_dim
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load y_dim from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp134
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp136
	# (save modified registers before flow of control change)
	sw $t1, -176($fp)	# spill _tmp134 from $t1 to $fp-176
	sw $t2, -180($fp)	# spill _tmp135 from $t2 to $fp-180
	sw $t3, -184($fp)	# spill _tmp136 from $t3 to $fp-184
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp137 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp138 = x + _tmp137
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	add $t2, $t1, $t0	
	# x = _tmp138
	move $t1, $t2		# copy value
	# Goto _L12
	# (save modified registers before flow of control change)
	sw $t0, -192($fp)	# spill _tmp137 from $t0 to $fp-192
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -188($fp)	# spill _tmp138 from $t2 to $fp-188
	b _L12		# unconditional branch
_L13:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__matrix.Set:
	# BeginFunc 120
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 120	# decrement sp to make space for locals/temps
	# _tmp139 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp140 = x < _tmp139
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp140 Goto _L18
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp139 from $t0 to $fp-16
	sw $t2, -20($fp)	# spill _tmp140 from $t2 to $fp-20
	beqz $t2, _L18	# branch if _tmp140 is zero 
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L19
	b _L19		# unconditional branch
_L18:
_L19:
	# _tmp141 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp142 = _tmp141 < x
	lw $t2, 8($fp)	# load x from $fp+8 into $t2
	slt $t3, $t1, $t2	
	# _tmp143 = x == _tmp141
	seq $t4, $t2, $t1	
	# _tmp144 = _tmp142 || _tmp143
	or $t5, $t3, $t4	
	# IfZ _tmp144 Goto _L20
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp141 from $t1 to $fp-24
	sw $t3, -28($fp)	# spill _tmp142 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp143 from $t4 to $fp-32
	sw $t5, -36($fp)	# spill _tmp144 from $t5 to $fp-36
	beqz $t5, _L20	# branch if _tmp144 is zero 
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L21
	b _L21		# unconditional branch
_L20:
_L21:
	# _tmp145 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp146 = y < _tmp145
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp146 Goto _L22
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp145 from $t0 to $fp-40
	sw $t2, -44($fp)	# spill _tmp146 from $t2 to $fp-44
	beqz $t2, _L22	# branch if _tmp146 is zero 
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L23
	b _L23		# unconditional branch
_L22:
_L23:
	# _tmp147 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp148 = _tmp147 < y
	lw $t2, 12($fp)	# load y from $fp+12 into $t2
	slt $t3, $t1, $t2	
	# _tmp149 = y == _tmp147
	seq $t4, $t2, $t1	
	# _tmp150 = _tmp148 || _tmp149
	or $t5, $t3, $t4	
	# IfZ _tmp150 Goto _L24
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp147 from $t1 to $fp-48
	sw $t3, -52($fp)	# spill _tmp148 from $t3 to $fp-52
	sw $t4, -56($fp)	# spill _tmp149 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp150 from $t5 to $fp-60
	beqz $t5, _L24	# branch if _tmp150 is zero 
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L25
	b _L25		# unconditional branch
_L24:
_L25:
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
	sw $t1, -64($fp)	# spill _tmp151 from $t1 to $fp-64
	sw $t2, -68($fp)	# spill _tmp152 from $t2 to $fp-68
	sw $t4, -72($fp)	# spill _tmp153 from $t4 to $fp-72
	sw $t5, -76($fp)	# spill _tmp154 from $t5 to $fp-76
	sw $t6, -80($fp)	# spill _tmp155 from $t6 to $fp-80
	sw $t7, -84($fp)	# spill _tmp156 from $t7 to $fp-84
	beqz $t7, _L26	# branch if _tmp156 is zero 
	# _tmp157 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp158 = x * _tmp157
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp159 = _tmp158 + _tmp157
	add $t3, $t2, $t0	
	# _tmp160 = _tmp151 + _tmp159
	lw $t4, -64($fp)	# load _tmp151 from $fp-64 into $t4
	add $t5, $t4, $t3	
	# Goto _L27
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp157 from $t0 to $fp-88
	sw $t2, -92($fp)	# spill _tmp158 from $t2 to $fp-92
	sw $t3, -96($fp)	# spill _tmp159 from $t3 to $fp-96
	sw $t5, -96($fp)	# spill _tmp160 from $t5 to $fp-96
	b _L27		# unconditional branch
_L26:
	# _tmp161 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string9: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp161
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp161 from $t0 to $fp-100
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L27:
	# _tmp162 = *(_tmp160)
	lw $t0, -96($fp)	# load _tmp160 from $fp-96 into $t0
	lw $t1, 0($t0) 	# load with offset
	# mcol = _tmp162
	move $t2, $t1		# copy value
	# _tmp163 = *(mcol)
	lw $t3, 0($t2) 	# load with offset
	# _tmp164 = *(_tmp163)
	lw $t4, 0($t3) 	# load with offset
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, 12($fp)	# load y from $fp+12 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam mcol
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp165 = ACall _tmp164
	# (save modified registers before flow of control change)
	sw $t1, -104($fp)	# spill _tmp162 from $t1 to $fp-104
	sw $t2, -8($fp)	# spill mcol from $t2 to $fp-8
	sw $t3, -108($fp)	# spill _tmp163 from $t3 to $fp-108
	sw $t4, -112($fp)	# spill _tmp164 from $t4 to $fp-112
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# mcell = _tmp165
	move $t1, $t0		# copy value
	# _tmp166 = *(mcell)
	lw $t2, 0($t1) 	# load with offset
	# _tmp167 = *(_tmp166 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam state
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 16($fp)	# load state from $fp+16 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam mcell
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp167
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp165 from $t0 to $fp-116
	sw $t1, -12($fp)	# spill mcell from $t1 to $fp-12
	sw $t2, -120($fp)	# spill _tmp166 from $t2 to $fp-120
	sw $t3, -124($fp)	# spill _tmp167 from $t3 to $fp-124
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__matrix.Get:
	# BeginFunc 140
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 140	# decrement sp to make space for locals/temps
	# _tmp168 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp169 = x < _tmp168
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp169 Goto _L28
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp168 from $t0 to $fp-16
	sw $t2, -20($fp)	# spill _tmp169 from $t2 to $fp-20
	beqz $t2, _L28	# branch if _tmp169 is zero 
	# _tmp170 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp170
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L29
	b _L29		# unconditional branch
_L28:
_L29:
	# _tmp171 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp172 = _tmp171 < x
	lw $t2, 8($fp)	# load x from $fp+8 into $t2
	slt $t3, $t1, $t2	
	# _tmp173 = x == _tmp171
	seq $t4, $t2, $t1	
	# _tmp174 = _tmp172 || _tmp173
	or $t5, $t3, $t4	
	# IfZ _tmp174 Goto _L30
	# (save modified registers before flow of control change)
	sw $t1, -28($fp)	# spill _tmp171 from $t1 to $fp-28
	sw $t3, -32($fp)	# spill _tmp172 from $t3 to $fp-32
	sw $t4, -36($fp)	# spill _tmp173 from $t4 to $fp-36
	sw $t5, -40($fp)	# spill _tmp174 from $t5 to $fp-40
	beqz $t5, _L30	# branch if _tmp174 is zero 
	# _tmp175 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp175
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L31
	b _L31		# unconditional branch
_L30:
_L31:
	# _tmp176 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp177 = y < _tmp176
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp177 Goto _L32
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp176 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp177 from $t2 to $fp-52
	beqz $t2, _L32	# branch if _tmp177 is zero 
	# _tmp178 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp178
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L33
	b _L33		# unconditional branch
_L32:
_L33:
	# _tmp179 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp180 = _tmp179 < y
	lw $t2, 12($fp)	# load y from $fp+12 into $t2
	slt $t3, $t1, $t2	
	# _tmp181 = y == _tmp179
	seq $t4, $t2, $t1	
	# _tmp182 = _tmp180 || _tmp181
	or $t5, $t3, $t4	
	# IfZ _tmp182 Goto _L34
	# (save modified registers before flow of control change)
	sw $t1, -60($fp)	# spill _tmp179 from $t1 to $fp-60
	sw $t3, -64($fp)	# spill _tmp180 from $t3 to $fp-64
	sw $t4, -68($fp)	# spill _tmp181 from $t4 to $fp-68
	sw $t5, -72($fp)	# spill _tmp182 from $t5 to $fp-72
	beqz $t5, _L34	# branch if _tmp182 is zero 
	# _tmp183 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp183
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L35
	b _L35		# unconditional branch
_L34:
_L35:
	# _tmp184 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp185 = *(_tmp184)
	lw $t2, 0($t1) 	# load with offset
	# _tmp186 = x < _tmp185
	lw $t3, 8($fp)	# load x from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp187 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp188 = _tmp187 < x
	slt $t6, $t5, $t3	
	# _tmp189 = _tmp188 && _tmp186
	and $t7, $t6, $t4	
	# IfZ _tmp189 Goto _L36
	# (save modified registers before flow of control change)
	sw $t1, -80($fp)	# spill _tmp184 from $t1 to $fp-80
	sw $t2, -84($fp)	# spill _tmp185 from $t2 to $fp-84
	sw $t4, -88($fp)	# spill _tmp186 from $t4 to $fp-88
	sw $t5, -92($fp)	# spill _tmp187 from $t5 to $fp-92
	sw $t6, -96($fp)	# spill _tmp188 from $t6 to $fp-96
	sw $t7, -100($fp)	# spill _tmp189 from $t7 to $fp-100
	beqz $t7, _L36	# branch if _tmp189 is zero 
	# _tmp190 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp191 = x * _tmp190
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp192 = _tmp191 + _tmp190
	add $t3, $t2, $t0	
	# _tmp193 = _tmp184 + _tmp192
	lw $t4, -80($fp)	# load _tmp184 from $fp-80 into $t4
	add $t5, $t4, $t3	
	# Goto _L37
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp190 from $t0 to $fp-104
	sw $t2, -108($fp)	# spill _tmp191 from $t2 to $fp-108
	sw $t3, -112($fp)	# spill _tmp192 from $t3 to $fp-112
	sw $t5, -112($fp)	# spill _tmp193 from $t5 to $fp-112
	b _L37		# unconditional branch
_L36:
	# _tmp194 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp194
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp194 from $t0 to $fp-116
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L37:
	# _tmp195 = *(_tmp193)
	lw $t0, -112($fp)	# load _tmp193 from $fp-112 into $t0
	lw $t1, 0($t0) 	# load with offset
	# mcol = _tmp195
	move $t2, $t1		# copy value
	# _tmp196 = *(mcol)
	lw $t3, 0($t2) 	# load with offset
	# _tmp197 = *(_tmp196)
	lw $t4, 0($t3) 	# load with offset
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, 12($fp)	# load y from $fp+12 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam mcol
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp198 = ACall _tmp197
	# (save modified registers before flow of control change)
	sw $t1, -120($fp)	# spill _tmp195 from $t1 to $fp-120
	sw $t2, -8($fp)	# spill mcol from $t2 to $fp-8
	sw $t3, -124($fp)	# spill _tmp196 from $t3 to $fp-124
	sw $t4, -128($fp)	# spill _tmp197 from $t4 to $fp-128
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# mcell = _tmp198
	move $t1, $t0		# copy value
	# _tmp199 = *(mcell)
	lw $t2, 0($t1) 	# load with offset
	# _tmp200 = *(_tmp199)
	lw $t3, 0($t2) 	# load with offset
	# PushParam mcell
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp201 = ACall _tmp200
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp198 from $t0 to $fp-132
	sw $t1, -12($fp)	# spill mcell from $t1 to $fp-12
	sw $t2, -136($fp)	# spill _tmp199 from $t2 to $fp-136
	sw $t3, -140($fp)	# spill _tmp200 from $t3 to $fp-140
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Return _tmp201
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
	# VTable for class matrix
	.data
	.align 2
	matrix:		# label for class matrix vtable
	.word __matrix.Get
	.word __matrix.Init
	.word __matrix.Set
	.text
__life.Init:
	# BeginFunc 180
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 180	# decrement sp to make space for locals/temps
	# _tmp202 = 0
	li $t0, 0		# load constant value 0 into $t0
	# x = _tmp202
	move $t1, $t0		# copy value
	# _tmp203 = 0
	li $t2, 0		# load constant value 0 into $t2
	# y = _tmp203
	move $t3, $t2		# copy value
	# _tmp204 = 20
	li $t4, 20		# load constant value 20 into $t4
	# _tmp205 = this + _tmp204
	lw $t5, 4($fp)	# load this from $fp+4 into $t5
	add $t6, $t5, $t4	
	# *(_tmp205) = x_dim
	lw $t7, 8($fp)	# load x_dim from $fp+8 into $t7
	sw $t7, 0($t6) 	# store with offset
	# _tmp206 = 24
	li $s0, 24		# load constant value 24 into $s0
	# _tmp207 = this + _tmp206
	add $s1, $t5, $s0	
	# *(_tmp207) = y_dim
	lw $s2, 12($fp)	# load y_dim from $fp+12 into $s2
	sw $s2, 0($s1) 	# store with offset
	# _tmp208 = 16
	li $s3, 16		# load constant value 16 into $s3
	# PushParam _tmp208
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s3, 4($sp)	# copy param value to stack
	# _tmp209 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp202 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -20($fp)	# spill _tmp203 from $t2 to $fp-20
	sw $t3, -12($fp)	# spill y from $t3 to $fp-12
	sw $t4, -24($fp)	# spill _tmp204 from $t4 to $fp-24
	sw $t6, -28($fp)	# spill _tmp205 from $t6 to $fp-28
	sw $s0, -32($fp)	# spill _tmp206 from $s0 to $fp-32
	sw $s1, -36($fp)	# spill _tmp207 from $s1 to $fp-36
	sw $s3, -40($fp)	# spill _tmp208 from $s3 to $fp-40
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp210 = matrix
	la $t1, matrix	# load label
	# *(_tmp209) = _tmp210
	sw $t1, 0($t0) 	# store with offset
	# _tmp211 = 8
	li $t2, 8		# load constant value 8 into $t2
	# _tmp212 = this + _tmp211
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp212) = _tmp209
	sw $t0, 0($t4) 	# store with offset
	# _tmp213 = 16
	li $t5, 16		# load constant value 16 into $t5
	# PushParam _tmp213
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# _tmp214 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp209 from $t0 to $fp-44
	sw $t1, -48($fp)	# spill _tmp210 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp211 from $t2 to $fp-52
	sw $t4, -56($fp)	# spill _tmp212 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp213 from $t5 to $fp-60
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp215 = matrix
	la $t1, matrix	# load label
	# *(_tmp214) = _tmp215
	sw $t1, 0($t0) 	# store with offset
	# _tmp216 = 12
	li $t2, 12		# load constant value 12 into $t2
	# _tmp217 = this + _tmp216
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp217) = _tmp214
	sw $t0, 0($t4) 	# store with offset
	# _tmp218 = *(this + 8)
	lw $t5, 8($t3) 	# load with offset
	# _tmp219 = 4
	li $t6, 4		# load constant value 4 into $t6
	# _tmp220 = this + _tmp219
	add $t7, $t3, $t6	
	# *(_tmp220) = _tmp218
	sw $t5, 0($t7) 	# store with offset
	# _tmp221 = *(this + 8)
	lw $s0, 8($t3) 	# load with offset
	# _tmp222 = *(_tmp221)
	lw $s1, 0($s0) 	# load with offset
	# _tmp223 = *(_tmp222 + 4)
	lw $s2, 4($s1) 	# load with offset
	# PushParam y_dim
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $s3, 12($fp)	# load y_dim from $fp+12 into $s3
	sw $s3, 4($sp)	# copy param value to stack
	# PushParam x_dim
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $s4, 8($fp)	# load x_dim from $fp+8 into $s4
	sw $s4, 4($sp)	# copy param value to stack
	# PushParam _tmp221
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s0, 4($sp)	# copy param value to stack
	# ACall _tmp223
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp214 from $t0 to $fp-64
	sw $t1, -68($fp)	# spill _tmp215 from $t1 to $fp-68
	sw $t2, -72($fp)	# spill _tmp216 from $t2 to $fp-72
	sw $t4, -76($fp)	# spill _tmp217 from $t4 to $fp-76
	sw $t5, -80($fp)	# spill _tmp218 from $t5 to $fp-80
	sw $t6, -84($fp)	# spill _tmp219 from $t6 to $fp-84
	sw $t7, -88($fp)	# spill _tmp220 from $t7 to $fp-88
	sw $s0, -92($fp)	# spill _tmp221 from $s0 to $fp-92
	sw $s1, -96($fp)	# spill _tmp222 from $s1 to $fp-96
	sw $s2, -100($fp)	# spill _tmp223 from $s2 to $fp-100
	jalr $s2            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp224 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp225 = *(_tmp224)
	lw $t2, 0($t1) 	# load with offset
	# _tmp226 = *(_tmp225 + 4)
	lw $t3, 4($t2) 	# load with offset
	# PushParam y_dim
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load y_dim from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam x_dim
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, 8($fp)	# load x_dim from $fp+8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam _tmp224
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp226
	# (save modified registers before flow of control change)
	sw $t1, -104($fp)	# spill _tmp224 from $t1 to $fp-104
	sw $t2, -108($fp)	# spill _tmp225 from $t2 to $fp-108
	sw $t3, -112($fp)	# spill _tmp226 from $t3 to $fp-112
	jalr $t3            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp227 = 0
	li $t0, 0		# load constant value 0 into $t0
	# y = _tmp227
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp227 from $t0 to $fp-116
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
_L38:
	# _tmp228 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp229 = y < _tmp228
	lw $t2, -12($fp)	# load y from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp229 Goto _L39
	# (save modified registers before flow of control change)
	sw $t1, -120($fp)	# spill _tmp228 from $t1 to $fp-120
	sw $t3, -124($fp)	# spill _tmp229 from $t3 to $fp-124
	beqz $t3, _L39	# branch if _tmp229 is zero 
	# _tmp230 = 0
	li $t0, 0		# load constant value 0 into $t0
	# x = _tmp230
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp230 from $t0 to $fp-128
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
_L40:
	# _tmp231 = *(this + 20)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 20($t0) 	# load with offset
	# _tmp232 = x < _tmp231
	lw $t2, -8($fp)	# load x from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp232 Goto _L41
	# (save modified registers before flow of control change)
	sw $t1, -132($fp)	# spill _tmp231 from $t1 to $fp-132
	sw $t3, -136($fp)	# spill _tmp232 from $t3 to $fp-136
	beqz $t3, _L41	# branch if _tmp232 is zero 
	# _tmp233 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# _tmp234 = *(_tmp233)
	lw $t2, 0($t1) 	# load with offset
	# _tmp235 = *(_tmp234 + 8)
	lw $t3, 8($t2) 	# load with offset
	# _tmp236 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp236
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -12($fp)	# load y from $fp-12 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, -8($fp)	# load x from $fp-8 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam _tmp233
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp235
	# (save modified registers before flow of control change)
	sw $t1, -140($fp)	# spill _tmp233 from $t1 to $fp-140
	sw $t2, -144($fp)	# spill _tmp234 from $t2 to $fp-144
	sw $t3, -148($fp)	# spill _tmp235 from $t3 to $fp-148
	sw $t4, -152($fp)	# spill _tmp236 from $t4 to $fp-152
	jalr $t3            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp237 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp238 = *(_tmp237)
	lw $t2, 0($t1) 	# load with offset
	# _tmp239 = *(_tmp238 + 8)
	lw $t3, 8($t2) 	# load with offset
	# _tmp240 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp240
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -12($fp)	# load y from $fp-12 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, -8($fp)	# load x from $fp-8 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam _tmp237
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp239
	# (save modified registers before flow of control change)
	sw $t1, -156($fp)	# spill _tmp237 from $t1 to $fp-156
	sw $t2, -160($fp)	# spill _tmp238 from $t2 to $fp-160
	sw $t3, -164($fp)	# spill _tmp239 from $t3 to $fp-164
	sw $t4, -168($fp)	# spill _tmp240 from $t4 to $fp-168
	jalr $t3            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp241 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp242 = x + _tmp241
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	add $t2, $t1, $t0	
	# x = _tmp242
	move $t1, $t2		# copy value
	# Goto _L40
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp241 from $t0 to $fp-176
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -172($fp)	# spill _tmp242 from $t2 to $fp-172
	b _L40		# unconditional branch
_L41:
	# _tmp243 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp244 = y + _tmp243
	lw $t1, -12($fp)	# load y from $fp-12 into $t1
	add $t2, $t1, $t0	
	# y = _tmp244
	move $t1, $t2		# copy value
	# Goto _L38
	# (save modified registers before flow of control change)
	sw $t0, -184($fp)	# spill _tmp243 from $t0 to $fp-184
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
	sw $t2, -180($fp)	# spill _tmp244 from $t2 to $fp-180
	b _L38		# unconditional branch
_L39:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__life.SetInit:
	# BeginFunc 80
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 80	# decrement sp to make space for locals/temps
	# _tmp245 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp246 = x < _tmp245
	lw $t1, 8($fp)	# load x from $fp+8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp246 Goto _L42
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp245 from $t0 to $fp-8
	sw $t2, -12($fp)	# spill _tmp246 from $t2 to $fp-12
	beqz $t2, _L42	# branch if _tmp246 is zero 
	# _tmp247 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp247
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L43
	b _L43		# unconditional branch
_L42:
_L43:
	# _tmp248 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp249 = y < _tmp248
	lw $t1, 12($fp)	# load y from $fp+12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp249 Goto _L44
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp248 from $t0 to $fp-20
	sw $t2, -24($fp)	# spill _tmp249 from $t2 to $fp-24
	beqz $t2, _L44	# branch if _tmp249 is zero 
	# _tmp250 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp250
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L45
	b _L45		# unconditional branch
_L44:
_L45:
	# _tmp251 = *(this + 20)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 20($t0) 	# load with offset
	# _tmp252 = _tmp251 < x
	lw $t2, 8($fp)	# load x from $fp+8 into $t2
	slt $t3, $t1, $t2	
	# _tmp253 = x == _tmp251
	seq $t4, $t2, $t1	
	# _tmp254 = _tmp252 || _tmp253
	or $t5, $t3, $t4	
	# IfZ _tmp254 Goto _L46
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp251 from $t1 to $fp-32
	sw $t3, -36($fp)	# spill _tmp252 from $t3 to $fp-36
	sw $t4, -40($fp)	# spill _tmp253 from $t4 to $fp-40
	sw $t5, -44($fp)	# spill _tmp254 from $t5 to $fp-44
	beqz $t5, _L46	# branch if _tmp254 is zero 
	# _tmp255 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp255
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L47
	b _L47		# unconditional branch
_L46:
_L47:
	# _tmp256 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp257 = _tmp256 < y
	lw $t2, 12($fp)	# load y from $fp+12 into $t2
	slt $t3, $t1, $t2	
	# _tmp258 = y == _tmp256
	seq $t4, $t2, $t1	
	# _tmp259 = _tmp257 || _tmp258
	or $t5, $t3, $t4	
	# IfZ _tmp259 Goto _L48
	# (save modified registers before flow of control change)
	sw $t1, -52($fp)	# spill _tmp256 from $t1 to $fp-52
	sw $t3, -56($fp)	# spill _tmp257 from $t3 to $fp-56
	sw $t4, -60($fp)	# spill _tmp258 from $t4 to $fp-60
	sw $t5, -64($fp)	# spill _tmp259 from $t5 to $fp-64
	beqz $t5, _L48	# branch if _tmp259 is zero 
	# _tmp260 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp260
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L49
	b _L49		# unconditional branch
_L48:
_L49:
	# _tmp261 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp262 = *(_tmp261)
	lw $t2, 0($t1) 	# load with offset
	# _tmp263 = *(_tmp262 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam state
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 16($fp)	# load state from $fp+16 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, 12($fp)	# load y from $fp+12 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, 8($fp)	# load x from $fp+8 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam _tmp261
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp263
	# (save modified registers before flow of control change)
	sw $t1, -72($fp)	# spill _tmp261 from $t1 to $fp-72
	sw $t2, -76($fp)	# spill _tmp262 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp263 from $t3 to $fp-80
	jalr $t3            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp264 = 1
	li $t0, 1		# load constant value 1 into $t0
	# Return _tmp264
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
__life.PrintMatrix:
	# BeginFunc 104
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 104	# decrement sp to make space for locals/temps
	# _tmp265 = 0
	li $t0, 0		# load constant value 0 into $t0
	# y = _tmp265
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp265 from $t0 to $fp-20
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
_L50:
	# _tmp266 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp267 = y < _tmp266
	lw $t2, -12($fp)	# load y from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp267 Goto _L51
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp266 from $t1 to $fp-24
	sw $t3, -28($fp)	# spill _tmp267 from $t3 to $fp-28
	beqz $t3, _L51	# branch if _tmp267 is zero 
	# _tmp268 = 0
	li $t0, 0		# load constant value 0 into $t0
	# x = _tmp268
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp268 from $t0 to $fp-32
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
_L52:
	# _tmp269 = *(this + 20)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 20($t0) 	# load with offset
	# _tmp270 = x < _tmp269
	lw $t2, -8($fp)	# load x from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp270 Goto _L53
	# (save modified registers before flow of control change)
	sw $t1, -36($fp)	# spill _tmp269 from $t1 to $fp-36
	sw $t3, -40($fp)	# spill _tmp270 from $t3 to $fp-40
	beqz $t3, _L53	# branch if _tmp270 is zero 
	# _tmp271 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp272 = *(_tmp271)
	lw $t2, 0($t1) 	# load with offset
	# _tmp273 = *(_tmp272)
	lw $t3, 0($t2) 	# load with offset
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load y from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load x from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam _tmp271
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp274 = ACall _tmp273
	# (save modified registers before flow of control change)
	sw $t1, -44($fp)	# spill _tmp271 from $t1 to $fp-44
	sw $t2, -48($fp)	# spill _tmp272 from $t2 to $fp-48
	sw $t3, -52($fp)	# spill _tmp273 from $t3 to $fp-52
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# IfZ _tmp274 Goto _L54
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp274 from $t0 to $fp-56
	beqz $t0, _L54	# branch if _tmp274 is zero 
	# _tmp275 = 1
	li $t0, 1		# load constant value 1 into $t0
	# s = _tmp275
	move $t1, $t0		# copy value
	# Goto _L55
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp275 from $t0 to $fp-60
	sw $t1, -16($fp)	# spill s from $t1 to $fp-16
	b _L55		# unconditional branch
_L54:
	# _tmp276 = 0
	li $t0, 0		# load constant value 0 into $t0
	# s = _tmp276
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp276 from $t0 to $fp-64
	sw $t1, -16($fp)	# spill s from $t1 to $fp-16
_L55:
	# _tmp277 = "| "
	.data			# create string constant marked with label
	_string11: .asciiz "| "
	.text
	la $t0, _string11	# load label
	# PushParam _tmp277
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp277 from $t0 to $fp-68
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -16($fp)	# load s from $fp-16 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp278 = " "
	.data			# create string constant marked with label
	_string12: .asciiz " "
	.text
	la $t0, _string12	# load label
	# PushParam _tmp278
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp278 from $t0 to $fp-72
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp279 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp280 = *(this + 20)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 20($t1) 	# load with offset
	# _tmp281 = _tmp280 - _tmp279
	sub $t3, $t2, $t0	
	# _tmp282 = x == _tmp281
	lw $t4, -8($fp)	# load x from $fp-8 into $t4
	seq $t5, $t4, $t3	
	# IfZ _tmp282 Goto _L56
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp279 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp280 from $t2 to $fp-84
	sw $t3, -76($fp)	# spill _tmp281 from $t3 to $fp-76
	sw $t5, -88($fp)	# spill _tmp282 from $t5 to $fp-88
	beqz $t5, _L56	# branch if _tmp282 is zero 
	# _tmp283 = "|\n"
	.data			# create string constant marked with label
	_string13: .asciiz "|\n"
	.text
	la $t0, _string13	# load label
	# PushParam _tmp283
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp283 from $t0 to $fp-92
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L57
	b _L57		# unconditional branch
_L56:
_L57:
	# _tmp284 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp285 = x + _tmp284
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	add $t2, $t1, $t0	
	# x = _tmp285
	move $t1, $t2		# copy value
	# Goto _L52
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp284 from $t0 to $fp-100
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -96($fp)	# spill _tmp285 from $t2 to $fp-96
	b _L52		# unconditional branch
_L53:
	# _tmp286 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp287 = y + _tmp286
	lw $t1, -12($fp)	# load y from $fp-12 into $t1
	add $t2, $t1, $t0	
	# y = _tmp287
	move $t1, $t2		# copy value
	# Goto _L50
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp286 from $t0 to $fp-108
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
	sw $t2, -104($fp)	# spill _tmp287 from $t2 to $fp-104
	b _L50		# unconditional branch
_L51:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__life.DoLife:
	# BeginFunc 300
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 300	# decrement sp to make space for locals/temps
	# _tmp288 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp289 = *(this + 8)
	lw $t2, 8($t0) 	# load with offset
	# _tmp290 = _tmp288 == _tmp289
	seq $t3, $t1, $t2	
	# IfZ _tmp290 Goto _L58
	# (save modified registers before flow of control change)
	sw $t1, -28($fp)	# spill _tmp288 from $t1 to $fp-28
	sw $t2, -32($fp)	# spill _tmp289 from $t2 to $fp-32
	sw $t3, -36($fp)	# spill _tmp290 from $t3 to $fp-36
	beqz $t3, _L58	# branch if _tmp290 is zero 
	# _tmp291 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# n = _tmp291
	move $t2, $t1		# copy value
	# Goto _L59
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp291 from $t1 to $fp-40
	sw $t2, -24($fp)	# spill n from $t2 to $fp-24
	b _L59		# unconditional branch
_L58:
	# _tmp292 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# n = _tmp292
	move $t2, $t1		# copy value
	# (save modified registers before flow of control change)
	sw $t1, -44($fp)	# spill _tmp292 from $t1 to $fp-44
	sw $t2, -24($fp)	# spill n from $t2 to $fp-24
_L59:
	# _tmp293 = 0
	li $t0, 0		# load constant value 0 into $t0
	# y = _tmp293
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp293 from $t0 to $fp-48
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
_L60:
	# _tmp294 = *(this + 24)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 24($t0) 	# load with offset
	# _tmp295 = y < _tmp294
	lw $t2, -12($fp)	# load y from $fp-12 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp295 Goto _L61
	# (save modified registers before flow of control change)
	sw $t1, -52($fp)	# spill _tmp294 from $t1 to $fp-52
	sw $t3, -56($fp)	# spill _tmp295 from $t3 to $fp-56
	beqz $t3, _L61	# branch if _tmp295 is zero 
	# _tmp296 = 0
	li $t0, 0		# load constant value 0 into $t0
	# x = _tmp296
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp296 from $t0 to $fp-60
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
_L62:
	# _tmp297 = *(this + 20)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 20($t0) 	# load with offset
	# _tmp298 = x < _tmp297
	lw $t2, -8($fp)	# load x from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp298 Goto _L63
	# (save modified registers before flow of control change)
	sw $t1, -64($fp)	# spill _tmp297 from $t1 to $fp-64
	sw $t3, -68($fp)	# spill _tmp298 from $t3 to $fp-68
	beqz $t3, _L63	# branch if _tmp298 is zero 
	# _tmp299 = 0
	li $t0, 0		# load constant value 0 into $t0
	# neigh_count = _tmp299
	move $t1, $t0		# copy value
	# _tmp300 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp301 = *(_tmp300)
	lw $t4, 0($t3) 	# load with offset
	# _tmp302 = *(_tmp301)
	lw $t5, 0($t4) 	# load with offset
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, -12($fp)	# load y from $fp-12 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t7, -8($fp)	# load x from $fp-8 into $t7
	sw $t7, 4($sp)	# copy param value to stack
	# PushParam _tmp300
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp303 = ACall _tmp302
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp299 from $t0 to $fp-80
	sw $t1, -72($fp)	# spill neigh_count from $t1 to $fp-72
	sw $t3, -84($fp)	# spill _tmp300 from $t3 to $fp-84
	sw $t4, -88($fp)	# spill _tmp301 from $t4 to $fp-88
	sw $t5, -92($fp)	# spill _tmp302 from $t5 to $fp-92
	jalr $t5            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# my_state = _tmp303
	move $t1, $t0		# copy value
	# _tmp304 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp305 = y - _tmp304
	lw $t3, -12($fp)	# load y from $fp-12 into $t3
	sub $t4, $t3, $t2	
	# j = _tmp305
	move $t5, $t4		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp303 from $t0 to $fp-96
	sw $t1, -76($fp)	# spill my_state from $t1 to $fp-76
	sw $t2, -104($fp)	# spill _tmp304 from $t2 to $fp-104
	sw $t4, -100($fp)	# spill _tmp305 from $t4 to $fp-100
	sw $t5, -20($fp)	# spill j from $t5 to $fp-20
_L64:
	# _tmp306 = 2
	li $t0, 2		# load constant value 2 into $t0
	# _tmp307 = y + _tmp306
	lw $t1, -12($fp)	# load y from $fp-12 into $t1
	add $t2, $t1, $t0	
	# _tmp308 = j < _tmp307
	lw $t3, -20($fp)	# load j from $fp-20 into $t3
	slt $t4, $t3, $t2	
	# IfZ _tmp308 Goto _L65
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp306 from $t0 to $fp-112
	sw $t2, -108($fp)	# spill _tmp307 from $t2 to $fp-108
	sw $t4, -116($fp)	# spill _tmp308 from $t4 to $fp-116
	beqz $t4, _L65	# branch if _tmp308 is zero 
	# _tmp309 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp310 = x - _tmp309
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	sub $t2, $t1, $t0	
	# i = _tmp310
	move $t3, $t2		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp309 from $t0 to $fp-124
	sw $t2, -120($fp)	# spill _tmp310 from $t2 to $fp-120
	sw $t3, -16($fp)	# spill i from $t3 to $fp-16
_L66:
	# _tmp311 = 2
	li $t0, 2		# load constant value 2 into $t0
	# _tmp312 = x + _tmp311
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	add $t2, $t1, $t0	
	# _tmp313 = i < _tmp312
	lw $t3, -16($fp)	# load i from $fp-16 into $t3
	slt $t4, $t3, $t2	
	# IfZ _tmp313 Goto _L67
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp311 from $t0 to $fp-132
	sw $t2, -128($fp)	# spill _tmp312 from $t2 to $fp-128
	sw $t4, -136($fp)	# spill _tmp313 from $t4 to $fp-136
	beqz $t4, _L67	# branch if _tmp313 is zero 
	# _tmp314 = y == j
	lw $t0, -12($fp)	# load y from $fp-12 into $t0
	lw $t1, -20($fp)	# load j from $fp-20 into $t1
	seq $t2, $t0, $t1	
	# _tmp315 = x == i
	lw $t3, -8($fp)	# load x from $fp-8 into $t3
	lw $t4, -16($fp)	# load i from $fp-16 into $t4
	seq $t5, $t3, $t4	
	# _tmp316 = _tmp315 && _tmp314
	and $t6, $t5, $t2	
	# skip = _tmp316
	move $t7, $t6		# copy value
	# _tmp317 = *(this + 4)
	lw $s0, 4($fp)	# load this from $fp+4 into $s0
	lw $s1, 4($s0) 	# load with offset
	# _tmp318 = *(_tmp317)
	lw $s2, 0($s1) 	# load with offset
	# _tmp319 = *(_tmp318)
	lw $s3, 0($s2) 	# load with offset
	# PushParam j
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp317
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s1, 4($sp)	# copy param value to stack
	# _tmp320 = ACall _tmp319
	# (save modified registers before flow of control change)
	sw $t2, -148($fp)	# spill _tmp314 from $t2 to $fp-148
	sw $t5, -152($fp)	# spill _tmp315 from $t5 to $fp-152
	sw $t6, -144($fp)	# spill _tmp316 from $t6 to $fp-144
	sw $t7, -140($fp)	# spill skip from $t7 to $fp-140
	sw $s1, -160($fp)	# spill _tmp317 from $s1 to $fp-160
	sw $s2, -164($fp)	# spill _tmp318 from $s2 to $fp-164
	sw $s3, -168($fp)	# spill _tmp319 from $s3 to $fp-168
	jalr $s3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp321 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp322 = _tmp321 - skip
	lw $t2, -140($fp)	# load skip from $fp-140 into $t2
	sub $t3, $t1, $t2	
	# _tmp323 = _tmp322 && _tmp320
	and $t4, $t3, $t0	
	# IfZ _tmp323 Goto _L68
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp320 from $t0 to $fp-172
	sw $t1, -176($fp)	# spill _tmp321 from $t1 to $fp-176
	sw $t3, -180($fp)	# spill _tmp322 from $t3 to $fp-180
	sw $t4, -156($fp)	# spill _tmp323 from $t4 to $fp-156
	beqz $t4, _L68	# branch if _tmp323 is zero 
	# _tmp324 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp325 = neigh_count + _tmp324
	lw $t1, -72($fp)	# load neigh_count from $fp-72 into $t1
	add $t2, $t1, $t0	
	# neigh_count = _tmp325
	move $t1, $t2		# copy value
	# Goto _L69
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp324 from $t0 to $fp-188
	sw $t1, -72($fp)	# spill neigh_count from $t1 to $fp-72
	sw $t2, -184($fp)	# spill _tmp325 from $t2 to $fp-184
	b _L69		# unconditional branch
_L68:
_L69:
	# _tmp326 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp327 = i + _tmp326
	lw $t1, -16($fp)	# load i from $fp-16 into $t1
	add $t2, $t1, $t0	
	# i = _tmp327
	move $t1, $t2		# copy value
	# Goto _L66
	# (save modified registers before flow of control change)
	sw $t0, -196($fp)	# spill _tmp326 from $t0 to $fp-196
	sw $t1, -16($fp)	# spill i from $t1 to $fp-16
	sw $t2, -192($fp)	# spill _tmp327 from $t2 to $fp-192
	b _L66		# unconditional branch
_L67:
	# _tmp328 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp329 = j + _tmp328
	lw $t1, -20($fp)	# load j from $fp-20 into $t1
	add $t2, $t1, $t0	
	# j = _tmp329
	move $t1, $t2		# copy value
	# Goto _L64
	# (save modified registers before flow of control change)
	sw $t0, -204($fp)	# spill _tmp328 from $t0 to $fp-204
	sw $t1, -20($fp)	# spill j from $t1 to $fp-20
	sw $t2, -200($fp)	# spill _tmp329 from $t2 to $fp-200
	b _L64		# unconditional branch
_L65:
	# IfZ my_state Goto _L70
	lw $t0, -76($fp)	# load my_state from $fp-76 into $t0
	beqz $t0, _L70	# branch if my_state is zero 
	# _tmp330 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp331 = neigh_count == _tmp330
	lw $t1, -72($fp)	# load neigh_count from $fp-72 into $t1
	seq $t2, $t1, $t0	
	# _tmp332 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp333 = neigh_count == _tmp332
	seq $t4, $t1, $t3	
	# _tmp334 = _tmp333 || _tmp331
	or $t5, $t4, $t2	
	# IfZ _tmp334 Goto _L72
	# (save modified registers before flow of control change)
	sw $t0, -212($fp)	# spill _tmp330 from $t0 to $fp-212
	sw $t2, -216($fp)	# spill _tmp331 from $t2 to $fp-216
	sw $t3, -220($fp)	# spill _tmp332 from $t3 to $fp-220
	sw $t4, -224($fp)	# spill _tmp333 from $t4 to $fp-224
	sw $t5, -208($fp)	# spill _tmp334 from $t5 to $fp-208
	beqz $t5, _L72	# branch if _tmp334 is zero 
	# _tmp335 = *(n)
	lw $t0, -24($fp)	# load n from $fp-24 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp336 = *(_tmp335 + 8)
	lw $t2, 8($t1) 	# load with offset
	# _tmp337 = 1
	li $t3, 1		# load constant value 1 into $t3
	# PushParam _tmp337
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load y from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load x from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam n
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp336
	# (save modified registers before flow of control change)
	sw $t1, -228($fp)	# spill _tmp335 from $t1 to $fp-228
	sw $t2, -232($fp)	# spill _tmp336 from $t2 to $fp-232
	sw $t3, -236($fp)	# spill _tmp337 from $t3 to $fp-236
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# Goto _L73
	b _L73		# unconditional branch
_L72:
	# _tmp338 = *(n)
	lw $t0, -24($fp)	# load n from $fp-24 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp339 = *(_tmp338 + 8)
	lw $t2, 8($t1) 	# load with offset
	# _tmp340 = 0
	li $t3, 0		# load constant value 0 into $t3
	# PushParam _tmp340
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load y from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load x from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam n
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp339
	# (save modified registers before flow of control change)
	sw $t1, -240($fp)	# spill _tmp338 from $t1 to $fp-240
	sw $t2, -244($fp)	# spill _tmp339 from $t2 to $fp-244
	sw $t3, -248($fp)	# spill _tmp340 from $t3 to $fp-248
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
_L73:
	# Goto _L71
	b _L71		# unconditional branch
_L70:
	# _tmp341 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp342 = neigh_count == _tmp341
	lw $t1, -72($fp)	# load neigh_count from $fp-72 into $t1
	seq $t2, $t1, $t0	
	# IfZ _tmp342 Goto _L74
	# (save modified registers before flow of control change)
	sw $t0, -252($fp)	# spill _tmp341 from $t0 to $fp-252
	sw $t2, -256($fp)	# spill _tmp342 from $t2 to $fp-256
	beqz $t2, _L74	# branch if _tmp342 is zero 
	# _tmp343 = *(n)
	lw $t0, -24($fp)	# load n from $fp-24 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp344 = *(_tmp343 + 8)
	lw $t2, 8($t1) 	# load with offset
	# _tmp345 = 1
	li $t3, 1		# load constant value 1 into $t3
	# PushParam _tmp345
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load y from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load x from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam n
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp344
	# (save modified registers before flow of control change)
	sw $t1, -260($fp)	# spill _tmp343 from $t1 to $fp-260
	sw $t2, -264($fp)	# spill _tmp344 from $t2 to $fp-264
	sw $t3, -268($fp)	# spill _tmp345 from $t3 to $fp-268
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# Goto _L75
	b _L75		# unconditional branch
_L74:
	# _tmp346 = *(n)
	lw $t0, -24($fp)	# load n from $fp-24 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp347 = *(_tmp346 + 8)
	lw $t2, 8($t1) 	# load with offset
	# _tmp348 = 0
	li $t3, 0		# load constant value 0 into $t3
	# PushParam _tmp348
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load y from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load x from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam n
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp347
	# (save modified registers before flow of control change)
	sw $t1, -272($fp)	# spill _tmp346 from $t1 to $fp-272
	sw $t2, -276($fp)	# spill _tmp347 from $t2 to $fp-276
	sw $t3, -280($fp)	# spill _tmp348 from $t3 to $fp-280
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
_L75:
_L71:
	# _tmp349 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp350 = x + _tmp349
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	add $t2, $t1, $t0	
	# x = _tmp350
	move $t1, $t2		# copy value
	# Goto _L62
	# (save modified registers before flow of control change)
	sw $t0, -288($fp)	# spill _tmp349 from $t0 to $fp-288
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -284($fp)	# spill _tmp350 from $t2 to $fp-284
	b _L62		# unconditional branch
_L63:
	# _tmp351 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp352 = y + _tmp351
	lw $t1, -12($fp)	# load y from $fp-12 into $t1
	add $t2, $t1, $t0	
	# y = _tmp352
	move $t1, $t2		# copy value
	# Goto _L60
	# (save modified registers before flow of control change)
	sw $t0, -296($fp)	# spill _tmp351 from $t0 to $fp-296
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
	sw $t2, -292($fp)	# spill _tmp352 from $t2 to $fp-292
	b _L60		# unconditional branch
_L61:
	# _tmp353 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp354 = this + _tmp353
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp354) = n
	lw $t3, -24($fp)	# load n from $fp-24 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__life.runLife:
	# BeginFunc 72
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 72	# decrement sp to make space for locals/temps
	# _tmp355 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp355
	move $t1, $t0		# copy value
	# _tmp356 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp357 = gen < _tmp356
	lw $t3, 8($fp)	# load gen from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# IfZ _tmp357 Goto _L76
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp355 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -20($fp)	# spill _tmp356 from $t2 to $fp-20
	sw $t4, -24($fp)	# spill _tmp357 from $t4 to $fp-24
	beqz $t4, _L76	# branch if _tmp357 is zero 
	# _tmp358 = 0
	li $t0, 0		# load constant value 0 into $t0
	# iter = _tmp358
	move $t1, $t0		# copy value
	# Goto _L77
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp358 from $t0 to $fp-28
	sw $t1, -12($fp)	# spill iter from $t1 to $fp-12
	b _L77		# unconditional branch
_L76:
	# iter = gen
	lw $t0, 8($fp)	# load gen from $fp+8 into $t0
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill iter from $t1 to $fp-12
_L77:
	# _tmp359 = "Initial generation\n"
	.data			# create string constant marked with label
	_string14: .asciiz "Initial generation\n"
	.text
	la $t0, _string14	# load label
	# PushParam _tmp359
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp359 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp360 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp361 = *(_tmp360 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp361
	# (save modified registers before flow of control change)
	sw $t1, -36($fp)	# spill _tmp360 from $t1 to $fp-36
	sw $t2, -40($fp)	# spill _tmp361 from $t2 to $fp-40
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L78:
	# _tmp362 = i < iter
	lw $t0, -8($fp)	# load i from $fp-8 into $t0
	lw $t1, -12($fp)	# load iter from $fp-12 into $t1
	slt $t2, $t0, $t1	
	# IfZ _tmp362 Goto _L79
	# (save modified registers before flow of control change)
	sw $t2, -44($fp)	# spill _tmp362 from $t2 to $fp-44
	beqz $t2, _L79	# branch if _tmp362 is zero 
	# _tmp363 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp364 = *(_tmp363)
	lw $t2, 0($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp364
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp363 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp364 from $t2 to $fp-52
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp365 = "New generation = "
	.data			# create string constant marked with label
	_string15: .asciiz "New generation = "
	.text
	la $t0, _string15	# load label
	# PushParam _tmp365
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp365 from $t0 to $fp-56
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load i from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp366 = "\n"
	.data			# create string constant marked with label
	_string16: .asciiz "\n"
	.text
	la $t0, _string16	# load label
	# PushParam _tmp366
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp366 from $t0 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp367 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp368 = *(_tmp367 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp368
	# (save modified registers before flow of control change)
	sw $t1, -64($fp)	# spill _tmp367 from $t1 to $fp-64
	sw $t2, -68($fp)	# spill _tmp368 from $t2 to $fp-68
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp369 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp370 = i + _tmp369
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp370
	move $t1, $t2		# copy value
	# Goto _L78
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp369 from $t0 to $fp-76
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -72($fp)	# spill _tmp370 from $t2 to $fp-72
	b _L78		# unconditional branch
_L79:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__life.playLife:
	# BeginFunc 492
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 492	# decrement sp to make space for locals/temps
	# _tmp371 = 0
	li $t0, 0		# load constant value 0 into $t0
	# x = _tmp371
	move $t1, $t0		# copy value
	# _tmp372 = 0
	li $t2, 0		# load constant value 0 into $t2
	# y = _tmp372
	move $t3, $t2		# copy value
	# _tmp373 = 0
	li $t4, 0		# load constant value 0 into $t4
	# gen = _tmp373
	move $t5, $t4		# copy value
	# _tmp374 = 0
	li $t6, 0		# load constant value 0 into $t6
	# use_rand = _tmp374
	move $t7, $t6		# copy value
	# _tmp375 = "The Game of Life using (Brown Univ) CS31 Rules\n"
	.data			# create string constant marked with label
	_string17: .asciiz "The Game of Life using (Brown Univ) CS31 Rules\n"
	.text
	la $s0, _string17	# load label
	# PushParam _tmp375
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp371 from $t0 to $fp-24
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -28($fp)	# spill _tmp372 from $t2 to $fp-28
	sw $t3, -12($fp)	# spill y from $t3 to $fp-12
	sw $t4, -32($fp)	# spill _tmp373 from $t4 to $fp-32
	sw $t5, -16($fp)	# spill gen from $t5 to $fp-16
	sw $t6, -36($fp)	# spill _tmp374 from $t6 to $fp-36
	sw $t7, -20($fp)	# spill use_rand from $t7 to $fp-20
	sw $s0, -40($fp)	# spill _tmp375 from $s0 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp376 = "Enter X dimension for game board\n"
	.data			# create string constant marked with label
	_string18: .asciiz "Enter X dimension for game board\n"
	.text
	la $t0, _string18	# load label
	# PushParam _tmp376
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp376 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L80:
	# _tmp377 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp378 = x < _tmp377
	lw $t1, -8($fp)	# load x from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# _tmp379 = x == _tmp377
	seq $t3, $t1, $t0	
	# _tmp380 = _tmp378 || _tmp379
	or $t4, $t2, $t3	
	# IfZ _tmp380 Goto _L81
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp377 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp378 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp379 from $t3 to $fp-56
	sw $t4, -60($fp)	# spill _tmp380 from $t4 to $fp-60
	beqz $t4, _L81	# branch if _tmp380 is zero 
	# _tmp381 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# x = _tmp381
	move $t1, $t0		# copy value
	# _tmp382 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp383 = x < _tmp382
	slt $t3, $t1, $t2	
	# _tmp384 = x == _tmp382
	seq $t4, $t1, $t2	
	# _tmp385 = _tmp383 || _tmp384
	or $t5, $t3, $t4	
	# IfZ _tmp385 Goto _L82
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp381 from $t0 to $fp-64
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -68($fp)	# spill _tmp382 from $t2 to $fp-68
	sw $t3, -72($fp)	# spill _tmp383 from $t3 to $fp-72
	sw $t4, -76($fp)	# spill _tmp384 from $t4 to $fp-76
	sw $t5, -80($fp)	# spill _tmp385 from $t5 to $fp-80
	beqz $t5, _L82	# branch if _tmp385 is zero 
	# _tmp386 = "Invalid x dimension, try again\n"
	.data			# create string constant marked with label
	_string19: .asciiz "Invalid x dimension, try again\n"
	.text
	la $t0, _string19	# load label
	# PushParam _tmp386
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp386 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L83
	b _L83		# unconditional branch
_L82:
_L83:
	# Goto _L80
	b _L80		# unconditional branch
_L81:
	# _tmp387 = "Enter Y dimension for game board\n"
	.data			# create string constant marked with label
	_string20: .asciiz "Enter Y dimension for game board\n"
	.text
	la $t0, _string20	# load label
	# PushParam _tmp387
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp387 from $t0 to $fp-88
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L84:
	# _tmp388 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp389 = y < _tmp388
	lw $t1, -12($fp)	# load y from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# _tmp390 = y == _tmp388
	seq $t3, $t1, $t0	
	# _tmp391 = _tmp389 || _tmp390
	or $t4, $t2, $t3	
	# IfZ _tmp391 Goto _L85
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp388 from $t0 to $fp-92
	sw $t2, -96($fp)	# spill _tmp389 from $t2 to $fp-96
	sw $t3, -100($fp)	# spill _tmp390 from $t3 to $fp-100
	sw $t4, -104($fp)	# spill _tmp391 from $t4 to $fp-104
	beqz $t4, _L85	# branch if _tmp391 is zero 
	# _tmp392 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# y = _tmp392
	move $t1, $t0		# copy value
	# _tmp393 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp394 = y < _tmp393
	slt $t3, $t1, $t2	
	# _tmp395 = y == _tmp393
	seq $t4, $t1, $t2	
	# _tmp396 = _tmp394 || _tmp395
	or $t5, $t3, $t4	
	# IfZ _tmp396 Goto _L86
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp392 from $t0 to $fp-108
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
	sw $t2, -112($fp)	# spill _tmp393 from $t2 to $fp-112
	sw $t3, -116($fp)	# spill _tmp394 from $t3 to $fp-116
	sw $t4, -120($fp)	# spill _tmp395 from $t4 to $fp-120
	sw $t5, -124($fp)	# spill _tmp396 from $t5 to $fp-124
	beqz $t5, _L86	# branch if _tmp396 is zero 
	# _tmp397 = "Invalid y dimension, try again\n"
	.data			# create string constant marked with label
	_string21: .asciiz "Invalid y dimension, try again\n"
	.text
	la $t0, _string21	# load label
	# PushParam _tmp397
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp397 from $t0 to $fp-128
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L87
	b _L87		# unconditional branch
_L86:
_L87:
	# Goto _L84
	b _L84		# unconditional branch
_L85:
	# _tmp398 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp399 = *(_tmp398 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, -12($fp)	# load y from $fp-12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load x from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp399
	# (save modified registers before flow of control change)
	sw $t1, -132($fp)	# spill _tmp398 from $t1 to $fp-132
	sw $t2, -136($fp)	# spill _tmp399 from $t2 to $fp-136
	jalr $t2            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp400 = 0
	li $t0, 0		# load constant value 0 into $t0
	# x = _tmp400
	move $t1, $t0		# copy value
	# _tmp401 = 0
	li $t2, 0		# load constant value 0 into $t2
	# y = _tmp401
	move $t3, $t2		# copy value
	# _tmp402 = "Would you like to use a random starting state?\n"
	.data			# create string constant marked with label
	_string22: .asciiz "Would you like to use a random starting state?\n"
	.text
	la $t4, _string22	# load label
	# PushParam _tmp402
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp400 from $t0 to $fp-140
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -144($fp)	# spill _tmp401 from $t2 to $fp-144
	sw $t3, -12($fp)	# spill y from $t3 to $fp-12
	sw $t4, -148($fp)	# spill _tmp402 from $t4 to $fp-148
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp403 = "Type 0 for no, anything else for yes\n"
	.data			# create string constant marked with label
	_string23: .asciiz "Type 0 for no, anything else for yes\n"
	.text
	la $t0, _string23	# load label
	# PushParam _tmp403
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp403 from $t0 to $fp-152
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp404 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# use_rand = _tmp404
	move $t1, $t0		# copy value
	# _tmp405 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp406 = use_rand < _tmp405
	slt $t3, $t1, $t2	
	# _tmp407 = _tmp405 < use_rand
	slt $t4, $t2, $t1	
	# _tmp408 = _tmp406 || _tmp407
	or $t5, $t3, $t4	
	# IfZ _tmp408 Goto _L88
	# (save modified registers before flow of control change)
	sw $t0, -156($fp)	# spill _tmp404 from $t0 to $fp-156
	sw $t1, -20($fp)	# spill use_rand from $t1 to $fp-20
	sw $t2, -160($fp)	# spill _tmp405 from $t2 to $fp-160
	sw $t3, -164($fp)	# spill _tmp406 from $t3 to $fp-164
	sw $t4, -168($fp)	# spill _tmp407 from $t4 to $fp-168
	sw $t5, -172($fp)	# spill _tmp408 from $t5 to $fp-172
	beqz $t5, _L88	# branch if _tmp408 is zero 
	# _tmp409 = "Please enter an random seed\n"
	.data			# create string constant marked with label
	_string24: .asciiz "Please enter an random seed\n"
	.text
	la $t0, _string24	# load label
	# PushParam _tmp409
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp409 from $t0 to $fp-176
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp410 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# x = _tmp410
	move $t1, $t0		# copy value
	# _tmp411 = 8
	li $t2, 8		# load constant value 8 into $t2
	# PushParam _tmp411
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp412 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp410 from $t0 to $fp-180
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -184($fp)	# spill _tmp411 from $t2 to $fp-184
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp413 = rndModule
	la $t1, rndModule	# load label
	# *(_tmp412) = _tmp413
	sw $t1, 0($t0) 	# store with offset
	# _tmp414 = 16
	li $t2, 16		# load constant value 16 into $t2
	# _tmp415 = this + _tmp414
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp415) = _tmp412
	sw $t0, 0($t4) 	# store with offset
	# _tmp416 = *(this + 16)
	lw $t5, 16($t3) 	# load with offset
	# _tmp417 = *(_tmp416)
	lw $t6, 0($t5) 	# load with offset
	# _tmp418 = *(_tmp417)
	lw $t7, 0($t6) 	# load with offset
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $s0, -8($fp)	# load x from $fp-8 into $s0
	sw $s0, 4($sp)	# copy param value to stack
	# PushParam _tmp416
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# ACall _tmp418
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp412 from $t0 to $fp-188
	sw $t1, -192($fp)	# spill _tmp413 from $t1 to $fp-192
	sw $t2, -196($fp)	# spill _tmp414 from $t2 to $fp-196
	sw $t4, -200($fp)	# spill _tmp415 from $t4 to $fp-200
	sw $t5, -204($fp)	# spill _tmp416 from $t5 to $fp-204
	sw $t6, -208($fp)	# spill _tmp417 from $t6 to $fp-208
	sw $t7, -212($fp)	# spill _tmp418 from $t7 to $fp-212
	jalr $t7            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp419 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# _tmp420 = *(_tmp419)
	lw $t2, 0($t1) 	# load with offset
	# _tmp421 = *(_tmp420 + 8)
	lw $t3, 8($t2) 	# load with offset
	# _tmp422 = *(this + 24)
	lw $t4, 24($t0) 	# load with offset
	# _tmp423 = *(this + 20)
	lw $t5, 20($t0) 	# load with offset
	# _tmp424 = _tmp423 * _tmp422
	mul $t6, $t5, $t4	
	# PushParam _tmp424
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam _tmp419
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp425 = ACall _tmp421
	# (save modified registers before flow of control change)
	sw $t1, -216($fp)	# spill _tmp419 from $t1 to $fp-216
	sw $t2, -220($fp)	# spill _tmp420 from $t2 to $fp-220
	sw $t3, -224($fp)	# spill _tmp421 from $t3 to $fp-224
	sw $t4, -232($fp)	# spill _tmp422 from $t4 to $fp-232
	sw $t5, -236($fp)	# spill _tmp423 from $t5 to $fp-236
	sw $t6, -228($fp)	# spill _tmp424 from $t6 to $fp-228
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# gen = _tmp425
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -240($fp)	# spill _tmp425 from $t0 to $fp-240
	sw $t1, -16($fp)	# spill gen from $t1 to $fp-16
_L90:
	# _tmp426 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp427 = _tmp426 < gen
	lw $t1, -16($fp)	# load gen from $fp-16 into $t1
	slt $t2, $t0, $t1	
	# IfZ _tmp427 Goto _L91
	# (save modified registers before flow of control change)
	sw $t0, -244($fp)	# spill _tmp426 from $t0 to $fp-244
	sw $t2, -248($fp)	# spill _tmp427 from $t2 to $fp-248
	beqz $t2, _L91	# branch if _tmp427 is zero 
	# _tmp428 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# _tmp429 = *(_tmp428)
	lw $t2, 0($t1) 	# load with offset
	# _tmp430 = *(_tmp429 + 8)
	lw $t3, 8($t2) 	# load with offset
	# _tmp431 = *(this + 20)
	lw $t4, 20($t0) 	# load with offset
	# PushParam _tmp431
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp428
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp432 = ACall _tmp430
	# (save modified registers before flow of control change)
	sw $t1, -252($fp)	# spill _tmp428 from $t1 to $fp-252
	sw $t2, -256($fp)	# spill _tmp429 from $t2 to $fp-256
	sw $t3, -260($fp)	# spill _tmp430 from $t3 to $fp-260
	sw $t4, -264($fp)	# spill _tmp431 from $t4 to $fp-264
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# x = _tmp432
	move $t1, $t0		# copy value
	# _tmp433 = *(this + 16)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 16($t2) 	# load with offset
	# _tmp434 = *(_tmp433)
	lw $t4, 0($t3) 	# load with offset
	# _tmp435 = *(_tmp434 + 8)
	lw $t5, 8($t4) 	# load with offset
	# _tmp436 = *(this + 24)
	lw $t6, 24($t2) 	# load with offset
	# PushParam _tmp436
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam _tmp433
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp437 = ACall _tmp435
	# (save modified registers before flow of control change)
	sw $t0, -268($fp)	# spill _tmp432 from $t0 to $fp-268
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t3, -272($fp)	# spill _tmp433 from $t3 to $fp-272
	sw $t4, -276($fp)	# spill _tmp434 from $t4 to $fp-276
	sw $t5, -280($fp)	# spill _tmp435 from $t5 to $fp-280
	sw $t6, -284($fp)	# spill _tmp436 from $t6 to $fp-284
	jalr $t5            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# y = _tmp437
	move $t1, $t0		# copy value
	# _tmp438 = *(this)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp439 = *(_tmp438 + 12)
	lw $t4, 12($t3) 	# load with offset
	# _tmp440 = 1
	li $t5, 1		# load constant value 1 into $t5
	# PushParam _tmp440
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, -8($fp)	# load x from $fp-8 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp441 = ACall _tmp439
	# (save modified registers before flow of control change)
	sw $t0, -288($fp)	# spill _tmp437 from $t0 to $fp-288
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
	sw $t3, -292($fp)	# spill _tmp438 from $t3 to $fp-292
	sw $t4, -296($fp)	# spill _tmp439 from $t4 to $fp-296
	sw $t5, -300($fp)	# spill _tmp440 from $t5 to $fp-300
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp442 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp443 = gen - _tmp442
	lw $t2, -16($fp)	# load gen from $fp-16 into $t2
	sub $t3, $t2, $t1	
	# gen = _tmp443
	move $t2, $t3		# copy value
	# Goto _L90
	# (save modified registers before flow of control change)
	sw $t0, -304($fp)	# spill _tmp441 from $t0 to $fp-304
	sw $t1, -312($fp)	# spill _tmp442 from $t1 to $fp-312
	sw $t2, -16($fp)	# spill gen from $t2 to $fp-16
	sw $t3, -308($fp)	# spill _tmp443 from $t3 to $fp-308
	b _L90		# unconditional branch
_L91:
	# Goto _L89
	b _L89		# unconditional branch
_L88:
	# _tmp444 = "Input initial live cell\n"
	.data			# create string constant marked with label
	_string25: .asciiz "Input initial live cell\n"
	.text
	la $t0, _string25	# load label
	# PushParam _tmp444
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -316($fp)	# spill _tmp444 from $t0 to $fp-316
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L92:
	# _tmp445 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp446 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp447 = _tmp445 - _tmp446
	sub $t2, $t0, $t1	
	# _tmp448 = y < _tmp447
	lw $t3, -12($fp)	# load y from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp449 = _tmp447 < y
	slt $t5, $t2, $t3	
	# _tmp450 = _tmp448 || _tmp449
	or $t6, $t4, $t5	
	# _tmp451 = 0
	li $t7, 0		# load constant value 0 into $t7
	# _tmp452 = 1
	li $s0, 1		# load constant value 1 into $s0
	# _tmp453 = _tmp451 - _tmp452
	sub $s1, $t7, $s0	
	# _tmp454 = x < _tmp453
	lw $s2, -8($fp)	# load x from $fp-8 into $s2
	slt $s3, $s2, $s1	
	# _tmp455 = _tmp453 < x
	slt $s4, $s1, $s2	
	# _tmp456 = _tmp454 || _tmp455
	or $s5, $s3, $s4	
	# _tmp457 = _tmp456 && _tmp450
	and $s6, $s5, $t6	
	# IfZ _tmp457 Goto _L93
	# (save modified registers before flow of control change)
	sw $t0, -324($fp)	# spill _tmp445 from $t0 to $fp-324
	sw $t1, -332($fp)	# spill _tmp446 from $t1 to $fp-332
	sw $t2, -328($fp)	# spill _tmp447 from $t2 to $fp-328
	sw $t4, -336($fp)	# spill _tmp448 from $t4 to $fp-336
	sw $t5, -340($fp)	# spill _tmp449 from $t5 to $fp-340
	sw $t6, -344($fp)	# spill _tmp450 from $t6 to $fp-344
	sw $t7, -348($fp)	# spill _tmp451 from $t7 to $fp-348
	sw $s0, -356($fp)	# spill _tmp452 from $s0 to $fp-356
	sw $s1, -352($fp)	# spill _tmp453 from $s1 to $fp-352
	sw $s3, -360($fp)	# spill _tmp454 from $s3 to $fp-360
	sw $s4, -364($fp)	# spill _tmp455 from $s4 to $fp-364
	sw $s5, -368($fp)	# spill _tmp456 from $s5 to $fp-368
	sw $s6, -320($fp)	# spill _tmp457 from $s6 to $fp-320
	beqz $s6, _L93	# branch if _tmp457 is zero 
	# _tmp458 = "Enter x\n"
	.data			# create string constant marked with label
	_string26: .asciiz "Enter x\n"
	.text
	la $t0, _string26	# load label
	# PushParam _tmp458
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -372($fp)	# spill _tmp458 from $t0 to $fp-372
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp459 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# x = _tmp459
	move $t1, $t0		# copy value
	# _tmp460 = "Enter y\n"
	.data			# create string constant marked with label
	_string27: .asciiz "Enter y\n"
	.text
	la $t2, _string27	# load label
	# PushParam _tmp460
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -376($fp)	# spill _tmp459 from $t0 to $fp-376
	sw $t1, -8($fp)	# spill x from $t1 to $fp-8
	sw $t2, -380($fp)	# spill _tmp460 from $t2 to $fp-380
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp461 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# y = _tmp461
	move $t1, $t0		# copy value
	# _tmp462 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp463 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp464 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp465 = _tmp463 - _tmp464
	sub $t5, $t3, $t4	
	# _tmp466 = y == _tmp465
	seq $t6, $t1, $t5	
	# _tmp467 = 0
	li $t7, 0		# load constant value 0 into $t7
	# _tmp468 = 1
	li $s0, 1		# load constant value 1 into $s0
	# _tmp469 = _tmp467 - _tmp468
	sub $s1, $t7, $s0	
	# _tmp470 = x == _tmp469
	lw $s2, -8($fp)	# load x from $fp-8 into $s2
	seq $s3, $s2, $s1	
	# _tmp471 = _tmp470 && _tmp466
	and $s4, $s3, $t6	
	# _tmp472 = _tmp462 - _tmp471
	sub $s5, $t2, $s4	
	# IfZ _tmp472 Goto _L94
	# (save modified registers before flow of control change)
	sw $t0, -384($fp)	# spill _tmp461 from $t0 to $fp-384
	sw $t1, -12($fp)	# spill y from $t1 to $fp-12
	sw $t2, -388($fp)	# spill _tmp462 from $t2 to $fp-388
	sw $t3, -400($fp)	# spill _tmp463 from $t3 to $fp-400
	sw $t4, -408($fp)	# spill _tmp464 from $t4 to $fp-408
	sw $t5, -404($fp)	# spill _tmp465 from $t5 to $fp-404
	sw $t6, -412($fp)	# spill _tmp466 from $t6 to $fp-412
	sw $t7, -416($fp)	# spill _tmp467 from $t7 to $fp-416
	sw $s0, -424($fp)	# spill _tmp468 from $s0 to $fp-424
	sw $s1, -420($fp)	# spill _tmp469 from $s1 to $fp-420
	sw $s3, -428($fp)	# spill _tmp470 from $s3 to $fp-428
	sw $s4, -396($fp)	# spill _tmp471 from $s4 to $fp-396
	sw $s5, -392($fp)	# spill _tmp472 from $s5 to $fp-392
	beqz $s5, _L94	# branch if _tmp472 is zero 
	# _tmp473 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp474 = *(this)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 0($t1) 	# load with offset
	# _tmp475 = *(_tmp474 + 12)
	lw $t3, 12($t2) 	# load with offset
	# _tmp476 = 1
	li $t4, 1		# load constant value 1 into $t4
	# PushParam _tmp476
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam y
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -12($fp)	# load y from $fp-12 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam x
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, -8($fp)	# load x from $fp-8 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp477 = ACall _tmp475
	# (save modified registers before flow of control change)
	sw $t0, -432($fp)	# spill _tmp473 from $t0 to $fp-432
	sw $t2, -440($fp)	# spill _tmp474 from $t2 to $fp-440
	sw $t3, -444($fp)	# spill _tmp475 from $t3 to $fp-444
	sw $t4, -448($fp)	# spill _tmp476 from $t4 to $fp-448
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp478 = _tmp473 - _tmp477
	lw $t1, -432($fp)	# load _tmp473 from $fp-432 into $t1
	sub $t2, $t1, $t0	
	# IfZ _tmp478 Goto _L96
	# (save modified registers before flow of control change)
	sw $t0, -452($fp)	# spill _tmp477 from $t0 to $fp-452
	sw $t2, -436($fp)	# spill _tmp478 from $t2 to $fp-436
	beqz $t2, _L96	# branch if _tmp478 is zero 
	# _tmp479 = "x = "
	.data			# create string constant marked with label
	_string28: .asciiz "x = "
	.text
	la $t0, _string28	# load label
	# PushParam _tmp479
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -456($fp)	# spill _tmp479 from $t0 to $fp-456
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
	# _tmp480 = " and y = "
	.data			# create string constant marked with label
	_string29: .asciiz " and y = "
	.text
	la $t0, _string29	# load label
	# PushParam _tmp480
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -460($fp)	# spill _tmp480 from $t0 to $fp-460
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
	# _tmp481 = "are bad coords\n"
	.data			# create string constant marked with label
	_string30: .asciiz "are bad coords\n"
	.text
	la $t0, _string30	# load label
	# PushParam _tmp481
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -464($fp)	# spill _tmp481 from $t0 to $fp-464
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp482 = "Try again\n"
	.data			# create string constant marked with label
	_string31: .asciiz "Try again\n"
	.text
	la $t0, _string31	# load label
	# PushParam _tmp482
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -468($fp)	# spill _tmp482 from $t0 to $fp-468
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L97
	b _L97		# unconditional branch
_L96:
	# _tmp483 = "Entering x = "
	.data			# create string constant marked with label
	_string32: .asciiz "Entering x = "
	.text
	la $t0, _string32	# load label
	# PushParam _tmp483
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -472($fp)	# spill _tmp483 from $t0 to $fp-472
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
	# _tmp484 = ", y = "
	.data			# create string constant marked with label
	_string33: .asciiz ", y = "
	.text
	la $t0, _string33	# load label
	# PushParam _tmp484
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -476($fp)	# spill _tmp484 from $t0 to $fp-476
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
	# _tmp485 = "\n"
	.data			# create string constant marked with label
	_string34: .asciiz "\n"
	.text
	la $t0, _string34	# load label
	# PushParam _tmp485
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -480($fp)	# spill _tmp485 from $t0 to $fp-480
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L97:
	# Goto _L95
	b _L95		# unconditional branch
_L94:
_L95:
	# Goto _L92
	b _L92		# unconditional branch
_L93:
_L89:
	# _tmp486 = "How many generations would like you run?\n"
	.data			# create string constant marked with label
	_string35: .asciiz "How many generations would like you run?\n"
	.text
	la $t0, _string35	# load label
	# PushParam _tmp486
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -484($fp)	# spill _tmp486 from $t0 to $fp-484
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp487 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# gen = _tmp487
	move $t1, $t0		# copy value
	# _tmp488 = *(this)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp489 = *(_tmp488 + 20)
	lw $t4, 20($t3) 	# load with offset
	# PushParam gen
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp489
	# (save modified registers before flow of control change)
	sw $t0, -488($fp)	# spill _tmp487 from $t0 to $fp-488
	sw $t1, -16($fp)	# spill gen from $t1 to $fp-16
	sw $t3, -492($fp)	# spill _tmp488 from $t3 to $fp-492
	sw $t4, -496($fp)	# spill _tmp489 from $t4 to $fp-496
	jalr $t4            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class life
	.data
	.align 2
	life:		# label for class life vtable
	.word __life.DoLife
	.word __life.Init
	.word __life.PrintMatrix
	.word __life.SetInit
	.word __life.playLife
	.word __life.runLife
	.text
main:
	# BeginFunc 24
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 24	# decrement sp to make space for locals/temps
	# _tmp490 = 28
	li $t0, 28		# load constant value 28 into $t0
	# PushParam _tmp490
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp491 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp490 from $t0 to $fp-12
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp492 = life
	la $t1, life	# load label
	# *(_tmp491) = _tmp492
	sw $t1, 0($t0) 	# store with offset
	# l = _tmp491
	move $t2, $t0		# copy value
	# _tmp493 = *(l)
	lw $t3, 0($t2) 	# load with offset
	# _tmp494 = *(_tmp493 + 16)
	lw $t4, 16($t3) 	# load with offset
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp494
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp491 from $t0 to $fp-16
	sw $t1, -20($fp)	# spill _tmp492 from $t1 to $fp-20
	sw $t2, -8($fp)	# spill l from $t2 to $fp-8
	sw $t3, -24($fp)	# spill _tmp493 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp494 from $t4 to $fp-28
	jalr $t4            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
