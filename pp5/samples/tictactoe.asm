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
	# BeginFunc 36
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 36	# decrement sp to make space for locals/temps
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
	# randomNum = _tmp16
	move $t1, $t0		# copy value
	# _tmp17 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp18 = max - min
	lw $t3, 12($fp)	# load max from $fp+12 into $t3
	lw $t4, 8($fp)	# load min from $fp+8 into $t4
	sub $t5, $t3, $t4	
	# _tmp19 = _tmp18 + _tmp17
	add $t6, $t5, $t2	
	# _tmp20 = randomNum % _tmp19
	rem $t7, $t1, $t6	
	# _tmp21 = _tmp20 + min
	add $s0, $t7, $t4	
	# Return _tmp21
	move $v0, $s0		# assign return value into $v0
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
__Square.Init:
	# BeginFunc 12
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp22 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp23 = 4
	li $t1, 4		# load constant value 4 into $t1
	# _tmp24 = this + _tmp23
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp24) = _tmp22
	sw $t0, 0($t3) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Square.PrintSquare:
	# BeginFunc 28
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 28	# decrement sp to make space for locals/temps
	# _tmp25 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp26 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp27 = _tmp25 == _tmp26
	seq $t3, $t1, $t2	
	# IfZ _tmp27 Goto _L0
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp25 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp26 from $t2 to $fp-12
	sw $t3, -16($fp)	# spill _tmp27 from $t3 to $fp-16
	beqz $t3, _L0	# branch if _tmp27 is zero 
	# _tmp28 = " "
	.data			# create string constant marked with label
	_string1: .asciiz " "
	.text
	la $t0, _string1	# load label
	# PushParam _tmp28
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp28 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp29 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# PushParam _tmp29
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp29 from $t1 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp30 = " "
	.data			# create string constant marked with label
	_string2: .asciiz " "
	.text
	la $t0, _string2	# load label
	# PushParam _tmp30
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp30 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L1
	b _L1		# unconditional branch
_L0:
	# _tmp31 = "   "
	.data			# create string constant marked with label
	_string3: .asciiz "   "
	.text
	la $t0, _string3	# load label
	# PushParam _tmp31
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp31 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L1:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Square.SetIsEmpty:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp32 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp33 = this + _tmp32
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp33) = isEmpty
	lw $t3, 8($fp)	# load isEmpty from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Square.GetIsEmpty:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp34 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
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
__Square.SetMark:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp35 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp36 = this + _tmp35
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp36) = mark
	lw $t3, 8($fp)	# load mark from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Square.IsMarked:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp37 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# IfZ _tmp37 Goto _L2
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp37 from $t1 to $fp-8
	beqz $t1, _L2	# branch if _tmp37 is zero 
	# _tmp38 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp38
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L3
	b _L3		# unconditional branch
_L2:
	# _tmp39 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, 8($fp)	# load mark from $fp+8 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam _tmp39
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp40 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp39 from $t1 to $fp-20
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Return _tmp40
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
_L3:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Square
	.data
	.align 2
	Square:		# label for class Square vtable
	.word __Square.GetIsEmpty
	.word __Square.Init
	.word __Square.IsMarked
	.word __Square.PrintSquare
	.word __Square.SetIsEmpty
	.word __Square.SetMark
	.text
__Player.GetMark:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp41 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# Return _tmp41
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
__Player.GetName:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp42 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# Return _tmp42
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
	# VTable for class Player
	.data
	.align 2
	Player:		# label for class Player vtable
	.word __Player.GetMark
	.word __Player.GetName
	.text
__Human.Init:
	# BeginFunc 28
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 28	# decrement sp to make space for locals/temps
	# _tmp43 = "X"
	.data			# create string constant marked with label
	_string4: .asciiz "X"
	.text
	la $t0, _string4	# load label
	# _tmp44 = 4
	li $t1, 4		# load constant value 4 into $t1
	# _tmp45 = this + _tmp44
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp45) = _tmp43
	sw $t0, 0($t3) 	# store with offset
	# _tmp46 = "\nYou're playing against the computer.\nEnter you..."
	.data			# create string constant marked with label
	_string5: .asciiz "\nYou're playing against the computer.\nEnter your name: "
	.text
	la $t4, _string5	# load label
	# PushParam _tmp46
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp43 from $t0 to $fp-8
	sw $t1, -12($fp)	# spill _tmp44 from $t1 to $fp-12
	sw $t3, -16($fp)	# spill _tmp45 from $t3 to $fp-16
	sw $t4, -20($fp)	# spill _tmp46 from $t4 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp47 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# _tmp48 = 8
	li $t1, 8		# load constant value 8 into $t1
	# _tmp49 = this + _tmp48
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp49) = _tmp47
	sw $t0, 0($t3) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Human.GetRow:
	# BeginFunc 80
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 80	# decrement sp to make space for locals/temps
	# _tmp50 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp51 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp52 = _tmp50 - _tmp51
	sub $t2, $t0, $t1	
	# row = _tmp52
	move $t3, $t2		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp50 from $t0 to $fp-12
	sw $t1, -20($fp)	# spill _tmp51 from $t1 to $fp-20
	sw $t2, -16($fp)	# spill _tmp52 from $t2 to $fp-16
	sw $t3, -8($fp)	# spill row from $t3 to $fp-8
_L4:
	# _tmp53 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp54 = row < _tmp53
	lw $t1, -8($fp)	# load row from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# _tmp55 = 3
	li $t3, 3		# load constant value 3 into $t3
	# _tmp56 = _tmp55 < row
	slt $t4, $t3, $t1	
	# _tmp57 = _tmp56 || _tmp54
	or $t5, $t4, $t2	
	# IfZ _tmp57 Goto _L5
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp53 from $t0 to $fp-28
	sw $t2, -32($fp)	# spill _tmp54 from $t2 to $fp-32
	sw $t3, -36($fp)	# spill _tmp55 from $t3 to $fp-36
	sw $t4, -40($fp)	# spill _tmp56 from $t4 to $fp-40
	sw $t5, -24($fp)	# spill _tmp57 from $t5 to $fp-24
	beqz $t5, _L5	# branch if _tmp57 is zero 
	# _tmp58 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# PushParam _tmp58
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -44($fp)	# spill _tmp58 from $t1 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp59 = " enter a row between 1 and 3: "
	.data			# create string constant marked with label
	_string6: .asciiz " enter a row between 1 and 3: "
	.text
	la $t0, _string6	# load label
	# PushParam _tmp59
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp59 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp60 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# row = _tmp60
	move $t1, $t0		# copy value
	# _tmp61 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp62 = row < _tmp61
	slt $t3, $t1, $t2	
	# _tmp63 = 3
	li $t4, 3		# load constant value 3 into $t4
	# _tmp64 = _tmp63 < row
	slt $t5, $t4, $t1	
	# _tmp65 = _tmp64 || _tmp62
	or $t6, $t5, $t3	
	# IfZ _tmp65 Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp60 from $t0 to $fp-52
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -60($fp)	# spill _tmp61 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp62 from $t3 to $fp-64
	sw $t4, -68($fp)	# spill _tmp63 from $t4 to $fp-68
	sw $t5, -72($fp)	# spill _tmp64 from $t5 to $fp-72
	sw $t6, -56($fp)	# spill _tmp65 from $t6 to $fp-56
	beqz $t6, _L6	# branch if _tmp65 is zero 
	# _tmp66 = "Error: Pick a row between 1 and 3\n"
	.data			# create string constant marked with label
	_string7: .asciiz "Error: Pick a row between 1 and 3\n"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp66
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp66 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L7
	b _L7		# unconditional branch
_L6:
_L7:
	# Goto _L4
	b _L4		# unconditional branch
_L5:
	# _tmp67 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp68 = row - _tmp67
	lw $t1, -8($fp)	# load row from $fp-8 into $t1
	sub $t2, $t1, $t0	
	# row = _tmp68
	move $t1, $t2		# copy value
	# Return row
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
__Human.GetColumn:
	# BeginFunc 80
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 80	# decrement sp to make space for locals/temps
	# _tmp69 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp70 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp71 = _tmp69 - _tmp70
	sub $t2, $t0, $t1	
	# column = _tmp71
	move $t3, $t2		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp69 from $t0 to $fp-12
	sw $t1, -20($fp)	# spill _tmp70 from $t1 to $fp-20
	sw $t2, -16($fp)	# spill _tmp71 from $t2 to $fp-16
	sw $t3, -8($fp)	# spill column from $t3 to $fp-8
_L8:
	# _tmp72 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp73 = column < _tmp72
	lw $t1, -8($fp)	# load column from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# _tmp74 = 3
	li $t3, 3		# load constant value 3 into $t3
	# _tmp75 = _tmp74 < column
	slt $t4, $t3, $t1	
	# _tmp76 = _tmp75 || _tmp73
	or $t5, $t4, $t2	
	# IfZ _tmp76 Goto _L9
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp72 from $t0 to $fp-28
	sw $t2, -32($fp)	# spill _tmp73 from $t2 to $fp-32
	sw $t3, -36($fp)	# spill _tmp74 from $t3 to $fp-36
	sw $t4, -40($fp)	# spill _tmp75 from $t4 to $fp-40
	sw $t5, -24($fp)	# spill _tmp76 from $t5 to $fp-24
	beqz $t5, _L9	# branch if _tmp76 is zero 
	# _tmp77 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# PushParam _tmp77
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -44($fp)	# spill _tmp77 from $t1 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp78 = " enter a column between 1 and 3: "
	.data			# create string constant marked with label
	_string8: .asciiz " enter a column between 1 and 3: "
	.text
	la $t0, _string8	# load label
	# PushParam _tmp78
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp78 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp79 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# column = _tmp79
	move $t1, $t0		# copy value
	# _tmp80 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp81 = column < _tmp80
	slt $t3, $t1, $t2	
	# _tmp82 = 3
	li $t4, 3		# load constant value 3 into $t4
	# _tmp83 = _tmp82 < column
	slt $t5, $t4, $t1	
	# _tmp84 = _tmp83 || _tmp81
	or $t6, $t5, $t3	
	# IfZ _tmp84 Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp79 from $t0 to $fp-52
	sw $t1, -8($fp)	# spill column from $t1 to $fp-8
	sw $t2, -60($fp)	# spill _tmp80 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp81 from $t3 to $fp-64
	sw $t4, -68($fp)	# spill _tmp82 from $t4 to $fp-68
	sw $t5, -72($fp)	# spill _tmp83 from $t5 to $fp-72
	sw $t6, -56($fp)	# spill _tmp84 from $t6 to $fp-56
	beqz $t6, _L10	# branch if _tmp84 is zero 
	# _tmp85 = "Error: Pick a column between 1 and 3\n"
	.data			# create string constant marked with label
	_string9: .asciiz "Error: Pick a column between 1 and 3\n"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp85
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp85 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L11
	b _L11		# unconditional branch
_L10:
_L11:
	# Goto _L8
	b _L8		# unconditional branch
_L9:
	# _tmp86 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp87 = column - _tmp86
	lw $t1, -8($fp)	# load column from $fp-8 into $t1
	sub $t2, $t1, $t0	
	# column = _tmp87
	move $t1, $t2		# copy value
	# Return column
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
	# VTable for class Human
	.data
	.align 2
	Human:		# label for class Human vtable
	.word __Human.GetColumn
	.word __Player.GetMark
	.word __Player.GetName
	.word __Human.GetRow
	.word __Human.Init
	.text
__Grid.Init:
	# BeginFunc 380
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 380	# decrement sp to make space for locals/temps
	# _tmp88 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp88
	move $t1, $t0		# copy value
	# _tmp89 = 3
	li $t2, 3		# load constant value 3 into $t2
	# _tmp90 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp91 = _tmp89 < _tmp90
	slt $t4, $t2, $t3	
	# _tmp92 = _tmp89 == _tmp90
	seq $t5, $t2, $t3	
	# _tmp93 = _tmp91 || _tmp92
	or $t6, $t4, $t5	
	# IfZ _tmp93 Goto _L12
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp88 from $t0 to $fp-16
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -20($fp)	# spill _tmp89 from $t2 to $fp-20
	sw $t3, -24($fp)	# spill _tmp90 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp91 from $t4 to $fp-28
	sw $t5, -32($fp)	# spill _tmp92 from $t5 to $fp-32
	sw $t6, -36($fp)	# spill _tmp93 from $t6 to $fp-36
	beqz $t6, _L12	# branch if _tmp93 is zero 
	# _tmp94 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp94
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp94 from $t0 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L12:
	# _tmp95 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp96 = _tmp89 * _tmp95
	lw $t1, -20($fp)	# load _tmp89 from $fp-20 into $t1
	mul $t2, $t1, $t0	
	# _tmp97 = _tmp96 + _tmp95
	add $t3, $t2, $t0	
	# PushParam _tmp97
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp98 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp95 from $t0 to $fp-44
	sw $t2, -48($fp)	# spill _tmp96 from $t2 to $fp-48
	sw $t3, -52($fp)	# spill _tmp97 from $t3 to $fp-52
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp98) = _tmp89
	lw $t1, -20($fp)	# load _tmp89 from $fp-20 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp99 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp100 = this + _tmp99
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp100) = _tmp98
	sw $t0, 0($t4) 	# store with offset
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp98 from $t0 to $fp-56
	sw $t2, -60($fp)	# spill _tmp99 from $t2 to $fp-60
	sw $t4, -64($fp)	# spill _tmp100 from $t4 to $fp-64
_L13:
	# _tmp101 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp102 = i < _tmp101
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp102 Goto _L14
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp101 from $t0 to $fp-68
	sw $t2, -72($fp)	# spill _tmp102 from $t2 to $fp-72
	beqz $t2, _L14	# branch if _tmp102 is zero 
	# _tmp103 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp104 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp105 = _tmp103 < _tmp104
	slt $t2, $t0, $t1	
	# _tmp106 = _tmp103 == _tmp104
	seq $t3, $t0, $t1	
	# _tmp107 = _tmp105 || _tmp106
	or $t4, $t2, $t3	
	# IfZ _tmp107 Goto _L15
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp103 from $t0 to $fp-76
	sw $t1, -80($fp)	# spill _tmp104 from $t1 to $fp-80
	sw $t2, -84($fp)	# spill _tmp105 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp106 from $t3 to $fp-88
	sw $t4, -92($fp)	# spill _tmp107 from $t4 to $fp-92
	beqz $t4, _L15	# branch if _tmp107 is zero 
	# _tmp108 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string11: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string11	# load label
	# PushParam _tmp108
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp108 from $t0 to $fp-96
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L15:
	# _tmp109 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp110 = _tmp103 * _tmp109
	lw $t1, -76($fp)	# load _tmp103 from $fp-76 into $t1
	mul $t2, $t1, $t0	
	# _tmp111 = _tmp110 + _tmp109
	add $t3, $t2, $t0	
	# PushParam _tmp111
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp112 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp109 from $t0 to $fp-100
	sw $t2, -104($fp)	# spill _tmp110 from $t2 to $fp-104
	sw $t3, -108($fp)	# spill _tmp111 from $t3 to $fp-108
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp112) = _tmp103
	lw $t1, -76($fp)	# load _tmp103 from $fp-76 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp113 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp114 = *(_tmp113)
	lw $t4, 0($t3) 	# load with offset
	# _tmp115 = i < _tmp114
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp116 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp117 = _tmp116 < i
	slt $s0, $t7, $t5	
	# _tmp118 = _tmp117 && _tmp115
	and $s1, $s0, $t6	
	# IfZ _tmp118 Goto _L16
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp112 from $t0 to $fp-112
	sw $t3, -116($fp)	# spill _tmp113 from $t3 to $fp-116
	sw $t4, -120($fp)	# spill _tmp114 from $t4 to $fp-120
	sw $t6, -124($fp)	# spill _tmp115 from $t6 to $fp-124
	sw $t7, -128($fp)	# spill _tmp116 from $t7 to $fp-128
	sw $s0, -132($fp)	# spill _tmp117 from $s0 to $fp-132
	sw $s1, -136($fp)	# spill _tmp118 from $s1 to $fp-136
	beqz $s1, _L16	# branch if _tmp118 is zero 
	# _tmp119 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp120 = i * _tmp119
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp121 = _tmp120 + _tmp119
	add $t3, $t2, $t0	
	# _tmp122 = _tmp113 + _tmp121
	lw $t4, -116($fp)	# load _tmp113 from $fp-116 into $t4
	add $t5, $t4, $t3	
	# Goto _L17
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp119 from $t0 to $fp-140
	sw $t2, -144($fp)	# spill _tmp120 from $t2 to $fp-144
	sw $t3, -148($fp)	# spill _tmp121 from $t3 to $fp-148
	sw $t5, -148($fp)	# spill _tmp122 from $t5 to $fp-148
	b _L17		# unconditional branch
_L16:
	# _tmp123 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string12: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string12	# load label
	# PushParam _tmp123
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp123 from $t0 to $fp-152
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L17:
	# *(_tmp122) = _tmp112
	lw $t0, -112($fp)	# load _tmp112 from $fp-112 into $t0
	lw $t1, -148($fp)	# load _tmp122 from $fp-148 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp124 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp125 = i + _tmp124
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	add $t4, $t3, $t2	
	# i = _tmp125
	move $t3, $t4		# copy value
	# Goto _L13
	# (save modified registers before flow of control change)
	sw $t2, -160($fp)	# spill _tmp124 from $t2 to $fp-160
	sw $t3, -8($fp)	# spill i from $t3 to $fp-8
	sw $t4, -156($fp)	# spill _tmp125 from $t4 to $fp-156
	b _L13		# unconditional branch
_L14:
	# _tmp126 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp126
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -164($fp)	# spill _tmp126 from $t0 to $fp-164
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L18:
	# _tmp127 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp128 = i < _tmp127
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp128 Goto _L19
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp127 from $t0 to $fp-168
	sw $t2, -172($fp)	# spill _tmp128 from $t2 to $fp-172
	beqz $t2, _L19	# branch if _tmp128 is zero 
	# _tmp129 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp129
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp129 from $t0 to $fp-176
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L20:
	# _tmp130 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp131 = j < _tmp130
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp131 Goto _L21
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp130 from $t0 to $fp-180
	sw $t2, -184($fp)	# spill _tmp131 from $t2 to $fp-184
	beqz $t2, _L21	# branch if _tmp131 is zero 
	# _tmp132 = 12
	li $t0, 12		# load constant value 12 into $t0
	# PushParam _tmp132
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp133 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp132 from $t0 to $fp-188
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp134 = Square
	la $t1, Square	# load label
	# *(_tmp133) = _tmp134
	sw $t1, 0($t0) 	# store with offset
	# _tmp135 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp136 = *(_tmp135)
	lw $t4, 0($t3) 	# load with offset
	# _tmp137 = i < _tmp136
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp138 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp139 = _tmp138 < i
	slt $s0, $t7, $t5	
	# _tmp140 = _tmp139 && _tmp137
	and $s1, $s0, $t6	
	# IfZ _tmp140 Goto _L22
	# (save modified registers before flow of control change)
	sw $t0, -192($fp)	# spill _tmp133 from $t0 to $fp-192
	sw $t1, -196($fp)	# spill _tmp134 from $t1 to $fp-196
	sw $t3, -200($fp)	# spill _tmp135 from $t3 to $fp-200
	sw $t4, -204($fp)	# spill _tmp136 from $t4 to $fp-204
	sw $t6, -208($fp)	# spill _tmp137 from $t6 to $fp-208
	sw $t7, -212($fp)	# spill _tmp138 from $t7 to $fp-212
	sw $s0, -216($fp)	# spill _tmp139 from $s0 to $fp-216
	sw $s1, -220($fp)	# spill _tmp140 from $s1 to $fp-220
	beqz $s1, _L22	# branch if _tmp140 is zero 
	# _tmp141 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp142 = i * _tmp141
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp143 = _tmp142 + _tmp141
	add $t3, $t2, $t0	
	# _tmp144 = _tmp135 + _tmp143
	lw $t4, -200($fp)	# load _tmp135 from $fp-200 into $t4
	add $t5, $t4, $t3	
	# Goto _L23
	# (save modified registers before flow of control change)
	sw $t0, -224($fp)	# spill _tmp141 from $t0 to $fp-224
	sw $t2, -228($fp)	# spill _tmp142 from $t2 to $fp-228
	sw $t3, -232($fp)	# spill _tmp143 from $t3 to $fp-232
	sw $t5, -232($fp)	# spill _tmp144 from $t5 to $fp-232
	b _L23		# unconditional branch
_L22:
	# _tmp145 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string13: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string13	# load label
	# PushParam _tmp145
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -236($fp)	# spill _tmp145 from $t0 to $fp-236
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L23:
	# _tmp146 = *(_tmp144)
	lw $t0, -232($fp)	# load _tmp144 from $fp-232 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp147 = *(_tmp146)
	lw $t2, 0($t1) 	# load with offset
	# _tmp148 = j < _tmp147
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp149 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp150 = _tmp149 < j
	slt $t6, $t5, $t3	
	# _tmp151 = _tmp150 && _tmp148
	and $t7, $t6, $t4	
	# IfZ _tmp151 Goto _L24
	# (save modified registers before flow of control change)
	sw $t1, -240($fp)	# spill _tmp146 from $t1 to $fp-240
	sw $t2, -244($fp)	# spill _tmp147 from $t2 to $fp-244
	sw $t4, -248($fp)	# spill _tmp148 from $t4 to $fp-248
	sw $t5, -252($fp)	# spill _tmp149 from $t5 to $fp-252
	sw $t6, -256($fp)	# spill _tmp150 from $t6 to $fp-256
	sw $t7, -260($fp)	# spill _tmp151 from $t7 to $fp-260
	beqz $t7, _L24	# branch if _tmp151 is zero 
	# _tmp152 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp153 = j * _tmp152
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp154 = _tmp153 + _tmp152
	add $t3, $t2, $t0	
	# _tmp155 = _tmp146 + _tmp154
	lw $t4, -240($fp)	# load _tmp146 from $fp-240 into $t4
	add $t5, $t4, $t3	
	# Goto _L25
	# (save modified registers before flow of control change)
	sw $t0, -264($fp)	# spill _tmp152 from $t0 to $fp-264
	sw $t2, -268($fp)	# spill _tmp153 from $t2 to $fp-268
	sw $t3, -272($fp)	# spill _tmp154 from $t3 to $fp-272
	sw $t5, -272($fp)	# spill _tmp155 from $t5 to $fp-272
	b _L25		# unconditional branch
_L24:
	# _tmp156 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string14: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string14	# load label
	# PushParam _tmp156
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -276($fp)	# spill _tmp156 from $t0 to $fp-276
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L25:
	# *(_tmp155) = _tmp133
	lw $t0, -192($fp)	# load _tmp133 from $fp-192 into $t0
	lw $t1, -272($fp)	# load _tmp155 from $fp-272 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp157 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp158 = *(_tmp157)
	lw $t4, 0($t3) 	# load with offset
	# _tmp159 = i < _tmp158
	lw $t5, -8($fp)	# load i from $fp-8 into $t5
	slt $t6, $t5, $t4	
	# _tmp160 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp161 = _tmp160 < i
	slt $s0, $t7, $t5	
	# _tmp162 = _tmp161 && _tmp159
	and $s1, $s0, $t6	
	# IfZ _tmp162 Goto _L26
	# (save modified registers before flow of control change)
	sw $t3, -280($fp)	# spill _tmp157 from $t3 to $fp-280
	sw $t4, -284($fp)	# spill _tmp158 from $t4 to $fp-284
	sw $t6, -288($fp)	# spill _tmp159 from $t6 to $fp-288
	sw $t7, -292($fp)	# spill _tmp160 from $t7 to $fp-292
	sw $s0, -296($fp)	# spill _tmp161 from $s0 to $fp-296
	sw $s1, -300($fp)	# spill _tmp162 from $s1 to $fp-300
	beqz $s1, _L26	# branch if _tmp162 is zero 
	# _tmp163 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp164 = i * _tmp163
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp165 = _tmp164 + _tmp163
	add $t3, $t2, $t0	
	# _tmp166 = _tmp157 + _tmp165
	lw $t4, -280($fp)	# load _tmp157 from $fp-280 into $t4
	add $t5, $t4, $t3	
	# Goto _L27
	# (save modified registers before flow of control change)
	sw $t0, -304($fp)	# spill _tmp163 from $t0 to $fp-304
	sw $t2, -308($fp)	# spill _tmp164 from $t2 to $fp-308
	sw $t3, -312($fp)	# spill _tmp165 from $t3 to $fp-312
	sw $t5, -312($fp)	# spill _tmp166 from $t5 to $fp-312
	b _L27		# unconditional branch
_L26:
	# _tmp167 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string15: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string15	# load label
	# PushParam _tmp167
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -316($fp)	# spill _tmp167 from $t0 to $fp-316
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L27:
	# _tmp168 = *(_tmp166)
	lw $t0, -312($fp)	# load _tmp166 from $fp-312 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp169 = *(_tmp168)
	lw $t2, 0($t1) 	# load with offset
	# _tmp170 = j < _tmp169
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp171 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp172 = _tmp171 < j
	slt $t6, $t5, $t3	
	# _tmp173 = _tmp172 && _tmp170
	and $t7, $t6, $t4	
	# IfZ _tmp173 Goto _L28
	# (save modified registers before flow of control change)
	sw $t1, -320($fp)	# spill _tmp168 from $t1 to $fp-320
	sw $t2, -324($fp)	# spill _tmp169 from $t2 to $fp-324
	sw $t4, -328($fp)	# spill _tmp170 from $t4 to $fp-328
	sw $t5, -332($fp)	# spill _tmp171 from $t5 to $fp-332
	sw $t6, -336($fp)	# spill _tmp172 from $t6 to $fp-336
	sw $t7, -340($fp)	# spill _tmp173 from $t7 to $fp-340
	beqz $t7, _L28	# branch if _tmp173 is zero 
	# _tmp174 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp175 = j * _tmp174
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp176 = _tmp175 + _tmp174
	add $t3, $t2, $t0	
	# _tmp177 = _tmp168 + _tmp176
	lw $t4, -320($fp)	# load _tmp168 from $fp-320 into $t4
	add $t5, $t4, $t3	
	# Goto _L29
	# (save modified registers before flow of control change)
	sw $t0, -344($fp)	# spill _tmp174 from $t0 to $fp-344
	sw $t2, -348($fp)	# spill _tmp175 from $t2 to $fp-348
	sw $t3, -352($fp)	# spill _tmp176 from $t3 to $fp-352
	sw $t5, -352($fp)	# spill _tmp177 from $t5 to $fp-352
	b _L29		# unconditional branch
_L28:
	# _tmp178 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string16: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string16	# load label
	# PushParam _tmp178
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -356($fp)	# spill _tmp178 from $t0 to $fp-356
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L29:
	# _tmp179 = *(_tmp177)
	lw $t0, -352($fp)	# load _tmp177 from $fp-352 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp180 = *(_tmp179)
	lw $t2, 0($t1) 	# load with offset
	# _tmp181 = *(_tmp180 + 4)
	lw $t3, 4($t2) 	# load with offset
	# PushParam _tmp179
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp181
	# (save modified registers before flow of control change)
	sw $t1, -360($fp)	# spill _tmp179 from $t1 to $fp-360
	sw $t2, -364($fp)	# spill _tmp180 from $t2 to $fp-364
	sw $t3, -368($fp)	# spill _tmp181 from $t3 to $fp-368
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp182 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp183 = j + _tmp182
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp183
	move $t1, $t2		# copy value
	# Goto _L20
	# (save modified registers before flow of control change)
	sw $t0, -376($fp)	# spill _tmp182 from $t0 to $fp-376
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -372($fp)	# spill _tmp183 from $t2 to $fp-372
	b _L20		# unconditional branch
_L21:
	# _tmp184 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp185 = i + _tmp184
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp185
	move $t1, $t2		# copy value
	# Goto _L18
	# (save modified registers before flow of control change)
	sw $t0, -384($fp)	# spill _tmp184 from $t0 to $fp-384
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -380($fp)	# spill _tmp185 from $t2 to $fp-380
	b _L18		# unconditional branch
_L19:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Grid.Full:
	# BeginFunc 156
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 156	# decrement sp to make space for locals/temps
	# _tmp186 = 1
	li $t0, 1		# load constant value 1 into $t0
	# full = _tmp186
	move $t1, $t0		# copy value
	# _tmp187 = 0
	li $t2, 0		# load constant value 0 into $t2
	# i = _tmp187
	move $t3, $t2		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp186 from $t0 to $fp-20
	sw $t1, -16($fp)	# spill full from $t1 to $fp-16
	sw $t2, -24($fp)	# spill _tmp187 from $t2 to $fp-24
	sw $t3, -8($fp)	# spill i from $t3 to $fp-8
_L30:
	# _tmp188 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp189 = i < _tmp188
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp189 Goto _L31
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp188 from $t0 to $fp-28
	sw $t2, -32($fp)	# spill _tmp189 from $t2 to $fp-32
	beqz $t2, _L31	# branch if _tmp189 is zero 
	# _tmp190 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp190
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp190 from $t0 to $fp-36
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L32:
	# _tmp191 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp192 = j < _tmp191
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp192 Goto _L33
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp191 from $t0 to $fp-40
	sw $t2, -44($fp)	# spill _tmp192 from $t2 to $fp-44
	beqz $t2, _L33	# branch if _tmp192 is zero 
	# _tmp193 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp194 = *(_tmp193)
	lw $t2, 0($t1) 	# load with offset
	# _tmp195 = i < _tmp194
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp196 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp197 = _tmp196 < i
	slt $t6, $t5, $t3	
	# _tmp198 = _tmp197 && _tmp195
	and $t7, $t6, $t4	
	# IfZ _tmp198 Goto _L36
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp193 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp194 from $t2 to $fp-52
	sw $t4, -56($fp)	# spill _tmp195 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp196 from $t5 to $fp-60
	sw $t6, -64($fp)	# spill _tmp197 from $t6 to $fp-64
	sw $t7, -68($fp)	# spill _tmp198 from $t7 to $fp-68
	beqz $t7, _L36	# branch if _tmp198 is zero 
	# _tmp199 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp200 = i * _tmp199
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp201 = _tmp200 + _tmp199
	add $t3, $t2, $t0	
	# _tmp202 = _tmp193 + _tmp201
	lw $t4, -48($fp)	# load _tmp193 from $fp-48 into $t4
	add $t5, $t4, $t3	
	# Goto _L37
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp199 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp200 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp201 from $t3 to $fp-80
	sw $t5, -80($fp)	# spill _tmp202 from $t5 to $fp-80
	b _L37		# unconditional branch
_L36:
	# _tmp203 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string17: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string17	# load label
	# PushParam _tmp203
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp203 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L37:
	# _tmp204 = *(_tmp202)
	lw $t0, -80($fp)	# load _tmp202 from $fp-80 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp205 = *(_tmp204)
	lw $t2, 0($t1) 	# load with offset
	# _tmp206 = j < _tmp205
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp207 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp208 = _tmp207 < j
	slt $t6, $t5, $t3	
	# _tmp209 = _tmp208 && _tmp206
	and $t7, $t6, $t4	
	# IfZ _tmp209 Goto _L38
	# (save modified registers before flow of control change)
	sw $t1, -88($fp)	# spill _tmp204 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp205 from $t2 to $fp-92
	sw $t4, -96($fp)	# spill _tmp206 from $t4 to $fp-96
	sw $t5, -100($fp)	# spill _tmp207 from $t5 to $fp-100
	sw $t6, -104($fp)	# spill _tmp208 from $t6 to $fp-104
	sw $t7, -108($fp)	# spill _tmp209 from $t7 to $fp-108
	beqz $t7, _L38	# branch if _tmp209 is zero 
	# _tmp210 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp211 = j * _tmp210
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp212 = _tmp211 + _tmp210
	add $t3, $t2, $t0	
	# _tmp213 = _tmp204 + _tmp212
	lw $t4, -88($fp)	# load _tmp204 from $fp-88 into $t4
	add $t5, $t4, $t3	
	# Goto _L39
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp210 from $t0 to $fp-112
	sw $t2, -116($fp)	# spill _tmp211 from $t2 to $fp-116
	sw $t3, -120($fp)	# spill _tmp212 from $t3 to $fp-120
	sw $t5, -120($fp)	# spill _tmp213 from $t5 to $fp-120
	b _L39		# unconditional branch
_L38:
	# _tmp214 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string18: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string18	# load label
	# PushParam _tmp214
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp214 from $t0 to $fp-124
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L39:
	# _tmp215 = *(_tmp213)
	lw $t0, -120($fp)	# load _tmp213 from $fp-120 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp216 = *(_tmp215)
	lw $t2, 0($t1) 	# load with offset
	# _tmp217 = *(_tmp216)
	lw $t3, 0($t2) 	# load with offset
	# PushParam _tmp215
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp218 = ACall _tmp217
	# (save modified registers before flow of control change)
	sw $t1, -128($fp)	# spill _tmp215 from $t1 to $fp-128
	sw $t2, -132($fp)	# spill _tmp216 from $t2 to $fp-132
	sw $t3, -136($fp)	# spill _tmp217 from $t3 to $fp-136
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp218 Goto _L34
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp218 from $t0 to $fp-140
	beqz $t0, _L34	# branch if _tmp218 is zero 
	# _tmp219 = 0
	li $t0, 0		# load constant value 0 into $t0
	# full = _tmp219
	move $t1, $t0		# copy value
	# Goto _L35
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp219 from $t0 to $fp-144
	sw $t1, -16($fp)	# spill full from $t1 to $fp-16
	b _L35		# unconditional branch
_L34:
_L35:
	# _tmp220 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp221 = j + _tmp220
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp221
	move $t1, $t2		# copy value
	# Goto _L32
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp220 from $t0 to $fp-152
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -148($fp)	# spill _tmp221 from $t2 to $fp-148
	b _L32		# unconditional branch
_L33:
	# _tmp222 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp223 = i + _tmp222
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp223
	move $t1, $t2		# copy value
	# Goto _L30
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp222 from $t0 to $fp-160
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -156($fp)	# spill _tmp223 from $t2 to $fp-156
	b _L30		# unconditional branch
_L31:
	# Return full
	lw $t0, -16($fp)	# load full from $fp-16 into $t0
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
__Grid.Draw:
	# BeginFunc 184
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 184	# decrement sp to make space for locals/temps
	# _tmp224 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp224
	move $t1, $t0		# copy value
	# _tmp225 = "  1   2   3\n"
	.data			# create string constant marked with label
	_string19: .asciiz "  1   2   3\n"
	.text
	la $t2, _string19	# load label
	# PushParam _tmp225
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp224 from $t0 to $fp-20
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -24($fp)	# spill _tmp225 from $t2 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L40:
	# _tmp226 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp227 = i < _tmp226
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp227 Goto _L41
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp226 from $t0 to $fp-28
	sw $t2, -32($fp)	# spill _tmp227 from $t2 to $fp-32
	beqz $t2, _L41	# branch if _tmp227 is zero 
	# _tmp228 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp229 = i + _tmp228
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# rowToPrint = _tmp229
	move $t3, $t2		# copy value
	# PushParam rowToPrint
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp228 from $t0 to $fp-40
	sw $t2, -36($fp)	# spill _tmp229 from $t2 to $fp-36
	sw $t3, -16($fp)	# spill rowToPrint from $t3 to $fp-16
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp230 = 0
	li $t0, 0		# load constant value 0 into $t0
	# j = _tmp230
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp230 from $t0 to $fp-44
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
_L42:
	# _tmp231 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp232 = j < _tmp231
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp232 Goto _L43
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp231 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp232 from $t2 to $fp-52
	beqz $t2, _L43	# branch if _tmp232 is zero 
	# _tmp233 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp234 = *(_tmp233)
	lw $t2, 0($t1) 	# load with offset
	# _tmp235 = i < _tmp234
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp236 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp237 = _tmp236 < i
	slt $t6, $t5, $t3	
	# _tmp238 = _tmp237 && _tmp235
	and $t7, $t6, $t4	
	# IfZ _tmp238 Goto _L44
	# (save modified registers before flow of control change)
	sw $t1, -56($fp)	# spill _tmp233 from $t1 to $fp-56
	sw $t2, -60($fp)	# spill _tmp234 from $t2 to $fp-60
	sw $t4, -64($fp)	# spill _tmp235 from $t4 to $fp-64
	sw $t5, -68($fp)	# spill _tmp236 from $t5 to $fp-68
	sw $t6, -72($fp)	# spill _tmp237 from $t6 to $fp-72
	sw $t7, -76($fp)	# spill _tmp238 from $t7 to $fp-76
	beqz $t7, _L44	# branch if _tmp238 is zero 
	# _tmp239 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp240 = i * _tmp239
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp241 = _tmp240 + _tmp239
	add $t3, $t2, $t0	
	# _tmp242 = _tmp233 + _tmp241
	lw $t4, -56($fp)	# load _tmp233 from $fp-56 into $t4
	add $t5, $t4, $t3	
	# Goto _L45
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp239 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp240 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp241 from $t3 to $fp-88
	sw $t5, -88($fp)	# spill _tmp242 from $t5 to $fp-88
	b _L45		# unconditional branch
_L44:
	# _tmp243 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string20: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string20	# load label
	# PushParam _tmp243
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp243 from $t0 to $fp-92
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L45:
	# _tmp244 = *(_tmp242)
	lw $t0, -88($fp)	# load _tmp242 from $fp-88 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp245 = *(_tmp244)
	lw $t2, 0($t1) 	# load with offset
	# _tmp246 = j < _tmp245
	lw $t3, -12($fp)	# load j from $fp-12 into $t3
	slt $t4, $t3, $t2	
	# _tmp247 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp248 = _tmp247 < j
	slt $t6, $t5, $t3	
	# _tmp249 = _tmp248 && _tmp246
	and $t7, $t6, $t4	
	# IfZ _tmp249 Goto _L46
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp244 from $t1 to $fp-96
	sw $t2, -100($fp)	# spill _tmp245 from $t2 to $fp-100
	sw $t4, -104($fp)	# spill _tmp246 from $t4 to $fp-104
	sw $t5, -108($fp)	# spill _tmp247 from $t5 to $fp-108
	sw $t6, -112($fp)	# spill _tmp248 from $t6 to $fp-112
	sw $t7, -116($fp)	# spill _tmp249 from $t7 to $fp-116
	beqz $t7, _L46	# branch if _tmp249 is zero 
	# _tmp250 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp251 = j * _tmp250
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp252 = _tmp251 + _tmp250
	add $t3, $t2, $t0	
	# _tmp253 = _tmp244 + _tmp252
	lw $t4, -96($fp)	# load _tmp244 from $fp-96 into $t4
	add $t5, $t4, $t3	
	# Goto _L47
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp250 from $t0 to $fp-120
	sw $t2, -124($fp)	# spill _tmp251 from $t2 to $fp-124
	sw $t3, -128($fp)	# spill _tmp252 from $t3 to $fp-128
	sw $t5, -128($fp)	# spill _tmp253 from $t5 to $fp-128
	b _L47		# unconditional branch
_L46:
	# _tmp254 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string21: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string21	# load label
	# PushParam _tmp254
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp254 from $t0 to $fp-132
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L47:
	# _tmp255 = *(_tmp253)
	lw $t0, -128($fp)	# load _tmp253 from $fp-128 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp256 = *(_tmp255)
	lw $t2, 0($t1) 	# load with offset
	# _tmp257 = *(_tmp256 + 12)
	lw $t3, 12($t2) 	# load with offset
	# PushParam _tmp255
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp257
	# (save modified registers before flow of control change)
	sw $t1, -136($fp)	# spill _tmp255 from $t1 to $fp-136
	sw $t2, -140($fp)	# spill _tmp256 from $t2 to $fp-140
	sw $t3, -144($fp)	# spill _tmp257 from $t3 to $fp-144
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp258 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp259 = j + _tmp258
	lw $t1, -12($fp)	# load j from $fp-12 into $t1
	add $t2, $t1, $t0	
	# j = _tmp259
	move $t1, $t2		# copy value
	# _tmp260 = 3
	li $t3, 3		# load constant value 3 into $t3
	# _tmp261 = j < _tmp260
	slt $t4, $t1, $t3	
	# IfZ _tmp261 Goto _L48
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp258 from $t0 to $fp-152
	sw $t1, -12($fp)	# spill j from $t1 to $fp-12
	sw $t2, -148($fp)	# spill _tmp259 from $t2 to $fp-148
	sw $t3, -156($fp)	# spill _tmp260 from $t3 to $fp-156
	sw $t4, -160($fp)	# spill _tmp261 from $t4 to $fp-160
	beqz $t4, _L48	# branch if _tmp261 is zero 
	# _tmp262 = "|"
	.data			# create string constant marked with label
	_string22: .asciiz "|"
	.text
	la $t0, _string22	# load label
	# PushParam _tmp262
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -164($fp)	# spill _tmp262 from $t0 to $fp-164
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L49
	b _L49		# unconditional branch
_L48:
_L49:
	# Goto _L42
	b _L42		# unconditional branch
_L43:
	# _tmp263 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp264 = i + _tmp263
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp264
	move $t1, $t2		# copy value
	# _tmp265 = "\n"
	.data			# create string constant marked with label
	_string23: .asciiz "\n"
	.text
	la $t3, _string23	# load label
	# PushParam _tmp265
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp263 from $t0 to $fp-172
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -168($fp)	# spill _tmp264 from $t2 to $fp-168
	sw $t3, -176($fp)	# spill _tmp265 from $t3 to $fp-176
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp266 = 3
	li $t0, 3		# load constant value 3 into $t0
	# _tmp267 = i < _tmp266
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	slt $t2, $t1, $t0	
	# IfZ _tmp267 Goto _L50
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp266 from $t0 to $fp-180
	sw $t2, -184($fp)	# spill _tmp267 from $t2 to $fp-184
	beqz $t2, _L50	# branch if _tmp267 is zero 
	# _tmp268 = " ---+---+---\n"
	.data			# create string constant marked with label
	_string24: .asciiz " ---+---+---\n"
	.text
	la $t0, _string24	# load label
	# PushParam _tmp268
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp268 from $t0 to $fp-188
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L51
	b _L51		# unconditional branch
_L50:
_L51:
	# Goto _L40
	b _L40		# unconditional branch
_L41:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Grid.Update:
	# BeginFunc 196
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 196	# decrement sp to make space for locals/temps
	# _tmp269 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp270 = *(_tmp269)
	lw $t2, 0($t1) 	# load with offset
	# _tmp271 = row < _tmp270
	lw $t3, 8($fp)	# load row from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp272 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp273 = _tmp272 < row
	slt $t6, $t5, $t3	
	# _tmp274 = _tmp273 && _tmp271
	and $t7, $t6, $t4	
	# IfZ _tmp274 Goto _L52
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp269 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp270 from $t2 to $fp-12
	sw $t4, -16($fp)	# spill _tmp271 from $t4 to $fp-16
	sw $t5, -20($fp)	# spill _tmp272 from $t5 to $fp-20
	sw $t6, -24($fp)	# spill _tmp273 from $t6 to $fp-24
	sw $t7, -28($fp)	# spill _tmp274 from $t7 to $fp-28
	beqz $t7, _L52	# branch if _tmp274 is zero 
	# _tmp275 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp276 = row * _tmp275
	lw $t1, 8($fp)	# load row from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp277 = _tmp276 + _tmp275
	add $t3, $t2, $t0	
	# _tmp278 = _tmp269 + _tmp277
	lw $t4, -8($fp)	# load _tmp269 from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L53
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp275 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp276 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp277 from $t3 to $fp-40
	sw $t5, -40($fp)	# spill _tmp278 from $t5 to $fp-40
	b _L53		# unconditional branch
_L52:
	# _tmp279 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string25: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string25	# load label
	# PushParam _tmp279
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp279 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L53:
	# _tmp280 = *(_tmp278)
	lw $t0, -40($fp)	# load _tmp278 from $fp-40 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp281 = *(_tmp280)
	lw $t2, 0($t1) 	# load with offset
	# _tmp282 = column < _tmp281
	lw $t3, 12($fp)	# load column from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp283 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp284 = _tmp283 < column
	slt $t6, $t5, $t3	
	# _tmp285 = _tmp284 && _tmp282
	and $t7, $t6, $t4	
	# IfZ _tmp285 Goto _L54
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp280 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp281 from $t2 to $fp-52
	sw $t4, -56($fp)	# spill _tmp282 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp283 from $t5 to $fp-60
	sw $t6, -64($fp)	# spill _tmp284 from $t6 to $fp-64
	sw $t7, -68($fp)	# spill _tmp285 from $t7 to $fp-68
	beqz $t7, _L54	# branch if _tmp285 is zero 
	# _tmp286 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp287 = column * _tmp286
	lw $t1, 12($fp)	# load column from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp288 = _tmp287 + _tmp286
	add $t3, $t2, $t0	
	# _tmp289 = _tmp280 + _tmp288
	lw $t4, -48($fp)	# load _tmp280 from $fp-48 into $t4
	add $t5, $t4, $t3	
	# Goto _L55
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp286 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp287 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp288 from $t3 to $fp-80
	sw $t5, -80($fp)	# spill _tmp289 from $t5 to $fp-80
	b _L55		# unconditional branch
_L54:
	# _tmp290 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string26: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string26	# load label
	# PushParam _tmp290
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp290 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L55:
	# _tmp291 = *(_tmp289)
	lw $t0, -80($fp)	# load _tmp289 from $fp-80 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp292 = *(_tmp291)
	lw $t2, 0($t1) 	# load with offset
	# _tmp293 = *(_tmp292 + 16)
	lw $t3, 16($t2) 	# load with offset
	# _tmp294 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp294
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp291
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp293
	# (save modified registers before flow of control change)
	sw $t1, -88($fp)	# spill _tmp291 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp292 from $t2 to $fp-92
	sw $t3, -96($fp)	# spill _tmp293 from $t3 to $fp-96
	sw $t4, -100($fp)	# spill _tmp294 from $t4 to $fp-100
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp295 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp296 = *(_tmp295)
	lw $t2, 0($t1) 	# load with offset
	# _tmp297 = row < _tmp296
	lw $t3, 8($fp)	# load row from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp298 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp299 = _tmp298 < row
	slt $t6, $t5, $t3	
	# _tmp300 = _tmp299 && _tmp297
	and $t7, $t6, $t4	
	# IfZ _tmp300 Goto _L56
	# (save modified registers before flow of control change)
	sw $t1, -104($fp)	# spill _tmp295 from $t1 to $fp-104
	sw $t2, -108($fp)	# spill _tmp296 from $t2 to $fp-108
	sw $t4, -112($fp)	# spill _tmp297 from $t4 to $fp-112
	sw $t5, -116($fp)	# spill _tmp298 from $t5 to $fp-116
	sw $t6, -120($fp)	# spill _tmp299 from $t6 to $fp-120
	sw $t7, -124($fp)	# spill _tmp300 from $t7 to $fp-124
	beqz $t7, _L56	# branch if _tmp300 is zero 
	# _tmp301 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp302 = row * _tmp301
	lw $t1, 8($fp)	# load row from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp303 = _tmp302 + _tmp301
	add $t3, $t2, $t0	
	# _tmp304 = _tmp295 + _tmp303
	lw $t4, -104($fp)	# load _tmp295 from $fp-104 into $t4
	add $t5, $t4, $t3	
	# Goto _L57
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp301 from $t0 to $fp-128
	sw $t2, -132($fp)	# spill _tmp302 from $t2 to $fp-132
	sw $t3, -136($fp)	# spill _tmp303 from $t3 to $fp-136
	sw $t5, -136($fp)	# spill _tmp304 from $t5 to $fp-136
	b _L57		# unconditional branch
_L56:
	# _tmp305 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string27: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string27	# load label
	# PushParam _tmp305
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp305 from $t0 to $fp-140
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L57:
	# _tmp306 = *(_tmp304)
	lw $t0, -136($fp)	# load _tmp304 from $fp-136 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp307 = *(_tmp306)
	lw $t2, 0($t1) 	# load with offset
	# _tmp308 = column < _tmp307
	lw $t3, 12($fp)	# load column from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp309 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp310 = _tmp309 < column
	slt $t6, $t5, $t3	
	# _tmp311 = _tmp310 && _tmp308
	and $t7, $t6, $t4	
	# IfZ _tmp311 Goto _L58
	# (save modified registers before flow of control change)
	sw $t1, -144($fp)	# spill _tmp306 from $t1 to $fp-144
	sw $t2, -148($fp)	# spill _tmp307 from $t2 to $fp-148
	sw $t4, -152($fp)	# spill _tmp308 from $t4 to $fp-152
	sw $t5, -156($fp)	# spill _tmp309 from $t5 to $fp-156
	sw $t6, -160($fp)	# spill _tmp310 from $t6 to $fp-160
	sw $t7, -164($fp)	# spill _tmp311 from $t7 to $fp-164
	beqz $t7, _L58	# branch if _tmp311 is zero 
	# _tmp312 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp313 = column * _tmp312
	lw $t1, 12($fp)	# load column from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp314 = _tmp313 + _tmp312
	add $t3, $t2, $t0	
	# _tmp315 = _tmp306 + _tmp314
	lw $t4, -144($fp)	# load _tmp306 from $fp-144 into $t4
	add $t5, $t4, $t3	
	# Goto _L59
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp312 from $t0 to $fp-168
	sw $t2, -172($fp)	# spill _tmp313 from $t2 to $fp-172
	sw $t3, -176($fp)	# spill _tmp314 from $t3 to $fp-176
	sw $t5, -176($fp)	# spill _tmp315 from $t5 to $fp-176
	b _L59		# unconditional branch
_L58:
	# _tmp316 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string28: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string28	# load label
	# PushParam _tmp316
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp316 from $t0 to $fp-180
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L59:
	# _tmp317 = *(_tmp315)
	lw $t0, -176($fp)	# load _tmp315 from $fp-176 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp318 = *(_tmp317)
	lw $t2, 0($t1) 	# load with offset
	# _tmp319 = *(_tmp318 + 20)
	lw $t3, 20($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 16($fp)	# load mark from $fp+16 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp317
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp319
	# (save modified registers before flow of control change)
	sw $t1, -184($fp)	# spill _tmp317 from $t1 to $fp-184
	sw $t2, -188($fp)	# spill _tmp318 from $t2 to $fp-188
	sw $t3, -192($fp)	# spill _tmp319 from $t3 to $fp-192
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp320 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp321 = *(_tmp320 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp321
	# (save modified registers before flow of control change)
	sw $t1, -196($fp)	# spill _tmp320 from $t1 to $fp-196
	sw $t2, -200($fp)	# spill _tmp321 from $t2 to $fp-200
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Grid.IsMoveLegal:
	# BeginFunc 96
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 96	# decrement sp to make space for locals/temps
	# _tmp322 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp323 = *(_tmp322)
	lw $t2, 0($t1) 	# load with offset
	# _tmp324 = row < _tmp323
	lw $t3, 8($fp)	# load row from $fp+8 into $t3
	slt $t4, $t3, $t2	
	# _tmp325 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp326 = _tmp325 < row
	slt $t6, $t5, $t3	
	# _tmp327 = _tmp326 && _tmp324
	and $t7, $t6, $t4	
	# IfZ _tmp327 Goto _L60
	# (save modified registers before flow of control change)
	sw $t1, -8($fp)	# spill _tmp322 from $t1 to $fp-8
	sw $t2, -12($fp)	# spill _tmp323 from $t2 to $fp-12
	sw $t4, -16($fp)	# spill _tmp324 from $t4 to $fp-16
	sw $t5, -20($fp)	# spill _tmp325 from $t5 to $fp-20
	sw $t6, -24($fp)	# spill _tmp326 from $t6 to $fp-24
	sw $t7, -28($fp)	# spill _tmp327 from $t7 to $fp-28
	beqz $t7, _L60	# branch if _tmp327 is zero 
	# _tmp328 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp329 = row * _tmp328
	lw $t1, 8($fp)	# load row from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp330 = _tmp329 + _tmp328
	add $t3, $t2, $t0	
	# _tmp331 = _tmp322 + _tmp330
	lw $t4, -8($fp)	# load _tmp322 from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L61
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp328 from $t0 to $fp-32
	sw $t2, -36($fp)	# spill _tmp329 from $t2 to $fp-36
	sw $t3, -40($fp)	# spill _tmp330 from $t3 to $fp-40
	sw $t5, -40($fp)	# spill _tmp331 from $t5 to $fp-40
	b _L61		# unconditional branch
_L60:
	# _tmp332 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string29: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string29	# load label
	# PushParam _tmp332
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp332 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L61:
	# _tmp333 = *(_tmp331)
	lw $t0, -40($fp)	# load _tmp331 from $fp-40 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp334 = *(_tmp333)
	lw $t2, 0($t1) 	# load with offset
	# _tmp335 = column < _tmp334
	lw $t3, 12($fp)	# load column from $fp+12 into $t3
	slt $t4, $t3, $t2	
	# _tmp336 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp337 = _tmp336 < column
	slt $t6, $t5, $t3	
	# _tmp338 = _tmp337 && _tmp335
	and $t7, $t6, $t4	
	# IfZ _tmp338 Goto _L62
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp333 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp334 from $t2 to $fp-52
	sw $t4, -56($fp)	# spill _tmp335 from $t4 to $fp-56
	sw $t5, -60($fp)	# spill _tmp336 from $t5 to $fp-60
	sw $t6, -64($fp)	# spill _tmp337 from $t6 to $fp-64
	sw $t7, -68($fp)	# spill _tmp338 from $t7 to $fp-68
	beqz $t7, _L62	# branch if _tmp338 is zero 
	# _tmp339 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp340 = column * _tmp339
	lw $t1, 12($fp)	# load column from $fp+12 into $t1
	mul $t2, $t1, $t0	
	# _tmp341 = _tmp340 + _tmp339
	add $t3, $t2, $t0	
	# _tmp342 = _tmp333 + _tmp341
	lw $t4, -48($fp)	# load _tmp333 from $fp-48 into $t4
	add $t5, $t4, $t3	
	# Goto _L63
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp339 from $t0 to $fp-72
	sw $t2, -76($fp)	# spill _tmp340 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp341 from $t3 to $fp-80
	sw $t5, -80($fp)	# spill _tmp342 from $t5 to $fp-80
	b _L63		# unconditional branch
_L62:
	# _tmp343 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string30: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string30	# load label
	# PushParam _tmp343
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp343 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L63:
	# _tmp344 = *(_tmp342)
	lw $t0, -80($fp)	# load _tmp342 from $fp-80 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp345 = *(_tmp344)
	lw $t2, 0($t1) 	# load with offset
	# _tmp346 = *(_tmp345)
	lw $t3, 0($t2) 	# load with offset
	# PushParam _tmp344
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp347 = ACall _tmp346
	# (save modified registers before flow of control change)
	sw $t1, -88($fp)	# spill _tmp344 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp345 from $t2 to $fp-92
	sw $t3, -96($fp)	# spill _tmp346 from $t3 to $fp-96
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Return _tmp347
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
__Grid.GameNotWon:
	# BeginFunc 2612
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 2612	# decrement sp to make space for locals/temps
	# _tmp348 = *(p)
	lw $t0, 8($fp)	# load p from $fp+8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp349 = *(_tmp348)
	lw $t2, 0($t1) 	# load with offset
	# PushParam p
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp350 = ACall _tmp349
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp348 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp349 from $t2 to $fp-16
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# mark = _tmp350
	move $t1, $t0		# copy value
	# _tmp351 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp352 = *(_tmp351)
	lw $t4, 0($t3) 	# load with offset
	# _tmp353 = 0
	li $t5, 0		# load constant value 0 into $t5
	# _tmp354 = _tmp353 < _tmp352
	slt $t6, $t5, $t4	
	# _tmp355 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp356 = _tmp355 < _tmp353
	slt $s0, $t7, $t5	
	# _tmp357 = _tmp356 && _tmp354
	and $s1, $s0, $t6	
	# IfZ _tmp357 Goto _L66
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp350 from $t0 to $fp-20
	sw $t1, -8($fp)	# spill mark from $t1 to $fp-8
	sw $t3, -28($fp)	# spill _tmp351 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp352 from $t4 to $fp-32
	sw $t5, -40($fp)	# spill _tmp353 from $t5 to $fp-40
	sw $t6, -36($fp)	# spill _tmp354 from $t6 to $fp-36
	sw $t7, -44($fp)	# spill _tmp355 from $t7 to $fp-44
	sw $s0, -48($fp)	# spill _tmp356 from $s0 to $fp-48
	sw $s1, -52($fp)	# spill _tmp357 from $s1 to $fp-52
	beqz $s1, _L66	# branch if _tmp357 is zero 
	# _tmp358 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp359 = _tmp353 * _tmp358
	lw $t1, -40($fp)	# load _tmp353 from $fp-40 into $t1
	mul $t2, $t1, $t0	
	# _tmp360 = _tmp359 + _tmp358
	add $t3, $t2, $t0	
	# _tmp361 = _tmp351 + _tmp360
	lw $t4, -28($fp)	# load _tmp351 from $fp-28 into $t4
	add $t5, $t4, $t3	
	# Goto _L67
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp358 from $t0 to $fp-56
	sw $t2, -60($fp)	# spill _tmp359 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp360 from $t3 to $fp-64
	sw $t5, -64($fp)	# spill _tmp361 from $t5 to $fp-64
	b _L67		# unconditional branch
_L66:
	# _tmp362 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string31: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string31	# load label
	# PushParam _tmp362
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp362 from $t0 to $fp-68
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L67:
	# _tmp363 = *(_tmp361)
	lw $t0, -64($fp)	# load _tmp361 from $fp-64 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp364 = *(_tmp363)
	lw $t2, 0($t1) 	# load with offset
	# _tmp365 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp366 = _tmp365 < _tmp364
	slt $t4, $t3, $t2	
	# _tmp367 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp368 = _tmp367 < _tmp365
	slt $t6, $t5, $t3	
	# _tmp369 = _tmp368 && _tmp366
	and $t7, $t6, $t4	
	# IfZ _tmp369 Goto _L68
	# (save modified registers before flow of control change)
	sw $t1, -72($fp)	# spill _tmp363 from $t1 to $fp-72
	sw $t2, -76($fp)	# spill _tmp364 from $t2 to $fp-76
	sw $t3, -84($fp)	# spill _tmp365 from $t3 to $fp-84
	sw $t4, -80($fp)	# spill _tmp366 from $t4 to $fp-80
	sw $t5, -88($fp)	# spill _tmp367 from $t5 to $fp-88
	sw $t6, -92($fp)	# spill _tmp368 from $t6 to $fp-92
	sw $t7, -96($fp)	# spill _tmp369 from $t7 to $fp-96
	beqz $t7, _L68	# branch if _tmp369 is zero 
	# _tmp370 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp371 = _tmp365 * _tmp370
	lw $t1, -84($fp)	# load _tmp365 from $fp-84 into $t1
	mul $t2, $t1, $t0	
	# _tmp372 = _tmp371 + _tmp370
	add $t3, $t2, $t0	
	# _tmp373 = _tmp363 + _tmp372
	lw $t4, -72($fp)	# load _tmp363 from $fp-72 into $t4
	add $t5, $t4, $t3	
	# Goto _L69
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp370 from $t0 to $fp-100
	sw $t2, -104($fp)	# spill _tmp371 from $t2 to $fp-104
	sw $t3, -108($fp)	# spill _tmp372 from $t3 to $fp-108
	sw $t5, -108($fp)	# spill _tmp373 from $t5 to $fp-108
	b _L69		# unconditional branch
_L68:
	# _tmp374 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string32: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string32	# load label
	# PushParam _tmp374
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp374 from $t0 to $fp-112
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L69:
	# _tmp375 = *(_tmp373)
	lw $t0, -108($fp)	# load _tmp373 from $fp-108 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp376 = *(_tmp375)
	lw $t2, 0($t1) 	# load with offset
	# _tmp377 = *(_tmp376 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp375
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp378 = ACall _tmp377
	# (save modified registers before flow of control change)
	sw $t1, -116($fp)	# spill _tmp375 from $t1 to $fp-116
	sw $t2, -120($fp)	# spill _tmp376 from $t2 to $fp-120
	sw $t3, -124($fp)	# spill _tmp377 from $t3 to $fp-124
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp379 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp380 = *(_tmp379)
	lw $t3, 0($t2) 	# load with offset
	# _tmp381 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp382 = _tmp381 < _tmp380
	slt $t5, $t4, $t3	
	# _tmp383 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp384 = _tmp383 < _tmp381
	slt $t7, $t6, $t4	
	# _tmp385 = _tmp384 && _tmp382
	and $s0, $t7, $t5	
	# IfZ _tmp385 Goto _L70
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp378 from $t0 to $fp-128
	sw $t2, -136($fp)	# spill _tmp379 from $t2 to $fp-136
	sw $t3, -140($fp)	# spill _tmp380 from $t3 to $fp-140
	sw $t4, -148($fp)	# spill _tmp381 from $t4 to $fp-148
	sw $t5, -144($fp)	# spill _tmp382 from $t5 to $fp-144
	sw $t6, -152($fp)	# spill _tmp383 from $t6 to $fp-152
	sw $t7, -156($fp)	# spill _tmp384 from $t7 to $fp-156
	sw $s0, -160($fp)	# spill _tmp385 from $s0 to $fp-160
	beqz $s0, _L70	# branch if _tmp385 is zero 
	# _tmp386 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp387 = _tmp381 * _tmp386
	lw $t1, -148($fp)	# load _tmp381 from $fp-148 into $t1
	mul $t2, $t1, $t0	
	# _tmp388 = _tmp387 + _tmp386
	add $t3, $t2, $t0	
	# _tmp389 = _tmp379 + _tmp388
	lw $t4, -136($fp)	# load _tmp379 from $fp-136 into $t4
	add $t5, $t4, $t3	
	# Goto _L71
	# (save modified registers before flow of control change)
	sw $t0, -164($fp)	# spill _tmp386 from $t0 to $fp-164
	sw $t2, -168($fp)	# spill _tmp387 from $t2 to $fp-168
	sw $t3, -172($fp)	# spill _tmp388 from $t3 to $fp-172
	sw $t5, -172($fp)	# spill _tmp389 from $t5 to $fp-172
	b _L71		# unconditional branch
_L70:
	# _tmp390 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string33: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string33	# load label
	# PushParam _tmp390
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp390 from $t0 to $fp-176
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L71:
	# _tmp391 = *(_tmp389)
	lw $t0, -172($fp)	# load _tmp389 from $fp-172 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp392 = *(_tmp391)
	lw $t2, 0($t1) 	# load with offset
	# _tmp393 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp394 = _tmp393 < _tmp392
	slt $t4, $t3, $t2	
	# _tmp395 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp396 = _tmp395 < _tmp393
	slt $t6, $t5, $t3	
	# _tmp397 = _tmp396 && _tmp394
	and $t7, $t6, $t4	
	# IfZ _tmp397 Goto _L72
	# (save modified registers before flow of control change)
	sw $t1, -180($fp)	# spill _tmp391 from $t1 to $fp-180
	sw $t2, -184($fp)	# spill _tmp392 from $t2 to $fp-184
	sw $t3, -192($fp)	# spill _tmp393 from $t3 to $fp-192
	sw $t4, -188($fp)	# spill _tmp394 from $t4 to $fp-188
	sw $t5, -196($fp)	# spill _tmp395 from $t5 to $fp-196
	sw $t6, -200($fp)	# spill _tmp396 from $t6 to $fp-200
	sw $t7, -204($fp)	# spill _tmp397 from $t7 to $fp-204
	beqz $t7, _L72	# branch if _tmp397 is zero 
	# _tmp398 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp399 = _tmp393 * _tmp398
	lw $t1, -192($fp)	# load _tmp393 from $fp-192 into $t1
	mul $t2, $t1, $t0	
	# _tmp400 = _tmp399 + _tmp398
	add $t3, $t2, $t0	
	# _tmp401 = _tmp391 + _tmp400
	lw $t4, -180($fp)	# load _tmp391 from $fp-180 into $t4
	add $t5, $t4, $t3	
	# Goto _L73
	# (save modified registers before flow of control change)
	sw $t0, -208($fp)	# spill _tmp398 from $t0 to $fp-208
	sw $t2, -212($fp)	# spill _tmp399 from $t2 to $fp-212
	sw $t3, -216($fp)	# spill _tmp400 from $t3 to $fp-216
	sw $t5, -216($fp)	# spill _tmp401 from $t5 to $fp-216
	b _L73		# unconditional branch
_L72:
	# _tmp402 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string34: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string34	# load label
	# PushParam _tmp402
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -220($fp)	# spill _tmp402 from $t0 to $fp-220
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L73:
	# _tmp403 = *(_tmp401)
	lw $t0, -216($fp)	# load _tmp401 from $fp-216 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp404 = *(_tmp403)
	lw $t2, 0($t1) 	# load with offset
	# _tmp405 = *(_tmp404 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp403
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp406 = ACall _tmp405
	# (save modified registers before flow of control change)
	sw $t1, -224($fp)	# spill _tmp403 from $t1 to $fp-224
	sw $t2, -228($fp)	# spill _tmp404 from $t2 to $fp-228
	sw $t3, -232($fp)	# spill _tmp405 from $t3 to $fp-232
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp407 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp408 = *(_tmp407)
	lw $t3, 0($t2) 	# load with offset
	# _tmp409 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp410 = _tmp409 < _tmp408
	slt $t5, $t4, $t3	
	# _tmp411 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp412 = _tmp411 < _tmp409
	slt $t7, $t6, $t4	
	# _tmp413 = _tmp412 && _tmp410
	and $s0, $t7, $t5	
	# IfZ _tmp413 Goto _L74
	# (save modified registers before flow of control change)
	sw $t0, -236($fp)	# spill _tmp406 from $t0 to $fp-236
	sw $t2, -240($fp)	# spill _tmp407 from $t2 to $fp-240
	sw $t3, -244($fp)	# spill _tmp408 from $t3 to $fp-244
	sw $t4, -252($fp)	# spill _tmp409 from $t4 to $fp-252
	sw $t5, -248($fp)	# spill _tmp410 from $t5 to $fp-248
	sw $t6, -256($fp)	# spill _tmp411 from $t6 to $fp-256
	sw $t7, -260($fp)	# spill _tmp412 from $t7 to $fp-260
	sw $s0, -264($fp)	# spill _tmp413 from $s0 to $fp-264
	beqz $s0, _L74	# branch if _tmp413 is zero 
	# _tmp414 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp415 = _tmp409 * _tmp414
	lw $t1, -252($fp)	# load _tmp409 from $fp-252 into $t1
	mul $t2, $t1, $t0	
	# _tmp416 = _tmp415 + _tmp414
	add $t3, $t2, $t0	
	# _tmp417 = _tmp407 + _tmp416
	lw $t4, -240($fp)	# load _tmp407 from $fp-240 into $t4
	add $t5, $t4, $t3	
	# Goto _L75
	# (save modified registers before flow of control change)
	sw $t0, -268($fp)	# spill _tmp414 from $t0 to $fp-268
	sw $t2, -272($fp)	# spill _tmp415 from $t2 to $fp-272
	sw $t3, -276($fp)	# spill _tmp416 from $t3 to $fp-276
	sw $t5, -276($fp)	# spill _tmp417 from $t5 to $fp-276
	b _L75		# unconditional branch
_L74:
	# _tmp418 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string35: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string35	# load label
	# PushParam _tmp418
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -280($fp)	# spill _tmp418 from $t0 to $fp-280
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L75:
	# _tmp419 = *(_tmp417)
	lw $t0, -276($fp)	# load _tmp417 from $fp-276 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp420 = *(_tmp419)
	lw $t2, 0($t1) 	# load with offset
	# _tmp421 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp422 = _tmp421 < _tmp420
	slt $t4, $t3, $t2	
	# _tmp423 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp424 = _tmp423 < _tmp421
	slt $t6, $t5, $t3	
	# _tmp425 = _tmp424 && _tmp422
	and $t7, $t6, $t4	
	# IfZ _tmp425 Goto _L76
	# (save modified registers before flow of control change)
	sw $t1, -284($fp)	# spill _tmp419 from $t1 to $fp-284
	sw $t2, -288($fp)	# spill _tmp420 from $t2 to $fp-288
	sw $t3, -296($fp)	# spill _tmp421 from $t3 to $fp-296
	sw $t4, -292($fp)	# spill _tmp422 from $t4 to $fp-292
	sw $t5, -300($fp)	# spill _tmp423 from $t5 to $fp-300
	sw $t6, -304($fp)	# spill _tmp424 from $t6 to $fp-304
	sw $t7, -308($fp)	# spill _tmp425 from $t7 to $fp-308
	beqz $t7, _L76	# branch if _tmp425 is zero 
	# _tmp426 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp427 = _tmp421 * _tmp426
	lw $t1, -296($fp)	# load _tmp421 from $fp-296 into $t1
	mul $t2, $t1, $t0	
	# _tmp428 = _tmp427 + _tmp426
	add $t3, $t2, $t0	
	# _tmp429 = _tmp419 + _tmp428
	lw $t4, -284($fp)	# load _tmp419 from $fp-284 into $t4
	add $t5, $t4, $t3	
	# Goto _L77
	# (save modified registers before flow of control change)
	sw $t0, -312($fp)	# spill _tmp426 from $t0 to $fp-312
	sw $t2, -316($fp)	# spill _tmp427 from $t2 to $fp-316
	sw $t3, -320($fp)	# spill _tmp428 from $t3 to $fp-320
	sw $t5, -320($fp)	# spill _tmp429 from $t5 to $fp-320
	b _L77		# unconditional branch
_L76:
	# _tmp430 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string36: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string36	# load label
	# PushParam _tmp430
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -324($fp)	# spill _tmp430 from $t0 to $fp-324
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L77:
	# _tmp431 = *(_tmp429)
	lw $t0, -320($fp)	# load _tmp429 from $fp-320 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp432 = *(_tmp431)
	lw $t2, 0($t1) 	# load with offset
	# _tmp433 = *(_tmp432 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp431
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp434 = ACall _tmp433
	# (save modified registers before flow of control change)
	sw $t1, -328($fp)	# spill _tmp431 from $t1 to $fp-328
	sw $t2, -332($fp)	# spill _tmp432 from $t2 to $fp-332
	sw $t3, -336($fp)	# spill _tmp433 from $t3 to $fp-336
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp435 = _tmp434 && _tmp406
	lw $t1, -236($fp)	# load _tmp406 from $fp-236 into $t1
	and $t2, $t0, $t1	
	# _tmp436 = _tmp435 && _tmp378
	lw $t3, -128($fp)	# load _tmp378 from $fp-128 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp436 Goto _L64
	# (save modified registers before flow of control change)
	sw $t0, -340($fp)	# spill _tmp434 from $t0 to $fp-340
	sw $t2, -132($fp)	# spill _tmp435 from $t2 to $fp-132
	sw $t4, -24($fp)	# spill _tmp436 from $t4 to $fp-24
	beqz $t4, _L64	# branch if _tmp436 is zero 
	# _tmp437 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp437
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L65
	b _L65		# unconditional branch
_L64:
	# _tmp438 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp439 = *(_tmp438)
	lw $t2, 0($t1) 	# load with offset
	# _tmp440 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp441 = _tmp440 < _tmp439
	slt $t4, $t3, $t2	
	# _tmp442 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp443 = _tmp442 < _tmp440
	slt $t6, $t5, $t3	
	# _tmp444 = _tmp443 && _tmp441
	and $t7, $t6, $t4	
	# IfZ _tmp444 Goto _L80
	# (save modified registers before flow of control change)
	sw $t1, -352($fp)	# spill _tmp438 from $t1 to $fp-352
	sw $t2, -356($fp)	# spill _tmp439 from $t2 to $fp-356
	sw $t3, -364($fp)	# spill _tmp440 from $t3 to $fp-364
	sw $t4, -360($fp)	# spill _tmp441 from $t4 to $fp-360
	sw $t5, -368($fp)	# spill _tmp442 from $t5 to $fp-368
	sw $t6, -372($fp)	# spill _tmp443 from $t6 to $fp-372
	sw $t7, -376($fp)	# spill _tmp444 from $t7 to $fp-376
	beqz $t7, _L80	# branch if _tmp444 is zero 
	# _tmp445 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp446 = _tmp440 * _tmp445
	lw $t1, -364($fp)	# load _tmp440 from $fp-364 into $t1
	mul $t2, $t1, $t0	
	# _tmp447 = _tmp446 + _tmp445
	add $t3, $t2, $t0	
	# _tmp448 = _tmp438 + _tmp447
	lw $t4, -352($fp)	# load _tmp438 from $fp-352 into $t4
	add $t5, $t4, $t3	
	# Goto _L81
	# (save modified registers before flow of control change)
	sw $t0, -380($fp)	# spill _tmp445 from $t0 to $fp-380
	sw $t2, -384($fp)	# spill _tmp446 from $t2 to $fp-384
	sw $t3, -388($fp)	# spill _tmp447 from $t3 to $fp-388
	sw $t5, -388($fp)	# spill _tmp448 from $t5 to $fp-388
	b _L81		# unconditional branch
_L80:
	# _tmp449 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string37: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string37	# load label
	# PushParam _tmp449
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -392($fp)	# spill _tmp449 from $t0 to $fp-392
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L81:
	# _tmp450 = *(_tmp448)
	lw $t0, -388($fp)	# load _tmp448 from $fp-388 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp451 = *(_tmp450)
	lw $t2, 0($t1) 	# load with offset
	# _tmp452 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp453 = _tmp452 < _tmp451
	slt $t4, $t3, $t2	
	# _tmp454 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp455 = _tmp454 < _tmp452
	slt $t6, $t5, $t3	
	# _tmp456 = _tmp455 && _tmp453
	and $t7, $t6, $t4	
	# IfZ _tmp456 Goto _L82
	# (save modified registers before flow of control change)
	sw $t1, -396($fp)	# spill _tmp450 from $t1 to $fp-396
	sw $t2, -400($fp)	# spill _tmp451 from $t2 to $fp-400
	sw $t3, -408($fp)	# spill _tmp452 from $t3 to $fp-408
	sw $t4, -404($fp)	# spill _tmp453 from $t4 to $fp-404
	sw $t5, -412($fp)	# spill _tmp454 from $t5 to $fp-412
	sw $t6, -416($fp)	# spill _tmp455 from $t6 to $fp-416
	sw $t7, -420($fp)	# spill _tmp456 from $t7 to $fp-420
	beqz $t7, _L82	# branch if _tmp456 is zero 
	# _tmp457 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp458 = _tmp452 * _tmp457
	lw $t1, -408($fp)	# load _tmp452 from $fp-408 into $t1
	mul $t2, $t1, $t0	
	# _tmp459 = _tmp458 + _tmp457
	add $t3, $t2, $t0	
	# _tmp460 = _tmp450 + _tmp459
	lw $t4, -396($fp)	# load _tmp450 from $fp-396 into $t4
	add $t5, $t4, $t3	
	# Goto _L83
	# (save modified registers before flow of control change)
	sw $t0, -424($fp)	# spill _tmp457 from $t0 to $fp-424
	sw $t2, -428($fp)	# spill _tmp458 from $t2 to $fp-428
	sw $t3, -432($fp)	# spill _tmp459 from $t3 to $fp-432
	sw $t5, -432($fp)	# spill _tmp460 from $t5 to $fp-432
	b _L83		# unconditional branch
_L82:
	# _tmp461 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string38: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string38	# load label
	# PushParam _tmp461
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -436($fp)	# spill _tmp461 from $t0 to $fp-436
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L83:
	# _tmp462 = *(_tmp460)
	lw $t0, -432($fp)	# load _tmp460 from $fp-432 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp463 = *(_tmp462)
	lw $t2, 0($t1) 	# load with offset
	# _tmp464 = *(_tmp463 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp462
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp465 = ACall _tmp464
	# (save modified registers before flow of control change)
	sw $t1, -440($fp)	# spill _tmp462 from $t1 to $fp-440
	sw $t2, -444($fp)	# spill _tmp463 from $t2 to $fp-444
	sw $t3, -448($fp)	# spill _tmp464 from $t3 to $fp-448
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp466 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp467 = *(_tmp466)
	lw $t3, 0($t2) 	# load with offset
	# _tmp468 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp469 = _tmp468 < _tmp467
	slt $t5, $t4, $t3	
	# _tmp470 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp471 = _tmp470 < _tmp468
	slt $t7, $t6, $t4	
	# _tmp472 = _tmp471 && _tmp469
	and $s0, $t7, $t5	
	# IfZ _tmp472 Goto _L84
	# (save modified registers before flow of control change)
	sw $t0, -452($fp)	# spill _tmp465 from $t0 to $fp-452
	sw $t2, -460($fp)	# spill _tmp466 from $t2 to $fp-460
	sw $t3, -464($fp)	# spill _tmp467 from $t3 to $fp-464
	sw $t4, -472($fp)	# spill _tmp468 from $t4 to $fp-472
	sw $t5, -468($fp)	# spill _tmp469 from $t5 to $fp-468
	sw $t6, -476($fp)	# spill _tmp470 from $t6 to $fp-476
	sw $t7, -480($fp)	# spill _tmp471 from $t7 to $fp-480
	sw $s0, -484($fp)	# spill _tmp472 from $s0 to $fp-484
	beqz $s0, _L84	# branch if _tmp472 is zero 
	# _tmp473 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp474 = _tmp468 * _tmp473
	lw $t1, -472($fp)	# load _tmp468 from $fp-472 into $t1
	mul $t2, $t1, $t0	
	# _tmp475 = _tmp474 + _tmp473
	add $t3, $t2, $t0	
	# _tmp476 = _tmp466 + _tmp475
	lw $t4, -460($fp)	# load _tmp466 from $fp-460 into $t4
	add $t5, $t4, $t3	
	# Goto _L85
	# (save modified registers before flow of control change)
	sw $t0, -488($fp)	# spill _tmp473 from $t0 to $fp-488
	sw $t2, -492($fp)	# spill _tmp474 from $t2 to $fp-492
	sw $t3, -496($fp)	# spill _tmp475 from $t3 to $fp-496
	sw $t5, -496($fp)	# spill _tmp476 from $t5 to $fp-496
	b _L85		# unconditional branch
_L84:
	# _tmp477 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string39: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string39	# load label
	# PushParam _tmp477
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -500($fp)	# spill _tmp477 from $t0 to $fp-500
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L85:
	# _tmp478 = *(_tmp476)
	lw $t0, -496($fp)	# load _tmp476 from $fp-496 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp479 = *(_tmp478)
	lw $t2, 0($t1) 	# load with offset
	# _tmp480 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp481 = _tmp480 < _tmp479
	slt $t4, $t3, $t2	
	# _tmp482 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp483 = _tmp482 < _tmp480
	slt $t6, $t5, $t3	
	# _tmp484 = _tmp483 && _tmp481
	and $t7, $t6, $t4	
	# IfZ _tmp484 Goto _L86
	# (save modified registers before flow of control change)
	sw $t1, -504($fp)	# spill _tmp478 from $t1 to $fp-504
	sw $t2, -508($fp)	# spill _tmp479 from $t2 to $fp-508
	sw $t3, -516($fp)	# spill _tmp480 from $t3 to $fp-516
	sw $t4, -512($fp)	# spill _tmp481 from $t4 to $fp-512
	sw $t5, -520($fp)	# spill _tmp482 from $t5 to $fp-520
	sw $t6, -524($fp)	# spill _tmp483 from $t6 to $fp-524
	sw $t7, -528($fp)	# spill _tmp484 from $t7 to $fp-528
	beqz $t7, _L86	# branch if _tmp484 is zero 
	# _tmp485 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp486 = _tmp480 * _tmp485
	lw $t1, -516($fp)	# load _tmp480 from $fp-516 into $t1
	mul $t2, $t1, $t0	
	# _tmp487 = _tmp486 + _tmp485
	add $t3, $t2, $t0	
	# _tmp488 = _tmp478 + _tmp487
	lw $t4, -504($fp)	# load _tmp478 from $fp-504 into $t4
	add $t5, $t4, $t3	
	# Goto _L87
	# (save modified registers before flow of control change)
	sw $t0, -532($fp)	# spill _tmp485 from $t0 to $fp-532
	sw $t2, -536($fp)	# spill _tmp486 from $t2 to $fp-536
	sw $t3, -540($fp)	# spill _tmp487 from $t3 to $fp-540
	sw $t5, -540($fp)	# spill _tmp488 from $t5 to $fp-540
	b _L87		# unconditional branch
_L86:
	# _tmp489 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string40: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string40	# load label
	# PushParam _tmp489
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -544($fp)	# spill _tmp489 from $t0 to $fp-544
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L87:
	# _tmp490 = *(_tmp488)
	lw $t0, -540($fp)	# load _tmp488 from $fp-540 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp491 = *(_tmp490)
	lw $t2, 0($t1) 	# load with offset
	# _tmp492 = *(_tmp491 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp490
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp493 = ACall _tmp492
	# (save modified registers before flow of control change)
	sw $t1, -548($fp)	# spill _tmp490 from $t1 to $fp-548
	sw $t2, -552($fp)	# spill _tmp491 from $t2 to $fp-552
	sw $t3, -556($fp)	# spill _tmp492 from $t3 to $fp-556
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp494 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp495 = *(_tmp494)
	lw $t3, 0($t2) 	# load with offset
	# _tmp496 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp497 = _tmp496 < _tmp495
	slt $t5, $t4, $t3	
	# _tmp498 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp499 = _tmp498 < _tmp496
	slt $t7, $t6, $t4	
	# _tmp500 = _tmp499 && _tmp497
	and $s0, $t7, $t5	
	# IfZ _tmp500 Goto _L88
	# (save modified registers before flow of control change)
	sw $t0, -560($fp)	# spill _tmp493 from $t0 to $fp-560
	sw $t2, -564($fp)	# spill _tmp494 from $t2 to $fp-564
	sw $t3, -568($fp)	# spill _tmp495 from $t3 to $fp-568
	sw $t4, -576($fp)	# spill _tmp496 from $t4 to $fp-576
	sw $t5, -572($fp)	# spill _tmp497 from $t5 to $fp-572
	sw $t6, -580($fp)	# spill _tmp498 from $t6 to $fp-580
	sw $t7, -584($fp)	# spill _tmp499 from $t7 to $fp-584
	sw $s0, -588($fp)	# spill _tmp500 from $s0 to $fp-588
	beqz $s0, _L88	# branch if _tmp500 is zero 
	# _tmp501 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp502 = _tmp496 * _tmp501
	lw $t1, -576($fp)	# load _tmp496 from $fp-576 into $t1
	mul $t2, $t1, $t0	
	# _tmp503 = _tmp502 + _tmp501
	add $t3, $t2, $t0	
	# _tmp504 = _tmp494 + _tmp503
	lw $t4, -564($fp)	# load _tmp494 from $fp-564 into $t4
	add $t5, $t4, $t3	
	# Goto _L89
	# (save modified registers before flow of control change)
	sw $t0, -592($fp)	# spill _tmp501 from $t0 to $fp-592
	sw $t2, -596($fp)	# spill _tmp502 from $t2 to $fp-596
	sw $t3, -600($fp)	# spill _tmp503 from $t3 to $fp-600
	sw $t5, -600($fp)	# spill _tmp504 from $t5 to $fp-600
	b _L89		# unconditional branch
_L88:
	# _tmp505 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string41: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string41	# load label
	# PushParam _tmp505
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -604($fp)	# spill _tmp505 from $t0 to $fp-604
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L89:
	# _tmp506 = *(_tmp504)
	lw $t0, -600($fp)	# load _tmp504 from $fp-600 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp507 = *(_tmp506)
	lw $t2, 0($t1) 	# load with offset
	# _tmp508 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp509 = _tmp508 < _tmp507
	slt $t4, $t3, $t2	
	# _tmp510 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp511 = _tmp510 < _tmp508
	slt $t6, $t5, $t3	
	# _tmp512 = _tmp511 && _tmp509
	and $t7, $t6, $t4	
	# IfZ _tmp512 Goto _L90
	# (save modified registers before flow of control change)
	sw $t1, -608($fp)	# spill _tmp506 from $t1 to $fp-608
	sw $t2, -612($fp)	# spill _tmp507 from $t2 to $fp-612
	sw $t3, -620($fp)	# spill _tmp508 from $t3 to $fp-620
	sw $t4, -616($fp)	# spill _tmp509 from $t4 to $fp-616
	sw $t5, -624($fp)	# spill _tmp510 from $t5 to $fp-624
	sw $t6, -628($fp)	# spill _tmp511 from $t6 to $fp-628
	sw $t7, -632($fp)	# spill _tmp512 from $t7 to $fp-632
	beqz $t7, _L90	# branch if _tmp512 is zero 
	# _tmp513 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp514 = _tmp508 * _tmp513
	lw $t1, -620($fp)	# load _tmp508 from $fp-620 into $t1
	mul $t2, $t1, $t0	
	# _tmp515 = _tmp514 + _tmp513
	add $t3, $t2, $t0	
	# _tmp516 = _tmp506 + _tmp515
	lw $t4, -608($fp)	# load _tmp506 from $fp-608 into $t4
	add $t5, $t4, $t3	
	# Goto _L91
	# (save modified registers before flow of control change)
	sw $t0, -636($fp)	# spill _tmp513 from $t0 to $fp-636
	sw $t2, -640($fp)	# spill _tmp514 from $t2 to $fp-640
	sw $t3, -644($fp)	# spill _tmp515 from $t3 to $fp-644
	sw $t5, -644($fp)	# spill _tmp516 from $t5 to $fp-644
	b _L91		# unconditional branch
_L90:
	# _tmp517 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string42: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string42	# load label
	# PushParam _tmp517
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -648($fp)	# spill _tmp517 from $t0 to $fp-648
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L91:
	# _tmp518 = *(_tmp516)
	lw $t0, -644($fp)	# load _tmp516 from $fp-644 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp519 = *(_tmp518)
	lw $t2, 0($t1) 	# load with offset
	# _tmp520 = *(_tmp519 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp518
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp521 = ACall _tmp520
	# (save modified registers before flow of control change)
	sw $t1, -652($fp)	# spill _tmp518 from $t1 to $fp-652
	sw $t2, -656($fp)	# spill _tmp519 from $t2 to $fp-656
	sw $t3, -660($fp)	# spill _tmp520 from $t3 to $fp-660
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp522 = _tmp521 && _tmp493
	lw $t1, -560($fp)	# load _tmp493 from $fp-560 into $t1
	and $t2, $t0, $t1	
	# _tmp523 = _tmp522 && _tmp465
	lw $t3, -452($fp)	# load _tmp465 from $fp-452 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp523 Goto _L78
	# (save modified registers before flow of control change)
	sw $t0, -664($fp)	# spill _tmp521 from $t0 to $fp-664
	sw $t2, -456($fp)	# spill _tmp522 from $t2 to $fp-456
	sw $t4, -348($fp)	# spill _tmp523 from $t4 to $fp-348
	beqz $t4, _L78	# branch if _tmp523 is zero 
	# _tmp524 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp524
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L79
	b _L79		# unconditional branch
_L78:
	# _tmp525 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp526 = *(_tmp525)
	lw $t2, 0($t1) 	# load with offset
	# _tmp527 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp528 = _tmp527 < _tmp526
	slt $t4, $t3, $t2	
	# _tmp529 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp530 = _tmp529 < _tmp527
	slt $t6, $t5, $t3	
	# _tmp531 = _tmp530 && _tmp528
	and $t7, $t6, $t4	
	# IfZ _tmp531 Goto _L94
	# (save modified registers before flow of control change)
	sw $t1, -676($fp)	# spill _tmp525 from $t1 to $fp-676
	sw $t2, -680($fp)	# spill _tmp526 from $t2 to $fp-680
	sw $t3, -688($fp)	# spill _tmp527 from $t3 to $fp-688
	sw $t4, -684($fp)	# spill _tmp528 from $t4 to $fp-684
	sw $t5, -692($fp)	# spill _tmp529 from $t5 to $fp-692
	sw $t6, -696($fp)	# spill _tmp530 from $t6 to $fp-696
	sw $t7, -700($fp)	# spill _tmp531 from $t7 to $fp-700
	beqz $t7, _L94	# branch if _tmp531 is zero 
	# _tmp532 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp533 = _tmp527 * _tmp532
	lw $t1, -688($fp)	# load _tmp527 from $fp-688 into $t1
	mul $t2, $t1, $t0	
	# _tmp534 = _tmp533 + _tmp532
	add $t3, $t2, $t0	
	# _tmp535 = _tmp525 + _tmp534
	lw $t4, -676($fp)	# load _tmp525 from $fp-676 into $t4
	add $t5, $t4, $t3	
	# Goto _L95
	# (save modified registers before flow of control change)
	sw $t0, -704($fp)	# spill _tmp532 from $t0 to $fp-704
	sw $t2, -708($fp)	# spill _tmp533 from $t2 to $fp-708
	sw $t3, -712($fp)	# spill _tmp534 from $t3 to $fp-712
	sw $t5, -712($fp)	# spill _tmp535 from $t5 to $fp-712
	b _L95		# unconditional branch
_L94:
	# _tmp536 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string43: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string43	# load label
	# PushParam _tmp536
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -716($fp)	# spill _tmp536 from $t0 to $fp-716
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L95:
	# _tmp537 = *(_tmp535)
	lw $t0, -712($fp)	# load _tmp535 from $fp-712 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp538 = *(_tmp537)
	lw $t2, 0($t1) 	# load with offset
	# _tmp539 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp540 = _tmp539 < _tmp538
	slt $t4, $t3, $t2	
	# _tmp541 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp542 = _tmp541 < _tmp539
	slt $t6, $t5, $t3	
	# _tmp543 = _tmp542 && _tmp540
	and $t7, $t6, $t4	
	# IfZ _tmp543 Goto _L96
	# (save modified registers before flow of control change)
	sw $t1, -720($fp)	# spill _tmp537 from $t1 to $fp-720
	sw $t2, -724($fp)	# spill _tmp538 from $t2 to $fp-724
	sw $t3, -732($fp)	# spill _tmp539 from $t3 to $fp-732
	sw $t4, -728($fp)	# spill _tmp540 from $t4 to $fp-728
	sw $t5, -736($fp)	# spill _tmp541 from $t5 to $fp-736
	sw $t6, -740($fp)	# spill _tmp542 from $t6 to $fp-740
	sw $t7, -744($fp)	# spill _tmp543 from $t7 to $fp-744
	beqz $t7, _L96	# branch if _tmp543 is zero 
	# _tmp544 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp545 = _tmp539 * _tmp544
	lw $t1, -732($fp)	# load _tmp539 from $fp-732 into $t1
	mul $t2, $t1, $t0	
	# _tmp546 = _tmp545 + _tmp544
	add $t3, $t2, $t0	
	# _tmp547 = _tmp537 + _tmp546
	lw $t4, -720($fp)	# load _tmp537 from $fp-720 into $t4
	add $t5, $t4, $t3	
	# Goto _L97
	# (save modified registers before flow of control change)
	sw $t0, -748($fp)	# spill _tmp544 from $t0 to $fp-748
	sw $t2, -752($fp)	# spill _tmp545 from $t2 to $fp-752
	sw $t3, -756($fp)	# spill _tmp546 from $t3 to $fp-756
	sw $t5, -756($fp)	# spill _tmp547 from $t5 to $fp-756
	b _L97		# unconditional branch
_L96:
	# _tmp548 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string44: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string44	# load label
	# PushParam _tmp548
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -760($fp)	# spill _tmp548 from $t0 to $fp-760
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L97:
	# _tmp549 = *(_tmp547)
	lw $t0, -756($fp)	# load _tmp547 from $fp-756 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp550 = *(_tmp549)
	lw $t2, 0($t1) 	# load with offset
	# _tmp551 = *(_tmp550 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp549
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp552 = ACall _tmp551
	# (save modified registers before flow of control change)
	sw $t1, -764($fp)	# spill _tmp549 from $t1 to $fp-764
	sw $t2, -768($fp)	# spill _tmp550 from $t2 to $fp-768
	sw $t3, -772($fp)	# spill _tmp551 from $t3 to $fp-772
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp553 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp554 = *(_tmp553)
	lw $t3, 0($t2) 	# load with offset
	# _tmp555 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp556 = _tmp555 < _tmp554
	slt $t5, $t4, $t3	
	# _tmp557 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp558 = _tmp557 < _tmp555
	slt $t7, $t6, $t4	
	# _tmp559 = _tmp558 && _tmp556
	and $s0, $t7, $t5	
	# IfZ _tmp559 Goto _L98
	# (save modified registers before flow of control change)
	sw $t0, -776($fp)	# spill _tmp552 from $t0 to $fp-776
	sw $t2, -784($fp)	# spill _tmp553 from $t2 to $fp-784
	sw $t3, -788($fp)	# spill _tmp554 from $t3 to $fp-788
	sw $t4, -796($fp)	# spill _tmp555 from $t4 to $fp-796
	sw $t5, -792($fp)	# spill _tmp556 from $t5 to $fp-792
	sw $t6, -800($fp)	# spill _tmp557 from $t6 to $fp-800
	sw $t7, -804($fp)	# spill _tmp558 from $t7 to $fp-804
	sw $s0, -808($fp)	# spill _tmp559 from $s0 to $fp-808
	beqz $s0, _L98	# branch if _tmp559 is zero 
	# _tmp560 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp561 = _tmp555 * _tmp560
	lw $t1, -796($fp)	# load _tmp555 from $fp-796 into $t1
	mul $t2, $t1, $t0	
	# _tmp562 = _tmp561 + _tmp560
	add $t3, $t2, $t0	
	# _tmp563 = _tmp553 + _tmp562
	lw $t4, -784($fp)	# load _tmp553 from $fp-784 into $t4
	add $t5, $t4, $t3	
	# Goto _L99
	# (save modified registers before flow of control change)
	sw $t0, -812($fp)	# spill _tmp560 from $t0 to $fp-812
	sw $t2, -816($fp)	# spill _tmp561 from $t2 to $fp-816
	sw $t3, -820($fp)	# spill _tmp562 from $t3 to $fp-820
	sw $t5, -820($fp)	# spill _tmp563 from $t5 to $fp-820
	b _L99		# unconditional branch
_L98:
	# _tmp564 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string45: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string45	# load label
	# PushParam _tmp564
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -824($fp)	# spill _tmp564 from $t0 to $fp-824
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L99:
	# _tmp565 = *(_tmp563)
	lw $t0, -820($fp)	# load _tmp563 from $fp-820 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp566 = *(_tmp565)
	lw $t2, 0($t1) 	# load with offset
	# _tmp567 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp568 = _tmp567 < _tmp566
	slt $t4, $t3, $t2	
	# _tmp569 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp570 = _tmp569 < _tmp567
	slt $t6, $t5, $t3	
	# _tmp571 = _tmp570 && _tmp568
	and $t7, $t6, $t4	
	# IfZ _tmp571 Goto _L100
	# (save modified registers before flow of control change)
	sw $t1, -828($fp)	# spill _tmp565 from $t1 to $fp-828
	sw $t2, -832($fp)	# spill _tmp566 from $t2 to $fp-832
	sw $t3, -840($fp)	# spill _tmp567 from $t3 to $fp-840
	sw $t4, -836($fp)	# spill _tmp568 from $t4 to $fp-836
	sw $t5, -844($fp)	# spill _tmp569 from $t5 to $fp-844
	sw $t6, -848($fp)	# spill _tmp570 from $t6 to $fp-848
	sw $t7, -852($fp)	# spill _tmp571 from $t7 to $fp-852
	beqz $t7, _L100	# branch if _tmp571 is zero 
	# _tmp572 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp573 = _tmp567 * _tmp572
	lw $t1, -840($fp)	# load _tmp567 from $fp-840 into $t1
	mul $t2, $t1, $t0	
	# _tmp574 = _tmp573 + _tmp572
	add $t3, $t2, $t0	
	# _tmp575 = _tmp565 + _tmp574
	lw $t4, -828($fp)	# load _tmp565 from $fp-828 into $t4
	add $t5, $t4, $t3	
	# Goto _L101
	# (save modified registers before flow of control change)
	sw $t0, -856($fp)	# spill _tmp572 from $t0 to $fp-856
	sw $t2, -860($fp)	# spill _tmp573 from $t2 to $fp-860
	sw $t3, -864($fp)	# spill _tmp574 from $t3 to $fp-864
	sw $t5, -864($fp)	# spill _tmp575 from $t5 to $fp-864
	b _L101		# unconditional branch
_L100:
	# _tmp576 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string46: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string46	# load label
	# PushParam _tmp576
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -868($fp)	# spill _tmp576 from $t0 to $fp-868
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L101:
	# _tmp577 = *(_tmp575)
	lw $t0, -864($fp)	# load _tmp575 from $fp-864 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp578 = *(_tmp577)
	lw $t2, 0($t1) 	# load with offset
	# _tmp579 = *(_tmp578 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp577
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp580 = ACall _tmp579
	# (save modified registers before flow of control change)
	sw $t1, -872($fp)	# spill _tmp577 from $t1 to $fp-872
	sw $t2, -876($fp)	# spill _tmp578 from $t2 to $fp-876
	sw $t3, -880($fp)	# spill _tmp579 from $t3 to $fp-880
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp581 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp582 = *(_tmp581)
	lw $t3, 0($t2) 	# load with offset
	# _tmp583 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp584 = _tmp583 < _tmp582
	slt $t5, $t4, $t3	
	# _tmp585 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp586 = _tmp585 < _tmp583
	slt $t7, $t6, $t4	
	# _tmp587 = _tmp586 && _tmp584
	and $s0, $t7, $t5	
	# IfZ _tmp587 Goto _L102
	# (save modified registers before flow of control change)
	sw $t0, -884($fp)	# spill _tmp580 from $t0 to $fp-884
	sw $t2, -888($fp)	# spill _tmp581 from $t2 to $fp-888
	sw $t3, -892($fp)	# spill _tmp582 from $t3 to $fp-892
	sw $t4, -900($fp)	# spill _tmp583 from $t4 to $fp-900
	sw $t5, -896($fp)	# spill _tmp584 from $t5 to $fp-896
	sw $t6, -904($fp)	# spill _tmp585 from $t6 to $fp-904
	sw $t7, -908($fp)	# spill _tmp586 from $t7 to $fp-908
	sw $s0, -912($fp)	# spill _tmp587 from $s0 to $fp-912
	beqz $s0, _L102	# branch if _tmp587 is zero 
	# _tmp588 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp589 = _tmp583 * _tmp588
	lw $t1, -900($fp)	# load _tmp583 from $fp-900 into $t1
	mul $t2, $t1, $t0	
	# _tmp590 = _tmp589 + _tmp588
	add $t3, $t2, $t0	
	# _tmp591 = _tmp581 + _tmp590
	lw $t4, -888($fp)	# load _tmp581 from $fp-888 into $t4
	add $t5, $t4, $t3	
	# Goto _L103
	# (save modified registers before flow of control change)
	sw $t0, -916($fp)	# spill _tmp588 from $t0 to $fp-916
	sw $t2, -920($fp)	# spill _tmp589 from $t2 to $fp-920
	sw $t3, -924($fp)	# spill _tmp590 from $t3 to $fp-924
	sw $t5, -924($fp)	# spill _tmp591 from $t5 to $fp-924
	b _L103		# unconditional branch
_L102:
	# _tmp592 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string47: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string47	# load label
	# PushParam _tmp592
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -928($fp)	# spill _tmp592 from $t0 to $fp-928
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L103:
	# _tmp593 = *(_tmp591)
	lw $t0, -924($fp)	# load _tmp591 from $fp-924 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp594 = *(_tmp593)
	lw $t2, 0($t1) 	# load with offset
	# _tmp595 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp596 = _tmp595 < _tmp594
	slt $t4, $t3, $t2	
	# _tmp597 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp598 = _tmp597 < _tmp595
	slt $t6, $t5, $t3	
	# _tmp599 = _tmp598 && _tmp596
	and $t7, $t6, $t4	
	# IfZ _tmp599 Goto _L104
	# (save modified registers before flow of control change)
	sw $t1, -932($fp)	# spill _tmp593 from $t1 to $fp-932
	sw $t2, -936($fp)	# spill _tmp594 from $t2 to $fp-936
	sw $t3, -944($fp)	# spill _tmp595 from $t3 to $fp-944
	sw $t4, -940($fp)	# spill _tmp596 from $t4 to $fp-940
	sw $t5, -948($fp)	# spill _tmp597 from $t5 to $fp-948
	sw $t6, -952($fp)	# spill _tmp598 from $t6 to $fp-952
	sw $t7, -956($fp)	# spill _tmp599 from $t7 to $fp-956
	beqz $t7, _L104	# branch if _tmp599 is zero 
	# _tmp600 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp601 = _tmp595 * _tmp600
	lw $t1, -944($fp)	# load _tmp595 from $fp-944 into $t1
	mul $t2, $t1, $t0	
	# _tmp602 = _tmp601 + _tmp600
	add $t3, $t2, $t0	
	# _tmp603 = _tmp593 + _tmp602
	lw $t4, -932($fp)	# load _tmp593 from $fp-932 into $t4
	add $t5, $t4, $t3	
	# Goto _L105
	# (save modified registers before flow of control change)
	sw $t0, -960($fp)	# spill _tmp600 from $t0 to $fp-960
	sw $t2, -964($fp)	# spill _tmp601 from $t2 to $fp-964
	sw $t3, -968($fp)	# spill _tmp602 from $t3 to $fp-968
	sw $t5, -968($fp)	# spill _tmp603 from $t5 to $fp-968
	b _L105		# unconditional branch
_L104:
	# _tmp604 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string48: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string48	# load label
	# PushParam _tmp604
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -972($fp)	# spill _tmp604 from $t0 to $fp-972
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L105:
	# _tmp605 = *(_tmp603)
	lw $t0, -968($fp)	# load _tmp603 from $fp-968 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp606 = *(_tmp605)
	lw $t2, 0($t1) 	# load with offset
	# _tmp607 = *(_tmp606 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp605
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp608 = ACall _tmp607
	# (save modified registers before flow of control change)
	sw $t1, -976($fp)	# spill _tmp605 from $t1 to $fp-976
	sw $t2, -980($fp)	# spill _tmp606 from $t2 to $fp-980
	sw $t3, -984($fp)	# spill _tmp607 from $t3 to $fp-984
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp609 = _tmp608 && _tmp580
	lw $t1, -884($fp)	# load _tmp580 from $fp-884 into $t1
	and $t2, $t0, $t1	
	# _tmp610 = _tmp609 && _tmp552
	lw $t3, -776($fp)	# load _tmp552 from $fp-776 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp610 Goto _L92
	# (save modified registers before flow of control change)
	sw $t0, -988($fp)	# spill _tmp608 from $t0 to $fp-988
	sw $t2, -780($fp)	# spill _tmp609 from $t2 to $fp-780
	sw $t4, -672($fp)	# spill _tmp610 from $t4 to $fp-672
	beqz $t4, _L92	# branch if _tmp610 is zero 
	# _tmp611 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp611
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L93
	b _L93		# unconditional branch
_L92:
	# _tmp612 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp613 = *(_tmp612)
	lw $t2, 0($t1) 	# load with offset
	# _tmp614 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp615 = _tmp614 < _tmp613
	slt $t4, $t3, $t2	
	# _tmp616 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp617 = _tmp616 < _tmp614
	slt $t6, $t5, $t3	
	# _tmp618 = _tmp617 && _tmp615
	and $t7, $t6, $t4	
	# IfZ _tmp618 Goto _L108
	# (save modified registers before flow of control change)
	sw $t1, -1000($fp)	# spill _tmp612 from $t1 to $fp-1000
	sw $t2, -1004($fp)	# spill _tmp613 from $t2 to $fp-1004
	sw $t3, -1012($fp)	# spill _tmp614 from $t3 to $fp-1012
	sw $t4, -1008($fp)	# spill _tmp615 from $t4 to $fp-1008
	sw $t5, -1016($fp)	# spill _tmp616 from $t5 to $fp-1016
	sw $t6, -1020($fp)	# spill _tmp617 from $t6 to $fp-1020
	sw $t7, -1024($fp)	# spill _tmp618 from $t7 to $fp-1024
	beqz $t7, _L108	# branch if _tmp618 is zero 
	# _tmp619 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp620 = _tmp614 * _tmp619
	lw $t1, -1012($fp)	# load _tmp614 from $fp-1012 into $t1
	mul $t2, $t1, $t0	
	# _tmp621 = _tmp620 + _tmp619
	add $t3, $t2, $t0	
	# _tmp622 = _tmp612 + _tmp621
	lw $t4, -1000($fp)	# load _tmp612 from $fp-1000 into $t4
	add $t5, $t4, $t3	
	# Goto _L109
	# (save modified registers before flow of control change)
	sw $t0, -1028($fp)	# spill _tmp619 from $t0 to $fp-1028
	sw $t2, -1032($fp)	# spill _tmp620 from $t2 to $fp-1032
	sw $t3, -1036($fp)	# spill _tmp621 from $t3 to $fp-1036
	sw $t5, -1036($fp)	# spill _tmp622 from $t5 to $fp-1036
	b _L109		# unconditional branch
_L108:
	# _tmp623 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string49: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string49	# load label
	# PushParam _tmp623
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1040($fp)	# spill _tmp623 from $t0 to $fp-1040
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L109:
	# _tmp624 = *(_tmp622)
	lw $t0, -1036($fp)	# load _tmp622 from $fp-1036 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp625 = *(_tmp624)
	lw $t2, 0($t1) 	# load with offset
	# _tmp626 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp627 = _tmp626 < _tmp625
	slt $t4, $t3, $t2	
	# _tmp628 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp629 = _tmp628 < _tmp626
	slt $t6, $t5, $t3	
	# _tmp630 = _tmp629 && _tmp627
	and $t7, $t6, $t4	
	# IfZ _tmp630 Goto _L110
	# (save modified registers before flow of control change)
	sw $t1, -1044($fp)	# spill _tmp624 from $t1 to $fp-1044
	sw $t2, -1048($fp)	# spill _tmp625 from $t2 to $fp-1048
	sw $t3, -1056($fp)	# spill _tmp626 from $t3 to $fp-1056
	sw $t4, -1052($fp)	# spill _tmp627 from $t4 to $fp-1052
	sw $t5, -1060($fp)	# spill _tmp628 from $t5 to $fp-1060
	sw $t6, -1064($fp)	# spill _tmp629 from $t6 to $fp-1064
	sw $t7, -1068($fp)	# spill _tmp630 from $t7 to $fp-1068
	beqz $t7, _L110	# branch if _tmp630 is zero 
	# _tmp631 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp632 = _tmp626 * _tmp631
	lw $t1, -1056($fp)	# load _tmp626 from $fp-1056 into $t1
	mul $t2, $t1, $t0	
	# _tmp633 = _tmp632 + _tmp631
	add $t3, $t2, $t0	
	# _tmp634 = _tmp624 + _tmp633
	lw $t4, -1044($fp)	# load _tmp624 from $fp-1044 into $t4
	add $t5, $t4, $t3	
	# Goto _L111
	# (save modified registers before flow of control change)
	sw $t0, -1072($fp)	# spill _tmp631 from $t0 to $fp-1072
	sw $t2, -1076($fp)	# spill _tmp632 from $t2 to $fp-1076
	sw $t3, -1080($fp)	# spill _tmp633 from $t3 to $fp-1080
	sw $t5, -1080($fp)	# spill _tmp634 from $t5 to $fp-1080
	b _L111		# unconditional branch
_L110:
	# _tmp635 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string50: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string50	# load label
	# PushParam _tmp635
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1084($fp)	# spill _tmp635 from $t0 to $fp-1084
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L111:
	# _tmp636 = *(_tmp634)
	lw $t0, -1080($fp)	# load _tmp634 from $fp-1080 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp637 = *(_tmp636)
	lw $t2, 0($t1) 	# load with offset
	# _tmp638 = *(_tmp637 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp636
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp639 = ACall _tmp638
	# (save modified registers before flow of control change)
	sw $t1, -1088($fp)	# spill _tmp636 from $t1 to $fp-1088
	sw $t2, -1092($fp)	# spill _tmp637 from $t2 to $fp-1092
	sw $t3, -1096($fp)	# spill _tmp638 from $t3 to $fp-1096
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp640 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp641 = *(_tmp640)
	lw $t3, 0($t2) 	# load with offset
	# _tmp642 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp643 = _tmp642 < _tmp641
	slt $t5, $t4, $t3	
	# _tmp644 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp645 = _tmp644 < _tmp642
	slt $t7, $t6, $t4	
	# _tmp646 = _tmp645 && _tmp643
	and $s0, $t7, $t5	
	# IfZ _tmp646 Goto _L112
	# (save modified registers before flow of control change)
	sw $t0, -1100($fp)	# spill _tmp639 from $t0 to $fp-1100
	sw $t2, -1108($fp)	# spill _tmp640 from $t2 to $fp-1108
	sw $t3, -1112($fp)	# spill _tmp641 from $t3 to $fp-1112
	sw $t4, -1120($fp)	# spill _tmp642 from $t4 to $fp-1120
	sw $t5, -1116($fp)	# spill _tmp643 from $t5 to $fp-1116
	sw $t6, -1124($fp)	# spill _tmp644 from $t6 to $fp-1124
	sw $t7, -1128($fp)	# spill _tmp645 from $t7 to $fp-1128
	sw $s0, -1132($fp)	# spill _tmp646 from $s0 to $fp-1132
	beqz $s0, _L112	# branch if _tmp646 is zero 
	# _tmp647 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp648 = _tmp642 * _tmp647
	lw $t1, -1120($fp)	# load _tmp642 from $fp-1120 into $t1
	mul $t2, $t1, $t0	
	# _tmp649 = _tmp648 + _tmp647
	add $t3, $t2, $t0	
	# _tmp650 = _tmp640 + _tmp649
	lw $t4, -1108($fp)	# load _tmp640 from $fp-1108 into $t4
	add $t5, $t4, $t3	
	# Goto _L113
	# (save modified registers before flow of control change)
	sw $t0, -1136($fp)	# spill _tmp647 from $t0 to $fp-1136
	sw $t2, -1140($fp)	# spill _tmp648 from $t2 to $fp-1140
	sw $t3, -1144($fp)	# spill _tmp649 from $t3 to $fp-1144
	sw $t5, -1144($fp)	# spill _tmp650 from $t5 to $fp-1144
	b _L113		# unconditional branch
_L112:
	# _tmp651 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string51: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string51	# load label
	# PushParam _tmp651
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1148($fp)	# spill _tmp651 from $t0 to $fp-1148
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L113:
	# _tmp652 = *(_tmp650)
	lw $t0, -1144($fp)	# load _tmp650 from $fp-1144 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp653 = *(_tmp652)
	lw $t2, 0($t1) 	# load with offset
	# _tmp654 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp655 = _tmp654 < _tmp653
	slt $t4, $t3, $t2	
	# _tmp656 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp657 = _tmp656 < _tmp654
	slt $t6, $t5, $t3	
	# _tmp658 = _tmp657 && _tmp655
	and $t7, $t6, $t4	
	# IfZ _tmp658 Goto _L114
	# (save modified registers before flow of control change)
	sw $t1, -1152($fp)	# spill _tmp652 from $t1 to $fp-1152
	sw $t2, -1156($fp)	# spill _tmp653 from $t2 to $fp-1156
	sw $t3, -1164($fp)	# spill _tmp654 from $t3 to $fp-1164
	sw $t4, -1160($fp)	# spill _tmp655 from $t4 to $fp-1160
	sw $t5, -1168($fp)	# spill _tmp656 from $t5 to $fp-1168
	sw $t6, -1172($fp)	# spill _tmp657 from $t6 to $fp-1172
	sw $t7, -1176($fp)	# spill _tmp658 from $t7 to $fp-1176
	beqz $t7, _L114	# branch if _tmp658 is zero 
	# _tmp659 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp660 = _tmp654 * _tmp659
	lw $t1, -1164($fp)	# load _tmp654 from $fp-1164 into $t1
	mul $t2, $t1, $t0	
	# _tmp661 = _tmp660 + _tmp659
	add $t3, $t2, $t0	
	# _tmp662 = _tmp652 + _tmp661
	lw $t4, -1152($fp)	# load _tmp652 from $fp-1152 into $t4
	add $t5, $t4, $t3	
	# Goto _L115
	# (save modified registers before flow of control change)
	sw $t0, -1180($fp)	# spill _tmp659 from $t0 to $fp-1180
	sw $t2, -1184($fp)	# spill _tmp660 from $t2 to $fp-1184
	sw $t3, -1188($fp)	# spill _tmp661 from $t3 to $fp-1188
	sw $t5, -1188($fp)	# spill _tmp662 from $t5 to $fp-1188
	b _L115		# unconditional branch
_L114:
	# _tmp663 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string52: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string52	# load label
	# PushParam _tmp663
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1192($fp)	# spill _tmp663 from $t0 to $fp-1192
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L115:
	# _tmp664 = *(_tmp662)
	lw $t0, -1188($fp)	# load _tmp662 from $fp-1188 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp665 = *(_tmp664)
	lw $t2, 0($t1) 	# load with offset
	# _tmp666 = *(_tmp665 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp664
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp667 = ACall _tmp666
	# (save modified registers before flow of control change)
	sw $t1, -1196($fp)	# spill _tmp664 from $t1 to $fp-1196
	sw $t2, -1200($fp)	# spill _tmp665 from $t2 to $fp-1200
	sw $t3, -1204($fp)	# spill _tmp666 from $t3 to $fp-1204
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp668 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp669 = *(_tmp668)
	lw $t3, 0($t2) 	# load with offset
	# _tmp670 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp671 = _tmp670 < _tmp669
	slt $t5, $t4, $t3	
	# _tmp672 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp673 = _tmp672 < _tmp670
	slt $t7, $t6, $t4	
	# _tmp674 = _tmp673 && _tmp671
	and $s0, $t7, $t5	
	# IfZ _tmp674 Goto _L116
	# (save modified registers before flow of control change)
	sw $t0, -1208($fp)	# spill _tmp667 from $t0 to $fp-1208
	sw $t2, -1212($fp)	# spill _tmp668 from $t2 to $fp-1212
	sw $t3, -1216($fp)	# spill _tmp669 from $t3 to $fp-1216
	sw $t4, -1224($fp)	# spill _tmp670 from $t4 to $fp-1224
	sw $t5, -1220($fp)	# spill _tmp671 from $t5 to $fp-1220
	sw $t6, -1228($fp)	# spill _tmp672 from $t6 to $fp-1228
	sw $t7, -1232($fp)	# spill _tmp673 from $t7 to $fp-1232
	sw $s0, -1236($fp)	# spill _tmp674 from $s0 to $fp-1236
	beqz $s0, _L116	# branch if _tmp674 is zero 
	# _tmp675 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp676 = _tmp670 * _tmp675
	lw $t1, -1224($fp)	# load _tmp670 from $fp-1224 into $t1
	mul $t2, $t1, $t0	
	# _tmp677 = _tmp676 + _tmp675
	add $t3, $t2, $t0	
	# _tmp678 = _tmp668 + _tmp677
	lw $t4, -1212($fp)	# load _tmp668 from $fp-1212 into $t4
	add $t5, $t4, $t3	
	# Goto _L117
	# (save modified registers before flow of control change)
	sw $t0, -1240($fp)	# spill _tmp675 from $t0 to $fp-1240
	sw $t2, -1244($fp)	# spill _tmp676 from $t2 to $fp-1244
	sw $t3, -1248($fp)	# spill _tmp677 from $t3 to $fp-1248
	sw $t5, -1248($fp)	# spill _tmp678 from $t5 to $fp-1248
	b _L117		# unconditional branch
_L116:
	# _tmp679 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string53: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string53	# load label
	# PushParam _tmp679
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1252($fp)	# spill _tmp679 from $t0 to $fp-1252
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L117:
	# _tmp680 = *(_tmp678)
	lw $t0, -1248($fp)	# load _tmp678 from $fp-1248 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp681 = *(_tmp680)
	lw $t2, 0($t1) 	# load with offset
	# _tmp682 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp683 = _tmp682 < _tmp681
	slt $t4, $t3, $t2	
	# _tmp684 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp685 = _tmp684 < _tmp682
	slt $t6, $t5, $t3	
	# _tmp686 = _tmp685 && _tmp683
	and $t7, $t6, $t4	
	# IfZ _tmp686 Goto _L118
	# (save modified registers before flow of control change)
	sw $t1, -1256($fp)	# spill _tmp680 from $t1 to $fp-1256
	sw $t2, -1260($fp)	# spill _tmp681 from $t2 to $fp-1260
	sw $t3, -1268($fp)	# spill _tmp682 from $t3 to $fp-1268
	sw $t4, -1264($fp)	# spill _tmp683 from $t4 to $fp-1264
	sw $t5, -1272($fp)	# spill _tmp684 from $t5 to $fp-1272
	sw $t6, -1276($fp)	# spill _tmp685 from $t6 to $fp-1276
	sw $t7, -1280($fp)	# spill _tmp686 from $t7 to $fp-1280
	beqz $t7, _L118	# branch if _tmp686 is zero 
	# _tmp687 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp688 = _tmp682 * _tmp687
	lw $t1, -1268($fp)	# load _tmp682 from $fp-1268 into $t1
	mul $t2, $t1, $t0	
	# _tmp689 = _tmp688 + _tmp687
	add $t3, $t2, $t0	
	# _tmp690 = _tmp680 + _tmp689
	lw $t4, -1256($fp)	# load _tmp680 from $fp-1256 into $t4
	add $t5, $t4, $t3	
	# Goto _L119
	# (save modified registers before flow of control change)
	sw $t0, -1284($fp)	# spill _tmp687 from $t0 to $fp-1284
	sw $t2, -1288($fp)	# spill _tmp688 from $t2 to $fp-1288
	sw $t3, -1292($fp)	# spill _tmp689 from $t3 to $fp-1292
	sw $t5, -1292($fp)	# spill _tmp690 from $t5 to $fp-1292
	b _L119		# unconditional branch
_L118:
	# _tmp691 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string54: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string54	# load label
	# PushParam _tmp691
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1296($fp)	# spill _tmp691 from $t0 to $fp-1296
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L119:
	# _tmp692 = *(_tmp690)
	lw $t0, -1292($fp)	# load _tmp690 from $fp-1292 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp693 = *(_tmp692)
	lw $t2, 0($t1) 	# load with offset
	# _tmp694 = *(_tmp693 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp692
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp695 = ACall _tmp694
	# (save modified registers before flow of control change)
	sw $t1, -1300($fp)	# spill _tmp692 from $t1 to $fp-1300
	sw $t2, -1304($fp)	# spill _tmp693 from $t2 to $fp-1304
	sw $t3, -1308($fp)	# spill _tmp694 from $t3 to $fp-1308
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp696 = _tmp695 && _tmp667
	lw $t1, -1208($fp)	# load _tmp667 from $fp-1208 into $t1
	and $t2, $t0, $t1	
	# _tmp697 = _tmp696 && _tmp639
	lw $t3, -1100($fp)	# load _tmp639 from $fp-1100 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp697 Goto _L106
	# (save modified registers before flow of control change)
	sw $t0, -1312($fp)	# spill _tmp695 from $t0 to $fp-1312
	sw $t2, -1104($fp)	# spill _tmp696 from $t2 to $fp-1104
	sw $t4, -996($fp)	# spill _tmp697 from $t4 to $fp-996
	beqz $t4, _L106	# branch if _tmp697 is zero 
	# _tmp698 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp698
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L107
	b _L107		# unconditional branch
_L106:
_L107:
_L93:
_L79:
_L65:
	# _tmp699 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp700 = *(_tmp699)
	lw $t2, 0($t1) 	# load with offset
	# _tmp701 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp702 = _tmp701 < _tmp700
	slt $t4, $t3, $t2	
	# _tmp703 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp704 = _tmp703 < _tmp701
	slt $t6, $t5, $t3	
	# _tmp705 = _tmp704 && _tmp702
	and $t7, $t6, $t4	
	# IfZ _tmp705 Goto _L122
	# (save modified registers before flow of control change)
	sw $t1, -1324($fp)	# spill _tmp699 from $t1 to $fp-1324
	sw $t2, -1328($fp)	# spill _tmp700 from $t2 to $fp-1328
	sw $t3, -1336($fp)	# spill _tmp701 from $t3 to $fp-1336
	sw $t4, -1332($fp)	# spill _tmp702 from $t4 to $fp-1332
	sw $t5, -1340($fp)	# spill _tmp703 from $t5 to $fp-1340
	sw $t6, -1344($fp)	# spill _tmp704 from $t6 to $fp-1344
	sw $t7, -1348($fp)	# spill _tmp705 from $t7 to $fp-1348
	beqz $t7, _L122	# branch if _tmp705 is zero 
	# _tmp706 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp707 = _tmp701 * _tmp706
	lw $t1, -1336($fp)	# load _tmp701 from $fp-1336 into $t1
	mul $t2, $t1, $t0	
	# _tmp708 = _tmp707 + _tmp706
	add $t3, $t2, $t0	
	# _tmp709 = _tmp699 + _tmp708
	lw $t4, -1324($fp)	# load _tmp699 from $fp-1324 into $t4
	add $t5, $t4, $t3	
	# Goto _L123
	# (save modified registers before flow of control change)
	sw $t0, -1352($fp)	# spill _tmp706 from $t0 to $fp-1352
	sw $t2, -1356($fp)	# spill _tmp707 from $t2 to $fp-1356
	sw $t3, -1360($fp)	# spill _tmp708 from $t3 to $fp-1360
	sw $t5, -1360($fp)	# spill _tmp709 from $t5 to $fp-1360
	b _L123		# unconditional branch
_L122:
	# _tmp710 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string55: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string55	# load label
	# PushParam _tmp710
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1364($fp)	# spill _tmp710 from $t0 to $fp-1364
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L123:
	# _tmp711 = *(_tmp709)
	lw $t0, -1360($fp)	# load _tmp709 from $fp-1360 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp712 = *(_tmp711)
	lw $t2, 0($t1) 	# load with offset
	# _tmp713 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp714 = _tmp713 < _tmp712
	slt $t4, $t3, $t2	
	# _tmp715 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp716 = _tmp715 < _tmp713
	slt $t6, $t5, $t3	
	# _tmp717 = _tmp716 && _tmp714
	and $t7, $t6, $t4	
	# IfZ _tmp717 Goto _L124
	# (save modified registers before flow of control change)
	sw $t1, -1368($fp)	# spill _tmp711 from $t1 to $fp-1368
	sw $t2, -1372($fp)	# spill _tmp712 from $t2 to $fp-1372
	sw $t3, -1380($fp)	# spill _tmp713 from $t3 to $fp-1380
	sw $t4, -1376($fp)	# spill _tmp714 from $t4 to $fp-1376
	sw $t5, -1384($fp)	# spill _tmp715 from $t5 to $fp-1384
	sw $t6, -1388($fp)	# spill _tmp716 from $t6 to $fp-1388
	sw $t7, -1392($fp)	# spill _tmp717 from $t7 to $fp-1392
	beqz $t7, _L124	# branch if _tmp717 is zero 
	# _tmp718 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp719 = _tmp713 * _tmp718
	lw $t1, -1380($fp)	# load _tmp713 from $fp-1380 into $t1
	mul $t2, $t1, $t0	
	# _tmp720 = _tmp719 + _tmp718
	add $t3, $t2, $t0	
	# _tmp721 = _tmp711 + _tmp720
	lw $t4, -1368($fp)	# load _tmp711 from $fp-1368 into $t4
	add $t5, $t4, $t3	
	# Goto _L125
	# (save modified registers before flow of control change)
	sw $t0, -1396($fp)	# spill _tmp718 from $t0 to $fp-1396
	sw $t2, -1400($fp)	# spill _tmp719 from $t2 to $fp-1400
	sw $t3, -1404($fp)	# spill _tmp720 from $t3 to $fp-1404
	sw $t5, -1404($fp)	# spill _tmp721 from $t5 to $fp-1404
	b _L125		# unconditional branch
_L124:
	# _tmp722 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string56: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string56	# load label
	# PushParam _tmp722
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1408($fp)	# spill _tmp722 from $t0 to $fp-1408
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L125:
	# _tmp723 = *(_tmp721)
	lw $t0, -1404($fp)	# load _tmp721 from $fp-1404 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp724 = *(_tmp723)
	lw $t2, 0($t1) 	# load with offset
	# _tmp725 = *(_tmp724 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp723
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp726 = ACall _tmp725
	# (save modified registers before flow of control change)
	sw $t1, -1412($fp)	# spill _tmp723 from $t1 to $fp-1412
	sw $t2, -1416($fp)	# spill _tmp724 from $t2 to $fp-1416
	sw $t3, -1420($fp)	# spill _tmp725 from $t3 to $fp-1420
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp727 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp728 = *(_tmp727)
	lw $t3, 0($t2) 	# load with offset
	# _tmp729 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp730 = _tmp729 < _tmp728
	slt $t5, $t4, $t3	
	# _tmp731 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp732 = _tmp731 < _tmp729
	slt $t7, $t6, $t4	
	# _tmp733 = _tmp732 && _tmp730
	and $s0, $t7, $t5	
	# IfZ _tmp733 Goto _L126
	# (save modified registers before flow of control change)
	sw $t0, -1424($fp)	# spill _tmp726 from $t0 to $fp-1424
	sw $t2, -1432($fp)	# spill _tmp727 from $t2 to $fp-1432
	sw $t3, -1436($fp)	# spill _tmp728 from $t3 to $fp-1436
	sw $t4, -1444($fp)	# spill _tmp729 from $t4 to $fp-1444
	sw $t5, -1440($fp)	# spill _tmp730 from $t5 to $fp-1440
	sw $t6, -1448($fp)	# spill _tmp731 from $t6 to $fp-1448
	sw $t7, -1452($fp)	# spill _tmp732 from $t7 to $fp-1452
	sw $s0, -1456($fp)	# spill _tmp733 from $s0 to $fp-1456
	beqz $s0, _L126	# branch if _tmp733 is zero 
	# _tmp734 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp735 = _tmp729 * _tmp734
	lw $t1, -1444($fp)	# load _tmp729 from $fp-1444 into $t1
	mul $t2, $t1, $t0	
	# _tmp736 = _tmp735 + _tmp734
	add $t3, $t2, $t0	
	# _tmp737 = _tmp727 + _tmp736
	lw $t4, -1432($fp)	# load _tmp727 from $fp-1432 into $t4
	add $t5, $t4, $t3	
	# Goto _L127
	# (save modified registers before flow of control change)
	sw $t0, -1460($fp)	# spill _tmp734 from $t0 to $fp-1460
	sw $t2, -1464($fp)	# spill _tmp735 from $t2 to $fp-1464
	sw $t3, -1468($fp)	# spill _tmp736 from $t3 to $fp-1468
	sw $t5, -1468($fp)	# spill _tmp737 from $t5 to $fp-1468
	b _L127		# unconditional branch
_L126:
	# _tmp738 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string57: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string57	# load label
	# PushParam _tmp738
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1472($fp)	# spill _tmp738 from $t0 to $fp-1472
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L127:
	# _tmp739 = *(_tmp737)
	lw $t0, -1468($fp)	# load _tmp737 from $fp-1468 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp740 = *(_tmp739)
	lw $t2, 0($t1) 	# load with offset
	# _tmp741 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp742 = _tmp741 < _tmp740
	slt $t4, $t3, $t2	
	# _tmp743 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp744 = _tmp743 < _tmp741
	slt $t6, $t5, $t3	
	# _tmp745 = _tmp744 && _tmp742
	and $t7, $t6, $t4	
	# IfZ _tmp745 Goto _L128
	# (save modified registers before flow of control change)
	sw $t1, -1476($fp)	# spill _tmp739 from $t1 to $fp-1476
	sw $t2, -1480($fp)	# spill _tmp740 from $t2 to $fp-1480
	sw $t3, -1488($fp)	# spill _tmp741 from $t3 to $fp-1488
	sw $t4, -1484($fp)	# spill _tmp742 from $t4 to $fp-1484
	sw $t5, -1492($fp)	# spill _tmp743 from $t5 to $fp-1492
	sw $t6, -1496($fp)	# spill _tmp744 from $t6 to $fp-1496
	sw $t7, -1500($fp)	# spill _tmp745 from $t7 to $fp-1500
	beqz $t7, _L128	# branch if _tmp745 is zero 
	# _tmp746 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp747 = _tmp741 * _tmp746
	lw $t1, -1488($fp)	# load _tmp741 from $fp-1488 into $t1
	mul $t2, $t1, $t0	
	# _tmp748 = _tmp747 + _tmp746
	add $t3, $t2, $t0	
	# _tmp749 = _tmp739 + _tmp748
	lw $t4, -1476($fp)	# load _tmp739 from $fp-1476 into $t4
	add $t5, $t4, $t3	
	# Goto _L129
	# (save modified registers before flow of control change)
	sw $t0, -1504($fp)	# spill _tmp746 from $t0 to $fp-1504
	sw $t2, -1508($fp)	# spill _tmp747 from $t2 to $fp-1508
	sw $t3, -1512($fp)	# spill _tmp748 from $t3 to $fp-1512
	sw $t5, -1512($fp)	# spill _tmp749 from $t5 to $fp-1512
	b _L129		# unconditional branch
_L128:
	# _tmp750 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string58: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string58	# load label
	# PushParam _tmp750
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1516($fp)	# spill _tmp750 from $t0 to $fp-1516
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L129:
	# _tmp751 = *(_tmp749)
	lw $t0, -1512($fp)	# load _tmp749 from $fp-1512 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp752 = *(_tmp751)
	lw $t2, 0($t1) 	# load with offset
	# _tmp753 = *(_tmp752 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp751
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp754 = ACall _tmp753
	# (save modified registers before flow of control change)
	sw $t1, -1520($fp)	# spill _tmp751 from $t1 to $fp-1520
	sw $t2, -1524($fp)	# spill _tmp752 from $t2 to $fp-1524
	sw $t3, -1528($fp)	# spill _tmp753 from $t3 to $fp-1528
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp755 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp756 = *(_tmp755)
	lw $t3, 0($t2) 	# load with offset
	# _tmp757 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp758 = _tmp757 < _tmp756
	slt $t5, $t4, $t3	
	# _tmp759 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp760 = _tmp759 < _tmp757
	slt $t7, $t6, $t4	
	# _tmp761 = _tmp760 && _tmp758
	and $s0, $t7, $t5	
	# IfZ _tmp761 Goto _L130
	# (save modified registers before flow of control change)
	sw $t0, -1532($fp)	# spill _tmp754 from $t0 to $fp-1532
	sw $t2, -1536($fp)	# spill _tmp755 from $t2 to $fp-1536
	sw $t3, -1540($fp)	# spill _tmp756 from $t3 to $fp-1540
	sw $t4, -1548($fp)	# spill _tmp757 from $t4 to $fp-1548
	sw $t5, -1544($fp)	# spill _tmp758 from $t5 to $fp-1544
	sw $t6, -1552($fp)	# spill _tmp759 from $t6 to $fp-1552
	sw $t7, -1556($fp)	# spill _tmp760 from $t7 to $fp-1556
	sw $s0, -1560($fp)	# spill _tmp761 from $s0 to $fp-1560
	beqz $s0, _L130	# branch if _tmp761 is zero 
	# _tmp762 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp763 = _tmp757 * _tmp762
	lw $t1, -1548($fp)	# load _tmp757 from $fp-1548 into $t1
	mul $t2, $t1, $t0	
	# _tmp764 = _tmp763 + _tmp762
	add $t3, $t2, $t0	
	# _tmp765 = _tmp755 + _tmp764
	lw $t4, -1536($fp)	# load _tmp755 from $fp-1536 into $t4
	add $t5, $t4, $t3	
	# Goto _L131
	# (save modified registers before flow of control change)
	sw $t0, -1564($fp)	# spill _tmp762 from $t0 to $fp-1564
	sw $t2, -1568($fp)	# spill _tmp763 from $t2 to $fp-1568
	sw $t3, -1572($fp)	# spill _tmp764 from $t3 to $fp-1572
	sw $t5, -1572($fp)	# spill _tmp765 from $t5 to $fp-1572
	b _L131		# unconditional branch
_L130:
	# _tmp766 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string59: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string59	# load label
	# PushParam _tmp766
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1576($fp)	# spill _tmp766 from $t0 to $fp-1576
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L131:
	# _tmp767 = *(_tmp765)
	lw $t0, -1572($fp)	# load _tmp765 from $fp-1572 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp768 = *(_tmp767)
	lw $t2, 0($t1) 	# load with offset
	# _tmp769 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp770 = _tmp769 < _tmp768
	slt $t4, $t3, $t2	
	# _tmp771 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp772 = _tmp771 < _tmp769
	slt $t6, $t5, $t3	
	# _tmp773 = _tmp772 && _tmp770
	and $t7, $t6, $t4	
	# IfZ _tmp773 Goto _L132
	# (save modified registers before flow of control change)
	sw $t1, -1580($fp)	# spill _tmp767 from $t1 to $fp-1580
	sw $t2, -1584($fp)	# spill _tmp768 from $t2 to $fp-1584
	sw $t3, -1592($fp)	# spill _tmp769 from $t3 to $fp-1592
	sw $t4, -1588($fp)	# spill _tmp770 from $t4 to $fp-1588
	sw $t5, -1596($fp)	# spill _tmp771 from $t5 to $fp-1596
	sw $t6, -1600($fp)	# spill _tmp772 from $t6 to $fp-1600
	sw $t7, -1604($fp)	# spill _tmp773 from $t7 to $fp-1604
	beqz $t7, _L132	# branch if _tmp773 is zero 
	# _tmp774 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp775 = _tmp769 * _tmp774
	lw $t1, -1592($fp)	# load _tmp769 from $fp-1592 into $t1
	mul $t2, $t1, $t0	
	# _tmp776 = _tmp775 + _tmp774
	add $t3, $t2, $t0	
	# _tmp777 = _tmp767 + _tmp776
	lw $t4, -1580($fp)	# load _tmp767 from $fp-1580 into $t4
	add $t5, $t4, $t3	
	# Goto _L133
	# (save modified registers before flow of control change)
	sw $t0, -1608($fp)	# spill _tmp774 from $t0 to $fp-1608
	sw $t2, -1612($fp)	# spill _tmp775 from $t2 to $fp-1612
	sw $t3, -1616($fp)	# spill _tmp776 from $t3 to $fp-1616
	sw $t5, -1616($fp)	# spill _tmp777 from $t5 to $fp-1616
	b _L133		# unconditional branch
_L132:
	# _tmp778 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string60: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string60	# load label
	# PushParam _tmp778
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1620($fp)	# spill _tmp778 from $t0 to $fp-1620
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L133:
	# _tmp779 = *(_tmp777)
	lw $t0, -1616($fp)	# load _tmp777 from $fp-1616 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp780 = *(_tmp779)
	lw $t2, 0($t1) 	# load with offset
	# _tmp781 = *(_tmp780 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp779
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp782 = ACall _tmp781
	# (save modified registers before flow of control change)
	sw $t1, -1624($fp)	# spill _tmp779 from $t1 to $fp-1624
	sw $t2, -1628($fp)	# spill _tmp780 from $t2 to $fp-1628
	sw $t3, -1632($fp)	# spill _tmp781 from $t3 to $fp-1632
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp783 = _tmp782 && _tmp754
	lw $t1, -1532($fp)	# load _tmp754 from $fp-1532 into $t1
	and $t2, $t0, $t1	
	# _tmp784 = _tmp783 && _tmp726
	lw $t3, -1424($fp)	# load _tmp726 from $fp-1424 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp784 Goto _L120
	# (save modified registers before flow of control change)
	sw $t0, -1636($fp)	# spill _tmp782 from $t0 to $fp-1636
	sw $t2, -1428($fp)	# spill _tmp783 from $t2 to $fp-1428
	sw $t4, -1320($fp)	# spill _tmp784 from $t4 to $fp-1320
	beqz $t4, _L120	# branch if _tmp784 is zero 
	# _tmp785 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp785
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L121
	b _L121		# unconditional branch
_L120:
_L121:
	# _tmp786 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp787 = *(_tmp786)
	lw $t2, 0($t1) 	# load with offset
	# _tmp788 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp789 = _tmp788 < _tmp787
	slt $t4, $t3, $t2	
	# _tmp790 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp791 = _tmp790 < _tmp788
	slt $t6, $t5, $t3	
	# _tmp792 = _tmp791 && _tmp789
	and $t7, $t6, $t4	
	# IfZ _tmp792 Goto _L136
	# (save modified registers before flow of control change)
	sw $t1, -1648($fp)	# spill _tmp786 from $t1 to $fp-1648
	sw $t2, -1652($fp)	# spill _tmp787 from $t2 to $fp-1652
	sw $t3, -1660($fp)	# spill _tmp788 from $t3 to $fp-1660
	sw $t4, -1656($fp)	# spill _tmp789 from $t4 to $fp-1656
	sw $t5, -1664($fp)	# spill _tmp790 from $t5 to $fp-1664
	sw $t6, -1668($fp)	# spill _tmp791 from $t6 to $fp-1668
	sw $t7, -1672($fp)	# spill _tmp792 from $t7 to $fp-1672
	beqz $t7, _L136	# branch if _tmp792 is zero 
	# _tmp793 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp794 = _tmp788 * _tmp793
	lw $t1, -1660($fp)	# load _tmp788 from $fp-1660 into $t1
	mul $t2, $t1, $t0	
	# _tmp795 = _tmp794 + _tmp793
	add $t3, $t2, $t0	
	# _tmp796 = _tmp786 + _tmp795
	lw $t4, -1648($fp)	# load _tmp786 from $fp-1648 into $t4
	add $t5, $t4, $t3	
	# Goto _L137
	# (save modified registers before flow of control change)
	sw $t0, -1676($fp)	# spill _tmp793 from $t0 to $fp-1676
	sw $t2, -1680($fp)	# spill _tmp794 from $t2 to $fp-1680
	sw $t3, -1684($fp)	# spill _tmp795 from $t3 to $fp-1684
	sw $t5, -1684($fp)	# spill _tmp796 from $t5 to $fp-1684
	b _L137		# unconditional branch
_L136:
	# _tmp797 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string61: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string61	# load label
	# PushParam _tmp797
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1688($fp)	# spill _tmp797 from $t0 to $fp-1688
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L137:
	# _tmp798 = *(_tmp796)
	lw $t0, -1684($fp)	# load _tmp796 from $fp-1684 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp799 = *(_tmp798)
	lw $t2, 0($t1) 	# load with offset
	# _tmp800 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp801 = _tmp800 < _tmp799
	slt $t4, $t3, $t2	
	# _tmp802 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp803 = _tmp802 < _tmp800
	slt $t6, $t5, $t3	
	# _tmp804 = _tmp803 && _tmp801
	and $t7, $t6, $t4	
	# IfZ _tmp804 Goto _L138
	# (save modified registers before flow of control change)
	sw $t1, -1692($fp)	# spill _tmp798 from $t1 to $fp-1692
	sw $t2, -1696($fp)	# spill _tmp799 from $t2 to $fp-1696
	sw $t3, -1704($fp)	# spill _tmp800 from $t3 to $fp-1704
	sw $t4, -1700($fp)	# spill _tmp801 from $t4 to $fp-1700
	sw $t5, -1708($fp)	# spill _tmp802 from $t5 to $fp-1708
	sw $t6, -1712($fp)	# spill _tmp803 from $t6 to $fp-1712
	sw $t7, -1716($fp)	# spill _tmp804 from $t7 to $fp-1716
	beqz $t7, _L138	# branch if _tmp804 is zero 
	# _tmp805 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp806 = _tmp800 * _tmp805
	lw $t1, -1704($fp)	# load _tmp800 from $fp-1704 into $t1
	mul $t2, $t1, $t0	
	# _tmp807 = _tmp806 + _tmp805
	add $t3, $t2, $t0	
	# _tmp808 = _tmp798 + _tmp807
	lw $t4, -1692($fp)	# load _tmp798 from $fp-1692 into $t4
	add $t5, $t4, $t3	
	# Goto _L139
	# (save modified registers before flow of control change)
	sw $t0, -1720($fp)	# spill _tmp805 from $t0 to $fp-1720
	sw $t2, -1724($fp)	# spill _tmp806 from $t2 to $fp-1724
	sw $t3, -1728($fp)	# spill _tmp807 from $t3 to $fp-1728
	sw $t5, -1728($fp)	# spill _tmp808 from $t5 to $fp-1728
	b _L139		# unconditional branch
_L138:
	# _tmp809 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string62: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string62	# load label
	# PushParam _tmp809
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1732($fp)	# spill _tmp809 from $t0 to $fp-1732
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L139:
	# _tmp810 = *(_tmp808)
	lw $t0, -1728($fp)	# load _tmp808 from $fp-1728 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp811 = *(_tmp810)
	lw $t2, 0($t1) 	# load with offset
	# _tmp812 = *(_tmp811 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp810
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp813 = ACall _tmp812
	# (save modified registers before flow of control change)
	sw $t1, -1736($fp)	# spill _tmp810 from $t1 to $fp-1736
	sw $t2, -1740($fp)	# spill _tmp811 from $t2 to $fp-1740
	sw $t3, -1744($fp)	# spill _tmp812 from $t3 to $fp-1744
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp814 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp815 = *(_tmp814)
	lw $t3, 0($t2) 	# load with offset
	# _tmp816 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp817 = _tmp816 < _tmp815
	slt $t5, $t4, $t3	
	# _tmp818 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp819 = _tmp818 < _tmp816
	slt $t7, $t6, $t4	
	# _tmp820 = _tmp819 && _tmp817
	and $s0, $t7, $t5	
	# IfZ _tmp820 Goto _L140
	# (save modified registers before flow of control change)
	sw $t0, -1748($fp)	# spill _tmp813 from $t0 to $fp-1748
	sw $t2, -1756($fp)	# spill _tmp814 from $t2 to $fp-1756
	sw $t3, -1760($fp)	# spill _tmp815 from $t3 to $fp-1760
	sw $t4, -1768($fp)	# spill _tmp816 from $t4 to $fp-1768
	sw $t5, -1764($fp)	# spill _tmp817 from $t5 to $fp-1764
	sw $t6, -1772($fp)	# spill _tmp818 from $t6 to $fp-1772
	sw $t7, -1776($fp)	# spill _tmp819 from $t7 to $fp-1776
	sw $s0, -1780($fp)	# spill _tmp820 from $s0 to $fp-1780
	beqz $s0, _L140	# branch if _tmp820 is zero 
	# _tmp821 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp822 = _tmp816 * _tmp821
	lw $t1, -1768($fp)	# load _tmp816 from $fp-1768 into $t1
	mul $t2, $t1, $t0	
	# _tmp823 = _tmp822 + _tmp821
	add $t3, $t2, $t0	
	# _tmp824 = _tmp814 + _tmp823
	lw $t4, -1756($fp)	# load _tmp814 from $fp-1756 into $t4
	add $t5, $t4, $t3	
	# Goto _L141
	# (save modified registers before flow of control change)
	sw $t0, -1784($fp)	# spill _tmp821 from $t0 to $fp-1784
	sw $t2, -1788($fp)	# spill _tmp822 from $t2 to $fp-1788
	sw $t3, -1792($fp)	# spill _tmp823 from $t3 to $fp-1792
	sw $t5, -1792($fp)	# spill _tmp824 from $t5 to $fp-1792
	b _L141		# unconditional branch
_L140:
	# _tmp825 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string63: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string63	# load label
	# PushParam _tmp825
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1796($fp)	# spill _tmp825 from $t0 to $fp-1796
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L141:
	# _tmp826 = *(_tmp824)
	lw $t0, -1792($fp)	# load _tmp824 from $fp-1792 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp827 = *(_tmp826)
	lw $t2, 0($t1) 	# load with offset
	# _tmp828 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp829 = _tmp828 < _tmp827
	slt $t4, $t3, $t2	
	# _tmp830 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp831 = _tmp830 < _tmp828
	slt $t6, $t5, $t3	
	# _tmp832 = _tmp831 && _tmp829
	and $t7, $t6, $t4	
	# IfZ _tmp832 Goto _L142
	# (save modified registers before flow of control change)
	sw $t1, -1800($fp)	# spill _tmp826 from $t1 to $fp-1800
	sw $t2, -1804($fp)	# spill _tmp827 from $t2 to $fp-1804
	sw $t3, -1812($fp)	# spill _tmp828 from $t3 to $fp-1812
	sw $t4, -1808($fp)	# spill _tmp829 from $t4 to $fp-1808
	sw $t5, -1816($fp)	# spill _tmp830 from $t5 to $fp-1816
	sw $t6, -1820($fp)	# spill _tmp831 from $t6 to $fp-1820
	sw $t7, -1824($fp)	# spill _tmp832 from $t7 to $fp-1824
	beqz $t7, _L142	# branch if _tmp832 is zero 
	# _tmp833 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp834 = _tmp828 * _tmp833
	lw $t1, -1812($fp)	# load _tmp828 from $fp-1812 into $t1
	mul $t2, $t1, $t0	
	# _tmp835 = _tmp834 + _tmp833
	add $t3, $t2, $t0	
	# _tmp836 = _tmp826 + _tmp835
	lw $t4, -1800($fp)	# load _tmp826 from $fp-1800 into $t4
	add $t5, $t4, $t3	
	# Goto _L143
	# (save modified registers before flow of control change)
	sw $t0, -1828($fp)	# spill _tmp833 from $t0 to $fp-1828
	sw $t2, -1832($fp)	# spill _tmp834 from $t2 to $fp-1832
	sw $t3, -1836($fp)	# spill _tmp835 from $t3 to $fp-1836
	sw $t5, -1836($fp)	# spill _tmp836 from $t5 to $fp-1836
	b _L143		# unconditional branch
_L142:
	# _tmp837 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string64: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string64	# load label
	# PushParam _tmp837
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1840($fp)	# spill _tmp837 from $t0 to $fp-1840
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L143:
	# _tmp838 = *(_tmp836)
	lw $t0, -1836($fp)	# load _tmp836 from $fp-1836 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp839 = *(_tmp838)
	lw $t2, 0($t1) 	# load with offset
	# _tmp840 = *(_tmp839 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp838
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp841 = ACall _tmp840
	# (save modified registers before flow of control change)
	sw $t1, -1844($fp)	# spill _tmp838 from $t1 to $fp-1844
	sw $t2, -1848($fp)	# spill _tmp839 from $t2 to $fp-1848
	sw $t3, -1852($fp)	# spill _tmp840 from $t3 to $fp-1852
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp842 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp843 = *(_tmp842)
	lw $t3, 0($t2) 	# load with offset
	# _tmp844 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp845 = _tmp844 < _tmp843
	slt $t5, $t4, $t3	
	# _tmp846 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp847 = _tmp846 < _tmp844
	slt $t7, $t6, $t4	
	# _tmp848 = _tmp847 && _tmp845
	and $s0, $t7, $t5	
	# IfZ _tmp848 Goto _L144
	# (save modified registers before flow of control change)
	sw $t0, -1856($fp)	# spill _tmp841 from $t0 to $fp-1856
	sw $t2, -1860($fp)	# spill _tmp842 from $t2 to $fp-1860
	sw $t3, -1864($fp)	# spill _tmp843 from $t3 to $fp-1864
	sw $t4, -1872($fp)	# spill _tmp844 from $t4 to $fp-1872
	sw $t5, -1868($fp)	# spill _tmp845 from $t5 to $fp-1868
	sw $t6, -1876($fp)	# spill _tmp846 from $t6 to $fp-1876
	sw $t7, -1880($fp)	# spill _tmp847 from $t7 to $fp-1880
	sw $s0, -1884($fp)	# spill _tmp848 from $s0 to $fp-1884
	beqz $s0, _L144	# branch if _tmp848 is zero 
	# _tmp849 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp850 = _tmp844 * _tmp849
	lw $t1, -1872($fp)	# load _tmp844 from $fp-1872 into $t1
	mul $t2, $t1, $t0	
	# _tmp851 = _tmp850 + _tmp849
	add $t3, $t2, $t0	
	# _tmp852 = _tmp842 + _tmp851
	lw $t4, -1860($fp)	# load _tmp842 from $fp-1860 into $t4
	add $t5, $t4, $t3	
	# Goto _L145
	# (save modified registers before flow of control change)
	sw $t0, -1888($fp)	# spill _tmp849 from $t0 to $fp-1888
	sw $t2, -1892($fp)	# spill _tmp850 from $t2 to $fp-1892
	sw $t3, -1896($fp)	# spill _tmp851 from $t3 to $fp-1896
	sw $t5, -1896($fp)	# spill _tmp852 from $t5 to $fp-1896
	b _L145		# unconditional branch
_L144:
	# _tmp853 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string65: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string65	# load label
	# PushParam _tmp853
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1900($fp)	# spill _tmp853 from $t0 to $fp-1900
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L145:
	# _tmp854 = *(_tmp852)
	lw $t0, -1896($fp)	# load _tmp852 from $fp-1896 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp855 = *(_tmp854)
	lw $t2, 0($t1) 	# load with offset
	# _tmp856 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp857 = _tmp856 < _tmp855
	slt $t4, $t3, $t2	
	# _tmp858 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp859 = _tmp858 < _tmp856
	slt $t6, $t5, $t3	
	# _tmp860 = _tmp859 && _tmp857
	and $t7, $t6, $t4	
	# IfZ _tmp860 Goto _L146
	# (save modified registers before flow of control change)
	sw $t1, -1904($fp)	# spill _tmp854 from $t1 to $fp-1904
	sw $t2, -1908($fp)	# spill _tmp855 from $t2 to $fp-1908
	sw $t3, -1916($fp)	# spill _tmp856 from $t3 to $fp-1916
	sw $t4, -1912($fp)	# spill _tmp857 from $t4 to $fp-1912
	sw $t5, -1920($fp)	# spill _tmp858 from $t5 to $fp-1920
	sw $t6, -1924($fp)	# spill _tmp859 from $t6 to $fp-1924
	sw $t7, -1928($fp)	# spill _tmp860 from $t7 to $fp-1928
	beqz $t7, _L146	# branch if _tmp860 is zero 
	# _tmp861 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp862 = _tmp856 * _tmp861
	lw $t1, -1916($fp)	# load _tmp856 from $fp-1916 into $t1
	mul $t2, $t1, $t0	
	# _tmp863 = _tmp862 + _tmp861
	add $t3, $t2, $t0	
	# _tmp864 = _tmp854 + _tmp863
	lw $t4, -1904($fp)	# load _tmp854 from $fp-1904 into $t4
	add $t5, $t4, $t3	
	# Goto _L147
	# (save modified registers before flow of control change)
	sw $t0, -1932($fp)	# spill _tmp861 from $t0 to $fp-1932
	sw $t2, -1936($fp)	# spill _tmp862 from $t2 to $fp-1936
	sw $t3, -1940($fp)	# spill _tmp863 from $t3 to $fp-1940
	sw $t5, -1940($fp)	# spill _tmp864 from $t5 to $fp-1940
	b _L147		# unconditional branch
_L146:
	# _tmp865 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string66: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string66	# load label
	# PushParam _tmp865
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1944($fp)	# spill _tmp865 from $t0 to $fp-1944
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L147:
	# _tmp866 = *(_tmp864)
	lw $t0, -1940($fp)	# load _tmp864 from $fp-1940 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp867 = *(_tmp866)
	lw $t2, 0($t1) 	# load with offset
	# _tmp868 = *(_tmp867 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp866
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp869 = ACall _tmp868
	# (save modified registers before flow of control change)
	sw $t1, -1948($fp)	# spill _tmp866 from $t1 to $fp-1948
	sw $t2, -1952($fp)	# spill _tmp867 from $t2 to $fp-1952
	sw $t3, -1956($fp)	# spill _tmp868 from $t3 to $fp-1956
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp870 = _tmp869 && _tmp841
	lw $t1, -1856($fp)	# load _tmp841 from $fp-1856 into $t1
	and $t2, $t0, $t1	
	# _tmp871 = _tmp870 && _tmp813
	lw $t3, -1748($fp)	# load _tmp813 from $fp-1748 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp871 Goto _L134
	# (save modified registers before flow of control change)
	sw $t0, -1960($fp)	# spill _tmp869 from $t0 to $fp-1960
	sw $t2, -1752($fp)	# spill _tmp870 from $t2 to $fp-1752
	sw $t4, -1644($fp)	# spill _tmp871 from $t4 to $fp-1644
	beqz $t4, _L134	# branch if _tmp871 is zero 
	# _tmp872 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp872
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L135
	b _L135		# unconditional branch
_L134:
_L135:
	# _tmp873 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp874 = *(_tmp873)
	lw $t2, 0($t1) 	# load with offset
	# _tmp875 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp876 = _tmp875 < _tmp874
	slt $t4, $t3, $t2	
	# _tmp877 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp878 = _tmp877 < _tmp875
	slt $t6, $t5, $t3	
	# _tmp879 = _tmp878 && _tmp876
	and $t7, $t6, $t4	
	# IfZ _tmp879 Goto _L150
	# (save modified registers before flow of control change)
	sw $t1, -1972($fp)	# spill _tmp873 from $t1 to $fp-1972
	sw $t2, -1976($fp)	# spill _tmp874 from $t2 to $fp-1976
	sw $t3, -1984($fp)	# spill _tmp875 from $t3 to $fp-1984
	sw $t4, -1980($fp)	# spill _tmp876 from $t4 to $fp-1980
	sw $t5, -1988($fp)	# spill _tmp877 from $t5 to $fp-1988
	sw $t6, -1992($fp)	# spill _tmp878 from $t6 to $fp-1992
	sw $t7, -1996($fp)	# spill _tmp879 from $t7 to $fp-1996
	beqz $t7, _L150	# branch if _tmp879 is zero 
	# _tmp880 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp881 = _tmp875 * _tmp880
	lw $t1, -1984($fp)	# load _tmp875 from $fp-1984 into $t1
	mul $t2, $t1, $t0	
	# _tmp882 = _tmp881 + _tmp880
	add $t3, $t2, $t0	
	# _tmp883 = _tmp873 + _tmp882
	lw $t4, -1972($fp)	# load _tmp873 from $fp-1972 into $t4
	add $t5, $t4, $t3	
	# Goto _L151
	# (save modified registers before flow of control change)
	sw $t0, -2000($fp)	# spill _tmp880 from $t0 to $fp-2000
	sw $t2, -2004($fp)	# spill _tmp881 from $t2 to $fp-2004
	sw $t3, -2008($fp)	# spill _tmp882 from $t3 to $fp-2008
	sw $t5, -2008($fp)	# spill _tmp883 from $t5 to $fp-2008
	b _L151		# unconditional branch
_L150:
	# _tmp884 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string67: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string67	# load label
	# PushParam _tmp884
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2012($fp)	# spill _tmp884 from $t0 to $fp-2012
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L151:
	# _tmp885 = *(_tmp883)
	lw $t0, -2008($fp)	# load _tmp883 from $fp-2008 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp886 = *(_tmp885)
	lw $t2, 0($t1) 	# load with offset
	# _tmp887 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp888 = _tmp887 < _tmp886
	slt $t4, $t3, $t2	
	# _tmp889 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp890 = _tmp889 < _tmp887
	slt $t6, $t5, $t3	
	# _tmp891 = _tmp890 && _tmp888
	and $t7, $t6, $t4	
	# IfZ _tmp891 Goto _L152
	# (save modified registers before flow of control change)
	sw $t1, -2016($fp)	# spill _tmp885 from $t1 to $fp-2016
	sw $t2, -2020($fp)	# spill _tmp886 from $t2 to $fp-2020
	sw $t3, -2028($fp)	# spill _tmp887 from $t3 to $fp-2028
	sw $t4, -2024($fp)	# spill _tmp888 from $t4 to $fp-2024
	sw $t5, -2032($fp)	# spill _tmp889 from $t5 to $fp-2032
	sw $t6, -2036($fp)	# spill _tmp890 from $t6 to $fp-2036
	sw $t7, -2040($fp)	# spill _tmp891 from $t7 to $fp-2040
	beqz $t7, _L152	# branch if _tmp891 is zero 
	# _tmp892 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp893 = _tmp887 * _tmp892
	lw $t1, -2028($fp)	# load _tmp887 from $fp-2028 into $t1
	mul $t2, $t1, $t0	
	# _tmp894 = _tmp893 + _tmp892
	add $t3, $t2, $t0	
	# _tmp895 = _tmp885 + _tmp894
	lw $t4, -2016($fp)	# load _tmp885 from $fp-2016 into $t4
	add $t5, $t4, $t3	
	# Goto _L153
	# (save modified registers before flow of control change)
	sw $t0, -2044($fp)	# spill _tmp892 from $t0 to $fp-2044
	sw $t2, -2048($fp)	# spill _tmp893 from $t2 to $fp-2048
	sw $t3, -2052($fp)	# spill _tmp894 from $t3 to $fp-2052
	sw $t5, -2052($fp)	# spill _tmp895 from $t5 to $fp-2052
	b _L153		# unconditional branch
_L152:
	# _tmp896 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string68: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string68	# load label
	# PushParam _tmp896
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2056($fp)	# spill _tmp896 from $t0 to $fp-2056
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L153:
	# _tmp897 = *(_tmp895)
	lw $t0, -2052($fp)	# load _tmp895 from $fp-2052 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp898 = *(_tmp897)
	lw $t2, 0($t1) 	# load with offset
	# _tmp899 = *(_tmp898 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp897
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp900 = ACall _tmp899
	# (save modified registers before flow of control change)
	sw $t1, -2060($fp)	# spill _tmp897 from $t1 to $fp-2060
	sw $t2, -2064($fp)	# spill _tmp898 from $t2 to $fp-2064
	sw $t3, -2068($fp)	# spill _tmp899 from $t3 to $fp-2068
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp901 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp902 = *(_tmp901)
	lw $t3, 0($t2) 	# load with offset
	# _tmp903 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp904 = _tmp903 < _tmp902
	slt $t5, $t4, $t3	
	# _tmp905 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp906 = _tmp905 < _tmp903
	slt $t7, $t6, $t4	
	# _tmp907 = _tmp906 && _tmp904
	and $s0, $t7, $t5	
	# IfZ _tmp907 Goto _L154
	# (save modified registers before flow of control change)
	sw $t0, -2072($fp)	# spill _tmp900 from $t0 to $fp-2072
	sw $t2, -2080($fp)	# spill _tmp901 from $t2 to $fp-2080
	sw $t3, -2084($fp)	# spill _tmp902 from $t3 to $fp-2084
	sw $t4, -2092($fp)	# spill _tmp903 from $t4 to $fp-2092
	sw $t5, -2088($fp)	# spill _tmp904 from $t5 to $fp-2088
	sw $t6, -2096($fp)	# spill _tmp905 from $t6 to $fp-2096
	sw $t7, -2100($fp)	# spill _tmp906 from $t7 to $fp-2100
	sw $s0, -2104($fp)	# spill _tmp907 from $s0 to $fp-2104
	beqz $s0, _L154	# branch if _tmp907 is zero 
	# _tmp908 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp909 = _tmp903 * _tmp908
	lw $t1, -2092($fp)	# load _tmp903 from $fp-2092 into $t1
	mul $t2, $t1, $t0	
	# _tmp910 = _tmp909 + _tmp908
	add $t3, $t2, $t0	
	# _tmp911 = _tmp901 + _tmp910
	lw $t4, -2080($fp)	# load _tmp901 from $fp-2080 into $t4
	add $t5, $t4, $t3	
	# Goto _L155
	# (save modified registers before flow of control change)
	sw $t0, -2108($fp)	# spill _tmp908 from $t0 to $fp-2108
	sw $t2, -2112($fp)	# spill _tmp909 from $t2 to $fp-2112
	sw $t3, -2116($fp)	# spill _tmp910 from $t3 to $fp-2116
	sw $t5, -2116($fp)	# spill _tmp911 from $t5 to $fp-2116
	b _L155		# unconditional branch
_L154:
	# _tmp912 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string69: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string69	# load label
	# PushParam _tmp912
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2120($fp)	# spill _tmp912 from $t0 to $fp-2120
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L155:
	# _tmp913 = *(_tmp911)
	lw $t0, -2116($fp)	# load _tmp911 from $fp-2116 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp914 = *(_tmp913)
	lw $t2, 0($t1) 	# load with offset
	# _tmp915 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp916 = _tmp915 < _tmp914
	slt $t4, $t3, $t2	
	# _tmp917 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp918 = _tmp917 < _tmp915
	slt $t6, $t5, $t3	
	# _tmp919 = _tmp918 && _tmp916
	and $t7, $t6, $t4	
	# IfZ _tmp919 Goto _L156
	# (save modified registers before flow of control change)
	sw $t1, -2124($fp)	# spill _tmp913 from $t1 to $fp-2124
	sw $t2, -2128($fp)	# spill _tmp914 from $t2 to $fp-2128
	sw $t3, -2136($fp)	# spill _tmp915 from $t3 to $fp-2136
	sw $t4, -2132($fp)	# spill _tmp916 from $t4 to $fp-2132
	sw $t5, -2140($fp)	# spill _tmp917 from $t5 to $fp-2140
	sw $t6, -2144($fp)	# spill _tmp918 from $t6 to $fp-2144
	sw $t7, -2148($fp)	# spill _tmp919 from $t7 to $fp-2148
	beqz $t7, _L156	# branch if _tmp919 is zero 
	# _tmp920 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp921 = _tmp915 * _tmp920
	lw $t1, -2136($fp)	# load _tmp915 from $fp-2136 into $t1
	mul $t2, $t1, $t0	
	# _tmp922 = _tmp921 + _tmp920
	add $t3, $t2, $t0	
	# _tmp923 = _tmp913 + _tmp922
	lw $t4, -2124($fp)	# load _tmp913 from $fp-2124 into $t4
	add $t5, $t4, $t3	
	# Goto _L157
	# (save modified registers before flow of control change)
	sw $t0, -2152($fp)	# spill _tmp920 from $t0 to $fp-2152
	sw $t2, -2156($fp)	# spill _tmp921 from $t2 to $fp-2156
	sw $t3, -2160($fp)	# spill _tmp922 from $t3 to $fp-2160
	sw $t5, -2160($fp)	# spill _tmp923 from $t5 to $fp-2160
	b _L157		# unconditional branch
_L156:
	# _tmp924 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string70: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string70	# load label
	# PushParam _tmp924
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2164($fp)	# spill _tmp924 from $t0 to $fp-2164
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L157:
	# _tmp925 = *(_tmp923)
	lw $t0, -2160($fp)	# load _tmp923 from $fp-2160 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp926 = *(_tmp925)
	lw $t2, 0($t1) 	# load with offset
	# _tmp927 = *(_tmp926 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp925
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp928 = ACall _tmp927
	# (save modified registers before flow of control change)
	sw $t1, -2168($fp)	# spill _tmp925 from $t1 to $fp-2168
	sw $t2, -2172($fp)	# spill _tmp926 from $t2 to $fp-2172
	sw $t3, -2176($fp)	# spill _tmp927 from $t3 to $fp-2176
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp929 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp930 = *(_tmp929)
	lw $t3, 0($t2) 	# load with offset
	# _tmp931 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp932 = _tmp931 < _tmp930
	slt $t5, $t4, $t3	
	# _tmp933 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp934 = _tmp933 < _tmp931
	slt $t7, $t6, $t4	
	# _tmp935 = _tmp934 && _tmp932
	and $s0, $t7, $t5	
	# IfZ _tmp935 Goto _L158
	# (save modified registers before flow of control change)
	sw $t0, -2180($fp)	# spill _tmp928 from $t0 to $fp-2180
	sw $t2, -2184($fp)	# spill _tmp929 from $t2 to $fp-2184
	sw $t3, -2188($fp)	# spill _tmp930 from $t3 to $fp-2188
	sw $t4, -2196($fp)	# spill _tmp931 from $t4 to $fp-2196
	sw $t5, -2192($fp)	# spill _tmp932 from $t5 to $fp-2192
	sw $t6, -2200($fp)	# spill _tmp933 from $t6 to $fp-2200
	sw $t7, -2204($fp)	# spill _tmp934 from $t7 to $fp-2204
	sw $s0, -2208($fp)	# spill _tmp935 from $s0 to $fp-2208
	beqz $s0, _L158	# branch if _tmp935 is zero 
	# _tmp936 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp937 = _tmp931 * _tmp936
	lw $t1, -2196($fp)	# load _tmp931 from $fp-2196 into $t1
	mul $t2, $t1, $t0	
	# _tmp938 = _tmp937 + _tmp936
	add $t3, $t2, $t0	
	# _tmp939 = _tmp929 + _tmp938
	lw $t4, -2184($fp)	# load _tmp929 from $fp-2184 into $t4
	add $t5, $t4, $t3	
	# Goto _L159
	# (save modified registers before flow of control change)
	sw $t0, -2212($fp)	# spill _tmp936 from $t0 to $fp-2212
	sw $t2, -2216($fp)	# spill _tmp937 from $t2 to $fp-2216
	sw $t3, -2220($fp)	# spill _tmp938 from $t3 to $fp-2220
	sw $t5, -2220($fp)	# spill _tmp939 from $t5 to $fp-2220
	b _L159		# unconditional branch
_L158:
	# _tmp940 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string71: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string71	# load label
	# PushParam _tmp940
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2224($fp)	# spill _tmp940 from $t0 to $fp-2224
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L159:
	# _tmp941 = *(_tmp939)
	lw $t0, -2220($fp)	# load _tmp939 from $fp-2220 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp942 = *(_tmp941)
	lw $t2, 0($t1) 	# load with offset
	# _tmp943 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp944 = _tmp943 < _tmp942
	slt $t4, $t3, $t2	
	# _tmp945 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp946 = _tmp945 < _tmp943
	slt $t6, $t5, $t3	
	# _tmp947 = _tmp946 && _tmp944
	and $t7, $t6, $t4	
	# IfZ _tmp947 Goto _L160
	# (save modified registers before flow of control change)
	sw $t1, -2228($fp)	# spill _tmp941 from $t1 to $fp-2228
	sw $t2, -2232($fp)	# spill _tmp942 from $t2 to $fp-2232
	sw $t3, -2240($fp)	# spill _tmp943 from $t3 to $fp-2240
	sw $t4, -2236($fp)	# spill _tmp944 from $t4 to $fp-2236
	sw $t5, -2244($fp)	# spill _tmp945 from $t5 to $fp-2244
	sw $t6, -2248($fp)	# spill _tmp946 from $t6 to $fp-2248
	sw $t7, -2252($fp)	# spill _tmp947 from $t7 to $fp-2252
	beqz $t7, _L160	# branch if _tmp947 is zero 
	# _tmp948 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp949 = _tmp943 * _tmp948
	lw $t1, -2240($fp)	# load _tmp943 from $fp-2240 into $t1
	mul $t2, $t1, $t0	
	# _tmp950 = _tmp949 + _tmp948
	add $t3, $t2, $t0	
	# _tmp951 = _tmp941 + _tmp950
	lw $t4, -2228($fp)	# load _tmp941 from $fp-2228 into $t4
	add $t5, $t4, $t3	
	# Goto _L161
	# (save modified registers before flow of control change)
	sw $t0, -2256($fp)	# spill _tmp948 from $t0 to $fp-2256
	sw $t2, -2260($fp)	# spill _tmp949 from $t2 to $fp-2260
	sw $t3, -2264($fp)	# spill _tmp950 from $t3 to $fp-2264
	sw $t5, -2264($fp)	# spill _tmp951 from $t5 to $fp-2264
	b _L161		# unconditional branch
_L160:
	# _tmp952 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string72: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string72	# load label
	# PushParam _tmp952
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2268($fp)	# spill _tmp952 from $t0 to $fp-2268
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L161:
	# _tmp953 = *(_tmp951)
	lw $t0, -2264($fp)	# load _tmp951 from $fp-2264 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp954 = *(_tmp953)
	lw $t2, 0($t1) 	# load with offset
	# _tmp955 = *(_tmp954 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp953
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp956 = ACall _tmp955
	# (save modified registers before flow of control change)
	sw $t1, -2272($fp)	# spill _tmp953 from $t1 to $fp-2272
	sw $t2, -2276($fp)	# spill _tmp954 from $t2 to $fp-2276
	sw $t3, -2280($fp)	# spill _tmp955 from $t3 to $fp-2280
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp957 = _tmp956 && _tmp928
	lw $t1, -2180($fp)	# load _tmp928 from $fp-2180 into $t1
	and $t2, $t0, $t1	
	# _tmp958 = _tmp957 && _tmp900
	lw $t3, -2072($fp)	# load _tmp900 from $fp-2072 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp958 Goto _L148
	# (save modified registers before flow of control change)
	sw $t0, -2284($fp)	# spill _tmp956 from $t0 to $fp-2284
	sw $t2, -2076($fp)	# spill _tmp957 from $t2 to $fp-2076
	sw $t4, -1968($fp)	# spill _tmp958 from $t4 to $fp-1968
	beqz $t4, _L148	# branch if _tmp958 is zero 
	# _tmp959 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp959
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L149
	b _L149		# unconditional branch
_L148:
_L149:
	# _tmp960 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp961 = *(_tmp960)
	lw $t2, 0($t1) 	# load with offset
	# _tmp962 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp963 = _tmp962 < _tmp961
	slt $t4, $t3, $t2	
	# _tmp964 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp965 = _tmp964 < _tmp962
	slt $t6, $t5, $t3	
	# _tmp966 = _tmp965 && _tmp963
	and $t7, $t6, $t4	
	# IfZ _tmp966 Goto _L164
	# (save modified registers before flow of control change)
	sw $t1, -2296($fp)	# spill _tmp960 from $t1 to $fp-2296
	sw $t2, -2300($fp)	# spill _tmp961 from $t2 to $fp-2300
	sw $t3, -2308($fp)	# spill _tmp962 from $t3 to $fp-2308
	sw $t4, -2304($fp)	# spill _tmp963 from $t4 to $fp-2304
	sw $t5, -2312($fp)	# spill _tmp964 from $t5 to $fp-2312
	sw $t6, -2316($fp)	# spill _tmp965 from $t6 to $fp-2316
	sw $t7, -2320($fp)	# spill _tmp966 from $t7 to $fp-2320
	beqz $t7, _L164	# branch if _tmp966 is zero 
	# _tmp967 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp968 = _tmp962 * _tmp967
	lw $t1, -2308($fp)	# load _tmp962 from $fp-2308 into $t1
	mul $t2, $t1, $t0	
	# _tmp969 = _tmp968 + _tmp967
	add $t3, $t2, $t0	
	# _tmp970 = _tmp960 + _tmp969
	lw $t4, -2296($fp)	# load _tmp960 from $fp-2296 into $t4
	add $t5, $t4, $t3	
	# Goto _L165
	# (save modified registers before flow of control change)
	sw $t0, -2324($fp)	# spill _tmp967 from $t0 to $fp-2324
	sw $t2, -2328($fp)	# spill _tmp968 from $t2 to $fp-2328
	sw $t3, -2332($fp)	# spill _tmp969 from $t3 to $fp-2332
	sw $t5, -2332($fp)	# spill _tmp970 from $t5 to $fp-2332
	b _L165		# unconditional branch
_L164:
	# _tmp971 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string73: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string73	# load label
	# PushParam _tmp971
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2336($fp)	# spill _tmp971 from $t0 to $fp-2336
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L165:
	# _tmp972 = *(_tmp970)
	lw $t0, -2332($fp)	# load _tmp970 from $fp-2332 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp973 = *(_tmp972)
	lw $t2, 0($t1) 	# load with offset
	# _tmp974 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp975 = _tmp974 < _tmp973
	slt $t4, $t3, $t2	
	# _tmp976 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp977 = _tmp976 < _tmp974
	slt $t6, $t5, $t3	
	# _tmp978 = _tmp977 && _tmp975
	and $t7, $t6, $t4	
	# IfZ _tmp978 Goto _L166
	# (save modified registers before flow of control change)
	sw $t1, -2340($fp)	# spill _tmp972 from $t1 to $fp-2340
	sw $t2, -2344($fp)	# spill _tmp973 from $t2 to $fp-2344
	sw $t3, -2352($fp)	# spill _tmp974 from $t3 to $fp-2352
	sw $t4, -2348($fp)	# spill _tmp975 from $t4 to $fp-2348
	sw $t5, -2356($fp)	# spill _tmp976 from $t5 to $fp-2356
	sw $t6, -2360($fp)	# spill _tmp977 from $t6 to $fp-2360
	sw $t7, -2364($fp)	# spill _tmp978 from $t7 to $fp-2364
	beqz $t7, _L166	# branch if _tmp978 is zero 
	# _tmp979 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp980 = _tmp974 * _tmp979
	lw $t1, -2352($fp)	# load _tmp974 from $fp-2352 into $t1
	mul $t2, $t1, $t0	
	# _tmp981 = _tmp980 + _tmp979
	add $t3, $t2, $t0	
	# _tmp982 = _tmp972 + _tmp981
	lw $t4, -2340($fp)	# load _tmp972 from $fp-2340 into $t4
	add $t5, $t4, $t3	
	# Goto _L167
	# (save modified registers before flow of control change)
	sw $t0, -2368($fp)	# spill _tmp979 from $t0 to $fp-2368
	sw $t2, -2372($fp)	# spill _tmp980 from $t2 to $fp-2372
	sw $t3, -2376($fp)	# spill _tmp981 from $t3 to $fp-2376
	sw $t5, -2376($fp)	# spill _tmp982 from $t5 to $fp-2376
	b _L167		# unconditional branch
_L166:
	# _tmp983 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string74: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string74	# load label
	# PushParam _tmp983
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2380($fp)	# spill _tmp983 from $t0 to $fp-2380
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L167:
	# _tmp984 = *(_tmp982)
	lw $t0, -2376($fp)	# load _tmp982 from $fp-2376 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp985 = *(_tmp984)
	lw $t2, 0($t1) 	# load with offset
	# _tmp986 = *(_tmp985 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp984
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp987 = ACall _tmp986
	# (save modified registers before flow of control change)
	sw $t1, -2384($fp)	# spill _tmp984 from $t1 to $fp-2384
	sw $t2, -2388($fp)	# spill _tmp985 from $t2 to $fp-2388
	sw $t3, -2392($fp)	# spill _tmp986 from $t3 to $fp-2392
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp988 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp989 = *(_tmp988)
	lw $t3, 0($t2) 	# load with offset
	# _tmp990 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp991 = _tmp990 < _tmp989
	slt $t5, $t4, $t3	
	# _tmp992 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp993 = _tmp992 < _tmp990
	slt $t7, $t6, $t4	
	# _tmp994 = _tmp993 && _tmp991
	and $s0, $t7, $t5	
	# IfZ _tmp994 Goto _L168
	# (save modified registers before flow of control change)
	sw $t0, -2396($fp)	# spill _tmp987 from $t0 to $fp-2396
	sw $t2, -2404($fp)	# spill _tmp988 from $t2 to $fp-2404
	sw $t3, -2408($fp)	# spill _tmp989 from $t3 to $fp-2408
	sw $t4, -2416($fp)	# spill _tmp990 from $t4 to $fp-2416
	sw $t5, -2412($fp)	# spill _tmp991 from $t5 to $fp-2412
	sw $t6, -2420($fp)	# spill _tmp992 from $t6 to $fp-2420
	sw $t7, -2424($fp)	# spill _tmp993 from $t7 to $fp-2424
	sw $s0, -2428($fp)	# spill _tmp994 from $s0 to $fp-2428
	beqz $s0, _L168	# branch if _tmp994 is zero 
	# _tmp995 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp996 = _tmp990 * _tmp995
	lw $t1, -2416($fp)	# load _tmp990 from $fp-2416 into $t1
	mul $t2, $t1, $t0	
	# _tmp997 = _tmp996 + _tmp995
	add $t3, $t2, $t0	
	# _tmp998 = _tmp988 + _tmp997
	lw $t4, -2404($fp)	# load _tmp988 from $fp-2404 into $t4
	add $t5, $t4, $t3	
	# Goto _L169
	# (save modified registers before flow of control change)
	sw $t0, -2432($fp)	# spill _tmp995 from $t0 to $fp-2432
	sw $t2, -2436($fp)	# spill _tmp996 from $t2 to $fp-2436
	sw $t3, -2440($fp)	# spill _tmp997 from $t3 to $fp-2440
	sw $t5, -2440($fp)	# spill _tmp998 from $t5 to $fp-2440
	b _L169		# unconditional branch
_L168:
	# _tmp999 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string75: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string75	# load label
	# PushParam _tmp999
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2444($fp)	# spill _tmp999 from $t0 to $fp-2444
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L169:
	# _tmp1000 = *(_tmp998)
	lw $t0, -2440($fp)	# load _tmp998 from $fp-2440 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1001 = *(_tmp1000)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1002 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1003 = _tmp1002 < _tmp1001
	slt $t4, $t3, $t2	
	# _tmp1004 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1005 = _tmp1004 < _tmp1002
	slt $t6, $t5, $t3	
	# _tmp1006 = _tmp1005 && _tmp1003
	and $t7, $t6, $t4	
	# IfZ _tmp1006 Goto _L170
	# (save modified registers before flow of control change)
	sw $t1, -2448($fp)	# spill _tmp1000 from $t1 to $fp-2448
	sw $t2, -2452($fp)	# spill _tmp1001 from $t2 to $fp-2452
	sw $t3, -2460($fp)	# spill _tmp1002 from $t3 to $fp-2460
	sw $t4, -2456($fp)	# spill _tmp1003 from $t4 to $fp-2456
	sw $t5, -2464($fp)	# spill _tmp1004 from $t5 to $fp-2464
	sw $t6, -2468($fp)	# spill _tmp1005 from $t6 to $fp-2468
	sw $t7, -2472($fp)	# spill _tmp1006 from $t7 to $fp-2472
	beqz $t7, _L170	# branch if _tmp1006 is zero 
	# _tmp1007 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1008 = _tmp1002 * _tmp1007
	lw $t1, -2460($fp)	# load _tmp1002 from $fp-2460 into $t1
	mul $t2, $t1, $t0	
	# _tmp1009 = _tmp1008 + _tmp1007
	add $t3, $t2, $t0	
	# _tmp1010 = _tmp1000 + _tmp1009
	lw $t4, -2448($fp)	# load _tmp1000 from $fp-2448 into $t4
	add $t5, $t4, $t3	
	# Goto _L171
	# (save modified registers before flow of control change)
	sw $t0, -2476($fp)	# spill _tmp1007 from $t0 to $fp-2476
	sw $t2, -2480($fp)	# spill _tmp1008 from $t2 to $fp-2480
	sw $t3, -2484($fp)	# spill _tmp1009 from $t3 to $fp-2484
	sw $t5, -2484($fp)	# spill _tmp1010 from $t5 to $fp-2484
	b _L171		# unconditional branch
_L170:
	# _tmp1011 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string76: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string76	# load label
	# PushParam _tmp1011
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2488($fp)	# spill _tmp1011 from $t0 to $fp-2488
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L171:
	# _tmp1012 = *(_tmp1010)
	lw $t0, -2484($fp)	# load _tmp1010 from $fp-2484 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1013 = *(_tmp1012)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1014 = *(_tmp1013 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1012
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1015 = ACall _tmp1014
	# (save modified registers before flow of control change)
	sw $t1, -2492($fp)	# spill _tmp1012 from $t1 to $fp-2492
	sw $t2, -2496($fp)	# spill _tmp1013 from $t2 to $fp-2496
	sw $t3, -2500($fp)	# spill _tmp1014 from $t3 to $fp-2500
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1016 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1017 = *(_tmp1016)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1018 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1019 = _tmp1018 < _tmp1017
	slt $t5, $t4, $t3	
	# _tmp1020 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1021 = _tmp1020 < _tmp1018
	slt $t7, $t6, $t4	
	# _tmp1022 = _tmp1021 && _tmp1019
	and $s0, $t7, $t5	
	# IfZ _tmp1022 Goto _L172
	# (save modified registers before flow of control change)
	sw $t0, -2504($fp)	# spill _tmp1015 from $t0 to $fp-2504
	sw $t2, -2508($fp)	# spill _tmp1016 from $t2 to $fp-2508
	sw $t3, -2512($fp)	# spill _tmp1017 from $t3 to $fp-2512
	sw $t4, -2520($fp)	# spill _tmp1018 from $t4 to $fp-2520
	sw $t5, -2516($fp)	# spill _tmp1019 from $t5 to $fp-2516
	sw $t6, -2524($fp)	# spill _tmp1020 from $t6 to $fp-2524
	sw $t7, -2528($fp)	# spill _tmp1021 from $t7 to $fp-2528
	sw $s0, -2532($fp)	# spill _tmp1022 from $s0 to $fp-2532
	beqz $s0, _L172	# branch if _tmp1022 is zero 
	# _tmp1023 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1024 = _tmp1018 * _tmp1023
	lw $t1, -2520($fp)	# load _tmp1018 from $fp-2520 into $t1
	mul $t2, $t1, $t0	
	# _tmp1025 = _tmp1024 + _tmp1023
	add $t3, $t2, $t0	
	# _tmp1026 = _tmp1016 + _tmp1025
	lw $t4, -2508($fp)	# load _tmp1016 from $fp-2508 into $t4
	add $t5, $t4, $t3	
	# Goto _L173
	# (save modified registers before flow of control change)
	sw $t0, -2536($fp)	# spill _tmp1023 from $t0 to $fp-2536
	sw $t2, -2540($fp)	# spill _tmp1024 from $t2 to $fp-2540
	sw $t3, -2544($fp)	# spill _tmp1025 from $t3 to $fp-2544
	sw $t5, -2544($fp)	# spill _tmp1026 from $t5 to $fp-2544
	b _L173		# unconditional branch
_L172:
	# _tmp1027 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string77: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string77	# load label
	# PushParam _tmp1027
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2548($fp)	# spill _tmp1027 from $t0 to $fp-2548
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L173:
	# _tmp1028 = *(_tmp1026)
	lw $t0, -2544($fp)	# load _tmp1026 from $fp-2544 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1029 = *(_tmp1028)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1030 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1031 = _tmp1030 < _tmp1029
	slt $t4, $t3, $t2	
	# _tmp1032 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1033 = _tmp1032 < _tmp1030
	slt $t6, $t5, $t3	
	# _tmp1034 = _tmp1033 && _tmp1031
	and $t7, $t6, $t4	
	# IfZ _tmp1034 Goto _L174
	# (save modified registers before flow of control change)
	sw $t1, -2552($fp)	# spill _tmp1028 from $t1 to $fp-2552
	sw $t2, -2556($fp)	# spill _tmp1029 from $t2 to $fp-2556
	sw $t3, -2564($fp)	# spill _tmp1030 from $t3 to $fp-2564
	sw $t4, -2560($fp)	# spill _tmp1031 from $t4 to $fp-2560
	sw $t5, -2568($fp)	# spill _tmp1032 from $t5 to $fp-2568
	sw $t6, -2572($fp)	# spill _tmp1033 from $t6 to $fp-2572
	sw $t7, -2576($fp)	# spill _tmp1034 from $t7 to $fp-2576
	beqz $t7, _L174	# branch if _tmp1034 is zero 
	# _tmp1035 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1036 = _tmp1030 * _tmp1035
	lw $t1, -2564($fp)	# load _tmp1030 from $fp-2564 into $t1
	mul $t2, $t1, $t0	
	# _tmp1037 = _tmp1036 + _tmp1035
	add $t3, $t2, $t0	
	# _tmp1038 = _tmp1028 + _tmp1037
	lw $t4, -2552($fp)	# load _tmp1028 from $fp-2552 into $t4
	add $t5, $t4, $t3	
	# Goto _L175
	# (save modified registers before flow of control change)
	sw $t0, -2580($fp)	# spill _tmp1035 from $t0 to $fp-2580
	sw $t2, -2584($fp)	# spill _tmp1036 from $t2 to $fp-2584
	sw $t3, -2588($fp)	# spill _tmp1037 from $t3 to $fp-2588
	sw $t5, -2588($fp)	# spill _tmp1038 from $t5 to $fp-2588
	b _L175		# unconditional branch
_L174:
	# _tmp1039 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string78: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string78	# load label
	# PushParam _tmp1039
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2592($fp)	# spill _tmp1039 from $t0 to $fp-2592
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L175:
	# _tmp1040 = *(_tmp1038)
	lw $t0, -2588($fp)	# load _tmp1038 from $fp-2588 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1041 = *(_tmp1040)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1042 = *(_tmp1041 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam mark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load mark from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1040
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1043 = ACall _tmp1042
	# (save modified registers before flow of control change)
	sw $t1, -2596($fp)	# spill _tmp1040 from $t1 to $fp-2596
	sw $t2, -2600($fp)	# spill _tmp1041 from $t2 to $fp-2600
	sw $t3, -2604($fp)	# spill _tmp1042 from $t3 to $fp-2604
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1044 = _tmp1043 && _tmp1015
	lw $t1, -2504($fp)	# load _tmp1015 from $fp-2504 into $t1
	and $t2, $t0, $t1	
	# _tmp1045 = _tmp1044 && _tmp987
	lw $t3, -2396($fp)	# load _tmp987 from $fp-2396 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1045 Goto _L162
	# (save modified registers before flow of control change)
	sw $t0, -2608($fp)	# spill _tmp1043 from $t0 to $fp-2608
	sw $t2, -2400($fp)	# spill _tmp1044 from $t2 to $fp-2400
	sw $t4, -2292($fp)	# spill _tmp1045 from $t4 to $fp-2292
	beqz $t4, _L162	# branch if _tmp1045 is zero 
	# _tmp1046 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp1046
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L163
	b _L163		# unconditional branch
_L162:
	# _tmp1047 = 1
	li $t0, 1		# load constant value 1 into $t0
	# Return _tmp1047
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
_L163:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Grid.BlockedPlay:
	# BeginFunc 5448
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 5448	# decrement sp to make space for locals/temps
	# _tmp1048 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp1049 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp1050 = _tmp1048 - _tmp1049
	sub $t2, $t0, $t1	
	# row = _tmp1050
	move $t3, $t2		# copy value
	# _tmp1051 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1052 = 1
	li $t5, 1		# load constant value 1 into $t5
	# _tmp1053 = _tmp1051 - _tmp1052
	sub $t6, $t4, $t5	
	# column = _tmp1053
	move $t7, $t6		# copy value
	# _tmp1054 = 1
	li $s0, 1		# load constant value 1 into $s0
	# _tmp1055 = *(this + 4)
	lw $s1, 4($fp)	# load this from $fp+4 into $s1
	lw $s2, 4($s1) 	# load with offset
	# _tmp1056 = *(_tmp1055)
	lw $s3, 0($s2) 	# load with offset
	# _tmp1057 = 0
	li $s4, 0		# load constant value 0 into $s4
	# _tmp1058 = _tmp1057 < _tmp1056
	slt $s5, $s4, $s3	
	# _tmp1059 = -1
	li $s6, -1		# load constant value -1 into $s6
	# _tmp1060 = _tmp1059 < _tmp1057
	slt $s7, $s6, $s4	
	# _tmp1061 = _tmp1060 && _tmp1058
	and $t8, $s7, $s5	
	# IfZ _tmp1061 Goto _L178
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp1048 from $t0 to $fp-16
	sw $t1, -24($fp)	# spill _tmp1049 from $t1 to $fp-24
	sw $t2, -20($fp)	# spill _tmp1050 from $t2 to $fp-20
	sw $t3, -8($fp)	# spill row from $t3 to $fp-8
	sw $t4, -28($fp)	# spill _tmp1051 from $t4 to $fp-28
	sw $t5, -36($fp)	# spill _tmp1052 from $t5 to $fp-36
	sw $t6, -32($fp)	# spill _tmp1053 from $t6 to $fp-32
	sw $t7, -12($fp)	# spill column from $t7 to $fp-12
	sw $s0, -44($fp)	# spill _tmp1054 from $s0 to $fp-44
	sw $s2, -52($fp)	# spill _tmp1055 from $s2 to $fp-52
	sw $s3, -56($fp)	# spill _tmp1056 from $s3 to $fp-56
	sw $s4, -64($fp)	# spill _tmp1057 from $s4 to $fp-64
	sw $s5, -60($fp)	# spill _tmp1058 from $s5 to $fp-60
	sw $s6, -68($fp)	# spill _tmp1059 from $s6 to $fp-68
	sw $s7, -72($fp)	# spill _tmp1060 from $s7 to $fp-72
	sw $t8, -76($fp)	# spill _tmp1061 from $t8 to $fp-76
	beqz $t8, _L178	# branch if _tmp1061 is zero 
	# _tmp1062 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1063 = _tmp1057 * _tmp1062
	lw $t1, -64($fp)	# load _tmp1057 from $fp-64 into $t1
	mul $t2, $t1, $t0	
	# _tmp1064 = _tmp1063 + _tmp1062
	add $t3, $t2, $t0	
	# _tmp1065 = _tmp1055 + _tmp1064
	lw $t4, -52($fp)	# load _tmp1055 from $fp-52 into $t4
	add $t5, $t4, $t3	
	# Goto _L179
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp1062 from $t0 to $fp-80
	sw $t2, -84($fp)	# spill _tmp1063 from $t2 to $fp-84
	sw $t3, -88($fp)	# spill _tmp1064 from $t3 to $fp-88
	sw $t5, -88($fp)	# spill _tmp1065 from $t5 to $fp-88
	b _L179		# unconditional branch
_L178:
	# _tmp1066 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string79: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string79	# load label
	# PushParam _tmp1066
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp1066 from $t0 to $fp-92
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L179:
	# _tmp1067 = *(_tmp1065)
	lw $t0, -88($fp)	# load _tmp1065 from $fp-88 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1068 = *(_tmp1067)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1069 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1070 = _tmp1069 < _tmp1068
	slt $t4, $t3, $t2	
	# _tmp1071 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1072 = _tmp1071 < _tmp1069
	slt $t6, $t5, $t3	
	# _tmp1073 = _tmp1072 && _tmp1070
	and $t7, $t6, $t4	
	# IfZ _tmp1073 Goto _L180
	# (save modified registers before flow of control change)
	sw $t1, -96($fp)	# spill _tmp1067 from $t1 to $fp-96
	sw $t2, -100($fp)	# spill _tmp1068 from $t2 to $fp-100
	sw $t3, -108($fp)	# spill _tmp1069 from $t3 to $fp-108
	sw $t4, -104($fp)	# spill _tmp1070 from $t4 to $fp-104
	sw $t5, -112($fp)	# spill _tmp1071 from $t5 to $fp-112
	sw $t6, -116($fp)	# spill _tmp1072 from $t6 to $fp-116
	sw $t7, -120($fp)	# spill _tmp1073 from $t7 to $fp-120
	beqz $t7, _L180	# branch if _tmp1073 is zero 
	# _tmp1074 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1075 = _tmp1069 * _tmp1074
	lw $t1, -108($fp)	# load _tmp1069 from $fp-108 into $t1
	mul $t2, $t1, $t0	
	# _tmp1076 = _tmp1075 + _tmp1074
	add $t3, $t2, $t0	
	# _tmp1077 = _tmp1067 + _tmp1076
	lw $t4, -96($fp)	# load _tmp1067 from $fp-96 into $t4
	add $t5, $t4, $t3	
	# Goto _L181
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp1074 from $t0 to $fp-124
	sw $t2, -128($fp)	# spill _tmp1075 from $t2 to $fp-128
	sw $t3, -132($fp)	# spill _tmp1076 from $t3 to $fp-132
	sw $t5, -132($fp)	# spill _tmp1077 from $t5 to $fp-132
	b _L181		# unconditional branch
_L180:
	# _tmp1078 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string80: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string80	# load label
	# PushParam _tmp1078
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -136($fp)	# spill _tmp1078 from $t0 to $fp-136
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L181:
	# _tmp1079 = *(_tmp1077)
	lw $t0, -132($fp)	# load _tmp1077 from $fp-132 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1080 = *(_tmp1079)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1081 = *(_tmp1080 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1079
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1082 = ACall _tmp1081
	# (save modified registers before flow of control change)
	sw $t1, -140($fp)	# spill _tmp1079 from $t1 to $fp-140
	sw $t2, -144($fp)	# spill _tmp1080 from $t2 to $fp-144
	sw $t3, -148($fp)	# spill _tmp1081 from $t3 to $fp-148
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1083 = _tmp1054 - _tmp1082
	lw $t1, -44($fp)	# load _tmp1054 from $fp-44 into $t1
	sub $t2, $t1, $t0	
	# _tmp1084 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1085 = *(_tmp1084)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1086 = 0
	li $t6, 0		# load constant value 0 into $t6
	# _tmp1087 = _tmp1086 < _tmp1085
	slt $t7, $t6, $t5	
	# _tmp1088 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1089 = _tmp1088 < _tmp1086
	slt $s1, $s0, $t6	
	# _tmp1090 = _tmp1089 && _tmp1087
	and $s2, $s1, $t7	
	# IfZ _tmp1090 Goto _L182
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp1082 from $t0 to $fp-152
	sw $t2, -48($fp)	# spill _tmp1083 from $t2 to $fp-48
	sw $t4, -160($fp)	# spill _tmp1084 from $t4 to $fp-160
	sw $t5, -164($fp)	# spill _tmp1085 from $t5 to $fp-164
	sw $t6, -172($fp)	# spill _tmp1086 from $t6 to $fp-172
	sw $t7, -168($fp)	# spill _tmp1087 from $t7 to $fp-168
	sw $s0, -176($fp)	# spill _tmp1088 from $s0 to $fp-176
	sw $s1, -180($fp)	# spill _tmp1089 from $s1 to $fp-180
	sw $s2, -184($fp)	# spill _tmp1090 from $s2 to $fp-184
	beqz $s2, _L182	# branch if _tmp1090 is zero 
	# _tmp1091 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1092 = _tmp1086 * _tmp1091
	lw $t1, -172($fp)	# load _tmp1086 from $fp-172 into $t1
	mul $t2, $t1, $t0	
	# _tmp1093 = _tmp1092 + _tmp1091
	add $t3, $t2, $t0	
	# _tmp1094 = _tmp1084 + _tmp1093
	lw $t4, -160($fp)	# load _tmp1084 from $fp-160 into $t4
	add $t5, $t4, $t3	
	# Goto _L183
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp1091 from $t0 to $fp-188
	sw $t2, -192($fp)	# spill _tmp1092 from $t2 to $fp-192
	sw $t3, -196($fp)	# spill _tmp1093 from $t3 to $fp-196
	sw $t5, -196($fp)	# spill _tmp1094 from $t5 to $fp-196
	b _L183		# unconditional branch
_L182:
	# _tmp1095 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string81: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string81	# load label
	# PushParam _tmp1095
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -200($fp)	# spill _tmp1095 from $t0 to $fp-200
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L183:
	# _tmp1096 = *(_tmp1094)
	lw $t0, -196($fp)	# load _tmp1094 from $fp-196 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1097 = *(_tmp1096)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1098 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1099 = _tmp1098 < _tmp1097
	slt $t4, $t3, $t2	
	# _tmp1100 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1101 = _tmp1100 < _tmp1098
	slt $t6, $t5, $t3	
	# _tmp1102 = _tmp1101 && _tmp1099
	and $t7, $t6, $t4	
	# IfZ _tmp1102 Goto _L184
	# (save modified registers before flow of control change)
	sw $t1, -204($fp)	# spill _tmp1096 from $t1 to $fp-204
	sw $t2, -208($fp)	# spill _tmp1097 from $t2 to $fp-208
	sw $t3, -216($fp)	# spill _tmp1098 from $t3 to $fp-216
	sw $t4, -212($fp)	# spill _tmp1099 from $t4 to $fp-212
	sw $t5, -220($fp)	# spill _tmp1100 from $t5 to $fp-220
	sw $t6, -224($fp)	# spill _tmp1101 from $t6 to $fp-224
	sw $t7, -228($fp)	# spill _tmp1102 from $t7 to $fp-228
	beqz $t7, _L184	# branch if _tmp1102 is zero 
	# _tmp1103 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1104 = _tmp1098 * _tmp1103
	lw $t1, -216($fp)	# load _tmp1098 from $fp-216 into $t1
	mul $t2, $t1, $t0	
	# _tmp1105 = _tmp1104 + _tmp1103
	add $t3, $t2, $t0	
	# _tmp1106 = _tmp1096 + _tmp1105
	lw $t4, -204($fp)	# load _tmp1096 from $fp-204 into $t4
	add $t5, $t4, $t3	
	# Goto _L185
	# (save modified registers before flow of control change)
	sw $t0, -232($fp)	# spill _tmp1103 from $t0 to $fp-232
	sw $t2, -236($fp)	# spill _tmp1104 from $t2 to $fp-236
	sw $t3, -240($fp)	# spill _tmp1105 from $t3 to $fp-240
	sw $t5, -240($fp)	# spill _tmp1106 from $t5 to $fp-240
	b _L185		# unconditional branch
_L184:
	# _tmp1107 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string82: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string82	# load label
	# PushParam _tmp1107
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -244($fp)	# spill _tmp1107 from $t0 to $fp-244
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L185:
	# _tmp1108 = *(_tmp1106)
	lw $t0, -240($fp)	# load _tmp1106 from $fp-240 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1109 = *(_tmp1108)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1110 = *(_tmp1109 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1108
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1111 = ACall _tmp1110
	# (save modified registers before flow of control change)
	sw $t1, -248($fp)	# spill _tmp1108 from $t1 to $fp-248
	sw $t2, -252($fp)	# spill _tmp1109 from $t2 to $fp-252
	sw $t3, -256($fp)	# spill _tmp1110 from $t3 to $fp-256
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1112 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1113 = *(_tmp1112)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1114 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1115 = _tmp1114 < _tmp1113
	slt $t5, $t4, $t3	
	# _tmp1116 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1117 = _tmp1116 < _tmp1114
	slt $t7, $t6, $t4	
	# _tmp1118 = _tmp1117 && _tmp1115
	and $s0, $t7, $t5	
	# IfZ _tmp1118 Goto _L186
	# (save modified registers before flow of control change)
	sw $t0, -260($fp)	# spill _tmp1111 from $t0 to $fp-260
	sw $t2, -264($fp)	# spill _tmp1112 from $t2 to $fp-264
	sw $t3, -268($fp)	# spill _tmp1113 from $t3 to $fp-268
	sw $t4, -276($fp)	# spill _tmp1114 from $t4 to $fp-276
	sw $t5, -272($fp)	# spill _tmp1115 from $t5 to $fp-272
	sw $t6, -280($fp)	# spill _tmp1116 from $t6 to $fp-280
	sw $t7, -284($fp)	# spill _tmp1117 from $t7 to $fp-284
	sw $s0, -288($fp)	# spill _tmp1118 from $s0 to $fp-288
	beqz $s0, _L186	# branch if _tmp1118 is zero 
	# _tmp1119 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1120 = _tmp1114 * _tmp1119
	lw $t1, -276($fp)	# load _tmp1114 from $fp-276 into $t1
	mul $t2, $t1, $t0	
	# _tmp1121 = _tmp1120 + _tmp1119
	add $t3, $t2, $t0	
	# _tmp1122 = _tmp1112 + _tmp1121
	lw $t4, -264($fp)	# load _tmp1112 from $fp-264 into $t4
	add $t5, $t4, $t3	
	# Goto _L187
	# (save modified registers before flow of control change)
	sw $t0, -292($fp)	# spill _tmp1119 from $t0 to $fp-292
	sw $t2, -296($fp)	# spill _tmp1120 from $t2 to $fp-296
	sw $t3, -300($fp)	# spill _tmp1121 from $t3 to $fp-300
	sw $t5, -300($fp)	# spill _tmp1122 from $t5 to $fp-300
	b _L187		# unconditional branch
_L186:
	# _tmp1123 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string83: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string83	# load label
	# PushParam _tmp1123
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -304($fp)	# spill _tmp1123 from $t0 to $fp-304
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L187:
	# _tmp1124 = *(_tmp1122)
	lw $t0, -300($fp)	# load _tmp1122 from $fp-300 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1125 = *(_tmp1124)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1126 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1127 = _tmp1126 < _tmp1125
	slt $t4, $t3, $t2	
	# _tmp1128 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1129 = _tmp1128 < _tmp1126
	slt $t6, $t5, $t3	
	# _tmp1130 = _tmp1129 && _tmp1127
	and $t7, $t6, $t4	
	# IfZ _tmp1130 Goto _L188
	# (save modified registers before flow of control change)
	sw $t1, -308($fp)	# spill _tmp1124 from $t1 to $fp-308
	sw $t2, -312($fp)	# spill _tmp1125 from $t2 to $fp-312
	sw $t3, -320($fp)	# spill _tmp1126 from $t3 to $fp-320
	sw $t4, -316($fp)	# spill _tmp1127 from $t4 to $fp-316
	sw $t5, -324($fp)	# spill _tmp1128 from $t5 to $fp-324
	sw $t6, -328($fp)	# spill _tmp1129 from $t6 to $fp-328
	sw $t7, -332($fp)	# spill _tmp1130 from $t7 to $fp-332
	beqz $t7, _L188	# branch if _tmp1130 is zero 
	# _tmp1131 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1132 = _tmp1126 * _tmp1131
	lw $t1, -320($fp)	# load _tmp1126 from $fp-320 into $t1
	mul $t2, $t1, $t0	
	# _tmp1133 = _tmp1132 + _tmp1131
	add $t3, $t2, $t0	
	# _tmp1134 = _tmp1124 + _tmp1133
	lw $t4, -308($fp)	# load _tmp1124 from $fp-308 into $t4
	add $t5, $t4, $t3	
	# Goto _L189
	# (save modified registers before flow of control change)
	sw $t0, -336($fp)	# spill _tmp1131 from $t0 to $fp-336
	sw $t2, -340($fp)	# spill _tmp1132 from $t2 to $fp-340
	sw $t3, -344($fp)	# spill _tmp1133 from $t3 to $fp-344
	sw $t5, -344($fp)	# spill _tmp1134 from $t5 to $fp-344
	b _L189		# unconditional branch
_L188:
	# _tmp1135 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string84: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string84	# load label
	# PushParam _tmp1135
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -348($fp)	# spill _tmp1135 from $t0 to $fp-348
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L189:
	# _tmp1136 = *(_tmp1134)
	lw $t0, -344($fp)	# load _tmp1134 from $fp-344 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1137 = *(_tmp1136)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1138 = *(_tmp1137 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1136
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1139 = ACall _tmp1138
	# (save modified registers before flow of control change)
	sw $t1, -352($fp)	# spill _tmp1136 from $t1 to $fp-352
	sw $t2, -356($fp)	# spill _tmp1137 from $t2 to $fp-356
	sw $t3, -360($fp)	# spill _tmp1138 from $t3 to $fp-360
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1140 = _tmp1139 && _tmp1111
	lw $t1, -260($fp)	# load _tmp1111 from $fp-260 into $t1
	and $t2, $t0, $t1	
	# _tmp1141 = _tmp1140 && _tmp1083
	lw $t3, -48($fp)	# load _tmp1083 from $fp-48 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1141 Goto _L176
	# (save modified registers before flow of control change)
	sw $t0, -364($fp)	# spill _tmp1139 from $t0 to $fp-364
	sw $t2, -156($fp)	# spill _tmp1140 from $t2 to $fp-156
	sw $t4, -40($fp)	# spill _tmp1141 from $t4 to $fp-40
	beqz $t4, _L176	# branch if _tmp1141 is zero 
	# _tmp1142 = 0
	li $t0, 0		# load constant value 0 into $t0
	# row = _tmp1142
	move $t1, $t0		# copy value
	# _tmp1143 = 2
	li $t2, 2		# load constant value 2 into $t2
	# column = _tmp1143
	move $t3, $t2		# copy value
	# Goto _L177
	# (save modified registers before flow of control change)
	sw $t0, -368($fp)	# spill _tmp1142 from $t0 to $fp-368
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -372($fp)	# spill _tmp1143 from $t2 to $fp-372
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L177		# unconditional branch
_L176:
	# _tmp1144 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1145 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1146 = *(_tmp1145)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1147 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp1148 = _tmp1147 < _tmp1146
	slt $t5, $t4, $t3	
	# _tmp1149 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1150 = _tmp1149 < _tmp1147
	slt $t7, $t6, $t4	
	# _tmp1151 = _tmp1150 && _tmp1148
	and $s0, $t7, $t5	
	# IfZ _tmp1151 Goto _L192
	# (save modified registers before flow of control change)
	sw $t0, -380($fp)	# spill _tmp1144 from $t0 to $fp-380
	sw $t2, -388($fp)	# spill _tmp1145 from $t2 to $fp-388
	sw $t3, -392($fp)	# spill _tmp1146 from $t3 to $fp-392
	sw $t4, -400($fp)	# spill _tmp1147 from $t4 to $fp-400
	sw $t5, -396($fp)	# spill _tmp1148 from $t5 to $fp-396
	sw $t6, -404($fp)	# spill _tmp1149 from $t6 to $fp-404
	sw $t7, -408($fp)	# spill _tmp1150 from $t7 to $fp-408
	sw $s0, -412($fp)	# spill _tmp1151 from $s0 to $fp-412
	beqz $s0, _L192	# branch if _tmp1151 is zero 
	# _tmp1152 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1153 = _tmp1147 * _tmp1152
	lw $t1, -400($fp)	# load _tmp1147 from $fp-400 into $t1
	mul $t2, $t1, $t0	
	# _tmp1154 = _tmp1153 + _tmp1152
	add $t3, $t2, $t0	
	# _tmp1155 = _tmp1145 + _tmp1154
	lw $t4, -388($fp)	# load _tmp1145 from $fp-388 into $t4
	add $t5, $t4, $t3	
	# Goto _L193
	# (save modified registers before flow of control change)
	sw $t0, -416($fp)	# spill _tmp1152 from $t0 to $fp-416
	sw $t2, -420($fp)	# spill _tmp1153 from $t2 to $fp-420
	sw $t3, -424($fp)	# spill _tmp1154 from $t3 to $fp-424
	sw $t5, -424($fp)	# spill _tmp1155 from $t5 to $fp-424
	b _L193		# unconditional branch
_L192:
	# _tmp1156 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string85: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string85	# load label
	# PushParam _tmp1156
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -428($fp)	# spill _tmp1156 from $t0 to $fp-428
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L193:
	# _tmp1157 = *(_tmp1155)
	lw $t0, -424($fp)	# load _tmp1155 from $fp-424 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1158 = *(_tmp1157)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1159 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1160 = _tmp1159 < _tmp1158
	slt $t4, $t3, $t2	
	# _tmp1161 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1162 = _tmp1161 < _tmp1159
	slt $t6, $t5, $t3	
	# _tmp1163 = _tmp1162 && _tmp1160
	and $t7, $t6, $t4	
	# IfZ _tmp1163 Goto _L194
	# (save modified registers before flow of control change)
	sw $t1, -432($fp)	# spill _tmp1157 from $t1 to $fp-432
	sw $t2, -436($fp)	# spill _tmp1158 from $t2 to $fp-436
	sw $t3, -444($fp)	# spill _tmp1159 from $t3 to $fp-444
	sw $t4, -440($fp)	# spill _tmp1160 from $t4 to $fp-440
	sw $t5, -448($fp)	# spill _tmp1161 from $t5 to $fp-448
	sw $t6, -452($fp)	# spill _tmp1162 from $t6 to $fp-452
	sw $t7, -456($fp)	# spill _tmp1163 from $t7 to $fp-456
	beqz $t7, _L194	# branch if _tmp1163 is zero 
	# _tmp1164 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1165 = _tmp1159 * _tmp1164
	lw $t1, -444($fp)	# load _tmp1159 from $fp-444 into $t1
	mul $t2, $t1, $t0	
	# _tmp1166 = _tmp1165 + _tmp1164
	add $t3, $t2, $t0	
	# _tmp1167 = _tmp1157 + _tmp1166
	lw $t4, -432($fp)	# load _tmp1157 from $fp-432 into $t4
	add $t5, $t4, $t3	
	# Goto _L195
	# (save modified registers before flow of control change)
	sw $t0, -460($fp)	# spill _tmp1164 from $t0 to $fp-460
	sw $t2, -464($fp)	# spill _tmp1165 from $t2 to $fp-464
	sw $t3, -468($fp)	# spill _tmp1166 from $t3 to $fp-468
	sw $t5, -468($fp)	# spill _tmp1167 from $t5 to $fp-468
	b _L195		# unconditional branch
_L194:
	# _tmp1168 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string86: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string86	# load label
	# PushParam _tmp1168
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -472($fp)	# spill _tmp1168 from $t0 to $fp-472
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L195:
	# _tmp1169 = *(_tmp1167)
	lw $t0, -468($fp)	# load _tmp1167 from $fp-468 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1170 = *(_tmp1169)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1171 = *(_tmp1170 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1169
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1172 = ACall _tmp1171
	# (save modified registers before flow of control change)
	sw $t1, -476($fp)	# spill _tmp1169 from $t1 to $fp-476
	sw $t2, -480($fp)	# spill _tmp1170 from $t2 to $fp-480
	sw $t3, -484($fp)	# spill _tmp1171 from $t3 to $fp-484
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1173 = _tmp1144 - _tmp1172
	lw $t1, -380($fp)	# load _tmp1144 from $fp-380 into $t1
	sub $t2, $t1, $t0	
	# _tmp1174 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1175 = *(_tmp1174)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1176 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp1177 = _tmp1176 < _tmp1175
	slt $t7, $t6, $t5	
	# _tmp1178 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1179 = _tmp1178 < _tmp1176
	slt $s1, $s0, $t6	
	# _tmp1180 = _tmp1179 && _tmp1177
	and $s2, $s1, $t7	
	# IfZ _tmp1180 Goto _L196
	# (save modified registers before flow of control change)
	sw $t0, -488($fp)	# spill _tmp1172 from $t0 to $fp-488
	sw $t2, -384($fp)	# spill _tmp1173 from $t2 to $fp-384
	sw $t4, -496($fp)	# spill _tmp1174 from $t4 to $fp-496
	sw $t5, -500($fp)	# spill _tmp1175 from $t5 to $fp-500
	sw $t6, -508($fp)	# spill _tmp1176 from $t6 to $fp-508
	sw $t7, -504($fp)	# spill _tmp1177 from $t7 to $fp-504
	sw $s0, -512($fp)	# spill _tmp1178 from $s0 to $fp-512
	sw $s1, -516($fp)	# spill _tmp1179 from $s1 to $fp-516
	sw $s2, -520($fp)	# spill _tmp1180 from $s2 to $fp-520
	beqz $s2, _L196	# branch if _tmp1180 is zero 
	# _tmp1181 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1182 = _tmp1176 * _tmp1181
	lw $t1, -508($fp)	# load _tmp1176 from $fp-508 into $t1
	mul $t2, $t1, $t0	
	# _tmp1183 = _tmp1182 + _tmp1181
	add $t3, $t2, $t0	
	# _tmp1184 = _tmp1174 + _tmp1183
	lw $t4, -496($fp)	# load _tmp1174 from $fp-496 into $t4
	add $t5, $t4, $t3	
	# Goto _L197
	# (save modified registers before flow of control change)
	sw $t0, -524($fp)	# spill _tmp1181 from $t0 to $fp-524
	sw $t2, -528($fp)	# spill _tmp1182 from $t2 to $fp-528
	sw $t3, -532($fp)	# spill _tmp1183 from $t3 to $fp-532
	sw $t5, -532($fp)	# spill _tmp1184 from $t5 to $fp-532
	b _L197		# unconditional branch
_L196:
	# _tmp1185 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string87: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string87	# load label
	# PushParam _tmp1185
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -536($fp)	# spill _tmp1185 from $t0 to $fp-536
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L197:
	# _tmp1186 = *(_tmp1184)
	lw $t0, -532($fp)	# load _tmp1184 from $fp-532 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1187 = *(_tmp1186)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1188 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1189 = _tmp1188 < _tmp1187
	slt $t4, $t3, $t2	
	# _tmp1190 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1191 = _tmp1190 < _tmp1188
	slt $t6, $t5, $t3	
	# _tmp1192 = _tmp1191 && _tmp1189
	and $t7, $t6, $t4	
	# IfZ _tmp1192 Goto _L198
	# (save modified registers before flow of control change)
	sw $t1, -540($fp)	# spill _tmp1186 from $t1 to $fp-540
	sw $t2, -544($fp)	# spill _tmp1187 from $t2 to $fp-544
	sw $t3, -552($fp)	# spill _tmp1188 from $t3 to $fp-552
	sw $t4, -548($fp)	# spill _tmp1189 from $t4 to $fp-548
	sw $t5, -556($fp)	# spill _tmp1190 from $t5 to $fp-556
	sw $t6, -560($fp)	# spill _tmp1191 from $t6 to $fp-560
	sw $t7, -564($fp)	# spill _tmp1192 from $t7 to $fp-564
	beqz $t7, _L198	# branch if _tmp1192 is zero 
	# _tmp1193 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1194 = _tmp1188 * _tmp1193
	lw $t1, -552($fp)	# load _tmp1188 from $fp-552 into $t1
	mul $t2, $t1, $t0	
	# _tmp1195 = _tmp1194 + _tmp1193
	add $t3, $t2, $t0	
	# _tmp1196 = _tmp1186 + _tmp1195
	lw $t4, -540($fp)	# load _tmp1186 from $fp-540 into $t4
	add $t5, $t4, $t3	
	# Goto _L199
	# (save modified registers before flow of control change)
	sw $t0, -568($fp)	# spill _tmp1193 from $t0 to $fp-568
	sw $t2, -572($fp)	# spill _tmp1194 from $t2 to $fp-572
	sw $t3, -576($fp)	# spill _tmp1195 from $t3 to $fp-576
	sw $t5, -576($fp)	# spill _tmp1196 from $t5 to $fp-576
	b _L199		# unconditional branch
_L198:
	# _tmp1197 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string88: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string88	# load label
	# PushParam _tmp1197
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -580($fp)	# spill _tmp1197 from $t0 to $fp-580
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L199:
	# _tmp1198 = *(_tmp1196)
	lw $t0, -576($fp)	# load _tmp1196 from $fp-576 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1199 = *(_tmp1198)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1200 = *(_tmp1199 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1198
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1201 = ACall _tmp1200
	# (save modified registers before flow of control change)
	sw $t1, -584($fp)	# spill _tmp1198 from $t1 to $fp-584
	sw $t2, -588($fp)	# spill _tmp1199 from $t2 to $fp-588
	sw $t3, -592($fp)	# spill _tmp1200 from $t3 to $fp-592
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1202 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1203 = *(_tmp1202)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1204 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp1205 = _tmp1204 < _tmp1203
	slt $t5, $t4, $t3	
	# _tmp1206 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1207 = _tmp1206 < _tmp1204
	slt $t7, $t6, $t4	
	# _tmp1208 = _tmp1207 && _tmp1205
	and $s0, $t7, $t5	
	# IfZ _tmp1208 Goto _L200
	# (save modified registers before flow of control change)
	sw $t0, -596($fp)	# spill _tmp1201 from $t0 to $fp-596
	sw $t2, -600($fp)	# spill _tmp1202 from $t2 to $fp-600
	sw $t3, -604($fp)	# spill _tmp1203 from $t3 to $fp-604
	sw $t4, -612($fp)	# spill _tmp1204 from $t4 to $fp-612
	sw $t5, -608($fp)	# spill _tmp1205 from $t5 to $fp-608
	sw $t6, -616($fp)	# spill _tmp1206 from $t6 to $fp-616
	sw $t7, -620($fp)	# spill _tmp1207 from $t7 to $fp-620
	sw $s0, -624($fp)	# spill _tmp1208 from $s0 to $fp-624
	beqz $s0, _L200	# branch if _tmp1208 is zero 
	# _tmp1209 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1210 = _tmp1204 * _tmp1209
	lw $t1, -612($fp)	# load _tmp1204 from $fp-612 into $t1
	mul $t2, $t1, $t0	
	# _tmp1211 = _tmp1210 + _tmp1209
	add $t3, $t2, $t0	
	# _tmp1212 = _tmp1202 + _tmp1211
	lw $t4, -600($fp)	# load _tmp1202 from $fp-600 into $t4
	add $t5, $t4, $t3	
	# Goto _L201
	# (save modified registers before flow of control change)
	sw $t0, -628($fp)	# spill _tmp1209 from $t0 to $fp-628
	sw $t2, -632($fp)	# spill _tmp1210 from $t2 to $fp-632
	sw $t3, -636($fp)	# spill _tmp1211 from $t3 to $fp-636
	sw $t5, -636($fp)	# spill _tmp1212 from $t5 to $fp-636
	b _L201		# unconditional branch
_L200:
	# _tmp1213 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string89: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string89	# load label
	# PushParam _tmp1213
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -640($fp)	# spill _tmp1213 from $t0 to $fp-640
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L201:
	# _tmp1214 = *(_tmp1212)
	lw $t0, -636($fp)	# load _tmp1212 from $fp-636 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1215 = *(_tmp1214)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1216 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1217 = _tmp1216 < _tmp1215
	slt $t4, $t3, $t2	
	# _tmp1218 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1219 = _tmp1218 < _tmp1216
	slt $t6, $t5, $t3	
	# _tmp1220 = _tmp1219 && _tmp1217
	and $t7, $t6, $t4	
	# IfZ _tmp1220 Goto _L202
	# (save modified registers before flow of control change)
	sw $t1, -644($fp)	# spill _tmp1214 from $t1 to $fp-644
	sw $t2, -648($fp)	# spill _tmp1215 from $t2 to $fp-648
	sw $t3, -656($fp)	# spill _tmp1216 from $t3 to $fp-656
	sw $t4, -652($fp)	# spill _tmp1217 from $t4 to $fp-652
	sw $t5, -660($fp)	# spill _tmp1218 from $t5 to $fp-660
	sw $t6, -664($fp)	# spill _tmp1219 from $t6 to $fp-664
	sw $t7, -668($fp)	# spill _tmp1220 from $t7 to $fp-668
	beqz $t7, _L202	# branch if _tmp1220 is zero 
	# _tmp1221 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1222 = _tmp1216 * _tmp1221
	lw $t1, -656($fp)	# load _tmp1216 from $fp-656 into $t1
	mul $t2, $t1, $t0	
	# _tmp1223 = _tmp1222 + _tmp1221
	add $t3, $t2, $t0	
	# _tmp1224 = _tmp1214 + _tmp1223
	lw $t4, -644($fp)	# load _tmp1214 from $fp-644 into $t4
	add $t5, $t4, $t3	
	# Goto _L203
	# (save modified registers before flow of control change)
	sw $t0, -672($fp)	# spill _tmp1221 from $t0 to $fp-672
	sw $t2, -676($fp)	# spill _tmp1222 from $t2 to $fp-676
	sw $t3, -680($fp)	# spill _tmp1223 from $t3 to $fp-680
	sw $t5, -680($fp)	# spill _tmp1224 from $t5 to $fp-680
	b _L203		# unconditional branch
_L202:
	# _tmp1225 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string90: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string90	# load label
	# PushParam _tmp1225
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -684($fp)	# spill _tmp1225 from $t0 to $fp-684
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L203:
	# _tmp1226 = *(_tmp1224)
	lw $t0, -680($fp)	# load _tmp1224 from $fp-680 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1227 = *(_tmp1226)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1228 = *(_tmp1227 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1226
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1229 = ACall _tmp1228
	# (save modified registers before flow of control change)
	sw $t1, -688($fp)	# spill _tmp1226 from $t1 to $fp-688
	sw $t2, -692($fp)	# spill _tmp1227 from $t2 to $fp-692
	sw $t3, -696($fp)	# spill _tmp1228 from $t3 to $fp-696
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1230 = _tmp1229 && _tmp1201
	lw $t1, -596($fp)	# load _tmp1201 from $fp-596 into $t1
	and $t2, $t0, $t1	
	# _tmp1231 = _tmp1230 && _tmp1173
	lw $t3, -384($fp)	# load _tmp1173 from $fp-384 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1231 Goto _L190
	# (save modified registers before flow of control change)
	sw $t0, -700($fp)	# spill _tmp1229 from $t0 to $fp-700
	sw $t2, -492($fp)	# spill _tmp1230 from $t2 to $fp-492
	sw $t4, -376($fp)	# spill _tmp1231 from $t4 to $fp-376
	beqz $t4, _L190	# branch if _tmp1231 is zero 
	# _tmp1232 = 1
	li $t0, 1		# load constant value 1 into $t0
	# row = _tmp1232
	move $t1, $t0		# copy value
	# _tmp1233 = 2
	li $t2, 2		# load constant value 2 into $t2
	# column = _tmp1233
	move $t3, $t2		# copy value
	# Goto _L191
	# (save modified registers before flow of control change)
	sw $t0, -704($fp)	# spill _tmp1232 from $t0 to $fp-704
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -708($fp)	# spill _tmp1233 from $t2 to $fp-708
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L191		# unconditional branch
_L190:
	# _tmp1234 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1235 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1236 = *(_tmp1235)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1237 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp1238 = _tmp1237 < _tmp1236
	slt $t5, $t4, $t3	
	# _tmp1239 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1240 = _tmp1239 < _tmp1237
	slt $t7, $t6, $t4	
	# _tmp1241 = _tmp1240 && _tmp1238
	and $s0, $t7, $t5	
	# IfZ _tmp1241 Goto _L206
	# (save modified registers before flow of control change)
	sw $t0, -716($fp)	# spill _tmp1234 from $t0 to $fp-716
	sw $t2, -724($fp)	# spill _tmp1235 from $t2 to $fp-724
	sw $t3, -728($fp)	# spill _tmp1236 from $t3 to $fp-728
	sw $t4, -736($fp)	# spill _tmp1237 from $t4 to $fp-736
	sw $t5, -732($fp)	# spill _tmp1238 from $t5 to $fp-732
	sw $t6, -740($fp)	# spill _tmp1239 from $t6 to $fp-740
	sw $t7, -744($fp)	# spill _tmp1240 from $t7 to $fp-744
	sw $s0, -748($fp)	# spill _tmp1241 from $s0 to $fp-748
	beqz $s0, _L206	# branch if _tmp1241 is zero 
	# _tmp1242 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1243 = _tmp1237 * _tmp1242
	lw $t1, -736($fp)	# load _tmp1237 from $fp-736 into $t1
	mul $t2, $t1, $t0	
	# _tmp1244 = _tmp1243 + _tmp1242
	add $t3, $t2, $t0	
	# _tmp1245 = _tmp1235 + _tmp1244
	lw $t4, -724($fp)	# load _tmp1235 from $fp-724 into $t4
	add $t5, $t4, $t3	
	# Goto _L207
	# (save modified registers before flow of control change)
	sw $t0, -752($fp)	# spill _tmp1242 from $t0 to $fp-752
	sw $t2, -756($fp)	# spill _tmp1243 from $t2 to $fp-756
	sw $t3, -760($fp)	# spill _tmp1244 from $t3 to $fp-760
	sw $t5, -760($fp)	# spill _tmp1245 from $t5 to $fp-760
	b _L207		# unconditional branch
_L206:
	# _tmp1246 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string91: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string91	# load label
	# PushParam _tmp1246
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -764($fp)	# spill _tmp1246 from $t0 to $fp-764
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L207:
	# _tmp1247 = *(_tmp1245)
	lw $t0, -760($fp)	# load _tmp1245 from $fp-760 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1248 = *(_tmp1247)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1249 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1250 = _tmp1249 < _tmp1248
	slt $t4, $t3, $t2	
	# _tmp1251 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1252 = _tmp1251 < _tmp1249
	slt $t6, $t5, $t3	
	# _tmp1253 = _tmp1252 && _tmp1250
	and $t7, $t6, $t4	
	# IfZ _tmp1253 Goto _L208
	# (save modified registers before flow of control change)
	sw $t1, -768($fp)	# spill _tmp1247 from $t1 to $fp-768
	sw $t2, -772($fp)	# spill _tmp1248 from $t2 to $fp-772
	sw $t3, -780($fp)	# spill _tmp1249 from $t3 to $fp-780
	sw $t4, -776($fp)	# spill _tmp1250 from $t4 to $fp-776
	sw $t5, -784($fp)	# spill _tmp1251 from $t5 to $fp-784
	sw $t6, -788($fp)	# spill _tmp1252 from $t6 to $fp-788
	sw $t7, -792($fp)	# spill _tmp1253 from $t7 to $fp-792
	beqz $t7, _L208	# branch if _tmp1253 is zero 
	# _tmp1254 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1255 = _tmp1249 * _tmp1254
	lw $t1, -780($fp)	# load _tmp1249 from $fp-780 into $t1
	mul $t2, $t1, $t0	
	# _tmp1256 = _tmp1255 + _tmp1254
	add $t3, $t2, $t0	
	# _tmp1257 = _tmp1247 + _tmp1256
	lw $t4, -768($fp)	# load _tmp1247 from $fp-768 into $t4
	add $t5, $t4, $t3	
	# Goto _L209
	# (save modified registers before flow of control change)
	sw $t0, -796($fp)	# spill _tmp1254 from $t0 to $fp-796
	sw $t2, -800($fp)	# spill _tmp1255 from $t2 to $fp-800
	sw $t3, -804($fp)	# spill _tmp1256 from $t3 to $fp-804
	sw $t5, -804($fp)	# spill _tmp1257 from $t5 to $fp-804
	b _L209		# unconditional branch
_L208:
	# _tmp1258 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string92: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string92	# load label
	# PushParam _tmp1258
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -808($fp)	# spill _tmp1258 from $t0 to $fp-808
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L209:
	# _tmp1259 = *(_tmp1257)
	lw $t0, -804($fp)	# load _tmp1257 from $fp-804 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1260 = *(_tmp1259)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1261 = *(_tmp1260 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1259
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1262 = ACall _tmp1261
	# (save modified registers before flow of control change)
	sw $t1, -812($fp)	# spill _tmp1259 from $t1 to $fp-812
	sw $t2, -816($fp)	# spill _tmp1260 from $t2 to $fp-816
	sw $t3, -820($fp)	# spill _tmp1261 from $t3 to $fp-820
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1263 = _tmp1234 - _tmp1262
	lw $t1, -716($fp)	# load _tmp1234 from $fp-716 into $t1
	sub $t2, $t1, $t0	
	# _tmp1264 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1265 = *(_tmp1264)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1266 = 2
	li $t6, 2		# load constant value 2 into $t6
	# _tmp1267 = _tmp1266 < _tmp1265
	slt $t7, $t6, $t5	
	# _tmp1268 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1269 = _tmp1268 < _tmp1266
	slt $s1, $s0, $t6	
	# _tmp1270 = _tmp1269 && _tmp1267
	and $s2, $s1, $t7	
	# IfZ _tmp1270 Goto _L210
	# (save modified registers before flow of control change)
	sw $t0, -824($fp)	# spill _tmp1262 from $t0 to $fp-824
	sw $t2, -720($fp)	# spill _tmp1263 from $t2 to $fp-720
	sw $t4, -832($fp)	# spill _tmp1264 from $t4 to $fp-832
	sw $t5, -836($fp)	# spill _tmp1265 from $t5 to $fp-836
	sw $t6, -844($fp)	# spill _tmp1266 from $t6 to $fp-844
	sw $t7, -840($fp)	# spill _tmp1267 from $t7 to $fp-840
	sw $s0, -848($fp)	# spill _tmp1268 from $s0 to $fp-848
	sw $s1, -852($fp)	# spill _tmp1269 from $s1 to $fp-852
	sw $s2, -856($fp)	# spill _tmp1270 from $s2 to $fp-856
	beqz $s2, _L210	# branch if _tmp1270 is zero 
	# _tmp1271 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1272 = _tmp1266 * _tmp1271
	lw $t1, -844($fp)	# load _tmp1266 from $fp-844 into $t1
	mul $t2, $t1, $t0	
	# _tmp1273 = _tmp1272 + _tmp1271
	add $t3, $t2, $t0	
	# _tmp1274 = _tmp1264 + _tmp1273
	lw $t4, -832($fp)	# load _tmp1264 from $fp-832 into $t4
	add $t5, $t4, $t3	
	# Goto _L211
	# (save modified registers before flow of control change)
	sw $t0, -860($fp)	# spill _tmp1271 from $t0 to $fp-860
	sw $t2, -864($fp)	# spill _tmp1272 from $t2 to $fp-864
	sw $t3, -868($fp)	# spill _tmp1273 from $t3 to $fp-868
	sw $t5, -868($fp)	# spill _tmp1274 from $t5 to $fp-868
	b _L211		# unconditional branch
_L210:
	# _tmp1275 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string93: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string93	# load label
	# PushParam _tmp1275
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -872($fp)	# spill _tmp1275 from $t0 to $fp-872
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L211:
	# _tmp1276 = *(_tmp1274)
	lw $t0, -868($fp)	# load _tmp1274 from $fp-868 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1277 = *(_tmp1276)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1278 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1279 = _tmp1278 < _tmp1277
	slt $t4, $t3, $t2	
	# _tmp1280 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1281 = _tmp1280 < _tmp1278
	slt $t6, $t5, $t3	
	# _tmp1282 = _tmp1281 && _tmp1279
	and $t7, $t6, $t4	
	# IfZ _tmp1282 Goto _L212
	# (save modified registers before flow of control change)
	sw $t1, -876($fp)	# spill _tmp1276 from $t1 to $fp-876
	sw $t2, -880($fp)	# spill _tmp1277 from $t2 to $fp-880
	sw $t3, -888($fp)	# spill _tmp1278 from $t3 to $fp-888
	sw $t4, -884($fp)	# spill _tmp1279 from $t4 to $fp-884
	sw $t5, -892($fp)	# spill _tmp1280 from $t5 to $fp-892
	sw $t6, -896($fp)	# spill _tmp1281 from $t6 to $fp-896
	sw $t7, -900($fp)	# spill _tmp1282 from $t7 to $fp-900
	beqz $t7, _L212	# branch if _tmp1282 is zero 
	# _tmp1283 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1284 = _tmp1278 * _tmp1283
	lw $t1, -888($fp)	# load _tmp1278 from $fp-888 into $t1
	mul $t2, $t1, $t0	
	# _tmp1285 = _tmp1284 + _tmp1283
	add $t3, $t2, $t0	
	# _tmp1286 = _tmp1276 + _tmp1285
	lw $t4, -876($fp)	# load _tmp1276 from $fp-876 into $t4
	add $t5, $t4, $t3	
	# Goto _L213
	# (save modified registers before flow of control change)
	sw $t0, -904($fp)	# spill _tmp1283 from $t0 to $fp-904
	sw $t2, -908($fp)	# spill _tmp1284 from $t2 to $fp-908
	sw $t3, -912($fp)	# spill _tmp1285 from $t3 to $fp-912
	sw $t5, -912($fp)	# spill _tmp1286 from $t5 to $fp-912
	b _L213		# unconditional branch
_L212:
	# _tmp1287 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string94: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string94	# load label
	# PushParam _tmp1287
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -916($fp)	# spill _tmp1287 from $t0 to $fp-916
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L213:
	# _tmp1288 = *(_tmp1286)
	lw $t0, -912($fp)	# load _tmp1286 from $fp-912 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1289 = *(_tmp1288)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1290 = *(_tmp1289 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1288
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1291 = ACall _tmp1290
	# (save modified registers before flow of control change)
	sw $t1, -920($fp)	# spill _tmp1288 from $t1 to $fp-920
	sw $t2, -924($fp)	# spill _tmp1289 from $t2 to $fp-924
	sw $t3, -928($fp)	# spill _tmp1290 from $t3 to $fp-928
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1292 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1293 = *(_tmp1292)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1294 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp1295 = _tmp1294 < _tmp1293
	slt $t5, $t4, $t3	
	# _tmp1296 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1297 = _tmp1296 < _tmp1294
	slt $t7, $t6, $t4	
	# _tmp1298 = _tmp1297 && _tmp1295
	and $s0, $t7, $t5	
	# IfZ _tmp1298 Goto _L214
	# (save modified registers before flow of control change)
	sw $t0, -932($fp)	# spill _tmp1291 from $t0 to $fp-932
	sw $t2, -936($fp)	# spill _tmp1292 from $t2 to $fp-936
	sw $t3, -940($fp)	# spill _tmp1293 from $t3 to $fp-940
	sw $t4, -948($fp)	# spill _tmp1294 from $t4 to $fp-948
	sw $t5, -944($fp)	# spill _tmp1295 from $t5 to $fp-944
	sw $t6, -952($fp)	# spill _tmp1296 from $t6 to $fp-952
	sw $t7, -956($fp)	# spill _tmp1297 from $t7 to $fp-956
	sw $s0, -960($fp)	# spill _tmp1298 from $s0 to $fp-960
	beqz $s0, _L214	# branch if _tmp1298 is zero 
	# _tmp1299 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1300 = _tmp1294 * _tmp1299
	lw $t1, -948($fp)	# load _tmp1294 from $fp-948 into $t1
	mul $t2, $t1, $t0	
	# _tmp1301 = _tmp1300 + _tmp1299
	add $t3, $t2, $t0	
	# _tmp1302 = _tmp1292 + _tmp1301
	lw $t4, -936($fp)	# load _tmp1292 from $fp-936 into $t4
	add $t5, $t4, $t3	
	# Goto _L215
	# (save modified registers before flow of control change)
	sw $t0, -964($fp)	# spill _tmp1299 from $t0 to $fp-964
	sw $t2, -968($fp)	# spill _tmp1300 from $t2 to $fp-968
	sw $t3, -972($fp)	# spill _tmp1301 from $t3 to $fp-972
	sw $t5, -972($fp)	# spill _tmp1302 from $t5 to $fp-972
	b _L215		# unconditional branch
_L214:
	# _tmp1303 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string95: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string95	# load label
	# PushParam _tmp1303
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -976($fp)	# spill _tmp1303 from $t0 to $fp-976
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L215:
	# _tmp1304 = *(_tmp1302)
	lw $t0, -972($fp)	# load _tmp1302 from $fp-972 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1305 = *(_tmp1304)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1306 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1307 = _tmp1306 < _tmp1305
	slt $t4, $t3, $t2	
	# _tmp1308 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1309 = _tmp1308 < _tmp1306
	slt $t6, $t5, $t3	
	# _tmp1310 = _tmp1309 && _tmp1307
	and $t7, $t6, $t4	
	# IfZ _tmp1310 Goto _L216
	# (save modified registers before flow of control change)
	sw $t1, -980($fp)	# spill _tmp1304 from $t1 to $fp-980
	sw $t2, -984($fp)	# spill _tmp1305 from $t2 to $fp-984
	sw $t3, -992($fp)	# spill _tmp1306 from $t3 to $fp-992
	sw $t4, -988($fp)	# spill _tmp1307 from $t4 to $fp-988
	sw $t5, -996($fp)	# spill _tmp1308 from $t5 to $fp-996
	sw $t6, -1000($fp)	# spill _tmp1309 from $t6 to $fp-1000
	sw $t7, -1004($fp)	# spill _tmp1310 from $t7 to $fp-1004
	beqz $t7, _L216	# branch if _tmp1310 is zero 
	# _tmp1311 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1312 = _tmp1306 * _tmp1311
	lw $t1, -992($fp)	# load _tmp1306 from $fp-992 into $t1
	mul $t2, $t1, $t0	
	# _tmp1313 = _tmp1312 + _tmp1311
	add $t3, $t2, $t0	
	# _tmp1314 = _tmp1304 + _tmp1313
	lw $t4, -980($fp)	# load _tmp1304 from $fp-980 into $t4
	add $t5, $t4, $t3	
	# Goto _L217
	# (save modified registers before flow of control change)
	sw $t0, -1008($fp)	# spill _tmp1311 from $t0 to $fp-1008
	sw $t2, -1012($fp)	# spill _tmp1312 from $t2 to $fp-1012
	sw $t3, -1016($fp)	# spill _tmp1313 from $t3 to $fp-1016
	sw $t5, -1016($fp)	# spill _tmp1314 from $t5 to $fp-1016
	b _L217		# unconditional branch
_L216:
	# _tmp1315 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string96: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string96	# load label
	# PushParam _tmp1315
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1020($fp)	# spill _tmp1315 from $t0 to $fp-1020
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L217:
	# _tmp1316 = *(_tmp1314)
	lw $t0, -1016($fp)	# load _tmp1314 from $fp-1016 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1317 = *(_tmp1316)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1318 = *(_tmp1317 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1316
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1319 = ACall _tmp1318
	# (save modified registers before flow of control change)
	sw $t1, -1024($fp)	# spill _tmp1316 from $t1 to $fp-1024
	sw $t2, -1028($fp)	# spill _tmp1317 from $t2 to $fp-1028
	sw $t3, -1032($fp)	# spill _tmp1318 from $t3 to $fp-1032
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1320 = _tmp1319 && _tmp1291
	lw $t1, -932($fp)	# load _tmp1291 from $fp-932 into $t1
	and $t2, $t0, $t1	
	# _tmp1321 = _tmp1320 && _tmp1263
	lw $t3, -720($fp)	# load _tmp1263 from $fp-720 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1321 Goto _L204
	# (save modified registers before flow of control change)
	sw $t0, -1036($fp)	# spill _tmp1319 from $t0 to $fp-1036
	sw $t2, -828($fp)	# spill _tmp1320 from $t2 to $fp-828
	sw $t4, -712($fp)	# spill _tmp1321 from $t4 to $fp-712
	beqz $t4, _L204	# branch if _tmp1321 is zero 
	# _tmp1322 = 2
	li $t0, 2		# load constant value 2 into $t0
	# row = _tmp1322
	move $t1, $t0		# copy value
	# _tmp1323 = 2
	li $t2, 2		# load constant value 2 into $t2
	# column = _tmp1323
	move $t3, $t2		# copy value
	# Goto _L205
	# (save modified registers before flow of control change)
	sw $t0, -1040($fp)	# spill _tmp1322 from $t0 to $fp-1040
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -1044($fp)	# spill _tmp1323 from $t2 to $fp-1044
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L205		# unconditional branch
_L204:
	# _tmp1324 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1325 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1326 = *(_tmp1325)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1327 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1328 = _tmp1327 < _tmp1326
	slt $t5, $t4, $t3	
	# _tmp1329 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1330 = _tmp1329 < _tmp1327
	slt $t7, $t6, $t4	
	# _tmp1331 = _tmp1330 && _tmp1328
	and $s0, $t7, $t5	
	# IfZ _tmp1331 Goto _L220
	# (save modified registers before flow of control change)
	sw $t0, -1052($fp)	# spill _tmp1324 from $t0 to $fp-1052
	sw $t2, -1060($fp)	# spill _tmp1325 from $t2 to $fp-1060
	sw $t3, -1064($fp)	# spill _tmp1326 from $t3 to $fp-1064
	sw $t4, -1072($fp)	# spill _tmp1327 from $t4 to $fp-1072
	sw $t5, -1068($fp)	# spill _tmp1328 from $t5 to $fp-1068
	sw $t6, -1076($fp)	# spill _tmp1329 from $t6 to $fp-1076
	sw $t7, -1080($fp)	# spill _tmp1330 from $t7 to $fp-1080
	sw $s0, -1084($fp)	# spill _tmp1331 from $s0 to $fp-1084
	beqz $s0, _L220	# branch if _tmp1331 is zero 
	# _tmp1332 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1333 = _tmp1327 * _tmp1332
	lw $t1, -1072($fp)	# load _tmp1327 from $fp-1072 into $t1
	mul $t2, $t1, $t0	
	# _tmp1334 = _tmp1333 + _tmp1332
	add $t3, $t2, $t0	
	# _tmp1335 = _tmp1325 + _tmp1334
	lw $t4, -1060($fp)	# load _tmp1325 from $fp-1060 into $t4
	add $t5, $t4, $t3	
	# Goto _L221
	# (save modified registers before flow of control change)
	sw $t0, -1088($fp)	# spill _tmp1332 from $t0 to $fp-1088
	sw $t2, -1092($fp)	# spill _tmp1333 from $t2 to $fp-1092
	sw $t3, -1096($fp)	# spill _tmp1334 from $t3 to $fp-1096
	sw $t5, -1096($fp)	# spill _tmp1335 from $t5 to $fp-1096
	b _L221		# unconditional branch
_L220:
	# _tmp1336 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string97: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string97	# load label
	# PushParam _tmp1336
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1100($fp)	# spill _tmp1336 from $t0 to $fp-1100
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L221:
	# _tmp1337 = *(_tmp1335)
	lw $t0, -1096($fp)	# load _tmp1335 from $fp-1096 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1338 = *(_tmp1337)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1339 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1340 = _tmp1339 < _tmp1338
	slt $t4, $t3, $t2	
	# _tmp1341 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1342 = _tmp1341 < _tmp1339
	slt $t6, $t5, $t3	
	# _tmp1343 = _tmp1342 && _tmp1340
	and $t7, $t6, $t4	
	# IfZ _tmp1343 Goto _L222
	# (save modified registers before flow of control change)
	sw $t1, -1104($fp)	# spill _tmp1337 from $t1 to $fp-1104
	sw $t2, -1108($fp)	# spill _tmp1338 from $t2 to $fp-1108
	sw $t3, -1116($fp)	# spill _tmp1339 from $t3 to $fp-1116
	sw $t4, -1112($fp)	# spill _tmp1340 from $t4 to $fp-1112
	sw $t5, -1120($fp)	# spill _tmp1341 from $t5 to $fp-1120
	sw $t6, -1124($fp)	# spill _tmp1342 from $t6 to $fp-1124
	sw $t7, -1128($fp)	# spill _tmp1343 from $t7 to $fp-1128
	beqz $t7, _L222	# branch if _tmp1343 is zero 
	# _tmp1344 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1345 = _tmp1339 * _tmp1344
	lw $t1, -1116($fp)	# load _tmp1339 from $fp-1116 into $t1
	mul $t2, $t1, $t0	
	# _tmp1346 = _tmp1345 + _tmp1344
	add $t3, $t2, $t0	
	# _tmp1347 = _tmp1337 + _tmp1346
	lw $t4, -1104($fp)	# load _tmp1337 from $fp-1104 into $t4
	add $t5, $t4, $t3	
	# Goto _L223
	# (save modified registers before flow of control change)
	sw $t0, -1132($fp)	# spill _tmp1344 from $t0 to $fp-1132
	sw $t2, -1136($fp)	# spill _tmp1345 from $t2 to $fp-1136
	sw $t3, -1140($fp)	# spill _tmp1346 from $t3 to $fp-1140
	sw $t5, -1140($fp)	# spill _tmp1347 from $t5 to $fp-1140
	b _L223		# unconditional branch
_L222:
	# _tmp1348 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string98: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string98	# load label
	# PushParam _tmp1348
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1144($fp)	# spill _tmp1348 from $t0 to $fp-1144
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L223:
	# _tmp1349 = *(_tmp1347)
	lw $t0, -1140($fp)	# load _tmp1347 from $fp-1140 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1350 = *(_tmp1349)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1351 = *(_tmp1350 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1349
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1352 = ACall _tmp1351
	# (save modified registers before flow of control change)
	sw $t1, -1148($fp)	# spill _tmp1349 from $t1 to $fp-1148
	sw $t2, -1152($fp)	# spill _tmp1350 from $t2 to $fp-1152
	sw $t3, -1156($fp)	# spill _tmp1351 from $t3 to $fp-1156
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1353 = _tmp1324 - _tmp1352
	lw $t1, -1052($fp)	# load _tmp1324 from $fp-1052 into $t1
	sub $t2, $t1, $t0	
	# _tmp1354 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1355 = *(_tmp1354)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1356 = 0
	li $t6, 0		# load constant value 0 into $t6
	# _tmp1357 = _tmp1356 < _tmp1355
	slt $t7, $t6, $t5	
	# _tmp1358 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1359 = _tmp1358 < _tmp1356
	slt $s1, $s0, $t6	
	# _tmp1360 = _tmp1359 && _tmp1357
	and $s2, $s1, $t7	
	# IfZ _tmp1360 Goto _L224
	# (save modified registers before flow of control change)
	sw $t0, -1160($fp)	# spill _tmp1352 from $t0 to $fp-1160
	sw $t2, -1056($fp)	# spill _tmp1353 from $t2 to $fp-1056
	sw $t4, -1168($fp)	# spill _tmp1354 from $t4 to $fp-1168
	sw $t5, -1172($fp)	# spill _tmp1355 from $t5 to $fp-1172
	sw $t6, -1180($fp)	# spill _tmp1356 from $t6 to $fp-1180
	sw $t7, -1176($fp)	# spill _tmp1357 from $t7 to $fp-1176
	sw $s0, -1184($fp)	# spill _tmp1358 from $s0 to $fp-1184
	sw $s1, -1188($fp)	# spill _tmp1359 from $s1 to $fp-1188
	sw $s2, -1192($fp)	# spill _tmp1360 from $s2 to $fp-1192
	beqz $s2, _L224	# branch if _tmp1360 is zero 
	# _tmp1361 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1362 = _tmp1356 * _tmp1361
	lw $t1, -1180($fp)	# load _tmp1356 from $fp-1180 into $t1
	mul $t2, $t1, $t0	
	# _tmp1363 = _tmp1362 + _tmp1361
	add $t3, $t2, $t0	
	# _tmp1364 = _tmp1354 + _tmp1363
	lw $t4, -1168($fp)	# load _tmp1354 from $fp-1168 into $t4
	add $t5, $t4, $t3	
	# Goto _L225
	# (save modified registers before flow of control change)
	sw $t0, -1196($fp)	# spill _tmp1361 from $t0 to $fp-1196
	sw $t2, -1200($fp)	# spill _tmp1362 from $t2 to $fp-1200
	sw $t3, -1204($fp)	# spill _tmp1363 from $t3 to $fp-1204
	sw $t5, -1204($fp)	# spill _tmp1364 from $t5 to $fp-1204
	b _L225		# unconditional branch
_L224:
	# _tmp1365 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string99: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string99	# load label
	# PushParam _tmp1365
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1208($fp)	# spill _tmp1365 from $t0 to $fp-1208
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L225:
	# _tmp1366 = *(_tmp1364)
	lw $t0, -1204($fp)	# load _tmp1364 from $fp-1204 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1367 = *(_tmp1366)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1368 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1369 = _tmp1368 < _tmp1367
	slt $t4, $t3, $t2	
	# _tmp1370 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1371 = _tmp1370 < _tmp1368
	slt $t6, $t5, $t3	
	# _tmp1372 = _tmp1371 && _tmp1369
	and $t7, $t6, $t4	
	# IfZ _tmp1372 Goto _L226
	# (save modified registers before flow of control change)
	sw $t1, -1212($fp)	# spill _tmp1366 from $t1 to $fp-1212
	sw $t2, -1216($fp)	# spill _tmp1367 from $t2 to $fp-1216
	sw $t3, -1224($fp)	# spill _tmp1368 from $t3 to $fp-1224
	sw $t4, -1220($fp)	# spill _tmp1369 from $t4 to $fp-1220
	sw $t5, -1228($fp)	# spill _tmp1370 from $t5 to $fp-1228
	sw $t6, -1232($fp)	# spill _tmp1371 from $t6 to $fp-1232
	sw $t7, -1236($fp)	# spill _tmp1372 from $t7 to $fp-1236
	beqz $t7, _L226	# branch if _tmp1372 is zero 
	# _tmp1373 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1374 = _tmp1368 * _tmp1373
	lw $t1, -1224($fp)	# load _tmp1368 from $fp-1224 into $t1
	mul $t2, $t1, $t0	
	# _tmp1375 = _tmp1374 + _tmp1373
	add $t3, $t2, $t0	
	# _tmp1376 = _tmp1366 + _tmp1375
	lw $t4, -1212($fp)	# load _tmp1366 from $fp-1212 into $t4
	add $t5, $t4, $t3	
	# Goto _L227
	# (save modified registers before flow of control change)
	sw $t0, -1240($fp)	# spill _tmp1373 from $t0 to $fp-1240
	sw $t2, -1244($fp)	# spill _tmp1374 from $t2 to $fp-1244
	sw $t3, -1248($fp)	# spill _tmp1375 from $t3 to $fp-1248
	sw $t5, -1248($fp)	# spill _tmp1376 from $t5 to $fp-1248
	b _L227		# unconditional branch
_L226:
	# _tmp1377 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string100: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string100	# load label
	# PushParam _tmp1377
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1252($fp)	# spill _tmp1377 from $t0 to $fp-1252
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L227:
	# _tmp1378 = *(_tmp1376)
	lw $t0, -1248($fp)	# load _tmp1376 from $fp-1248 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1379 = *(_tmp1378)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1380 = *(_tmp1379 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1378
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1381 = ACall _tmp1380
	# (save modified registers before flow of control change)
	sw $t1, -1256($fp)	# spill _tmp1378 from $t1 to $fp-1256
	sw $t2, -1260($fp)	# spill _tmp1379 from $t2 to $fp-1260
	sw $t3, -1264($fp)	# spill _tmp1380 from $t3 to $fp-1264
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1382 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1383 = *(_tmp1382)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1384 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1385 = _tmp1384 < _tmp1383
	slt $t5, $t4, $t3	
	# _tmp1386 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1387 = _tmp1386 < _tmp1384
	slt $t7, $t6, $t4	
	# _tmp1388 = _tmp1387 && _tmp1385
	and $s0, $t7, $t5	
	# IfZ _tmp1388 Goto _L228
	# (save modified registers before flow of control change)
	sw $t0, -1268($fp)	# spill _tmp1381 from $t0 to $fp-1268
	sw $t2, -1272($fp)	# spill _tmp1382 from $t2 to $fp-1272
	sw $t3, -1276($fp)	# spill _tmp1383 from $t3 to $fp-1276
	sw $t4, -1284($fp)	# spill _tmp1384 from $t4 to $fp-1284
	sw $t5, -1280($fp)	# spill _tmp1385 from $t5 to $fp-1280
	sw $t6, -1288($fp)	# spill _tmp1386 from $t6 to $fp-1288
	sw $t7, -1292($fp)	# spill _tmp1387 from $t7 to $fp-1292
	sw $s0, -1296($fp)	# spill _tmp1388 from $s0 to $fp-1296
	beqz $s0, _L228	# branch if _tmp1388 is zero 
	# _tmp1389 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1390 = _tmp1384 * _tmp1389
	lw $t1, -1284($fp)	# load _tmp1384 from $fp-1284 into $t1
	mul $t2, $t1, $t0	
	# _tmp1391 = _tmp1390 + _tmp1389
	add $t3, $t2, $t0	
	# _tmp1392 = _tmp1382 + _tmp1391
	lw $t4, -1272($fp)	# load _tmp1382 from $fp-1272 into $t4
	add $t5, $t4, $t3	
	# Goto _L229
	# (save modified registers before flow of control change)
	sw $t0, -1300($fp)	# spill _tmp1389 from $t0 to $fp-1300
	sw $t2, -1304($fp)	# spill _tmp1390 from $t2 to $fp-1304
	sw $t3, -1308($fp)	# spill _tmp1391 from $t3 to $fp-1308
	sw $t5, -1308($fp)	# spill _tmp1392 from $t5 to $fp-1308
	b _L229		# unconditional branch
_L228:
	# _tmp1393 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string101: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string101	# load label
	# PushParam _tmp1393
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1312($fp)	# spill _tmp1393 from $t0 to $fp-1312
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L229:
	# _tmp1394 = *(_tmp1392)
	lw $t0, -1308($fp)	# load _tmp1392 from $fp-1308 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1395 = *(_tmp1394)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1396 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1397 = _tmp1396 < _tmp1395
	slt $t4, $t3, $t2	
	# _tmp1398 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1399 = _tmp1398 < _tmp1396
	slt $t6, $t5, $t3	
	# _tmp1400 = _tmp1399 && _tmp1397
	and $t7, $t6, $t4	
	# IfZ _tmp1400 Goto _L230
	# (save modified registers before flow of control change)
	sw $t1, -1316($fp)	# spill _tmp1394 from $t1 to $fp-1316
	sw $t2, -1320($fp)	# spill _tmp1395 from $t2 to $fp-1320
	sw $t3, -1328($fp)	# spill _tmp1396 from $t3 to $fp-1328
	sw $t4, -1324($fp)	# spill _tmp1397 from $t4 to $fp-1324
	sw $t5, -1332($fp)	# spill _tmp1398 from $t5 to $fp-1332
	sw $t6, -1336($fp)	# spill _tmp1399 from $t6 to $fp-1336
	sw $t7, -1340($fp)	# spill _tmp1400 from $t7 to $fp-1340
	beqz $t7, _L230	# branch if _tmp1400 is zero 
	# _tmp1401 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1402 = _tmp1396 * _tmp1401
	lw $t1, -1328($fp)	# load _tmp1396 from $fp-1328 into $t1
	mul $t2, $t1, $t0	
	# _tmp1403 = _tmp1402 + _tmp1401
	add $t3, $t2, $t0	
	# _tmp1404 = _tmp1394 + _tmp1403
	lw $t4, -1316($fp)	# load _tmp1394 from $fp-1316 into $t4
	add $t5, $t4, $t3	
	# Goto _L231
	# (save modified registers before flow of control change)
	sw $t0, -1344($fp)	# spill _tmp1401 from $t0 to $fp-1344
	sw $t2, -1348($fp)	# spill _tmp1402 from $t2 to $fp-1348
	sw $t3, -1352($fp)	# spill _tmp1403 from $t3 to $fp-1352
	sw $t5, -1352($fp)	# spill _tmp1404 from $t5 to $fp-1352
	b _L231		# unconditional branch
_L230:
	# _tmp1405 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string102: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string102	# load label
	# PushParam _tmp1405
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1356($fp)	# spill _tmp1405 from $t0 to $fp-1356
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L231:
	# _tmp1406 = *(_tmp1404)
	lw $t0, -1352($fp)	# load _tmp1404 from $fp-1352 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1407 = *(_tmp1406)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1408 = *(_tmp1407 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1406
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1409 = ACall _tmp1408
	# (save modified registers before flow of control change)
	sw $t1, -1360($fp)	# spill _tmp1406 from $t1 to $fp-1360
	sw $t2, -1364($fp)	# spill _tmp1407 from $t2 to $fp-1364
	sw $t3, -1368($fp)	# spill _tmp1408 from $t3 to $fp-1368
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1410 = _tmp1409 && _tmp1381
	lw $t1, -1268($fp)	# load _tmp1381 from $fp-1268 into $t1
	and $t2, $t0, $t1	
	# _tmp1411 = _tmp1410 && _tmp1353
	lw $t3, -1056($fp)	# load _tmp1353 from $fp-1056 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1411 Goto _L218
	# (save modified registers before flow of control change)
	sw $t0, -1372($fp)	# spill _tmp1409 from $t0 to $fp-1372
	sw $t2, -1164($fp)	# spill _tmp1410 from $t2 to $fp-1164
	sw $t4, -1048($fp)	# spill _tmp1411 from $t4 to $fp-1048
	beqz $t4, _L218	# branch if _tmp1411 is zero 
	# _tmp1412 = 0
	li $t0, 0		# load constant value 0 into $t0
	# row = _tmp1412
	move $t1, $t0		# copy value
	# _tmp1413 = 0
	li $t2, 0		# load constant value 0 into $t2
	# column = _tmp1413
	move $t3, $t2		# copy value
	# Goto _L219
	# (save modified registers before flow of control change)
	sw $t0, -1376($fp)	# spill _tmp1412 from $t0 to $fp-1376
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -1380($fp)	# spill _tmp1413 from $t2 to $fp-1380
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L219		# unconditional branch
_L218:
	# _tmp1414 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1415 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1416 = *(_tmp1415)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1417 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp1418 = _tmp1417 < _tmp1416
	slt $t5, $t4, $t3	
	# _tmp1419 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1420 = _tmp1419 < _tmp1417
	slt $t7, $t6, $t4	
	# _tmp1421 = _tmp1420 && _tmp1418
	and $s0, $t7, $t5	
	# IfZ _tmp1421 Goto _L234
	# (save modified registers before flow of control change)
	sw $t0, -1388($fp)	# spill _tmp1414 from $t0 to $fp-1388
	sw $t2, -1396($fp)	# spill _tmp1415 from $t2 to $fp-1396
	sw $t3, -1400($fp)	# spill _tmp1416 from $t3 to $fp-1400
	sw $t4, -1408($fp)	# spill _tmp1417 from $t4 to $fp-1408
	sw $t5, -1404($fp)	# spill _tmp1418 from $t5 to $fp-1404
	sw $t6, -1412($fp)	# spill _tmp1419 from $t6 to $fp-1412
	sw $t7, -1416($fp)	# spill _tmp1420 from $t7 to $fp-1416
	sw $s0, -1420($fp)	# spill _tmp1421 from $s0 to $fp-1420
	beqz $s0, _L234	# branch if _tmp1421 is zero 
	# _tmp1422 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1423 = _tmp1417 * _tmp1422
	lw $t1, -1408($fp)	# load _tmp1417 from $fp-1408 into $t1
	mul $t2, $t1, $t0	
	# _tmp1424 = _tmp1423 + _tmp1422
	add $t3, $t2, $t0	
	# _tmp1425 = _tmp1415 + _tmp1424
	lw $t4, -1396($fp)	# load _tmp1415 from $fp-1396 into $t4
	add $t5, $t4, $t3	
	# Goto _L235
	# (save modified registers before flow of control change)
	sw $t0, -1424($fp)	# spill _tmp1422 from $t0 to $fp-1424
	sw $t2, -1428($fp)	# spill _tmp1423 from $t2 to $fp-1428
	sw $t3, -1432($fp)	# spill _tmp1424 from $t3 to $fp-1432
	sw $t5, -1432($fp)	# spill _tmp1425 from $t5 to $fp-1432
	b _L235		# unconditional branch
_L234:
	# _tmp1426 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string103: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string103	# load label
	# PushParam _tmp1426
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1436($fp)	# spill _tmp1426 from $t0 to $fp-1436
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L235:
	# _tmp1427 = *(_tmp1425)
	lw $t0, -1432($fp)	# load _tmp1425 from $fp-1432 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1428 = *(_tmp1427)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1429 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1430 = _tmp1429 < _tmp1428
	slt $t4, $t3, $t2	
	# _tmp1431 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1432 = _tmp1431 < _tmp1429
	slt $t6, $t5, $t3	
	# _tmp1433 = _tmp1432 && _tmp1430
	and $t7, $t6, $t4	
	# IfZ _tmp1433 Goto _L236
	# (save modified registers before flow of control change)
	sw $t1, -1440($fp)	# spill _tmp1427 from $t1 to $fp-1440
	sw $t2, -1444($fp)	# spill _tmp1428 from $t2 to $fp-1444
	sw $t3, -1452($fp)	# spill _tmp1429 from $t3 to $fp-1452
	sw $t4, -1448($fp)	# spill _tmp1430 from $t4 to $fp-1448
	sw $t5, -1456($fp)	# spill _tmp1431 from $t5 to $fp-1456
	sw $t6, -1460($fp)	# spill _tmp1432 from $t6 to $fp-1460
	sw $t7, -1464($fp)	# spill _tmp1433 from $t7 to $fp-1464
	beqz $t7, _L236	# branch if _tmp1433 is zero 
	# _tmp1434 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1435 = _tmp1429 * _tmp1434
	lw $t1, -1452($fp)	# load _tmp1429 from $fp-1452 into $t1
	mul $t2, $t1, $t0	
	# _tmp1436 = _tmp1435 + _tmp1434
	add $t3, $t2, $t0	
	# _tmp1437 = _tmp1427 + _tmp1436
	lw $t4, -1440($fp)	# load _tmp1427 from $fp-1440 into $t4
	add $t5, $t4, $t3	
	# Goto _L237
	# (save modified registers before flow of control change)
	sw $t0, -1468($fp)	# spill _tmp1434 from $t0 to $fp-1468
	sw $t2, -1472($fp)	# spill _tmp1435 from $t2 to $fp-1472
	sw $t3, -1476($fp)	# spill _tmp1436 from $t3 to $fp-1476
	sw $t5, -1476($fp)	# spill _tmp1437 from $t5 to $fp-1476
	b _L237		# unconditional branch
_L236:
	# _tmp1438 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string104: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string104	# load label
	# PushParam _tmp1438
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1480($fp)	# spill _tmp1438 from $t0 to $fp-1480
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L237:
	# _tmp1439 = *(_tmp1437)
	lw $t0, -1476($fp)	# load _tmp1437 from $fp-1476 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1440 = *(_tmp1439)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1441 = *(_tmp1440 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1439
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1442 = ACall _tmp1441
	# (save modified registers before flow of control change)
	sw $t1, -1484($fp)	# spill _tmp1439 from $t1 to $fp-1484
	sw $t2, -1488($fp)	# spill _tmp1440 from $t2 to $fp-1488
	sw $t3, -1492($fp)	# spill _tmp1441 from $t3 to $fp-1492
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1443 = _tmp1414 - _tmp1442
	lw $t1, -1388($fp)	# load _tmp1414 from $fp-1388 into $t1
	sub $t2, $t1, $t0	
	# _tmp1444 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1445 = *(_tmp1444)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1446 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp1447 = _tmp1446 < _tmp1445
	slt $t7, $t6, $t5	
	# _tmp1448 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1449 = _tmp1448 < _tmp1446
	slt $s1, $s0, $t6	
	# _tmp1450 = _tmp1449 && _tmp1447
	and $s2, $s1, $t7	
	# IfZ _tmp1450 Goto _L238
	# (save modified registers before flow of control change)
	sw $t0, -1496($fp)	# spill _tmp1442 from $t0 to $fp-1496
	sw $t2, -1392($fp)	# spill _tmp1443 from $t2 to $fp-1392
	sw $t4, -1504($fp)	# spill _tmp1444 from $t4 to $fp-1504
	sw $t5, -1508($fp)	# spill _tmp1445 from $t5 to $fp-1508
	sw $t6, -1516($fp)	# spill _tmp1446 from $t6 to $fp-1516
	sw $t7, -1512($fp)	# spill _tmp1447 from $t7 to $fp-1512
	sw $s0, -1520($fp)	# spill _tmp1448 from $s0 to $fp-1520
	sw $s1, -1524($fp)	# spill _tmp1449 from $s1 to $fp-1524
	sw $s2, -1528($fp)	# spill _tmp1450 from $s2 to $fp-1528
	beqz $s2, _L238	# branch if _tmp1450 is zero 
	# _tmp1451 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1452 = _tmp1446 * _tmp1451
	lw $t1, -1516($fp)	# load _tmp1446 from $fp-1516 into $t1
	mul $t2, $t1, $t0	
	# _tmp1453 = _tmp1452 + _tmp1451
	add $t3, $t2, $t0	
	# _tmp1454 = _tmp1444 + _tmp1453
	lw $t4, -1504($fp)	# load _tmp1444 from $fp-1504 into $t4
	add $t5, $t4, $t3	
	# Goto _L239
	# (save modified registers before flow of control change)
	sw $t0, -1532($fp)	# spill _tmp1451 from $t0 to $fp-1532
	sw $t2, -1536($fp)	# spill _tmp1452 from $t2 to $fp-1536
	sw $t3, -1540($fp)	# spill _tmp1453 from $t3 to $fp-1540
	sw $t5, -1540($fp)	# spill _tmp1454 from $t5 to $fp-1540
	b _L239		# unconditional branch
_L238:
	# _tmp1455 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string105: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string105	# load label
	# PushParam _tmp1455
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1544($fp)	# spill _tmp1455 from $t0 to $fp-1544
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L239:
	# _tmp1456 = *(_tmp1454)
	lw $t0, -1540($fp)	# load _tmp1454 from $fp-1540 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1457 = *(_tmp1456)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1458 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1459 = _tmp1458 < _tmp1457
	slt $t4, $t3, $t2	
	# _tmp1460 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1461 = _tmp1460 < _tmp1458
	slt $t6, $t5, $t3	
	# _tmp1462 = _tmp1461 && _tmp1459
	and $t7, $t6, $t4	
	# IfZ _tmp1462 Goto _L240
	# (save modified registers before flow of control change)
	sw $t1, -1548($fp)	# spill _tmp1456 from $t1 to $fp-1548
	sw $t2, -1552($fp)	# spill _tmp1457 from $t2 to $fp-1552
	sw $t3, -1560($fp)	# spill _tmp1458 from $t3 to $fp-1560
	sw $t4, -1556($fp)	# spill _tmp1459 from $t4 to $fp-1556
	sw $t5, -1564($fp)	# spill _tmp1460 from $t5 to $fp-1564
	sw $t6, -1568($fp)	# spill _tmp1461 from $t6 to $fp-1568
	sw $t7, -1572($fp)	# spill _tmp1462 from $t7 to $fp-1572
	beqz $t7, _L240	# branch if _tmp1462 is zero 
	# _tmp1463 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1464 = _tmp1458 * _tmp1463
	lw $t1, -1560($fp)	# load _tmp1458 from $fp-1560 into $t1
	mul $t2, $t1, $t0	
	# _tmp1465 = _tmp1464 + _tmp1463
	add $t3, $t2, $t0	
	# _tmp1466 = _tmp1456 + _tmp1465
	lw $t4, -1548($fp)	# load _tmp1456 from $fp-1548 into $t4
	add $t5, $t4, $t3	
	# Goto _L241
	# (save modified registers before flow of control change)
	sw $t0, -1576($fp)	# spill _tmp1463 from $t0 to $fp-1576
	sw $t2, -1580($fp)	# spill _tmp1464 from $t2 to $fp-1580
	sw $t3, -1584($fp)	# spill _tmp1465 from $t3 to $fp-1584
	sw $t5, -1584($fp)	# spill _tmp1466 from $t5 to $fp-1584
	b _L241		# unconditional branch
_L240:
	# _tmp1467 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string106: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string106	# load label
	# PushParam _tmp1467
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1588($fp)	# spill _tmp1467 from $t0 to $fp-1588
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L241:
	# _tmp1468 = *(_tmp1466)
	lw $t0, -1584($fp)	# load _tmp1466 from $fp-1584 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1469 = *(_tmp1468)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1470 = *(_tmp1469 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1468
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1471 = ACall _tmp1470
	# (save modified registers before flow of control change)
	sw $t1, -1592($fp)	# spill _tmp1468 from $t1 to $fp-1592
	sw $t2, -1596($fp)	# spill _tmp1469 from $t2 to $fp-1596
	sw $t3, -1600($fp)	# spill _tmp1470 from $t3 to $fp-1600
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1472 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1473 = *(_tmp1472)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1474 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp1475 = _tmp1474 < _tmp1473
	slt $t5, $t4, $t3	
	# _tmp1476 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1477 = _tmp1476 < _tmp1474
	slt $t7, $t6, $t4	
	# _tmp1478 = _tmp1477 && _tmp1475
	and $s0, $t7, $t5	
	# IfZ _tmp1478 Goto _L242
	# (save modified registers before flow of control change)
	sw $t0, -1604($fp)	# spill _tmp1471 from $t0 to $fp-1604
	sw $t2, -1608($fp)	# spill _tmp1472 from $t2 to $fp-1608
	sw $t3, -1612($fp)	# spill _tmp1473 from $t3 to $fp-1612
	sw $t4, -1620($fp)	# spill _tmp1474 from $t4 to $fp-1620
	sw $t5, -1616($fp)	# spill _tmp1475 from $t5 to $fp-1616
	sw $t6, -1624($fp)	# spill _tmp1476 from $t6 to $fp-1624
	sw $t7, -1628($fp)	# spill _tmp1477 from $t7 to $fp-1628
	sw $s0, -1632($fp)	# spill _tmp1478 from $s0 to $fp-1632
	beqz $s0, _L242	# branch if _tmp1478 is zero 
	# _tmp1479 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1480 = _tmp1474 * _tmp1479
	lw $t1, -1620($fp)	# load _tmp1474 from $fp-1620 into $t1
	mul $t2, $t1, $t0	
	# _tmp1481 = _tmp1480 + _tmp1479
	add $t3, $t2, $t0	
	# _tmp1482 = _tmp1472 + _tmp1481
	lw $t4, -1608($fp)	# load _tmp1472 from $fp-1608 into $t4
	add $t5, $t4, $t3	
	# Goto _L243
	# (save modified registers before flow of control change)
	sw $t0, -1636($fp)	# spill _tmp1479 from $t0 to $fp-1636
	sw $t2, -1640($fp)	# spill _tmp1480 from $t2 to $fp-1640
	sw $t3, -1644($fp)	# spill _tmp1481 from $t3 to $fp-1644
	sw $t5, -1644($fp)	# spill _tmp1482 from $t5 to $fp-1644
	b _L243		# unconditional branch
_L242:
	# _tmp1483 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string107: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string107	# load label
	# PushParam _tmp1483
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1648($fp)	# spill _tmp1483 from $t0 to $fp-1648
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L243:
	# _tmp1484 = *(_tmp1482)
	lw $t0, -1644($fp)	# load _tmp1482 from $fp-1644 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1485 = *(_tmp1484)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1486 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1487 = _tmp1486 < _tmp1485
	slt $t4, $t3, $t2	
	# _tmp1488 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1489 = _tmp1488 < _tmp1486
	slt $t6, $t5, $t3	
	# _tmp1490 = _tmp1489 && _tmp1487
	and $t7, $t6, $t4	
	# IfZ _tmp1490 Goto _L244
	# (save modified registers before flow of control change)
	sw $t1, -1652($fp)	# spill _tmp1484 from $t1 to $fp-1652
	sw $t2, -1656($fp)	# spill _tmp1485 from $t2 to $fp-1656
	sw $t3, -1664($fp)	# spill _tmp1486 from $t3 to $fp-1664
	sw $t4, -1660($fp)	# spill _tmp1487 from $t4 to $fp-1660
	sw $t5, -1668($fp)	# spill _tmp1488 from $t5 to $fp-1668
	sw $t6, -1672($fp)	# spill _tmp1489 from $t6 to $fp-1672
	sw $t7, -1676($fp)	# spill _tmp1490 from $t7 to $fp-1676
	beqz $t7, _L244	# branch if _tmp1490 is zero 
	# _tmp1491 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1492 = _tmp1486 * _tmp1491
	lw $t1, -1664($fp)	# load _tmp1486 from $fp-1664 into $t1
	mul $t2, $t1, $t0	
	# _tmp1493 = _tmp1492 + _tmp1491
	add $t3, $t2, $t0	
	# _tmp1494 = _tmp1484 + _tmp1493
	lw $t4, -1652($fp)	# load _tmp1484 from $fp-1652 into $t4
	add $t5, $t4, $t3	
	# Goto _L245
	# (save modified registers before flow of control change)
	sw $t0, -1680($fp)	# spill _tmp1491 from $t0 to $fp-1680
	sw $t2, -1684($fp)	# spill _tmp1492 from $t2 to $fp-1684
	sw $t3, -1688($fp)	# spill _tmp1493 from $t3 to $fp-1688
	sw $t5, -1688($fp)	# spill _tmp1494 from $t5 to $fp-1688
	b _L245		# unconditional branch
_L244:
	# _tmp1495 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string108: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string108	# load label
	# PushParam _tmp1495
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1692($fp)	# spill _tmp1495 from $t0 to $fp-1692
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L245:
	# _tmp1496 = *(_tmp1494)
	lw $t0, -1688($fp)	# load _tmp1494 from $fp-1688 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1497 = *(_tmp1496)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1498 = *(_tmp1497 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1496
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1499 = ACall _tmp1498
	# (save modified registers before flow of control change)
	sw $t1, -1696($fp)	# spill _tmp1496 from $t1 to $fp-1696
	sw $t2, -1700($fp)	# spill _tmp1497 from $t2 to $fp-1700
	sw $t3, -1704($fp)	# spill _tmp1498 from $t3 to $fp-1704
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1500 = _tmp1499 && _tmp1471
	lw $t1, -1604($fp)	# load _tmp1471 from $fp-1604 into $t1
	and $t2, $t0, $t1	
	# _tmp1501 = _tmp1500 && _tmp1443
	lw $t3, -1392($fp)	# load _tmp1443 from $fp-1392 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1501 Goto _L232
	# (save modified registers before flow of control change)
	sw $t0, -1708($fp)	# spill _tmp1499 from $t0 to $fp-1708
	sw $t2, -1500($fp)	# spill _tmp1500 from $t2 to $fp-1500
	sw $t4, -1384($fp)	# spill _tmp1501 from $t4 to $fp-1384
	beqz $t4, _L232	# branch if _tmp1501 is zero 
	# _tmp1502 = 1
	li $t0, 1		# load constant value 1 into $t0
	# row = _tmp1502
	move $t1, $t0		# copy value
	# _tmp1503 = 0
	li $t2, 0		# load constant value 0 into $t2
	# column = _tmp1503
	move $t3, $t2		# copy value
	# Goto _L233
	# (save modified registers before flow of control change)
	sw $t0, -1712($fp)	# spill _tmp1502 from $t0 to $fp-1712
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -1716($fp)	# spill _tmp1503 from $t2 to $fp-1716
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L233		# unconditional branch
_L232:
	# _tmp1504 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1505 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1506 = *(_tmp1505)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1507 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp1508 = _tmp1507 < _tmp1506
	slt $t5, $t4, $t3	
	# _tmp1509 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1510 = _tmp1509 < _tmp1507
	slt $t7, $t6, $t4	
	# _tmp1511 = _tmp1510 && _tmp1508
	and $s0, $t7, $t5	
	# IfZ _tmp1511 Goto _L248
	# (save modified registers before flow of control change)
	sw $t0, -1724($fp)	# spill _tmp1504 from $t0 to $fp-1724
	sw $t2, -1732($fp)	# spill _tmp1505 from $t2 to $fp-1732
	sw $t3, -1736($fp)	# spill _tmp1506 from $t3 to $fp-1736
	sw $t4, -1744($fp)	# spill _tmp1507 from $t4 to $fp-1744
	sw $t5, -1740($fp)	# spill _tmp1508 from $t5 to $fp-1740
	sw $t6, -1748($fp)	# spill _tmp1509 from $t6 to $fp-1748
	sw $t7, -1752($fp)	# spill _tmp1510 from $t7 to $fp-1752
	sw $s0, -1756($fp)	# spill _tmp1511 from $s0 to $fp-1756
	beqz $s0, _L248	# branch if _tmp1511 is zero 
	# _tmp1512 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1513 = _tmp1507 * _tmp1512
	lw $t1, -1744($fp)	# load _tmp1507 from $fp-1744 into $t1
	mul $t2, $t1, $t0	
	# _tmp1514 = _tmp1513 + _tmp1512
	add $t3, $t2, $t0	
	# _tmp1515 = _tmp1505 + _tmp1514
	lw $t4, -1732($fp)	# load _tmp1505 from $fp-1732 into $t4
	add $t5, $t4, $t3	
	# Goto _L249
	# (save modified registers before flow of control change)
	sw $t0, -1760($fp)	# spill _tmp1512 from $t0 to $fp-1760
	sw $t2, -1764($fp)	# spill _tmp1513 from $t2 to $fp-1764
	sw $t3, -1768($fp)	# spill _tmp1514 from $t3 to $fp-1768
	sw $t5, -1768($fp)	# spill _tmp1515 from $t5 to $fp-1768
	b _L249		# unconditional branch
_L248:
	# _tmp1516 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string109: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string109	# load label
	# PushParam _tmp1516
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1772($fp)	# spill _tmp1516 from $t0 to $fp-1772
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L249:
	# _tmp1517 = *(_tmp1515)
	lw $t0, -1768($fp)	# load _tmp1515 from $fp-1768 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1518 = *(_tmp1517)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1519 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1520 = _tmp1519 < _tmp1518
	slt $t4, $t3, $t2	
	# _tmp1521 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1522 = _tmp1521 < _tmp1519
	slt $t6, $t5, $t3	
	# _tmp1523 = _tmp1522 && _tmp1520
	and $t7, $t6, $t4	
	# IfZ _tmp1523 Goto _L250
	# (save modified registers before flow of control change)
	sw $t1, -1776($fp)	# spill _tmp1517 from $t1 to $fp-1776
	sw $t2, -1780($fp)	# spill _tmp1518 from $t2 to $fp-1780
	sw $t3, -1788($fp)	# spill _tmp1519 from $t3 to $fp-1788
	sw $t4, -1784($fp)	# spill _tmp1520 from $t4 to $fp-1784
	sw $t5, -1792($fp)	# spill _tmp1521 from $t5 to $fp-1792
	sw $t6, -1796($fp)	# spill _tmp1522 from $t6 to $fp-1796
	sw $t7, -1800($fp)	# spill _tmp1523 from $t7 to $fp-1800
	beqz $t7, _L250	# branch if _tmp1523 is zero 
	# _tmp1524 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1525 = _tmp1519 * _tmp1524
	lw $t1, -1788($fp)	# load _tmp1519 from $fp-1788 into $t1
	mul $t2, $t1, $t0	
	# _tmp1526 = _tmp1525 + _tmp1524
	add $t3, $t2, $t0	
	# _tmp1527 = _tmp1517 + _tmp1526
	lw $t4, -1776($fp)	# load _tmp1517 from $fp-1776 into $t4
	add $t5, $t4, $t3	
	# Goto _L251
	# (save modified registers before flow of control change)
	sw $t0, -1804($fp)	# spill _tmp1524 from $t0 to $fp-1804
	sw $t2, -1808($fp)	# spill _tmp1525 from $t2 to $fp-1808
	sw $t3, -1812($fp)	# spill _tmp1526 from $t3 to $fp-1812
	sw $t5, -1812($fp)	# spill _tmp1527 from $t5 to $fp-1812
	b _L251		# unconditional branch
_L250:
	# _tmp1528 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string110: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string110	# load label
	# PushParam _tmp1528
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1816($fp)	# spill _tmp1528 from $t0 to $fp-1816
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L251:
	# _tmp1529 = *(_tmp1527)
	lw $t0, -1812($fp)	# load _tmp1527 from $fp-1812 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1530 = *(_tmp1529)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1531 = *(_tmp1530 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1529
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1532 = ACall _tmp1531
	# (save modified registers before flow of control change)
	sw $t1, -1820($fp)	# spill _tmp1529 from $t1 to $fp-1820
	sw $t2, -1824($fp)	# spill _tmp1530 from $t2 to $fp-1824
	sw $t3, -1828($fp)	# spill _tmp1531 from $t3 to $fp-1828
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1533 = _tmp1504 - _tmp1532
	lw $t1, -1724($fp)	# load _tmp1504 from $fp-1724 into $t1
	sub $t2, $t1, $t0	
	# _tmp1534 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1535 = *(_tmp1534)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1536 = 2
	li $t6, 2		# load constant value 2 into $t6
	# _tmp1537 = _tmp1536 < _tmp1535
	slt $t7, $t6, $t5	
	# _tmp1538 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1539 = _tmp1538 < _tmp1536
	slt $s1, $s0, $t6	
	# _tmp1540 = _tmp1539 && _tmp1537
	and $s2, $s1, $t7	
	# IfZ _tmp1540 Goto _L252
	# (save modified registers before flow of control change)
	sw $t0, -1832($fp)	# spill _tmp1532 from $t0 to $fp-1832
	sw $t2, -1728($fp)	# spill _tmp1533 from $t2 to $fp-1728
	sw $t4, -1840($fp)	# spill _tmp1534 from $t4 to $fp-1840
	sw $t5, -1844($fp)	# spill _tmp1535 from $t5 to $fp-1844
	sw $t6, -1852($fp)	# spill _tmp1536 from $t6 to $fp-1852
	sw $t7, -1848($fp)	# spill _tmp1537 from $t7 to $fp-1848
	sw $s0, -1856($fp)	# spill _tmp1538 from $s0 to $fp-1856
	sw $s1, -1860($fp)	# spill _tmp1539 from $s1 to $fp-1860
	sw $s2, -1864($fp)	# spill _tmp1540 from $s2 to $fp-1864
	beqz $s2, _L252	# branch if _tmp1540 is zero 
	# _tmp1541 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1542 = _tmp1536 * _tmp1541
	lw $t1, -1852($fp)	# load _tmp1536 from $fp-1852 into $t1
	mul $t2, $t1, $t0	
	# _tmp1543 = _tmp1542 + _tmp1541
	add $t3, $t2, $t0	
	# _tmp1544 = _tmp1534 + _tmp1543
	lw $t4, -1840($fp)	# load _tmp1534 from $fp-1840 into $t4
	add $t5, $t4, $t3	
	# Goto _L253
	# (save modified registers before flow of control change)
	sw $t0, -1868($fp)	# spill _tmp1541 from $t0 to $fp-1868
	sw $t2, -1872($fp)	# spill _tmp1542 from $t2 to $fp-1872
	sw $t3, -1876($fp)	# spill _tmp1543 from $t3 to $fp-1876
	sw $t5, -1876($fp)	# spill _tmp1544 from $t5 to $fp-1876
	b _L253		# unconditional branch
_L252:
	# _tmp1545 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string111: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string111	# load label
	# PushParam _tmp1545
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1880($fp)	# spill _tmp1545 from $t0 to $fp-1880
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L253:
	# _tmp1546 = *(_tmp1544)
	lw $t0, -1876($fp)	# load _tmp1544 from $fp-1876 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1547 = *(_tmp1546)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1548 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1549 = _tmp1548 < _tmp1547
	slt $t4, $t3, $t2	
	# _tmp1550 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1551 = _tmp1550 < _tmp1548
	slt $t6, $t5, $t3	
	# _tmp1552 = _tmp1551 && _tmp1549
	and $t7, $t6, $t4	
	# IfZ _tmp1552 Goto _L254
	# (save modified registers before flow of control change)
	sw $t1, -1884($fp)	# spill _tmp1546 from $t1 to $fp-1884
	sw $t2, -1888($fp)	# spill _tmp1547 from $t2 to $fp-1888
	sw $t3, -1896($fp)	# spill _tmp1548 from $t3 to $fp-1896
	sw $t4, -1892($fp)	# spill _tmp1549 from $t4 to $fp-1892
	sw $t5, -1900($fp)	# spill _tmp1550 from $t5 to $fp-1900
	sw $t6, -1904($fp)	# spill _tmp1551 from $t6 to $fp-1904
	sw $t7, -1908($fp)	# spill _tmp1552 from $t7 to $fp-1908
	beqz $t7, _L254	# branch if _tmp1552 is zero 
	# _tmp1553 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1554 = _tmp1548 * _tmp1553
	lw $t1, -1896($fp)	# load _tmp1548 from $fp-1896 into $t1
	mul $t2, $t1, $t0	
	# _tmp1555 = _tmp1554 + _tmp1553
	add $t3, $t2, $t0	
	# _tmp1556 = _tmp1546 + _tmp1555
	lw $t4, -1884($fp)	# load _tmp1546 from $fp-1884 into $t4
	add $t5, $t4, $t3	
	# Goto _L255
	# (save modified registers before flow of control change)
	sw $t0, -1912($fp)	# spill _tmp1553 from $t0 to $fp-1912
	sw $t2, -1916($fp)	# spill _tmp1554 from $t2 to $fp-1916
	sw $t3, -1920($fp)	# spill _tmp1555 from $t3 to $fp-1920
	sw $t5, -1920($fp)	# spill _tmp1556 from $t5 to $fp-1920
	b _L255		# unconditional branch
_L254:
	# _tmp1557 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string112: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string112	# load label
	# PushParam _tmp1557
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1924($fp)	# spill _tmp1557 from $t0 to $fp-1924
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L255:
	# _tmp1558 = *(_tmp1556)
	lw $t0, -1920($fp)	# load _tmp1556 from $fp-1920 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1559 = *(_tmp1558)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1560 = *(_tmp1559 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1558
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1561 = ACall _tmp1560
	# (save modified registers before flow of control change)
	sw $t1, -1928($fp)	# spill _tmp1558 from $t1 to $fp-1928
	sw $t2, -1932($fp)	# spill _tmp1559 from $t2 to $fp-1932
	sw $t3, -1936($fp)	# spill _tmp1560 from $t3 to $fp-1936
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1562 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1563 = *(_tmp1562)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1564 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp1565 = _tmp1564 < _tmp1563
	slt $t5, $t4, $t3	
	# _tmp1566 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1567 = _tmp1566 < _tmp1564
	slt $t7, $t6, $t4	
	# _tmp1568 = _tmp1567 && _tmp1565
	and $s0, $t7, $t5	
	# IfZ _tmp1568 Goto _L256
	# (save modified registers before flow of control change)
	sw $t0, -1940($fp)	# spill _tmp1561 from $t0 to $fp-1940
	sw $t2, -1944($fp)	# spill _tmp1562 from $t2 to $fp-1944
	sw $t3, -1948($fp)	# spill _tmp1563 from $t3 to $fp-1948
	sw $t4, -1956($fp)	# spill _tmp1564 from $t4 to $fp-1956
	sw $t5, -1952($fp)	# spill _tmp1565 from $t5 to $fp-1952
	sw $t6, -1960($fp)	# spill _tmp1566 from $t6 to $fp-1960
	sw $t7, -1964($fp)	# spill _tmp1567 from $t7 to $fp-1964
	sw $s0, -1968($fp)	# spill _tmp1568 from $s0 to $fp-1968
	beqz $s0, _L256	# branch if _tmp1568 is zero 
	# _tmp1569 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1570 = _tmp1564 * _tmp1569
	lw $t1, -1956($fp)	# load _tmp1564 from $fp-1956 into $t1
	mul $t2, $t1, $t0	
	# _tmp1571 = _tmp1570 + _tmp1569
	add $t3, $t2, $t0	
	# _tmp1572 = _tmp1562 + _tmp1571
	lw $t4, -1944($fp)	# load _tmp1562 from $fp-1944 into $t4
	add $t5, $t4, $t3	
	# Goto _L257
	# (save modified registers before flow of control change)
	sw $t0, -1972($fp)	# spill _tmp1569 from $t0 to $fp-1972
	sw $t2, -1976($fp)	# spill _tmp1570 from $t2 to $fp-1976
	sw $t3, -1980($fp)	# spill _tmp1571 from $t3 to $fp-1980
	sw $t5, -1980($fp)	# spill _tmp1572 from $t5 to $fp-1980
	b _L257		# unconditional branch
_L256:
	# _tmp1573 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string113: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string113	# load label
	# PushParam _tmp1573
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -1984($fp)	# spill _tmp1573 from $t0 to $fp-1984
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L257:
	# _tmp1574 = *(_tmp1572)
	lw $t0, -1980($fp)	# load _tmp1572 from $fp-1980 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1575 = *(_tmp1574)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1576 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1577 = _tmp1576 < _tmp1575
	slt $t4, $t3, $t2	
	# _tmp1578 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1579 = _tmp1578 < _tmp1576
	slt $t6, $t5, $t3	
	# _tmp1580 = _tmp1579 && _tmp1577
	and $t7, $t6, $t4	
	# IfZ _tmp1580 Goto _L258
	# (save modified registers before flow of control change)
	sw $t1, -1988($fp)	# spill _tmp1574 from $t1 to $fp-1988
	sw $t2, -1992($fp)	# spill _tmp1575 from $t2 to $fp-1992
	sw $t3, -2000($fp)	# spill _tmp1576 from $t3 to $fp-2000
	sw $t4, -1996($fp)	# spill _tmp1577 from $t4 to $fp-1996
	sw $t5, -2004($fp)	# spill _tmp1578 from $t5 to $fp-2004
	sw $t6, -2008($fp)	# spill _tmp1579 from $t6 to $fp-2008
	sw $t7, -2012($fp)	# spill _tmp1580 from $t7 to $fp-2012
	beqz $t7, _L258	# branch if _tmp1580 is zero 
	# _tmp1581 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1582 = _tmp1576 * _tmp1581
	lw $t1, -2000($fp)	# load _tmp1576 from $fp-2000 into $t1
	mul $t2, $t1, $t0	
	# _tmp1583 = _tmp1582 + _tmp1581
	add $t3, $t2, $t0	
	# _tmp1584 = _tmp1574 + _tmp1583
	lw $t4, -1988($fp)	# load _tmp1574 from $fp-1988 into $t4
	add $t5, $t4, $t3	
	# Goto _L259
	# (save modified registers before flow of control change)
	sw $t0, -2016($fp)	# spill _tmp1581 from $t0 to $fp-2016
	sw $t2, -2020($fp)	# spill _tmp1582 from $t2 to $fp-2020
	sw $t3, -2024($fp)	# spill _tmp1583 from $t3 to $fp-2024
	sw $t5, -2024($fp)	# spill _tmp1584 from $t5 to $fp-2024
	b _L259		# unconditional branch
_L258:
	# _tmp1585 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string114: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string114	# load label
	# PushParam _tmp1585
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2028($fp)	# spill _tmp1585 from $t0 to $fp-2028
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L259:
	# _tmp1586 = *(_tmp1584)
	lw $t0, -2024($fp)	# load _tmp1584 from $fp-2024 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1587 = *(_tmp1586)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1588 = *(_tmp1587 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1586
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1589 = ACall _tmp1588
	# (save modified registers before flow of control change)
	sw $t1, -2032($fp)	# spill _tmp1586 from $t1 to $fp-2032
	sw $t2, -2036($fp)	# spill _tmp1587 from $t2 to $fp-2036
	sw $t3, -2040($fp)	# spill _tmp1588 from $t3 to $fp-2040
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1590 = _tmp1589 && _tmp1561
	lw $t1, -1940($fp)	# load _tmp1561 from $fp-1940 into $t1
	and $t2, $t0, $t1	
	# _tmp1591 = _tmp1590 && _tmp1533
	lw $t3, -1728($fp)	# load _tmp1533 from $fp-1728 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1591 Goto _L246
	# (save modified registers before flow of control change)
	sw $t0, -2044($fp)	# spill _tmp1589 from $t0 to $fp-2044
	sw $t2, -1836($fp)	# spill _tmp1590 from $t2 to $fp-1836
	sw $t4, -1720($fp)	# spill _tmp1591 from $t4 to $fp-1720
	beqz $t4, _L246	# branch if _tmp1591 is zero 
	# _tmp1592 = 2
	li $t0, 2		# load constant value 2 into $t0
	# row = _tmp1592
	move $t1, $t0		# copy value
	# _tmp1593 = 0
	li $t2, 0		# load constant value 0 into $t2
	# column = _tmp1593
	move $t3, $t2		# copy value
	# Goto _L247
	# (save modified registers before flow of control change)
	sw $t0, -2048($fp)	# spill _tmp1592 from $t0 to $fp-2048
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -2052($fp)	# spill _tmp1593 from $t2 to $fp-2052
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L247		# unconditional branch
_L246:
	# _tmp1594 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1595 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1596 = *(_tmp1595)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1597 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp1598 = _tmp1597 < _tmp1596
	slt $t5, $t4, $t3	
	# _tmp1599 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1600 = _tmp1599 < _tmp1597
	slt $t7, $t6, $t4	
	# _tmp1601 = _tmp1600 && _tmp1598
	and $s0, $t7, $t5	
	# IfZ _tmp1601 Goto _L262
	# (save modified registers before flow of control change)
	sw $t0, -2060($fp)	# spill _tmp1594 from $t0 to $fp-2060
	sw $t2, -2068($fp)	# spill _tmp1595 from $t2 to $fp-2068
	sw $t3, -2072($fp)	# spill _tmp1596 from $t3 to $fp-2072
	sw $t4, -2080($fp)	# spill _tmp1597 from $t4 to $fp-2080
	sw $t5, -2076($fp)	# spill _tmp1598 from $t5 to $fp-2076
	sw $t6, -2084($fp)	# spill _tmp1599 from $t6 to $fp-2084
	sw $t7, -2088($fp)	# spill _tmp1600 from $t7 to $fp-2088
	sw $s0, -2092($fp)	# spill _tmp1601 from $s0 to $fp-2092
	beqz $s0, _L262	# branch if _tmp1601 is zero 
	# _tmp1602 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1603 = _tmp1597 * _tmp1602
	lw $t1, -2080($fp)	# load _tmp1597 from $fp-2080 into $t1
	mul $t2, $t1, $t0	
	# _tmp1604 = _tmp1603 + _tmp1602
	add $t3, $t2, $t0	
	# _tmp1605 = _tmp1595 + _tmp1604
	lw $t4, -2068($fp)	# load _tmp1595 from $fp-2068 into $t4
	add $t5, $t4, $t3	
	# Goto _L263
	# (save modified registers before flow of control change)
	sw $t0, -2096($fp)	# spill _tmp1602 from $t0 to $fp-2096
	sw $t2, -2100($fp)	# spill _tmp1603 from $t2 to $fp-2100
	sw $t3, -2104($fp)	# spill _tmp1604 from $t3 to $fp-2104
	sw $t5, -2104($fp)	# spill _tmp1605 from $t5 to $fp-2104
	b _L263		# unconditional branch
_L262:
	# _tmp1606 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string115: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string115	# load label
	# PushParam _tmp1606
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2108($fp)	# spill _tmp1606 from $t0 to $fp-2108
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L263:
	# _tmp1607 = *(_tmp1605)
	lw $t0, -2104($fp)	# load _tmp1605 from $fp-2104 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1608 = *(_tmp1607)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1609 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1610 = _tmp1609 < _tmp1608
	slt $t4, $t3, $t2	
	# _tmp1611 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1612 = _tmp1611 < _tmp1609
	slt $t6, $t5, $t3	
	# _tmp1613 = _tmp1612 && _tmp1610
	and $t7, $t6, $t4	
	# IfZ _tmp1613 Goto _L264
	# (save modified registers before flow of control change)
	sw $t1, -2112($fp)	# spill _tmp1607 from $t1 to $fp-2112
	sw $t2, -2116($fp)	# spill _tmp1608 from $t2 to $fp-2116
	sw $t3, -2124($fp)	# spill _tmp1609 from $t3 to $fp-2124
	sw $t4, -2120($fp)	# spill _tmp1610 from $t4 to $fp-2120
	sw $t5, -2128($fp)	# spill _tmp1611 from $t5 to $fp-2128
	sw $t6, -2132($fp)	# spill _tmp1612 from $t6 to $fp-2132
	sw $t7, -2136($fp)	# spill _tmp1613 from $t7 to $fp-2136
	beqz $t7, _L264	# branch if _tmp1613 is zero 
	# _tmp1614 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1615 = _tmp1609 * _tmp1614
	lw $t1, -2124($fp)	# load _tmp1609 from $fp-2124 into $t1
	mul $t2, $t1, $t0	
	# _tmp1616 = _tmp1615 + _tmp1614
	add $t3, $t2, $t0	
	# _tmp1617 = _tmp1607 + _tmp1616
	lw $t4, -2112($fp)	# load _tmp1607 from $fp-2112 into $t4
	add $t5, $t4, $t3	
	# Goto _L265
	# (save modified registers before flow of control change)
	sw $t0, -2140($fp)	# spill _tmp1614 from $t0 to $fp-2140
	sw $t2, -2144($fp)	# spill _tmp1615 from $t2 to $fp-2144
	sw $t3, -2148($fp)	# spill _tmp1616 from $t3 to $fp-2148
	sw $t5, -2148($fp)	# spill _tmp1617 from $t5 to $fp-2148
	b _L265		# unconditional branch
_L264:
	# _tmp1618 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string116: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string116	# load label
	# PushParam _tmp1618
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2152($fp)	# spill _tmp1618 from $t0 to $fp-2152
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L265:
	# _tmp1619 = *(_tmp1617)
	lw $t0, -2148($fp)	# load _tmp1617 from $fp-2148 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1620 = *(_tmp1619)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1621 = *(_tmp1620 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1619
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1622 = ACall _tmp1621
	# (save modified registers before flow of control change)
	sw $t1, -2156($fp)	# spill _tmp1619 from $t1 to $fp-2156
	sw $t2, -2160($fp)	# spill _tmp1620 from $t2 to $fp-2160
	sw $t3, -2164($fp)	# spill _tmp1621 from $t3 to $fp-2164
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1623 = _tmp1594 - _tmp1622
	lw $t1, -2060($fp)	# load _tmp1594 from $fp-2060 into $t1
	sub $t2, $t1, $t0	
	# _tmp1624 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1625 = *(_tmp1624)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1626 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp1627 = _tmp1626 < _tmp1625
	slt $t7, $t6, $t5	
	# _tmp1628 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1629 = _tmp1628 < _tmp1626
	slt $s1, $s0, $t6	
	# _tmp1630 = _tmp1629 && _tmp1627
	and $s2, $s1, $t7	
	# IfZ _tmp1630 Goto _L266
	# (save modified registers before flow of control change)
	sw $t0, -2168($fp)	# spill _tmp1622 from $t0 to $fp-2168
	sw $t2, -2064($fp)	# spill _tmp1623 from $t2 to $fp-2064
	sw $t4, -2176($fp)	# spill _tmp1624 from $t4 to $fp-2176
	sw $t5, -2180($fp)	# spill _tmp1625 from $t5 to $fp-2180
	sw $t6, -2188($fp)	# spill _tmp1626 from $t6 to $fp-2188
	sw $t7, -2184($fp)	# spill _tmp1627 from $t7 to $fp-2184
	sw $s0, -2192($fp)	# spill _tmp1628 from $s0 to $fp-2192
	sw $s1, -2196($fp)	# spill _tmp1629 from $s1 to $fp-2196
	sw $s2, -2200($fp)	# spill _tmp1630 from $s2 to $fp-2200
	beqz $s2, _L266	# branch if _tmp1630 is zero 
	# _tmp1631 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1632 = _tmp1626 * _tmp1631
	lw $t1, -2188($fp)	# load _tmp1626 from $fp-2188 into $t1
	mul $t2, $t1, $t0	
	# _tmp1633 = _tmp1632 + _tmp1631
	add $t3, $t2, $t0	
	# _tmp1634 = _tmp1624 + _tmp1633
	lw $t4, -2176($fp)	# load _tmp1624 from $fp-2176 into $t4
	add $t5, $t4, $t3	
	# Goto _L267
	# (save modified registers before flow of control change)
	sw $t0, -2204($fp)	# spill _tmp1631 from $t0 to $fp-2204
	sw $t2, -2208($fp)	# spill _tmp1632 from $t2 to $fp-2208
	sw $t3, -2212($fp)	# spill _tmp1633 from $t3 to $fp-2212
	sw $t5, -2212($fp)	# spill _tmp1634 from $t5 to $fp-2212
	b _L267		# unconditional branch
_L266:
	# _tmp1635 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string117: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string117	# load label
	# PushParam _tmp1635
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2216($fp)	# spill _tmp1635 from $t0 to $fp-2216
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L267:
	# _tmp1636 = *(_tmp1634)
	lw $t0, -2212($fp)	# load _tmp1634 from $fp-2212 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1637 = *(_tmp1636)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1638 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1639 = _tmp1638 < _tmp1637
	slt $t4, $t3, $t2	
	# _tmp1640 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1641 = _tmp1640 < _tmp1638
	slt $t6, $t5, $t3	
	# _tmp1642 = _tmp1641 && _tmp1639
	and $t7, $t6, $t4	
	# IfZ _tmp1642 Goto _L268
	# (save modified registers before flow of control change)
	sw $t1, -2220($fp)	# spill _tmp1636 from $t1 to $fp-2220
	sw $t2, -2224($fp)	# spill _tmp1637 from $t2 to $fp-2224
	sw $t3, -2232($fp)	# spill _tmp1638 from $t3 to $fp-2232
	sw $t4, -2228($fp)	# spill _tmp1639 from $t4 to $fp-2228
	sw $t5, -2236($fp)	# spill _tmp1640 from $t5 to $fp-2236
	sw $t6, -2240($fp)	# spill _tmp1641 from $t6 to $fp-2240
	sw $t7, -2244($fp)	# spill _tmp1642 from $t7 to $fp-2244
	beqz $t7, _L268	# branch if _tmp1642 is zero 
	# _tmp1643 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1644 = _tmp1638 * _tmp1643
	lw $t1, -2232($fp)	# load _tmp1638 from $fp-2232 into $t1
	mul $t2, $t1, $t0	
	# _tmp1645 = _tmp1644 + _tmp1643
	add $t3, $t2, $t0	
	# _tmp1646 = _tmp1636 + _tmp1645
	lw $t4, -2220($fp)	# load _tmp1636 from $fp-2220 into $t4
	add $t5, $t4, $t3	
	# Goto _L269
	# (save modified registers before flow of control change)
	sw $t0, -2248($fp)	# spill _tmp1643 from $t0 to $fp-2248
	sw $t2, -2252($fp)	# spill _tmp1644 from $t2 to $fp-2252
	sw $t3, -2256($fp)	# spill _tmp1645 from $t3 to $fp-2256
	sw $t5, -2256($fp)	# spill _tmp1646 from $t5 to $fp-2256
	b _L269		# unconditional branch
_L268:
	# _tmp1647 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string118: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string118	# load label
	# PushParam _tmp1647
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2260($fp)	# spill _tmp1647 from $t0 to $fp-2260
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L269:
	# _tmp1648 = *(_tmp1646)
	lw $t0, -2256($fp)	# load _tmp1646 from $fp-2256 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1649 = *(_tmp1648)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1650 = *(_tmp1649 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1648
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1651 = ACall _tmp1650
	# (save modified registers before flow of control change)
	sw $t1, -2264($fp)	# spill _tmp1648 from $t1 to $fp-2264
	sw $t2, -2268($fp)	# spill _tmp1649 from $t2 to $fp-2268
	sw $t3, -2272($fp)	# spill _tmp1650 from $t3 to $fp-2272
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1652 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1653 = *(_tmp1652)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1654 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1655 = _tmp1654 < _tmp1653
	slt $t5, $t4, $t3	
	# _tmp1656 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1657 = _tmp1656 < _tmp1654
	slt $t7, $t6, $t4	
	# _tmp1658 = _tmp1657 && _tmp1655
	and $s0, $t7, $t5	
	# IfZ _tmp1658 Goto _L270
	# (save modified registers before flow of control change)
	sw $t0, -2276($fp)	# spill _tmp1651 from $t0 to $fp-2276
	sw $t2, -2280($fp)	# spill _tmp1652 from $t2 to $fp-2280
	sw $t3, -2284($fp)	# spill _tmp1653 from $t3 to $fp-2284
	sw $t4, -2292($fp)	# spill _tmp1654 from $t4 to $fp-2292
	sw $t5, -2288($fp)	# spill _tmp1655 from $t5 to $fp-2288
	sw $t6, -2296($fp)	# spill _tmp1656 from $t6 to $fp-2296
	sw $t7, -2300($fp)	# spill _tmp1657 from $t7 to $fp-2300
	sw $s0, -2304($fp)	# spill _tmp1658 from $s0 to $fp-2304
	beqz $s0, _L270	# branch if _tmp1658 is zero 
	# _tmp1659 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1660 = _tmp1654 * _tmp1659
	lw $t1, -2292($fp)	# load _tmp1654 from $fp-2292 into $t1
	mul $t2, $t1, $t0	
	# _tmp1661 = _tmp1660 + _tmp1659
	add $t3, $t2, $t0	
	# _tmp1662 = _tmp1652 + _tmp1661
	lw $t4, -2280($fp)	# load _tmp1652 from $fp-2280 into $t4
	add $t5, $t4, $t3	
	# Goto _L271
	# (save modified registers before flow of control change)
	sw $t0, -2308($fp)	# spill _tmp1659 from $t0 to $fp-2308
	sw $t2, -2312($fp)	# spill _tmp1660 from $t2 to $fp-2312
	sw $t3, -2316($fp)	# spill _tmp1661 from $t3 to $fp-2316
	sw $t5, -2316($fp)	# spill _tmp1662 from $t5 to $fp-2316
	b _L271		# unconditional branch
_L270:
	# _tmp1663 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string119: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string119	# load label
	# PushParam _tmp1663
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2320($fp)	# spill _tmp1663 from $t0 to $fp-2320
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L271:
	# _tmp1664 = *(_tmp1662)
	lw $t0, -2316($fp)	# load _tmp1662 from $fp-2316 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1665 = *(_tmp1664)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1666 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1667 = _tmp1666 < _tmp1665
	slt $t4, $t3, $t2	
	# _tmp1668 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1669 = _tmp1668 < _tmp1666
	slt $t6, $t5, $t3	
	# _tmp1670 = _tmp1669 && _tmp1667
	and $t7, $t6, $t4	
	# IfZ _tmp1670 Goto _L272
	# (save modified registers before flow of control change)
	sw $t1, -2324($fp)	# spill _tmp1664 from $t1 to $fp-2324
	sw $t2, -2328($fp)	# spill _tmp1665 from $t2 to $fp-2328
	sw $t3, -2336($fp)	# spill _tmp1666 from $t3 to $fp-2336
	sw $t4, -2332($fp)	# spill _tmp1667 from $t4 to $fp-2332
	sw $t5, -2340($fp)	# spill _tmp1668 from $t5 to $fp-2340
	sw $t6, -2344($fp)	# spill _tmp1669 from $t6 to $fp-2344
	sw $t7, -2348($fp)	# spill _tmp1670 from $t7 to $fp-2348
	beqz $t7, _L272	# branch if _tmp1670 is zero 
	# _tmp1671 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1672 = _tmp1666 * _tmp1671
	lw $t1, -2336($fp)	# load _tmp1666 from $fp-2336 into $t1
	mul $t2, $t1, $t0	
	# _tmp1673 = _tmp1672 + _tmp1671
	add $t3, $t2, $t0	
	# _tmp1674 = _tmp1664 + _tmp1673
	lw $t4, -2324($fp)	# load _tmp1664 from $fp-2324 into $t4
	add $t5, $t4, $t3	
	# Goto _L273
	# (save modified registers before flow of control change)
	sw $t0, -2352($fp)	# spill _tmp1671 from $t0 to $fp-2352
	sw $t2, -2356($fp)	# spill _tmp1672 from $t2 to $fp-2356
	sw $t3, -2360($fp)	# spill _tmp1673 from $t3 to $fp-2360
	sw $t5, -2360($fp)	# spill _tmp1674 from $t5 to $fp-2360
	b _L273		# unconditional branch
_L272:
	# _tmp1675 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string120: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string120	# load label
	# PushParam _tmp1675
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2364($fp)	# spill _tmp1675 from $t0 to $fp-2364
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L273:
	# _tmp1676 = *(_tmp1674)
	lw $t0, -2360($fp)	# load _tmp1674 from $fp-2360 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1677 = *(_tmp1676)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1678 = *(_tmp1677 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1676
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1679 = ACall _tmp1678
	# (save modified registers before flow of control change)
	sw $t1, -2368($fp)	# spill _tmp1676 from $t1 to $fp-2368
	sw $t2, -2372($fp)	# spill _tmp1677 from $t2 to $fp-2372
	sw $t3, -2376($fp)	# spill _tmp1678 from $t3 to $fp-2376
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1680 = _tmp1679 && _tmp1651
	lw $t1, -2276($fp)	# load _tmp1651 from $fp-2276 into $t1
	and $t2, $t0, $t1	
	# _tmp1681 = _tmp1680 && _tmp1623
	lw $t3, -2064($fp)	# load _tmp1623 from $fp-2064 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1681 Goto _L260
	# (save modified registers before flow of control change)
	sw $t0, -2380($fp)	# spill _tmp1679 from $t0 to $fp-2380
	sw $t2, -2172($fp)	# spill _tmp1680 from $t2 to $fp-2172
	sw $t4, -2056($fp)	# spill _tmp1681 from $t4 to $fp-2056
	beqz $t4, _L260	# branch if _tmp1681 is zero 
	# _tmp1682 = 2
	li $t0, 2		# load constant value 2 into $t0
	# row = _tmp1682
	move $t1, $t0		# copy value
	# _tmp1683 = 0
	li $t2, 0		# load constant value 0 into $t2
	# column = _tmp1683
	move $t3, $t2		# copy value
	# Goto _L261
	# (save modified registers before flow of control change)
	sw $t0, -2384($fp)	# spill _tmp1682 from $t0 to $fp-2384
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -2388($fp)	# spill _tmp1683 from $t2 to $fp-2388
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L261		# unconditional branch
_L260:
	# _tmp1684 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1685 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1686 = *(_tmp1685)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1687 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp1688 = _tmp1687 < _tmp1686
	slt $t5, $t4, $t3	
	# _tmp1689 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1690 = _tmp1689 < _tmp1687
	slt $t7, $t6, $t4	
	# _tmp1691 = _tmp1690 && _tmp1688
	and $s0, $t7, $t5	
	# IfZ _tmp1691 Goto _L276
	# (save modified registers before flow of control change)
	sw $t0, -2396($fp)	# spill _tmp1684 from $t0 to $fp-2396
	sw $t2, -2404($fp)	# spill _tmp1685 from $t2 to $fp-2404
	sw $t3, -2408($fp)	# spill _tmp1686 from $t3 to $fp-2408
	sw $t4, -2416($fp)	# spill _tmp1687 from $t4 to $fp-2416
	sw $t5, -2412($fp)	# spill _tmp1688 from $t5 to $fp-2412
	sw $t6, -2420($fp)	# spill _tmp1689 from $t6 to $fp-2420
	sw $t7, -2424($fp)	# spill _tmp1690 from $t7 to $fp-2424
	sw $s0, -2428($fp)	# spill _tmp1691 from $s0 to $fp-2428
	beqz $s0, _L276	# branch if _tmp1691 is zero 
	# _tmp1692 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1693 = _tmp1687 * _tmp1692
	lw $t1, -2416($fp)	# load _tmp1687 from $fp-2416 into $t1
	mul $t2, $t1, $t0	
	# _tmp1694 = _tmp1693 + _tmp1692
	add $t3, $t2, $t0	
	# _tmp1695 = _tmp1685 + _tmp1694
	lw $t4, -2404($fp)	# load _tmp1685 from $fp-2404 into $t4
	add $t5, $t4, $t3	
	# Goto _L277
	# (save modified registers before flow of control change)
	sw $t0, -2432($fp)	# spill _tmp1692 from $t0 to $fp-2432
	sw $t2, -2436($fp)	# spill _tmp1693 from $t2 to $fp-2436
	sw $t3, -2440($fp)	# spill _tmp1694 from $t3 to $fp-2440
	sw $t5, -2440($fp)	# spill _tmp1695 from $t5 to $fp-2440
	b _L277		# unconditional branch
_L276:
	# _tmp1696 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string121: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string121	# load label
	# PushParam _tmp1696
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2444($fp)	# spill _tmp1696 from $t0 to $fp-2444
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L277:
	# _tmp1697 = *(_tmp1695)
	lw $t0, -2440($fp)	# load _tmp1695 from $fp-2440 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1698 = *(_tmp1697)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1699 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1700 = _tmp1699 < _tmp1698
	slt $t4, $t3, $t2	
	# _tmp1701 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1702 = _tmp1701 < _tmp1699
	slt $t6, $t5, $t3	
	# _tmp1703 = _tmp1702 && _tmp1700
	and $t7, $t6, $t4	
	# IfZ _tmp1703 Goto _L278
	# (save modified registers before flow of control change)
	sw $t1, -2448($fp)	# spill _tmp1697 from $t1 to $fp-2448
	sw $t2, -2452($fp)	# spill _tmp1698 from $t2 to $fp-2452
	sw $t3, -2460($fp)	# spill _tmp1699 from $t3 to $fp-2460
	sw $t4, -2456($fp)	# spill _tmp1700 from $t4 to $fp-2456
	sw $t5, -2464($fp)	# spill _tmp1701 from $t5 to $fp-2464
	sw $t6, -2468($fp)	# spill _tmp1702 from $t6 to $fp-2468
	sw $t7, -2472($fp)	# spill _tmp1703 from $t7 to $fp-2472
	beqz $t7, _L278	# branch if _tmp1703 is zero 
	# _tmp1704 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1705 = _tmp1699 * _tmp1704
	lw $t1, -2460($fp)	# load _tmp1699 from $fp-2460 into $t1
	mul $t2, $t1, $t0	
	# _tmp1706 = _tmp1705 + _tmp1704
	add $t3, $t2, $t0	
	# _tmp1707 = _tmp1697 + _tmp1706
	lw $t4, -2448($fp)	# load _tmp1697 from $fp-2448 into $t4
	add $t5, $t4, $t3	
	# Goto _L279
	# (save modified registers before flow of control change)
	sw $t0, -2476($fp)	# spill _tmp1704 from $t0 to $fp-2476
	sw $t2, -2480($fp)	# spill _tmp1705 from $t2 to $fp-2480
	sw $t3, -2484($fp)	# spill _tmp1706 from $t3 to $fp-2484
	sw $t5, -2484($fp)	# spill _tmp1707 from $t5 to $fp-2484
	b _L279		# unconditional branch
_L278:
	# _tmp1708 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string122: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string122	# load label
	# PushParam _tmp1708
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2488($fp)	# spill _tmp1708 from $t0 to $fp-2488
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L279:
	# _tmp1709 = *(_tmp1707)
	lw $t0, -2484($fp)	# load _tmp1707 from $fp-2484 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1710 = *(_tmp1709)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1711 = *(_tmp1710 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1709
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1712 = ACall _tmp1711
	# (save modified registers before flow of control change)
	sw $t1, -2492($fp)	# spill _tmp1709 from $t1 to $fp-2492
	sw $t2, -2496($fp)	# spill _tmp1710 from $t2 to $fp-2496
	sw $t3, -2500($fp)	# spill _tmp1711 from $t3 to $fp-2500
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1713 = _tmp1684 - _tmp1712
	lw $t1, -2396($fp)	# load _tmp1684 from $fp-2396 into $t1
	sub $t2, $t1, $t0	
	# _tmp1714 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1715 = *(_tmp1714)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1716 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp1717 = _tmp1716 < _tmp1715
	slt $t7, $t6, $t5	
	# _tmp1718 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1719 = _tmp1718 < _tmp1716
	slt $s1, $s0, $t6	
	# _tmp1720 = _tmp1719 && _tmp1717
	and $s2, $s1, $t7	
	# IfZ _tmp1720 Goto _L280
	# (save modified registers before flow of control change)
	sw $t0, -2504($fp)	# spill _tmp1712 from $t0 to $fp-2504
	sw $t2, -2400($fp)	# spill _tmp1713 from $t2 to $fp-2400
	sw $t4, -2512($fp)	# spill _tmp1714 from $t4 to $fp-2512
	sw $t5, -2516($fp)	# spill _tmp1715 from $t5 to $fp-2516
	sw $t6, -2524($fp)	# spill _tmp1716 from $t6 to $fp-2524
	sw $t7, -2520($fp)	# spill _tmp1717 from $t7 to $fp-2520
	sw $s0, -2528($fp)	# spill _tmp1718 from $s0 to $fp-2528
	sw $s1, -2532($fp)	# spill _tmp1719 from $s1 to $fp-2532
	sw $s2, -2536($fp)	# spill _tmp1720 from $s2 to $fp-2536
	beqz $s2, _L280	# branch if _tmp1720 is zero 
	# _tmp1721 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1722 = _tmp1716 * _tmp1721
	lw $t1, -2524($fp)	# load _tmp1716 from $fp-2524 into $t1
	mul $t2, $t1, $t0	
	# _tmp1723 = _tmp1722 + _tmp1721
	add $t3, $t2, $t0	
	# _tmp1724 = _tmp1714 + _tmp1723
	lw $t4, -2512($fp)	# load _tmp1714 from $fp-2512 into $t4
	add $t5, $t4, $t3	
	# Goto _L281
	# (save modified registers before flow of control change)
	sw $t0, -2540($fp)	# spill _tmp1721 from $t0 to $fp-2540
	sw $t2, -2544($fp)	# spill _tmp1722 from $t2 to $fp-2544
	sw $t3, -2548($fp)	# spill _tmp1723 from $t3 to $fp-2548
	sw $t5, -2548($fp)	# spill _tmp1724 from $t5 to $fp-2548
	b _L281		# unconditional branch
_L280:
	# _tmp1725 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string123: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string123	# load label
	# PushParam _tmp1725
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2552($fp)	# spill _tmp1725 from $t0 to $fp-2552
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L281:
	# _tmp1726 = *(_tmp1724)
	lw $t0, -2548($fp)	# load _tmp1724 from $fp-2548 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1727 = *(_tmp1726)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1728 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1729 = _tmp1728 < _tmp1727
	slt $t4, $t3, $t2	
	# _tmp1730 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1731 = _tmp1730 < _tmp1728
	slt $t6, $t5, $t3	
	# _tmp1732 = _tmp1731 && _tmp1729
	and $t7, $t6, $t4	
	# IfZ _tmp1732 Goto _L282
	# (save modified registers before flow of control change)
	sw $t1, -2556($fp)	# spill _tmp1726 from $t1 to $fp-2556
	sw $t2, -2560($fp)	# spill _tmp1727 from $t2 to $fp-2560
	sw $t3, -2568($fp)	# spill _tmp1728 from $t3 to $fp-2568
	sw $t4, -2564($fp)	# spill _tmp1729 from $t4 to $fp-2564
	sw $t5, -2572($fp)	# spill _tmp1730 from $t5 to $fp-2572
	sw $t6, -2576($fp)	# spill _tmp1731 from $t6 to $fp-2576
	sw $t7, -2580($fp)	# spill _tmp1732 from $t7 to $fp-2580
	beqz $t7, _L282	# branch if _tmp1732 is zero 
	# _tmp1733 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1734 = _tmp1728 * _tmp1733
	lw $t1, -2568($fp)	# load _tmp1728 from $fp-2568 into $t1
	mul $t2, $t1, $t0	
	# _tmp1735 = _tmp1734 + _tmp1733
	add $t3, $t2, $t0	
	# _tmp1736 = _tmp1726 + _tmp1735
	lw $t4, -2556($fp)	# load _tmp1726 from $fp-2556 into $t4
	add $t5, $t4, $t3	
	# Goto _L283
	# (save modified registers before flow of control change)
	sw $t0, -2584($fp)	# spill _tmp1733 from $t0 to $fp-2584
	sw $t2, -2588($fp)	# spill _tmp1734 from $t2 to $fp-2588
	sw $t3, -2592($fp)	# spill _tmp1735 from $t3 to $fp-2592
	sw $t5, -2592($fp)	# spill _tmp1736 from $t5 to $fp-2592
	b _L283		# unconditional branch
_L282:
	# _tmp1737 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string124: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string124	# load label
	# PushParam _tmp1737
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2596($fp)	# spill _tmp1737 from $t0 to $fp-2596
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L283:
	# _tmp1738 = *(_tmp1736)
	lw $t0, -2592($fp)	# load _tmp1736 from $fp-2592 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1739 = *(_tmp1738)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1740 = *(_tmp1739 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1738
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1741 = ACall _tmp1740
	# (save modified registers before flow of control change)
	sw $t1, -2600($fp)	# spill _tmp1738 from $t1 to $fp-2600
	sw $t2, -2604($fp)	# spill _tmp1739 from $t2 to $fp-2604
	sw $t3, -2608($fp)	# spill _tmp1740 from $t3 to $fp-2608
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1742 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1743 = *(_tmp1742)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1744 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1745 = _tmp1744 < _tmp1743
	slt $t5, $t4, $t3	
	# _tmp1746 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1747 = _tmp1746 < _tmp1744
	slt $t7, $t6, $t4	
	# _tmp1748 = _tmp1747 && _tmp1745
	and $s0, $t7, $t5	
	# IfZ _tmp1748 Goto _L284
	# (save modified registers before flow of control change)
	sw $t0, -2612($fp)	# spill _tmp1741 from $t0 to $fp-2612
	sw $t2, -2616($fp)	# spill _tmp1742 from $t2 to $fp-2616
	sw $t3, -2620($fp)	# spill _tmp1743 from $t3 to $fp-2620
	sw $t4, -2628($fp)	# spill _tmp1744 from $t4 to $fp-2628
	sw $t5, -2624($fp)	# spill _tmp1745 from $t5 to $fp-2624
	sw $t6, -2632($fp)	# spill _tmp1746 from $t6 to $fp-2632
	sw $t7, -2636($fp)	# spill _tmp1747 from $t7 to $fp-2636
	sw $s0, -2640($fp)	# spill _tmp1748 from $s0 to $fp-2640
	beqz $s0, _L284	# branch if _tmp1748 is zero 
	# _tmp1749 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1750 = _tmp1744 * _tmp1749
	lw $t1, -2628($fp)	# load _tmp1744 from $fp-2628 into $t1
	mul $t2, $t1, $t0	
	# _tmp1751 = _tmp1750 + _tmp1749
	add $t3, $t2, $t0	
	# _tmp1752 = _tmp1742 + _tmp1751
	lw $t4, -2616($fp)	# load _tmp1742 from $fp-2616 into $t4
	add $t5, $t4, $t3	
	# Goto _L285
	# (save modified registers before flow of control change)
	sw $t0, -2644($fp)	# spill _tmp1749 from $t0 to $fp-2644
	sw $t2, -2648($fp)	# spill _tmp1750 from $t2 to $fp-2648
	sw $t3, -2652($fp)	# spill _tmp1751 from $t3 to $fp-2652
	sw $t5, -2652($fp)	# spill _tmp1752 from $t5 to $fp-2652
	b _L285		# unconditional branch
_L284:
	# _tmp1753 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string125: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string125	# load label
	# PushParam _tmp1753
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2656($fp)	# spill _tmp1753 from $t0 to $fp-2656
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L285:
	# _tmp1754 = *(_tmp1752)
	lw $t0, -2652($fp)	# load _tmp1752 from $fp-2652 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1755 = *(_tmp1754)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1756 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1757 = _tmp1756 < _tmp1755
	slt $t4, $t3, $t2	
	# _tmp1758 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1759 = _tmp1758 < _tmp1756
	slt $t6, $t5, $t3	
	# _tmp1760 = _tmp1759 && _tmp1757
	and $t7, $t6, $t4	
	# IfZ _tmp1760 Goto _L286
	# (save modified registers before flow of control change)
	sw $t1, -2660($fp)	# spill _tmp1754 from $t1 to $fp-2660
	sw $t2, -2664($fp)	# spill _tmp1755 from $t2 to $fp-2664
	sw $t3, -2672($fp)	# spill _tmp1756 from $t3 to $fp-2672
	sw $t4, -2668($fp)	# spill _tmp1757 from $t4 to $fp-2668
	sw $t5, -2676($fp)	# spill _tmp1758 from $t5 to $fp-2676
	sw $t6, -2680($fp)	# spill _tmp1759 from $t6 to $fp-2680
	sw $t7, -2684($fp)	# spill _tmp1760 from $t7 to $fp-2684
	beqz $t7, _L286	# branch if _tmp1760 is zero 
	# _tmp1761 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1762 = _tmp1756 * _tmp1761
	lw $t1, -2672($fp)	# load _tmp1756 from $fp-2672 into $t1
	mul $t2, $t1, $t0	
	# _tmp1763 = _tmp1762 + _tmp1761
	add $t3, $t2, $t0	
	# _tmp1764 = _tmp1754 + _tmp1763
	lw $t4, -2660($fp)	# load _tmp1754 from $fp-2660 into $t4
	add $t5, $t4, $t3	
	# Goto _L287
	# (save modified registers before flow of control change)
	sw $t0, -2688($fp)	# spill _tmp1761 from $t0 to $fp-2688
	sw $t2, -2692($fp)	# spill _tmp1762 from $t2 to $fp-2692
	sw $t3, -2696($fp)	# spill _tmp1763 from $t3 to $fp-2696
	sw $t5, -2696($fp)	# spill _tmp1764 from $t5 to $fp-2696
	b _L287		# unconditional branch
_L286:
	# _tmp1765 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string126: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string126	# load label
	# PushParam _tmp1765
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2700($fp)	# spill _tmp1765 from $t0 to $fp-2700
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L287:
	# _tmp1766 = *(_tmp1764)
	lw $t0, -2696($fp)	# load _tmp1764 from $fp-2696 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1767 = *(_tmp1766)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1768 = *(_tmp1767 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1766
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1769 = ACall _tmp1768
	# (save modified registers before flow of control change)
	sw $t1, -2704($fp)	# spill _tmp1766 from $t1 to $fp-2704
	sw $t2, -2708($fp)	# spill _tmp1767 from $t2 to $fp-2708
	sw $t3, -2712($fp)	# spill _tmp1768 from $t3 to $fp-2712
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1770 = _tmp1769 && _tmp1741
	lw $t1, -2612($fp)	# load _tmp1741 from $fp-2612 into $t1
	and $t2, $t0, $t1	
	# _tmp1771 = _tmp1770 && _tmp1713
	lw $t3, -2400($fp)	# load _tmp1713 from $fp-2400 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1771 Goto _L274
	# (save modified registers before flow of control change)
	sw $t0, -2716($fp)	# spill _tmp1769 from $t0 to $fp-2716
	sw $t2, -2508($fp)	# spill _tmp1770 from $t2 to $fp-2508
	sw $t4, -2392($fp)	# spill _tmp1771 from $t4 to $fp-2392
	beqz $t4, _L274	# branch if _tmp1771 is zero 
	# _tmp1772 = 2
	li $t0, 2		# load constant value 2 into $t0
	# row = _tmp1772
	move $t1, $t0		# copy value
	# _tmp1773 = 1
	li $t2, 1		# load constant value 1 into $t2
	# column = _tmp1773
	move $t3, $t2		# copy value
	# Goto _L275
	# (save modified registers before flow of control change)
	sw $t0, -2720($fp)	# spill _tmp1772 from $t0 to $fp-2720
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -2724($fp)	# spill _tmp1773 from $t2 to $fp-2724
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L275		# unconditional branch
_L274:
	# _tmp1774 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1775 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1776 = *(_tmp1775)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1777 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp1778 = _tmp1777 < _tmp1776
	slt $t5, $t4, $t3	
	# _tmp1779 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1780 = _tmp1779 < _tmp1777
	slt $t7, $t6, $t4	
	# _tmp1781 = _tmp1780 && _tmp1778
	and $s0, $t7, $t5	
	# IfZ _tmp1781 Goto _L290
	# (save modified registers before flow of control change)
	sw $t0, -2732($fp)	# spill _tmp1774 from $t0 to $fp-2732
	sw $t2, -2740($fp)	# spill _tmp1775 from $t2 to $fp-2740
	sw $t3, -2744($fp)	# spill _tmp1776 from $t3 to $fp-2744
	sw $t4, -2752($fp)	# spill _tmp1777 from $t4 to $fp-2752
	sw $t5, -2748($fp)	# spill _tmp1778 from $t5 to $fp-2748
	sw $t6, -2756($fp)	# spill _tmp1779 from $t6 to $fp-2756
	sw $t7, -2760($fp)	# spill _tmp1780 from $t7 to $fp-2760
	sw $s0, -2764($fp)	# spill _tmp1781 from $s0 to $fp-2764
	beqz $s0, _L290	# branch if _tmp1781 is zero 
	# _tmp1782 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1783 = _tmp1777 * _tmp1782
	lw $t1, -2752($fp)	# load _tmp1777 from $fp-2752 into $t1
	mul $t2, $t1, $t0	
	# _tmp1784 = _tmp1783 + _tmp1782
	add $t3, $t2, $t0	
	# _tmp1785 = _tmp1775 + _tmp1784
	lw $t4, -2740($fp)	# load _tmp1775 from $fp-2740 into $t4
	add $t5, $t4, $t3	
	# Goto _L291
	# (save modified registers before flow of control change)
	sw $t0, -2768($fp)	# spill _tmp1782 from $t0 to $fp-2768
	sw $t2, -2772($fp)	# spill _tmp1783 from $t2 to $fp-2772
	sw $t3, -2776($fp)	# spill _tmp1784 from $t3 to $fp-2776
	sw $t5, -2776($fp)	# spill _tmp1785 from $t5 to $fp-2776
	b _L291		# unconditional branch
_L290:
	# _tmp1786 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string127: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string127	# load label
	# PushParam _tmp1786
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2780($fp)	# spill _tmp1786 from $t0 to $fp-2780
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L291:
	# _tmp1787 = *(_tmp1785)
	lw $t0, -2776($fp)	# load _tmp1785 from $fp-2776 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1788 = *(_tmp1787)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1789 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1790 = _tmp1789 < _tmp1788
	slt $t4, $t3, $t2	
	# _tmp1791 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1792 = _tmp1791 < _tmp1789
	slt $t6, $t5, $t3	
	# _tmp1793 = _tmp1792 && _tmp1790
	and $t7, $t6, $t4	
	# IfZ _tmp1793 Goto _L292
	# (save modified registers before flow of control change)
	sw $t1, -2784($fp)	# spill _tmp1787 from $t1 to $fp-2784
	sw $t2, -2788($fp)	# spill _tmp1788 from $t2 to $fp-2788
	sw $t3, -2796($fp)	# spill _tmp1789 from $t3 to $fp-2796
	sw $t4, -2792($fp)	# spill _tmp1790 from $t4 to $fp-2792
	sw $t5, -2800($fp)	# spill _tmp1791 from $t5 to $fp-2800
	sw $t6, -2804($fp)	# spill _tmp1792 from $t6 to $fp-2804
	sw $t7, -2808($fp)	# spill _tmp1793 from $t7 to $fp-2808
	beqz $t7, _L292	# branch if _tmp1793 is zero 
	# _tmp1794 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1795 = _tmp1789 * _tmp1794
	lw $t1, -2796($fp)	# load _tmp1789 from $fp-2796 into $t1
	mul $t2, $t1, $t0	
	# _tmp1796 = _tmp1795 + _tmp1794
	add $t3, $t2, $t0	
	# _tmp1797 = _tmp1787 + _tmp1796
	lw $t4, -2784($fp)	# load _tmp1787 from $fp-2784 into $t4
	add $t5, $t4, $t3	
	# Goto _L293
	# (save modified registers before flow of control change)
	sw $t0, -2812($fp)	# spill _tmp1794 from $t0 to $fp-2812
	sw $t2, -2816($fp)	# spill _tmp1795 from $t2 to $fp-2816
	sw $t3, -2820($fp)	# spill _tmp1796 from $t3 to $fp-2820
	sw $t5, -2820($fp)	# spill _tmp1797 from $t5 to $fp-2820
	b _L293		# unconditional branch
_L292:
	# _tmp1798 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string128: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string128	# load label
	# PushParam _tmp1798
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2824($fp)	# spill _tmp1798 from $t0 to $fp-2824
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L293:
	# _tmp1799 = *(_tmp1797)
	lw $t0, -2820($fp)	# load _tmp1797 from $fp-2820 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1800 = *(_tmp1799)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1801 = *(_tmp1800 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1799
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1802 = ACall _tmp1801
	# (save modified registers before flow of control change)
	sw $t1, -2828($fp)	# spill _tmp1799 from $t1 to $fp-2828
	sw $t2, -2832($fp)	# spill _tmp1800 from $t2 to $fp-2832
	sw $t3, -2836($fp)	# spill _tmp1801 from $t3 to $fp-2836
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1803 = _tmp1774 - _tmp1802
	lw $t1, -2732($fp)	# load _tmp1774 from $fp-2732 into $t1
	sub $t2, $t1, $t0	
	# _tmp1804 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1805 = *(_tmp1804)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1806 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp1807 = _tmp1806 < _tmp1805
	slt $t7, $t6, $t5	
	# _tmp1808 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1809 = _tmp1808 < _tmp1806
	slt $s1, $s0, $t6	
	# _tmp1810 = _tmp1809 && _tmp1807
	and $s2, $s1, $t7	
	# IfZ _tmp1810 Goto _L294
	# (save modified registers before flow of control change)
	sw $t0, -2840($fp)	# spill _tmp1802 from $t0 to $fp-2840
	sw $t2, -2736($fp)	# spill _tmp1803 from $t2 to $fp-2736
	sw $t4, -2848($fp)	# spill _tmp1804 from $t4 to $fp-2848
	sw $t5, -2852($fp)	# spill _tmp1805 from $t5 to $fp-2852
	sw $t6, -2860($fp)	# spill _tmp1806 from $t6 to $fp-2860
	sw $t7, -2856($fp)	# spill _tmp1807 from $t7 to $fp-2856
	sw $s0, -2864($fp)	# spill _tmp1808 from $s0 to $fp-2864
	sw $s1, -2868($fp)	# spill _tmp1809 from $s1 to $fp-2868
	sw $s2, -2872($fp)	# spill _tmp1810 from $s2 to $fp-2872
	beqz $s2, _L294	# branch if _tmp1810 is zero 
	# _tmp1811 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1812 = _tmp1806 * _tmp1811
	lw $t1, -2860($fp)	# load _tmp1806 from $fp-2860 into $t1
	mul $t2, $t1, $t0	
	# _tmp1813 = _tmp1812 + _tmp1811
	add $t3, $t2, $t0	
	# _tmp1814 = _tmp1804 + _tmp1813
	lw $t4, -2848($fp)	# load _tmp1804 from $fp-2848 into $t4
	add $t5, $t4, $t3	
	# Goto _L295
	# (save modified registers before flow of control change)
	sw $t0, -2876($fp)	# spill _tmp1811 from $t0 to $fp-2876
	sw $t2, -2880($fp)	# spill _tmp1812 from $t2 to $fp-2880
	sw $t3, -2884($fp)	# spill _tmp1813 from $t3 to $fp-2884
	sw $t5, -2884($fp)	# spill _tmp1814 from $t5 to $fp-2884
	b _L295		# unconditional branch
_L294:
	# _tmp1815 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string129: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string129	# load label
	# PushParam _tmp1815
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2888($fp)	# spill _tmp1815 from $t0 to $fp-2888
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L295:
	# _tmp1816 = *(_tmp1814)
	lw $t0, -2884($fp)	# load _tmp1814 from $fp-2884 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1817 = *(_tmp1816)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1818 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1819 = _tmp1818 < _tmp1817
	slt $t4, $t3, $t2	
	# _tmp1820 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1821 = _tmp1820 < _tmp1818
	slt $t6, $t5, $t3	
	# _tmp1822 = _tmp1821 && _tmp1819
	and $t7, $t6, $t4	
	# IfZ _tmp1822 Goto _L296
	# (save modified registers before flow of control change)
	sw $t1, -2892($fp)	# spill _tmp1816 from $t1 to $fp-2892
	sw $t2, -2896($fp)	# spill _tmp1817 from $t2 to $fp-2896
	sw $t3, -2904($fp)	# spill _tmp1818 from $t3 to $fp-2904
	sw $t4, -2900($fp)	# spill _tmp1819 from $t4 to $fp-2900
	sw $t5, -2908($fp)	# spill _tmp1820 from $t5 to $fp-2908
	sw $t6, -2912($fp)	# spill _tmp1821 from $t6 to $fp-2912
	sw $t7, -2916($fp)	# spill _tmp1822 from $t7 to $fp-2916
	beqz $t7, _L296	# branch if _tmp1822 is zero 
	# _tmp1823 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1824 = _tmp1818 * _tmp1823
	lw $t1, -2904($fp)	# load _tmp1818 from $fp-2904 into $t1
	mul $t2, $t1, $t0	
	# _tmp1825 = _tmp1824 + _tmp1823
	add $t3, $t2, $t0	
	# _tmp1826 = _tmp1816 + _tmp1825
	lw $t4, -2892($fp)	# load _tmp1816 from $fp-2892 into $t4
	add $t5, $t4, $t3	
	# Goto _L297
	# (save modified registers before flow of control change)
	sw $t0, -2920($fp)	# spill _tmp1823 from $t0 to $fp-2920
	sw $t2, -2924($fp)	# spill _tmp1824 from $t2 to $fp-2924
	sw $t3, -2928($fp)	# spill _tmp1825 from $t3 to $fp-2928
	sw $t5, -2928($fp)	# spill _tmp1826 from $t5 to $fp-2928
	b _L297		# unconditional branch
_L296:
	# _tmp1827 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string130: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string130	# load label
	# PushParam _tmp1827
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2932($fp)	# spill _tmp1827 from $t0 to $fp-2932
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L297:
	# _tmp1828 = *(_tmp1826)
	lw $t0, -2928($fp)	# load _tmp1826 from $fp-2928 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1829 = *(_tmp1828)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1830 = *(_tmp1829 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1828
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1831 = ACall _tmp1830
	# (save modified registers before flow of control change)
	sw $t1, -2936($fp)	# spill _tmp1828 from $t1 to $fp-2936
	sw $t2, -2940($fp)	# spill _tmp1829 from $t2 to $fp-2940
	sw $t3, -2944($fp)	# spill _tmp1830 from $t3 to $fp-2944
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1832 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1833 = *(_tmp1832)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1834 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1835 = _tmp1834 < _tmp1833
	slt $t5, $t4, $t3	
	# _tmp1836 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1837 = _tmp1836 < _tmp1834
	slt $t7, $t6, $t4	
	# _tmp1838 = _tmp1837 && _tmp1835
	and $s0, $t7, $t5	
	# IfZ _tmp1838 Goto _L298
	# (save modified registers before flow of control change)
	sw $t0, -2948($fp)	# spill _tmp1831 from $t0 to $fp-2948
	sw $t2, -2952($fp)	# spill _tmp1832 from $t2 to $fp-2952
	sw $t3, -2956($fp)	# spill _tmp1833 from $t3 to $fp-2956
	sw $t4, -2964($fp)	# spill _tmp1834 from $t4 to $fp-2964
	sw $t5, -2960($fp)	# spill _tmp1835 from $t5 to $fp-2960
	sw $t6, -2968($fp)	# spill _tmp1836 from $t6 to $fp-2968
	sw $t7, -2972($fp)	# spill _tmp1837 from $t7 to $fp-2972
	sw $s0, -2976($fp)	# spill _tmp1838 from $s0 to $fp-2976
	beqz $s0, _L298	# branch if _tmp1838 is zero 
	# _tmp1839 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1840 = _tmp1834 * _tmp1839
	lw $t1, -2964($fp)	# load _tmp1834 from $fp-2964 into $t1
	mul $t2, $t1, $t0	
	# _tmp1841 = _tmp1840 + _tmp1839
	add $t3, $t2, $t0	
	# _tmp1842 = _tmp1832 + _tmp1841
	lw $t4, -2952($fp)	# load _tmp1832 from $fp-2952 into $t4
	add $t5, $t4, $t3	
	# Goto _L299
	# (save modified registers before flow of control change)
	sw $t0, -2980($fp)	# spill _tmp1839 from $t0 to $fp-2980
	sw $t2, -2984($fp)	# spill _tmp1840 from $t2 to $fp-2984
	sw $t3, -2988($fp)	# spill _tmp1841 from $t3 to $fp-2988
	sw $t5, -2988($fp)	# spill _tmp1842 from $t5 to $fp-2988
	b _L299		# unconditional branch
_L298:
	# _tmp1843 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string131: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string131	# load label
	# PushParam _tmp1843
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -2992($fp)	# spill _tmp1843 from $t0 to $fp-2992
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L299:
	# _tmp1844 = *(_tmp1842)
	lw $t0, -2988($fp)	# load _tmp1842 from $fp-2988 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1845 = *(_tmp1844)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1846 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp1847 = _tmp1846 < _tmp1845
	slt $t4, $t3, $t2	
	# _tmp1848 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1849 = _tmp1848 < _tmp1846
	slt $t6, $t5, $t3	
	# _tmp1850 = _tmp1849 && _tmp1847
	and $t7, $t6, $t4	
	# IfZ _tmp1850 Goto _L300
	# (save modified registers before flow of control change)
	sw $t1, -2996($fp)	# spill _tmp1844 from $t1 to $fp-2996
	sw $t2, -3000($fp)	# spill _tmp1845 from $t2 to $fp-3000
	sw $t3, -3008($fp)	# spill _tmp1846 from $t3 to $fp-3008
	sw $t4, -3004($fp)	# spill _tmp1847 from $t4 to $fp-3004
	sw $t5, -3012($fp)	# spill _tmp1848 from $t5 to $fp-3012
	sw $t6, -3016($fp)	# spill _tmp1849 from $t6 to $fp-3016
	sw $t7, -3020($fp)	# spill _tmp1850 from $t7 to $fp-3020
	beqz $t7, _L300	# branch if _tmp1850 is zero 
	# _tmp1851 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1852 = _tmp1846 * _tmp1851
	lw $t1, -3008($fp)	# load _tmp1846 from $fp-3008 into $t1
	mul $t2, $t1, $t0	
	# _tmp1853 = _tmp1852 + _tmp1851
	add $t3, $t2, $t0	
	# _tmp1854 = _tmp1844 + _tmp1853
	lw $t4, -2996($fp)	# load _tmp1844 from $fp-2996 into $t4
	add $t5, $t4, $t3	
	# Goto _L301
	# (save modified registers before flow of control change)
	sw $t0, -3024($fp)	# spill _tmp1851 from $t0 to $fp-3024
	sw $t2, -3028($fp)	# spill _tmp1852 from $t2 to $fp-3028
	sw $t3, -3032($fp)	# spill _tmp1853 from $t3 to $fp-3032
	sw $t5, -3032($fp)	# spill _tmp1854 from $t5 to $fp-3032
	b _L301		# unconditional branch
_L300:
	# _tmp1855 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string132: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string132	# load label
	# PushParam _tmp1855
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3036($fp)	# spill _tmp1855 from $t0 to $fp-3036
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L301:
	# _tmp1856 = *(_tmp1854)
	lw $t0, -3032($fp)	# load _tmp1854 from $fp-3032 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1857 = *(_tmp1856)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1858 = *(_tmp1857 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1856
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1859 = ACall _tmp1858
	# (save modified registers before flow of control change)
	sw $t1, -3040($fp)	# spill _tmp1856 from $t1 to $fp-3040
	sw $t2, -3044($fp)	# spill _tmp1857 from $t2 to $fp-3044
	sw $t3, -3048($fp)	# spill _tmp1858 from $t3 to $fp-3048
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1860 = _tmp1859 && _tmp1831
	lw $t1, -2948($fp)	# load _tmp1831 from $fp-2948 into $t1
	and $t2, $t0, $t1	
	# _tmp1861 = _tmp1860 && _tmp1803
	lw $t3, -2736($fp)	# load _tmp1803 from $fp-2736 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1861 Goto _L288
	# (save modified registers before flow of control change)
	sw $t0, -3052($fp)	# spill _tmp1859 from $t0 to $fp-3052
	sw $t2, -2844($fp)	# spill _tmp1860 from $t2 to $fp-2844
	sw $t4, -2728($fp)	# spill _tmp1861 from $t4 to $fp-2728
	beqz $t4, _L288	# branch if _tmp1861 is zero 
	# _tmp1862 = 2
	li $t0, 2		# load constant value 2 into $t0
	# row = _tmp1862
	move $t1, $t0		# copy value
	# _tmp1863 = 2
	li $t2, 2		# load constant value 2 into $t2
	# column = _tmp1863
	move $t3, $t2		# copy value
	# Goto _L289
	# (save modified registers before flow of control change)
	sw $t0, -3056($fp)	# spill _tmp1862 from $t0 to $fp-3056
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -3060($fp)	# spill _tmp1863 from $t2 to $fp-3060
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L289		# unconditional branch
_L288:
	# _tmp1864 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1865 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1866 = *(_tmp1865)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1867 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1868 = _tmp1867 < _tmp1866
	slt $t5, $t4, $t3	
	# _tmp1869 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1870 = _tmp1869 < _tmp1867
	slt $t7, $t6, $t4	
	# _tmp1871 = _tmp1870 && _tmp1868
	and $s0, $t7, $t5	
	# IfZ _tmp1871 Goto _L304
	# (save modified registers before flow of control change)
	sw $t0, -3068($fp)	# spill _tmp1864 from $t0 to $fp-3068
	sw $t2, -3076($fp)	# spill _tmp1865 from $t2 to $fp-3076
	sw $t3, -3080($fp)	# spill _tmp1866 from $t3 to $fp-3080
	sw $t4, -3088($fp)	# spill _tmp1867 from $t4 to $fp-3088
	sw $t5, -3084($fp)	# spill _tmp1868 from $t5 to $fp-3084
	sw $t6, -3092($fp)	# spill _tmp1869 from $t6 to $fp-3092
	sw $t7, -3096($fp)	# spill _tmp1870 from $t7 to $fp-3096
	sw $s0, -3100($fp)	# spill _tmp1871 from $s0 to $fp-3100
	beqz $s0, _L304	# branch if _tmp1871 is zero 
	# _tmp1872 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1873 = _tmp1867 * _tmp1872
	lw $t1, -3088($fp)	# load _tmp1867 from $fp-3088 into $t1
	mul $t2, $t1, $t0	
	# _tmp1874 = _tmp1873 + _tmp1872
	add $t3, $t2, $t0	
	# _tmp1875 = _tmp1865 + _tmp1874
	lw $t4, -3076($fp)	# load _tmp1865 from $fp-3076 into $t4
	add $t5, $t4, $t3	
	# Goto _L305
	# (save modified registers before flow of control change)
	sw $t0, -3104($fp)	# spill _tmp1872 from $t0 to $fp-3104
	sw $t2, -3108($fp)	# spill _tmp1873 from $t2 to $fp-3108
	sw $t3, -3112($fp)	# spill _tmp1874 from $t3 to $fp-3112
	sw $t5, -3112($fp)	# spill _tmp1875 from $t5 to $fp-3112
	b _L305		# unconditional branch
_L304:
	# _tmp1876 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string133: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string133	# load label
	# PushParam _tmp1876
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3116($fp)	# spill _tmp1876 from $t0 to $fp-3116
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L305:
	# _tmp1877 = *(_tmp1875)
	lw $t0, -3112($fp)	# load _tmp1875 from $fp-3112 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1878 = *(_tmp1877)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1879 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1880 = _tmp1879 < _tmp1878
	slt $t4, $t3, $t2	
	# _tmp1881 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1882 = _tmp1881 < _tmp1879
	slt $t6, $t5, $t3	
	# _tmp1883 = _tmp1882 && _tmp1880
	and $t7, $t6, $t4	
	# IfZ _tmp1883 Goto _L306
	# (save modified registers before flow of control change)
	sw $t1, -3120($fp)	# spill _tmp1877 from $t1 to $fp-3120
	sw $t2, -3124($fp)	# spill _tmp1878 from $t2 to $fp-3124
	sw $t3, -3132($fp)	# spill _tmp1879 from $t3 to $fp-3132
	sw $t4, -3128($fp)	# spill _tmp1880 from $t4 to $fp-3128
	sw $t5, -3136($fp)	# spill _tmp1881 from $t5 to $fp-3136
	sw $t6, -3140($fp)	# spill _tmp1882 from $t6 to $fp-3140
	sw $t7, -3144($fp)	# spill _tmp1883 from $t7 to $fp-3144
	beqz $t7, _L306	# branch if _tmp1883 is zero 
	# _tmp1884 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1885 = _tmp1879 * _tmp1884
	lw $t1, -3132($fp)	# load _tmp1879 from $fp-3132 into $t1
	mul $t2, $t1, $t0	
	# _tmp1886 = _tmp1885 + _tmp1884
	add $t3, $t2, $t0	
	# _tmp1887 = _tmp1877 + _tmp1886
	lw $t4, -3120($fp)	# load _tmp1877 from $fp-3120 into $t4
	add $t5, $t4, $t3	
	# Goto _L307
	# (save modified registers before flow of control change)
	sw $t0, -3148($fp)	# spill _tmp1884 from $t0 to $fp-3148
	sw $t2, -3152($fp)	# spill _tmp1885 from $t2 to $fp-3152
	sw $t3, -3156($fp)	# spill _tmp1886 from $t3 to $fp-3156
	sw $t5, -3156($fp)	# spill _tmp1887 from $t5 to $fp-3156
	b _L307		# unconditional branch
_L306:
	# _tmp1888 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string134: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string134	# load label
	# PushParam _tmp1888
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3160($fp)	# spill _tmp1888 from $t0 to $fp-3160
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L307:
	# _tmp1889 = *(_tmp1887)
	lw $t0, -3156($fp)	# load _tmp1887 from $fp-3156 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1890 = *(_tmp1889)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1891 = *(_tmp1890 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1889
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1892 = ACall _tmp1891
	# (save modified registers before flow of control change)
	sw $t1, -3164($fp)	# spill _tmp1889 from $t1 to $fp-3164
	sw $t2, -3168($fp)	# spill _tmp1890 from $t2 to $fp-3168
	sw $t3, -3172($fp)	# spill _tmp1891 from $t3 to $fp-3172
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1893 = _tmp1864 - _tmp1892
	lw $t1, -3068($fp)	# load _tmp1864 from $fp-3068 into $t1
	sub $t2, $t1, $t0	
	# _tmp1894 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1895 = *(_tmp1894)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1896 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp1897 = _tmp1896 < _tmp1895
	slt $t7, $t6, $t5	
	# _tmp1898 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1899 = _tmp1898 < _tmp1896
	slt $s1, $s0, $t6	
	# _tmp1900 = _tmp1899 && _tmp1897
	and $s2, $s1, $t7	
	# IfZ _tmp1900 Goto _L308
	# (save modified registers before flow of control change)
	sw $t0, -3176($fp)	# spill _tmp1892 from $t0 to $fp-3176
	sw $t2, -3072($fp)	# spill _tmp1893 from $t2 to $fp-3072
	sw $t4, -3184($fp)	# spill _tmp1894 from $t4 to $fp-3184
	sw $t5, -3188($fp)	# spill _tmp1895 from $t5 to $fp-3188
	sw $t6, -3196($fp)	# spill _tmp1896 from $t6 to $fp-3196
	sw $t7, -3192($fp)	# spill _tmp1897 from $t7 to $fp-3192
	sw $s0, -3200($fp)	# spill _tmp1898 from $s0 to $fp-3200
	sw $s1, -3204($fp)	# spill _tmp1899 from $s1 to $fp-3204
	sw $s2, -3208($fp)	# spill _tmp1900 from $s2 to $fp-3208
	beqz $s2, _L308	# branch if _tmp1900 is zero 
	# _tmp1901 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1902 = _tmp1896 * _tmp1901
	lw $t1, -3196($fp)	# load _tmp1896 from $fp-3196 into $t1
	mul $t2, $t1, $t0	
	# _tmp1903 = _tmp1902 + _tmp1901
	add $t3, $t2, $t0	
	# _tmp1904 = _tmp1894 + _tmp1903
	lw $t4, -3184($fp)	# load _tmp1894 from $fp-3184 into $t4
	add $t5, $t4, $t3	
	# Goto _L309
	# (save modified registers before flow of control change)
	sw $t0, -3212($fp)	# spill _tmp1901 from $t0 to $fp-3212
	sw $t2, -3216($fp)	# spill _tmp1902 from $t2 to $fp-3216
	sw $t3, -3220($fp)	# spill _tmp1903 from $t3 to $fp-3220
	sw $t5, -3220($fp)	# spill _tmp1904 from $t5 to $fp-3220
	b _L309		# unconditional branch
_L308:
	# _tmp1905 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string135: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string135	# load label
	# PushParam _tmp1905
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3224($fp)	# spill _tmp1905 from $t0 to $fp-3224
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L309:
	# _tmp1906 = *(_tmp1904)
	lw $t0, -3220($fp)	# load _tmp1904 from $fp-3220 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1907 = *(_tmp1906)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1908 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1909 = _tmp1908 < _tmp1907
	slt $t4, $t3, $t2	
	# _tmp1910 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1911 = _tmp1910 < _tmp1908
	slt $t6, $t5, $t3	
	# _tmp1912 = _tmp1911 && _tmp1909
	and $t7, $t6, $t4	
	# IfZ _tmp1912 Goto _L310
	# (save modified registers before flow of control change)
	sw $t1, -3228($fp)	# spill _tmp1906 from $t1 to $fp-3228
	sw $t2, -3232($fp)	# spill _tmp1907 from $t2 to $fp-3232
	sw $t3, -3240($fp)	# spill _tmp1908 from $t3 to $fp-3240
	sw $t4, -3236($fp)	# spill _tmp1909 from $t4 to $fp-3236
	sw $t5, -3244($fp)	# spill _tmp1910 from $t5 to $fp-3244
	sw $t6, -3248($fp)	# spill _tmp1911 from $t6 to $fp-3248
	sw $t7, -3252($fp)	# spill _tmp1912 from $t7 to $fp-3252
	beqz $t7, _L310	# branch if _tmp1912 is zero 
	# _tmp1913 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1914 = _tmp1908 * _tmp1913
	lw $t1, -3240($fp)	# load _tmp1908 from $fp-3240 into $t1
	mul $t2, $t1, $t0	
	# _tmp1915 = _tmp1914 + _tmp1913
	add $t3, $t2, $t0	
	# _tmp1916 = _tmp1906 + _tmp1915
	lw $t4, -3228($fp)	# load _tmp1906 from $fp-3228 into $t4
	add $t5, $t4, $t3	
	# Goto _L311
	# (save modified registers before flow of control change)
	sw $t0, -3256($fp)	# spill _tmp1913 from $t0 to $fp-3256
	sw $t2, -3260($fp)	# spill _tmp1914 from $t2 to $fp-3260
	sw $t3, -3264($fp)	# spill _tmp1915 from $t3 to $fp-3264
	sw $t5, -3264($fp)	# spill _tmp1916 from $t5 to $fp-3264
	b _L311		# unconditional branch
_L310:
	# _tmp1917 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string136: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string136	# load label
	# PushParam _tmp1917
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3268($fp)	# spill _tmp1917 from $t0 to $fp-3268
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L311:
	# _tmp1918 = *(_tmp1916)
	lw $t0, -3264($fp)	# load _tmp1916 from $fp-3264 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1919 = *(_tmp1918)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1920 = *(_tmp1919 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1918
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1921 = ACall _tmp1920
	# (save modified registers before flow of control change)
	sw $t1, -3272($fp)	# spill _tmp1918 from $t1 to $fp-3272
	sw $t2, -3276($fp)	# spill _tmp1919 from $t2 to $fp-3276
	sw $t3, -3280($fp)	# spill _tmp1920 from $t3 to $fp-3280
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1922 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1923 = *(_tmp1922)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1924 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp1925 = _tmp1924 < _tmp1923
	slt $t5, $t4, $t3	
	# _tmp1926 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1927 = _tmp1926 < _tmp1924
	slt $t7, $t6, $t4	
	# _tmp1928 = _tmp1927 && _tmp1925
	and $s0, $t7, $t5	
	# IfZ _tmp1928 Goto _L312
	# (save modified registers before flow of control change)
	sw $t0, -3284($fp)	# spill _tmp1921 from $t0 to $fp-3284
	sw $t2, -3288($fp)	# spill _tmp1922 from $t2 to $fp-3288
	sw $t3, -3292($fp)	# spill _tmp1923 from $t3 to $fp-3292
	sw $t4, -3300($fp)	# spill _tmp1924 from $t4 to $fp-3300
	sw $t5, -3296($fp)	# spill _tmp1925 from $t5 to $fp-3296
	sw $t6, -3304($fp)	# spill _tmp1926 from $t6 to $fp-3304
	sw $t7, -3308($fp)	# spill _tmp1927 from $t7 to $fp-3308
	sw $s0, -3312($fp)	# spill _tmp1928 from $s0 to $fp-3312
	beqz $s0, _L312	# branch if _tmp1928 is zero 
	# _tmp1929 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1930 = _tmp1924 * _tmp1929
	lw $t1, -3300($fp)	# load _tmp1924 from $fp-3300 into $t1
	mul $t2, $t1, $t0	
	# _tmp1931 = _tmp1930 + _tmp1929
	add $t3, $t2, $t0	
	# _tmp1932 = _tmp1922 + _tmp1931
	lw $t4, -3288($fp)	# load _tmp1922 from $fp-3288 into $t4
	add $t5, $t4, $t3	
	# Goto _L313
	# (save modified registers before flow of control change)
	sw $t0, -3316($fp)	# spill _tmp1929 from $t0 to $fp-3316
	sw $t2, -3320($fp)	# spill _tmp1930 from $t2 to $fp-3320
	sw $t3, -3324($fp)	# spill _tmp1931 from $t3 to $fp-3324
	sw $t5, -3324($fp)	# spill _tmp1932 from $t5 to $fp-3324
	b _L313		# unconditional branch
_L312:
	# _tmp1933 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string137: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string137	# load label
	# PushParam _tmp1933
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3328($fp)	# spill _tmp1933 from $t0 to $fp-3328
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L313:
	# _tmp1934 = *(_tmp1932)
	lw $t0, -3324($fp)	# load _tmp1932 from $fp-3324 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1935 = *(_tmp1934)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1936 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp1937 = _tmp1936 < _tmp1935
	slt $t4, $t3, $t2	
	# _tmp1938 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1939 = _tmp1938 < _tmp1936
	slt $t6, $t5, $t3	
	# _tmp1940 = _tmp1939 && _tmp1937
	and $t7, $t6, $t4	
	# IfZ _tmp1940 Goto _L314
	# (save modified registers before flow of control change)
	sw $t1, -3332($fp)	# spill _tmp1934 from $t1 to $fp-3332
	sw $t2, -3336($fp)	# spill _tmp1935 from $t2 to $fp-3336
	sw $t3, -3344($fp)	# spill _tmp1936 from $t3 to $fp-3344
	sw $t4, -3340($fp)	# spill _tmp1937 from $t4 to $fp-3340
	sw $t5, -3348($fp)	# spill _tmp1938 from $t5 to $fp-3348
	sw $t6, -3352($fp)	# spill _tmp1939 from $t6 to $fp-3352
	sw $t7, -3356($fp)	# spill _tmp1940 from $t7 to $fp-3356
	beqz $t7, _L314	# branch if _tmp1940 is zero 
	# _tmp1941 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1942 = _tmp1936 * _tmp1941
	lw $t1, -3344($fp)	# load _tmp1936 from $fp-3344 into $t1
	mul $t2, $t1, $t0	
	# _tmp1943 = _tmp1942 + _tmp1941
	add $t3, $t2, $t0	
	# _tmp1944 = _tmp1934 + _tmp1943
	lw $t4, -3332($fp)	# load _tmp1934 from $fp-3332 into $t4
	add $t5, $t4, $t3	
	# Goto _L315
	# (save modified registers before flow of control change)
	sw $t0, -3360($fp)	# spill _tmp1941 from $t0 to $fp-3360
	sw $t2, -3364($fp)	# spill _tmp1942 from $t2 to $fp-3364
	sw $t3, -3368($fp)	# spill _tmp1943 from $t3 to $fp-3368
	sw $t5, -3368($fp)	# spill _tmp1944 from $t5 to $fp-3368
	b _L315		# unconditional branch
_L314:
	# _tmp1945 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string138: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string138	# load label
	# PushParam _tmp1945
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3372($fp)	# spill _tmp1945 from $t0 to $fp-3372
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L315:
	# _tmp1946 = *(_tmp1944)
	lw $t0, -3368($fp)	# load _tmp1944 from $fp-3368 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1947 = *(_tmp1946)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1948 = *(_tmp1947 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1946
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1949 = ACall _tmp1948
	# (save modified registers before flow of control change)
	sw $t1, -3376($fp)	# spill _tmp1946 from $t1 to $fp-3376
	sw $t2, -3380($fp)	# spill _tmp1947 from $t2 to $fp-3380
	sw $t3, -3384($fp)	# spill _tmp1948 from $t3 to $fp-3384
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1950 = _tmp1949 && _tmp1921
	lw $t1, -3284($fp)	# load _tmp1921 from $fp-3284 into $t1
	and $t2, $t0, $t1	
	# _tmp1951 = _tmp1950 && _tmp1893
	lw $t3, -3072($fp)	# load _tmp1893 from $fp-3072 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp1951 Goto _L302
	# (save modified registers before flow of control change)
	sw $t0, -3388($fp)	# spill _tmp1949 from $t0 to $fp-3388
	sw $t2, -3180($fp)	# spill _tmp1950 from $t2 to $fp-3180
	sw $t4, -3064($fp)	# spill _tmp1951 from $t4 to $fp-3064
	beqz $t4, _L302	# branch if _tmp1951 is zero 
	# _tmp1952 = 0
	li $t0, 0		# load constant value 0 into $t0
	# row = _tmp1952
	move $t1, $t0		# copy value
	# _tmp1953 = 0
	li $t2, 0		# load constant value 0 into $t2
	# column = _tmp1953
	move $t3, $t2		# copy value
	# Goto _L303
	# (save modified registers before flow of control change)
	sw $t0, -3392($fp)	# spill _tmp1952 from $t0 to $fp-3392
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -3396($fp)	# spill _tmp1953 from $t2 to $fp-3396
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L303		# unconditional branch
_L302:
	# _tmp1954 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1955 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp1956 = *(_tmp1955)
	lw $t3, 0($t2) 	# load with offset
	# _tmp1957 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp1958 = _tmp1957 < _tmp1956
	slt $t5, $t4, $t3	
	# _tmp1959 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp1960 = _tmp1959 < _tmp1957
	slt $t7, $t6, $t4	
	# _tmp1961 = _tmp1960 && _tmp1958
	and $s0, $t7, $t5	
	# IfZ _tmp1961 Goto _L318
	# (save modified registers before flow of control change)
	sw $t0, -3404($fp)	# spill _tmp1954 from $t0 to $fp-3404
	sw $t2, -3412($fp)	# spill _tmp1955 from $t2 to $fp-3412
	sw $t3, -3416($fp)	# spill _tmp1956 from $t3 to $fp-3416
	sw $t4, -3424($fp)	# spill _tmp1957 from $t4 to $fp-3424
	sw $t5, -3420($fp)	# spill _tmp1958 from $t5 to $fp-3420
	sw $t6, -3428($fp)	# spill _tmp1959 from $t6 to $fp-3428
	sw $t7, -3432($fp)	# spill _tmp1960 from $t7 to $fp-3432
	sw $s0, -3436($fp)	# spill _tmp1961 from $s0 to $fp-3436
	beqz $s0, _L318	# branch if _tmp1961 is zero 
	# _tmp1962 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1963 = _tmp1957 * _tmp1962
	lw $t1, -3424($fp)	# load _tmp1957 from $fp-3424 into $t1
	mul $t2, $t1, $t0	
	# _tmp1964 = _tmp1963 + _tmp1962
	add $t3, $t2, $t0	
	# _tmp1965 = _tmp1955 + _tmp1964
	lw $t4, -3412($fp)	# load _tmp1955 from $fp-3412 into $t4
	add $t5, $t4, $t3	
	# Goto _L319
	# (save modified registers before flow of control change)
	sw $t0, -3440($fp)	# spill _tmp1962 from $t0 to $fp-3440
	sw $t2, -3444($fp)	# spill _tmp1963 from $t2 to $fp-3444
	sw $t3, -3448($fp)	# spill _tmp1964 from $t3 to $fp-3448
	sw $t5, -3448($fp)	# spill _tmp1965 from $t5 to $fp-3448
	b _L319		# unconditional branch
_L318:
	# _tmp1966 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string139: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string139	# load label
	# PushParam _tmp1966
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3452($fp)	# spill _tmp1966 from $t0 to $fp-3452
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L319:
	# _tmp1967 = *(_tmp1965)
	lw $t0, -3448($fp)	# load _tmp1965 from $fp-3448 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1968 = *(_tmp1967)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1969 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1970 = _tmp1969 < _tmp1968
	slt $t4, $t3, $t2	
	# _tmp1971 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp1972 = _tmp1971 < _tmp1969
	slt $t6, $t5, $t3	
	# _tmp1973 = _tmp1972 && _tmp1970
	and $t7, $t6, $t4	
	# IfZ _tmp1973 Goto _L320
	# (save modified registers before flow of control change)
	sw $t1, -3456($fp)	# spill _tmp1967 from $t1 to $fp-3456
	sw $t2, -3460($fp)	# spill _tmp1968 from $t2 to $fp-3460
	sw $t3, -3468($fp)	# spill _tmp1969 from $t3 to $fp-3468
	sw $t4, -3464($fp)	# spill _tmp1970 from $t4 to $fp-3464
	sw $t5, -3472($fp)	# spill _tmp1971 from $t5 to $fp-3472
	sw $t6, -3476($fp)	# spill _tmp1972 from $t6 to $fp-3476
	sw $t7, -3480($fp)	# spill _tmp1973 from $t7 to $fp-3480
	beqz $t7, _L320	# branch if _tmp1973 is zero 
	# _tmp1974 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1975 = _tmp1969 * _tmp1974
	lw $t1, -3468($fp)	# load _tmp1969 from $fp-3468 into $t1
	mul $t2, $t1, $t0	
	# _tmp1976 = _tmp1975 + _tmp1974
	add $t3, $t2, $t0	
	# _tmp1977 = _tmp1967 + _tmp1976
	lw $t4, -3456($fp)	# load _tmp1967 from $fp-3456 into $t4
	add $t5, $t4, $t3	
	# Goto _L321
	# (save modified registers before flow of control change)
	sw $t0, -3484($fp)	# spill _tmp1974 from $t0 to $fp-3484
	sw $t2, -3488($fp)	# spill _tmp1975 from $t2 to $fp-3488
	sw $t3, -3492($fp)	# spill _tmp1976 from $t3 to $fp-3492
	sw $t5, -3492($fp)	# spill _tmp1977 from $t5 to $fp-3492
	b _L321		# unconditional branch
_L320:
	# _tmp1978 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string140: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string140	# load label
	# PushParam _tmp1978
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3496($fp)	# spill _tmp1978 from $t0 to $fp-3496
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L321:
	# _tmp1979 = *(_tmp1977)
	lw $t0, -3492($fp)	# load _tmp1977 from $fp-3492 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1980 = *(_tmp1979)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1981 = *(_tmp1980 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp1979
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp1982 = ACall _tmp1981
	# (save modified registers before flow of control change)
	sw $t1, -3500($fp)	# spill _tmp1979 from $t1 to $fp-3500
	sw $t2, -3504($fp)	# spill _tmp1980 from $t2 to $fp-3504
	sw $t3, -3508($fp)	# spill _tmp1981 from $t3 to $fp-3508
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp1983 = _tmp1954 - _tmp1982
	lw $t1, -3404($fp)	# load _tmp1954 from $fp-3404 into $t1
	sub $t2, $t1, $t0	
	# _tmp1984 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp1985 = *(_tmp1984)
	lw $t5, 0($t4) 	# load with offset
	# _tmp1986 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp1987 = _tmp1986 < _tmp1985
	slt $t7, $t6, $t5	
	# _tmp1988 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp1989 = _tmp1988 < _tmp1986
	slt $s1, $s0, $t6	
	# _tmp1990 = _tmp1989 && _tmp1987
	and $s2, $s1, $t7	
	# IfZ _tmp1990 Goto _L322
	# (save modified registers before flow of control change)
	sw $t0, -3512($fp)	# spill _tmp1982 from $t0 to $fp-3512
	sw $t2, -3408($fp)	# spill _tmp1983 from $t2 to $fp-3408
	sw $t4, -3520($fp)	# spill _tmp1984 from $t4 to $fp-3520
	sw $t5, -3524($fp)	# spill _tmp1985 from $t5 to $fp-3524
	sw $t6, -3532($fp)	# spill _tmp1986 from $t6 to $fp-3532
	sw $t7, -3528($fp)	# spill _tmp1987 from $t7 to $fp-3528
	sw $s0, -3536($fp)	# spill _tmp1988 from $s0 to $fp-3536
	sw $s1, -3540($fp)	# spill _tmp1989 from $s1 to $fp-3540
	sw $s2, -3544($fp)	# spill _tmp1990 from $s2 to $fp-3544
	beqz $s2, _L322	# branch if _tmp1990 is zero 
	# _tmp1991 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1992 = _tmp1986 * _tmp1991
	lw $t1, -3532($fp)	# load _tmp1986 from $fp-3532 into $t1
	mul $t2, $t1, $t0	
	# _tmp1993 = _tmp1992 + _tmp1991
	add $t3, $t2, $t0	
	# _tmp1994 = _tmp1984 + _tmp1993
	lw $t4, -3520($fp)	# load _tmp1984 from $fp-3520 into $t4
	add $t5, $t4, $t3	
	# Goto _L323
	# (save modified registers before flow of control change)
	sw $t0, -3548($fp)	# spill _tmp1991 from $t0 to $fp-3548
	sw $t2, -3552($fp)	# spill _tmp1992 from $t2 to $fp-3552
	sw $t3, -3556($fp)	# spill _tmp1993 from $t3 to $fp-3556
	sw $t5, -3556($fp)	# spill _tmp1994 from $t5 to $fp-3556
	b _L323		# unconditional branch
_L322:
	# _tmp1995 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string141: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string141	# load label
	# PushParam _tmp1995
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3560($fp)	# spill _tmp1995 from $t0 to $fp-3560
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L323:
	# _tmp1996 = *(_tmp1994)
	lw $t0, -3556($fp)	# load _tmp1994 from $fp-3556 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp1997 = *(_tmp1996)
	lw $t2, 0($t1) 	# load with offset
	# _tmp1998 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp1999 = _tmp1998 < _tmp1997
	slt $t4, $t3, $t2	
	# _tmp2000 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2001 = _tmp2000 < _tmp1998
	slt $t6, $t5, $t3	
	# _tmp2002 = _tmp2001 && _tmp1999
	and $t7, $t6, $t4	
	# IfZ _tmp2002 Goto _L324
	# (save modified registers before flow of control change)
	sw $t1, -3564($fp)	# spill _tmp1996 from $t1 to $fp-3564
	sw $t2, -3568($fp)	# spill _tmp1997 from $t2 to $fp-3568
	sw $t3, -3576($fp)	# spill _tmp1998 from $t3 to $fp-3576
	sw $t4, -3572($fp)	# spill _tmp1999 from $t4 to $fp-3572
	sw $t5, -3580($fp)	# spill _tmp2000 from $t5 to $fp-3580
	sw $t6, -3584($fp)	# spill _tmp2001 from $t6 to $fp-3584
	sw $t7, -3588($fp)	# spill _tmp2002 from $t7 to $fp-3588
	beqz $t7, _L324	# branch if _tmp2002 is zero 
	# _tmp2003 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2004 = _tmp1998 * _tmp2003
	lw $t1, -3576($fp)	# load _tmp1998 from $fp-3576 into $t1
	mul $t2, $t1, $t0	
	# _tmp2005 = _tmp2004 + _tmp2003
	add $t3, $t2, $t0	
	# _tmp2006 = _tmp1996 + _tmp2005
	lw $t4, -3564($fp)	# load _tmp1996 from $fp-3564 into $t4
	add $t5, $t4, $t3	
	# Goto _L325
	# (save modified registers before flow of control change)
	sw $t0, -3592($fp)	# spill _tmp2003 from $t0 to $fp-3592
	sw $t2, -3596($fp)	# spill _tmp2004 from $t2 to $fp-3596
	sw $t3, -3600($fp)	# spill _tmp2005 from $t3 to $fp-3600
	sw $t5, -3600($fp)	# spill _tmp2006 from $t5 to $fp-3600
	b _L325		# unconditional branch
_L324:
	# _tmp2007 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string142: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string142	# load label
	# PushParam _tmp2007
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3604($fp)	# spill _tmp2007 from $t0 to $fp-3604
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L325:
	# _tmp2008 = *(_tmp2006)
	lw $t0, -3600($fp)	# load _tmp2006 from $fp-3600 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2009 = *(_tmp2008)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2010 = *(_tmp2009 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2008
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2011 = ACall _tmp2010
	# (save modified registers before flow of control change)
	sw $t1, -3608($fp)	# spill _tmp2008 from $t1 to $fp-3608
	sw $t2, -3612($fp)	# spill _tmp2009 from $t2 to $fp-3612
	sw $t3, -3616($fp)	# spill _tmp2010 from $t3 to $fp-3616
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2012 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2013 = *(_tmp2012)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2014 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp2015 = _tmp2014 < _tmp2013
	slt $t5, $t4, $t3	
	# _tmp2016 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2017 = _tmp2016 < _tmp2014
	slt $t7, $t6, $t4	
	# _tmp2018 = _tmp2017 && _tmp2015
	and $s0, $t7, $t5	
	# IfZ _tmp2018 Goto _L326
	# (save modified registers before flow of control change)
	sw $t0, -3620($fp)	# spill _tmp2011 from $t0 to $fp-3620
	sw $t2, -3624($fp)	# spill _tmp2012 from $t2 to $fp-3624
	sw $t3, -3628($fp)	# spill _tmp2013 from $t3 to $fp-3628
	sw $t4, -3636($fp)	# spill _tmp2014 from $t4 to $fp-3636
	sw $t5, -3632($fp)	# spill _tmp2015 from $t5 to $fp-3632
	sw $t6, -3640($fp)	# spill _tmp2016 from $t6 to $fp-3640
	sw $t7, -3644($fp)	# spill _tmp2017 from $t7 to $fp-3644
	sw $s0, -3648($fp)	# spill _tmp2018 from $s0 to $fp-3648
	beqz $s0, _L326	# branch if _tmp2018 is zero 
	# _tmp2019 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2020 = _tmp2014 * _tmp2019
	lw $t1, -3636($fp)	# load _tmp2014 from $fp-3636 into $t1
	mul $t2, $t1, $t0	
	# _tmp2021 = _tmp2020 + _tmp2019
	add $t3, $t2, $t0	
	# _tmp2022 = _tmp2012 + _tmp2021
	lw $t4, -3624($fp)	# load _tmp2012 from $fp-3624 into $t4
	add $t5, $t4, $t3	
	# Goto _L327
	# (save modified registers before flow of control change)
	sw $t0, -3652($fp)	# spill _tmp2019 from $t0 to $fp-3652
	sw $t2, -3656($fp)	# spill _tmp2020 from $t2 to $fp-3656
	sw $t3, -3660($fp)	# spill _tmp2021 from $t3 to $fp-3660
	sw $t5, -3660($fp)	# spill _tmp2022 from $t5 to $fp-3660
	b _L327		# unconditional branch
_L326:
	# _tmp2023 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string143: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string143	# load label
	# PushParam _tmp2023
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3664($fp)	# spill _tmp2023 from $t0 to $fp-3664
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L327:
	# _tmp2024 = *(_tmp2022)
	lw $t0, -3660($fp)	# load _tmp2022 from $fp-3660 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2025 = *(_tmp2024)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2026 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp2027 = _tmp2026 < _tmp2025
	slt $t4, $t3, $t2	
	# _tmp2028 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2029 = _tmp2028 < _tmp2026
	slt $t6, $t5, $t3	
	# _tmp2030 = _tmp2029 && _tmp2027
	and $t7, $t6, $t4	
	# IfZ _tmp2030 Goto _L328
	# (save modified registers before flow of control change)
	sw $t1, -3668($fp)	# spill _tmp2024 from $t1 to $fp-3668
	sw $t2, -3672($fp)	# spill _tmp2025 from $t2 to $fp-3672
	sw $t3, -3680($fp)	# spill _tmp2026 from $t3 to $fp-3680
	sw $t4, -3676($fp)	# spill _tmp2027 from $t4 to $fp-3676
	sw $t5, -3684($fp)	# spill _tmp2028 from $t5 to $fp-3684
	sw $t6, -3688($fp)	# spill _tmp2029 from $t6 to $fp-3688
	sw $t7, -3692($fp)	# spill _tmp2030 from $t7 to $fp-3692
	beqz $t7, _L328	# branch if _tmp2030 is zero 
	# _tmp2031 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2032 = _tmp2026 * _tmp2031
	lw $t1, -3680($fp)	# load _tmp2026 from $fp-3680 into $t1
	mul $t2, $t1, $t0	
	# _tmp2033 = _tmp2032 + _tmp2031
	add $t3, $t2, $t0	
	# _tmp2034 = _tmp2024 + _tmp2033
	lw $t4, -3668($fp)	# load _tmp2024 from $fp-3668 into $t4
	add $t5, $t4, $t3	
	# Goto _L329
	# (save modified registers before flow of control change)
	sw $t0, -3696($fp)	# spill _tmp2031 from $t0 to $fp-3696
	sw $t2, -3700($fp)	# spill _tmp2032 from $t2 to $fp-3700
	sw $t3, -3704($fp)	# spill _tmp2033 from $t3 to $fp-3704
	sw $t5, -3704($fp)	# spill _tmp2034 from $t5 to $fp-3704
	b _L329		# unconditional branch
_L328:
	# _tmp2035 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string144: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string144	# load label
	# PushParam _tmp2035
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3708($fp)	# spill _tmp2035 from $t0 to $fp-3708
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L329:
	# _tmp2036 = *(_tmp2034)
	lw $t0, -3704($fp)	# load _tmp2034 from $fp-3704 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2037 = *(_tmp2036)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2038 = *(_tmp2037 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2036
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2039 = ACall _tmp2038
	# (save modified registers before flow of control change)
	sw $t1, -3712($fp)	# spill _tmp2036 from $t1 to $fp-3712
	sw $t2, -3716($fp)	# spill _tmp2037 from $t2 to $fp-3716
	sw $t3, -3720($fp)	# spill _tmp2038 from $t3 to $fp-3720
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2040 = _tmp2039 && _tmp2011
	lw $t1, -3620($fp)	# load _tmp2011 from $fp-3620 into $t1
	and $t2, $t0, $t1	
	# _tmp2041 = _tmp2040 && _tmp1983
	lw $t3, -3408($fp)	# load _tmp1983 from $fp-3408 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp2041 Goto _L316
	# (save modified registers before flow of control change)
	sw $t0, -3724($fp)	# spill _tmp2039 from $t0 to $fp-3724
	sw $t2, -3516($fp)	# spill _tmp2040 from $t2 to $fp-3516
	sw $t4, -3400($fp)	# spill _tmp2041 from $t4 to $fp-3400
	beqz $t4, _L316	# branch if _tmp2041 is zero 
	# _tmp2042 = 0
	li $t0, 0		# load constant value 0 into $t0
	# row = _tmp2042
	move $t1, $t0		# copy value
	# _tmp2043 = 1
	li $t2, 1		# load constant value 1 into $t2
	# column = _tmp2043
	move $t3, $t2		# copy value
	# Goto _L317
	# (save modified registers before flow of control change)
	sw $t0, -3728($fp)	# spill _tmp2042 from $t0 to $fp-3728
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -3732($fp)	# spill _tmp2043 from $t2 to $fp-3732
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L317		# unconditional branch
_L316:
	# _tmp2044 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2045 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2046 = *(_tmp2045)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2047 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp2048 = _tmp2047 < _tmp2046
	slt $t5, $t4, $t3	
	# _tmp2049 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2050 = _tmp2049 < _tmp2047
	slt $t7, $t6, $t4	
	# _tmp2051 = _tmp2050 && _tmp2048
	and $s0, $t7, $t5	
	# IfZ _tmp2051 Goto _L332
	# (save modified registers before flow of control change)
	sw $t0, -3740($fp)	# spill _tmp2044 from $t0 to $fp-3740
	sw $t2, -3748($fp)	# spill _tmp2045 from $t2 to $fp-3748
	sw $t3, -3752($fp)	# spill _tmp2046 from $t3 to $fp-3752
	sw $t4, -3760($fp)	# spill _tmp2047 from $t4 to $fp-3760
	sw $t5, -3756($fp)	# spill _tmp2048 from $t5 to $fp-3756
	sw $t6, -3764($fp)	# spill _tmp2049 from $t6 to $fp-3764
	sw $t7, -3768($fp)	# spill _tmp2050 from $t7 to $fp-3768
	sw $s0, -3772($fp)	# spill _tmp2051 from $s0 to $fp-3772
	beqz $s0, _L332	# branch if _tmp2051 is zero 
	# _tmp2052 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2053 = _tmp2047 * _tmp2052
	lw $t1, -3760($fp)	# load _tmp2047 from $fp-3760 into $t1
	mul $t2, $t1, $t0	
	# _tmp2054 = _tmp2053 + _tmp2052
	add $t3, $t2, $t0	
	# _tmp2055 = _tmp2045 + _tmp2054
	lw $t4, -3748($fp)	# load _tmp2045 from $fp-3748 into $t4
	add $t5, $t4, $t3	
	# Goto _L333
	# (save modified registers before flow of control change)
	sw $t0, -3776($fp)	# spill _tmp2052 from $t0 to $fp-3776
	sw $t2, -3780($fp)	# spill _tmp2053 from $t2 to $fp-3780
	sw $t3, -3784($fp)	# spill _tmp2054 from $t3 to $fp-3784
	sw $t5, -3784($fp)	# spill _tmp2055 from $t5 to $fp-3784
	b _L333		# unconditional branch
_L332:
	# _tmp2056 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string145: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string145	# load label
	# PushParam _tmp2056
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3788($fp)	# spill _tmp2056 from $t0 to $fp-3788
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L333:
	# _tmp2057 = *(_tmp2055)
	lw $t0, -3784($fp)	# load _tmp2055 from $fp-3784 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2058 = *(_tmp2057)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2059 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp2060 = _tmp2059 < _tmp2058
	slt $t4, $t3, $t2	
	# _tmp2061 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2062 = _tmp2061 < _tmp2059
	slt $t6, $t5, $t3	
	# _tmp2063 = _tmp2062 && _tmp2060
	and $t7, $t6, $t4	
	# IfZ _tmp2063 Goto _L334
	# (save modified registers before flow of control change)
	sw $t1, -3792($fp)	# spill _tmp2057 from $t1 to $fp-3792
	sw $t2, -3796($fp)	# spill _tmp2058 from $t2 to $fp-3796
	sw $t3, -3804($fp)	# spill _tmp2059 from $t3 to $fp-3804
	sw $t4, -3800($fp)	# spill _tmp2060 from $t4 to $fp-3800
	sw $t5, -3808($fp)	# spill _tmp2061 from $t5 to $fp-3808
	sw $t6, -3812($fp)	# spill _tmp2062 from $t6 to $fp-3812
	sw $t7, -3816($fp)	# spill _tmp2063 from $t7 to $fp-3816
	beqz $t7, _L334	# branch if _tmp2063 is zero 
	# _tmp2064 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2065 = _tmp2059 * _tmp2064
	lw $t1, -3804($fp)	# load _tmp2059 from $fp-3804 into $t1
	mul $t2, $t1, $t0	
	# _tmp2066 = _tmp2065 + _tmp2064
	add $t3, $t2, $t0	
	# _tmp2067 = _tmp2057 + _tmp2066
	lw $t4, -3792($fp)	# load _tmp2057 from $fp-3792 into $t4
	add $t5, $t4, $t3	
	# Goto _L335
	# (save modified registers before flow of control change)
	sw $t0, -3820($fp)	# spill _tmp2064 from $t0 to $fp-3820
	sw $t2, -3824($fp)	# spill _tmp2065 from $t2 to $fp-3824
	sw $t3, -3828($fp)	# spill _tmp2066 from $t3 to $fp-3828
	sw $t5, -3828($fp)	# spill _tmp2067 from $t5 to $fp-3828
	b _L335		# unconditional branch
_L334:
	# _tmp2068 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string146: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string146	# load label
	# PushParam _tmp2068
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3832($fp)	# spill _tmp2068 from $t0 to $fp-3832
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L335:
	# _tmp2069 = *(_tmp2067)
	lw $t0, -3828($fp)	# load _tmp2067 from $fp-3828 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2070 = *(_tmp2069)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2071 = *(_tmp2070 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2069
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2072 = ACall _tmp2071
	# (save modified registers before flow of control change)
	sw $t1, -3836($fp)	# spill _tmp2069 from $t1 to $fp-3836
	sw $t2, -3840($fp)	# spill _tmp2070 from $t2 to $fp-3840
	sw $t3, -3844($fp)	# spill _tmp2071 from $t3 to $fp-3844
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2073 = _tmp2044 - _tmp2072
	lw $t1, -3740($fp)	# load _tmp2044 from $fp-3740 into $t1
	sub $t2, $t1, $t0	
	# _tmp2074 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp2075 = *(_tmp2074)
	lw $t5, 0($t4) 	# load with offset
	# _tmp2076 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp2077 = _tmp2076 < _tmp2075
	slt $t7, $t6, $t5	
	# _tmp2078 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp2079 = _tmp2078 < _tmp2076
	slt $s1, $s0, $t6	
	# _tmp2080 = _tmp2079 && _tmp2077
	and $s2, $s1, $t7	
	# IfZ _tmp2080 Goto _L336
	# (save modified registers before flow of control change)
	sw $t0, -3848($fp)	# spill _tmp2072 from $t0 to $fp-3848
	sw $t2, -3744($fp)	# spill _tmp2073 from $t2 to $fp-3744
	sw $t4, -3856($fp)	# spill _tmp2074 from $t4 to $fp-3856
	sw $t5, -3860($fp)	# spill _tmp2075 from $t5 to $fp-3860
	sw $t6, -3868($fp)	# spill _tmp2076 from $t6 to $fp-3868
	sw $t7, -3864($fp)	# spill _tmp2077 from $t7 to $fp-3864
	sw $s0, -3872($fp)	# spill _tmp2078 from $s0 to $fp-3872
	sw $s1, -3876($fp)	# spill _tmp2079 from $s1 to $fp-3876
	sw $s2, -3880($fp)	# spill _tmp2080 from $s2 to $fp-3880
	beqz $s2, _L336	# branch if _tmp2080 is zero 
	# _tmp2081 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2082 = _tmp2076 * _tmp2081
	lw $t1, -3868($fp)	# load _tmp2076 from $fp-3868 into $t1
	mul $t2, $t1, $t0	
	# _tmp2083 = _tmp2082 + _tmp2081
	add $t3, $t2, $t0	
	# _tmp2084 = _tmp2074 + _tmp2083
	lw $t4, -3856($fp)	# load _tmp2074 from $fp-3856 into $t4
	add $t5, $t4, $t3	
	# Goto _L337
	# (save modified registers before flow of control change)
	sw $t0, -3884($fp)	# spill _tmp2081 from $t0 to $fp-3884
	sw $t2, -3888($fp)	# spill _tmp2082 from $t2 to $fp-3888
	sw $t3, -3892($fp)	# spill _tmp2083 from $t3 to $fp-3892
	sw $t5, -3892($fp)	# spill _tmp2084 from $t5 to $fp-3892
	b _L337		# unconditional branch
_L336:
	# _tmp2085 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string147: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string147	# load label
	# PushParam _tmp2085
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3896($fp)	# spill _tmp2085 from $t0 to $fp-3896
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L337:
	# _tmp2086 = *(_tmp2084)
	lw $t0, -3892($fp)	# load _tmp2084 from $fp-3892 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2087 = *(_tmp2086)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2088 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp2089 = _tmp2088 < _tmp2087
	slt $t4, $t3, $t2	
	# _tmp2090 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2091 = _tmp2090 < _tmp2088
	slt $t6, $t5, $t3	
	# _tmp2092 = _tmp2091 && _tmp2089
	and $t7, $t6, $t4	
	# IfZ _tmp2092 Goto _L338
	# (save modified registers before flow of control change)
	sw $t1, -3900($fp)	# spill _tmp2086 from $t1 to $fp-3900
	sw $t2, -3904($fp)	# spill _tmp2087 from $t2 to $fp-3904
	sw $t3, -3912($fp)	# spill _tmp2088 from $t3 to $fp-3912
	sw $t4, -3908($fp)	# spill _tmp2089 from $t4 to $fp-3908
	sw $t5, -3916($fp)	# spill _tmp2090 from $t5 to $fp-3916
	sw $t6, -3920($fp)	# spill _tmp2091 from $t6 to $fp-3920
	sw $t7, -3924($fp)	# spill _tmp2092 from $t7 to $fp-3924
	beqz $t7, _L338	# branch if _tmp2092 is zero 
	# _tmp2093 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2094 = _tmp2088 * _tmp2093
	lw $t1, -3912($fp)	# load _tmp2088 from $fp-3912 into $t1
	mul $t2, $t1, $t0	
	# _tmp2095 = _tmp2094 + _tmp2093
	add $t3, $t2, $t0	
	# _tmp2096 = _tmp2086 + _tmp2095
	lw $t4, -3900($fp)	# load _tmp2086 from $fp-3900 into $t4
	add $t5, $t4, $t3	
	# Goto _L339
	# (save modified registers before flow of control change)
	sw $t0, -3928($fp)	# spill _tmp2093 from $t0 to $fp-3928
	sw $t2, -3932($fp)	# spill _tmp2094 from $t2 to $fp-3932
	sw $t3, -3936($fp)	# spill _tmp2095 from $t3 to $fp-3936
	sw $t5, -3936($fp)	# spill _tmp2096 from $t5 to $fp-3936
	b _L339		# unconditional branch
_L338:
	# _tmp2097 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string148: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string148	# load label
	# PushParam _tmp2097
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -3940($fp)	# spill _tmp2097 from $t0 to $fp-3940
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L339:
	# _tmp2098 = *(_tmp2096)
	lw $t0, -3936($fp)	# load _tmp2096 from $fp-3936 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2099 = *(_tmp2098)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2100 = *(_tmp2099 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2098
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2101 = ACall _tmp2100
	# (save modified registers before flow of control change)
	sw $t1, -3944($fp)	# spill _tmp2098 from $t1 to $fp-3944
	sw $t2, -3948($fp)	# spill _tmp2099 from $t2 to $fp-3948
	sw $t3, -3952($fp)	# spill _tmp2100 from $t3 to $fp-3952
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2102 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2103 = *(_tmp2102)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2104 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp2105 = _tmp2104 < _tmp2103
	slt $t5, $t4, $t3	
	# _tmp2106 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2107 = _tmp2106 < _tmp2104
	slt $t7, $t6, $t4	
	# _tmp2108 = _tmp2107 && _tmp2105
	and $s0, $t7, $t5	
	# IfZ _tmp2108 Goto _L340
	# (save modified registers before flow of control change)
	sw $t0, -3956($fp)	# spill _tmp2101 from $t0 to $fp-3956
	sw $t2, -3960($fp)	# spill _tmp2102 from $t2 to $fp-3960
	sw $t3, -3964($fp)	# spill _tmp2103 from $t3 to $fp-3964
	sw $t4, -3972($fp)	# spill _tmp2104 from $t4 to $fp-3972
	sw $t5, -3968($fp)	# spill _tmp2105 from $t5 to $fp-3968
	sw $t6, -3976($fp)	# spill _tmp2106 from $t6 to $fp-3976
	sw $t7, -3980($fp)	# spill _tmp2107 from $t7 to $fp-3980
	sw $s0, -3984($fp)	# spill _tmp2108 from $s0 to $fp-3984
	beqz $s0, _L340	# branch if _tmp2108 is zero 
	# _tmp2109 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2110 = _tmp2104 * _tmp2109
	lw $t1, -3972($fp)	# load _tmp2104 from $fp-3972 into $t1
	mul $t2, $t1, $t0	
	# _tmp2111 = _tmp2110 + _tmp2109
	add $t3, $t2, $t0	
	# _tmp2112 = _tmp2102 + _tmp2111
	lw $t4, -3960($fp)	# load _tmp2102 from $fp-3960 into $t4
	add $t5, $t4, $t3	
	# Goto _L341
	# (save modified registers before flow of control change)
	sw $t0, -3988($fp)	# spill _tmp2109 from $t0 to $fp-3988
	sw $t2, -3992($fp)	# spill _tmp2110 from $t2 to $fp-3992
	sw $t3, -3996($fp)	# spill _tmp2111 from $t3 to $fp-3996
	sw $t5, -3996($fp)	# spill _tmp2112 from $t5 to $fp-3996
	b _L341		# unconditional branch
_L340:
	# _tmp2113 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string149: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string149	# load label
	# PushParam _tmp2113
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4000($fp)	# spill _tmp2113 from $t0 to $fp-4000
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L341:
	# _tmp2114 = *(_tmp2112)
	lw $t0, -3996($fp)	# load _tmp2112 from $fp-3996 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2115 = *(_tmp2114)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2116 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp2117 = _tmp2116 < _tmp2115
	slt $t4, $t3, $t2	
	# _tmp2118 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2119 = _tmp2118 < _tmp2116
	slt $t6, $t5, $t3	
	# _tmp2120 = _tmp2119 && _tmp2117
	and $t7, $t6, $t4	
	# IfZ _tmp2120 Goto _L342
	# (save modified registers before flow of control change)
	sw $t1, -4004($fp)	# spill _tmp2114 from $t1 to $fp-4004
	sw $t2, -4008($fp)	# spill _tmp2115 from $t2 to $fp-4008
	sw $t3, -4016($fp)	# spill _tmp2116 from $t3 to $fp-4016
	sw $t4, -4012($fp)	# spill _tmp2117 from $t4 to $fp-4012
	sw $t5, -4020($fp)	# spill _tmp2118 from $t5 to $fp-4020
	sw $t6, -4024($fp)	# spill _tmp2119 from $t6 to $fp-4024
	sw $t7, -4028($fp)	# spill _tmp2120 from $t7 to $fp-4028
	beqz $t7, _L342	# branch if _tmp2120 is zero 
	# _tmp2121 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2122 = _tmp2116 * _tmp2121
	lw $t1, -4016($fp)	# load _tmp2116 from $fp-4016 into $t1
	mul $t2, $t1, $t0	
	# _tmp2123 = _tmp2122 + _tmp2121
	add $t3, $t2, $t0	
	# _tmp2124 = _tmp2114 + _tmp2123
	lw $t4, -4004($fp)	# load _tmp2114 from $fp-4004 into $t4
	add $t5, $t4, $t3	
	# Goto _L343
	# (save modified registers before flow of control change)
	sw $t0, -4032($fp)	# spill _tmp2121 from $t0 to $fp-4032
	sw $t2, -4036($fp)	# spill _tmp2122 from $t2 to $fp-4036
	sw $t3, -4040($fp)	# spill _tmp2123 from $t3 to $fp-4040
	sw $t5, -4040($fp)	# spill _tmp2124 from $t5 to $fp-4040
	b _L343		# unconditional branch
_L342:
	# _tmp2125 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string150: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string150	# load label
	# PushParam _tmp2125
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4044($fp)	# spill _tmp2125 from $t0 to $fp-4044
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L343:
	# _tmp2126 = *(_tmp2124)
	lw $t0, -4040($fp)	# load _tmp2124 from $fp-4040 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2127 = *(_tmp2126)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2128 = *(_tmp2127 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2126
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2129 = ACall _tmp2128
	# (save modified registers before flow of control change)
	sw $t1, -4048($fp)	# spill _tmp2126 from $t1 to $fp-4048
	sw $t2, -4052($fp)	# spill _tmp2127 from $t2 to $fp-4052
	sw $t3, -4056($fp)	# spill _tmp2128 from $t3 to $fp-4056
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2130 = _tmp2129 && _tmp2101
	lw $t1, -3956($fp)	# load _tmp2101 from $fp-3956 into $t1
	and $t2, $t0, $t1	
	# _tmp2131 = _tmp2130 && _tmp2073
	lw $t3, -3744($fp)	# load _tmp2073 from $fp-3744 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp2131 Goto _L330
	# (save modified registers before flow of control change)
	sw $t0, -4060($fp)	# spill _tmp2129 from $t0 to $fp-4060
	sw $t2, -3852($fp)	# spill _tmp2130 from $t2 to $fp-3852
	sw $t4, -3736($fp)	# spill _tmp2131 from $t4 to $fp-3736
	beqz $t4, _L330	# branch if _tmp2131 is zero 
	# _tmp2132 = 0
	li $t0, 0		# load constant value 0 into $t0
	# row = _tmp2132
	move $t1, $t0		# copy value
	# _tmp2133 = 2
	li $t2, 2		# load constant value 2 into $t2
	# column = _tmp2133
	move $t3, $t2		# copy value
	# Goto _L331
	# (save modified registers before flow of control change)
	sw $t0, -4064($fp)	# spill _tmp2132 from $t0 to $fp-4064
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -4068($fp)	# spill _tmp2133 from $t2 to $fp-4068
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L331		# unconditional branch
_L330:
	# _tmp2134 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2135 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2136 = *(_tmp2135)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2137 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp2138 = _tmp2137 < _tmp2136
	slt $t5, $t4, $t3	
	# _tmp2139 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2140 = _tmp2139 < _tmp2137
	slt $t7, $t6, $t4	
	# _tmp2141 = _tmp2140 && _tmp2138
	and $s0, $t7, $t5	
	# IfZ _tmp2141 Goto _L346
	# (save modified registers before flow of control change)
	sw $t0, -4076($fp)	# spill _tmp2134 from $t0 to $fp-4076
	sw $t2, -4084($fp)	# spill _tmp2135 from $t2 to $fp-4084
	sw $t3, -4088($fp)	# spill _tmp2136 from $t3 to $fp-4088
	sw $t4, -4096($fp)	# spill _tmp2137 from $t4 to $fp-4096
	sw $t5, -4092($fp)	# spill _tmp2138 from $t5 to $fp-4092
	sw $t6, -4100($fp)	# spill _tmp2139 from $t6 to $fp-4100
	sw $t7, -4104($fp)	# spill _tmp2140 from $t7 to $fp-4104
	sw $s0, -4108($fp)	# spill _tmp2141 from $s0 to $fp-4108
	beqz $s0, _L346	# branch if _tmp2141 is zero 
	# _tmp2142 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2143 = _tmp2137 * _tmp2142
	lw $t1, -4096($fp)	# load _tmp2137 from $fp-4096 into $t1
	mul $t2, $t1, $t0	
	# _tmp2144 = _tmp2143 + _tmp2142
	add $t3, $t2, $t0	
	# _tmp2145 = _tmp2135 + _tmp2144
	lw $t4, -4084($fp)	# load _tmp2135 from $fp-4084 into $t4
	add $t5, $t4, $t3	
	# Goto _L347
	# (save modified registers before flow of control change)
	sw $t0, -4112($fp)	# spill _tmp2142 from $t0 to $fp-4112
	sw $t2, -4116($fp)	# spill _tmp2143 from $t2 to $fp-4116
	sw $t3, -4120($fp)	# spill _tmp2144 from $t3 to $fp-4120
	sw $t5, -4120($fp)	# spill _tmp2145 from $t5 to $fp-4120
	b _L347		# unconditional branch
_L346:
	# _tmp2146 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string151: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string151	# load label
	# PushParam _tmp2146
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4124($fp)	# spill _tmp2146 from $t0 to $fp-4124
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L347:
	# _tmp2147 = *(_tmp2145)
	lw $t0, -4120($fp)	# load _tmp2145 from $fp-4120 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2148 = *(_tmp2147)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2149 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp2150 = _tmp2149 < _tmp2148
	slt $t4, $t3, $t2	
	# _tmp2151 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2152 = _tmp2151 < _tmp2149
	slt $t6, $t5, $t3	
	# _tmp2153 = _tmp2152 && _tmp2150
	and $t7, $t6, $t4	
	# IfZ _tmp2153 Goto _L348
	# (save modified registers before flow of control change)
	sw $t1, -4128($fp)	# spill _tmp2147 from $t1 to $fp-4128
	sw $t2, -4132($fp)	# spill _tmp2148 from $t2 to $fp-4132
	sw $t3, -4140($fp)	# spill _tmp2149 from $t3 to $fp-4140
	sw $t4, -4136($fp)	# spill _tmp2150 from $t4 to $fp-4136
	sw $t5, -4144($fp)	# spill _tmp2151 from $t5 to $fp-4144
	sw $t6, -4148($fp)	# spill _tmp2152 from $t6 to $fp-4148
	sw $t7, -4152($fp)	# spill _tmp2153 from $t7 to $fp-4152
	beqz $t7, _L348	# branch if _tmp2153 is zero 
	# _tmp2154 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2155 = _tmp2149 * _tmp2154
	lw $t1, -4140($fp)	# load _tmp2149 from $fp-4140 into $t1
	mul $t2, $t1, $t0	
	# _tmp2156 = _tmp2155 + _tmp2154
	add $t3, $t2, $t0	
	# _tmp2157 = _tmp2147 + _tmp2156
	lw $t4, -4128($fp)	# load _tmp2147 from $fp-4128 into $t4
	add $t5, $t4, $t3	
	# Goto _L349
	# (save modified registers before flow of control change)
	sw $t0, -4156($fp)	# spill _tmp2154 from $t0 to $fp-4156
	sw $t2, -4160($fp)	# spill _tmp2155 from $t2 to $fp-4160
	sw $t3, -4164($fp)	# spill _tmp2156 from $t3 to $fp-4164
	sw $t5, -4164($fp)	# spill _tmp2157 from $t5 to $fp-4164
	b _L349		# unconditional branch
_L348:
	# _tmp2158 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string152: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string152	# load label
	# PushParam _tmp2158
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4168($fp)	# spill _tmp2158 from $t0 to $fp-4168
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L349:
	# _tmp2159 = *(_tmp2157)
	lw $t0, -4164($fp)	# load _tmp2157 from $fp-4164 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2160 = *(_tmp2159)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2161 = *(_tmp2160 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2159
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2162 = ACall _tmp2161
	# (save modified registers before flow of control change)
	sw $t1, -4172($fp)	# spill _tmp2159 from $t1 to $fp-4172
	sw $t2, -4176($fp)	# spill _tmp2160 from $t2 to $fp-4176
	sw $t3, -4180($fp)	# spill _tmp2161 from $t3 to $fp-4180
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2163 = _tmp2134 - _tmp2162
	lw $t1, -4076($fp)	# load _tmp2134 from $fp-4076 into $t1
	sub $t2, $t1, $t0	
	# _tmp2164 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp2165 = *(_tmp2164)
	lw $t5, 0($t4) 	# load with offset
	# _tmp2166 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp2167 = _tmp2166 < _tmp2165
	slt $t7, $t6, $t5	
	# _tmp2168 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp2169 = _tmp2168 < _tmp2166
	slt $s1, $s0, $t6	
	# _tmp2170 = _tmp2169 && _tmp2167
	and $s2, $s1, $t7	
	# IfZ _tmp2170 Goto _L350
	# (save modified registers before flow of control change)
	sw $t0, -4184($fp)	# spill _tmp2162 from $t0 to $fp-4184
	sw $t2, -4080($fp)	# spill _tmp2163 from $t2 to $fp-4080
	sw $t4, -4192($fp)	# spill _tmp2164 from $t4 to $fp-4192
	sw $t5, -4196($fp)	# spill _tmp2165 from $t5 to $fp-4196
	sw $t6, -4204($fp)	# spill _tmp2166 from $t6 to $fp-4204
	sw $t7, -4200($fp)	# spill _tmp2167 from $t7 to $fp-4200
	sw $s0, -4208($fp)	# spill _tmp2168 from $s0 to $fp-4208
	sw $s1, -4212($fp)	# spill _tmp2169 from $s1 to $fp-4212
	sw $s2, -4216($fp)	# spill _tmp2170 from $s2 to $fp-4216
	beqz $s2, _L350	# branch if _tmp2170 is zero 
	# _tmp2171 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2172 = _tmp2166 * _tmp2171
	lw $t1, -4204($fp)	# load _tmp2166 from $fp-4204 into $t1
	mul $t2, $t1, $t0	
	# _tmp2173 = _tmp2172 + _tmp2171
	add $t3, $t2, $t0	
	# _tmp2174 = _tmp2164 + _tmp2173
	lw $t4, -4192($fp)	# load _tmp2164 from $fp-4192 into $t4
	add $t5, $t4, $t3	
	# Goto _L351
	# (save modified registers before flow of control change)
	sw $t0, -4220($fp)	# spill _tmp2171 from $t0 to $fp-4220
	sw $t2, -4224($fp)	# spill _tmp2172 from $t2 to $fp-4224
	sw $t3, -4228($fp)	# spill _tmp2173 from $t3 to $fp-4228
	sw $t5, -4228($fp)	# spill _tmp2174 from $t5 to $fp-4228
	b _L351		# unconditional branch
_L350:
	# _tmp2175 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string153: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string153	# load label
	# PushParam _tmp2175
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4232($fp)	# spill _tmp2175 from $t0 to $fp-4232
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L351:
	# _tmp2176 = *(_tmp2174)
	lw $t0, -4228($fp)	# load _tmp2174 from $fp-4228 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2177 = *(_tmp2176)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2178 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp2179 = _tmp2178 < _tmp2177
	slt $t4, $t3, $t2	
	# _tmp2180 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2181 = _tmp2180 < _tmp2178
	slt $t6, $t5, $t3	
	# _tmp2182 = _tmp2181 && _tmp2179
	and $t7, $t6, $t4	
	# IfZ _tmp2182 Goto _L352
	# (save modified registers before flow of control change)
	sw $t1, -4236($fp)	# spill _tmp2176 from $t1 to $fp-4236
	sw $t2, -4240($fp)	# spill _tmp2177 from $t2 to $fp-4240
	sw $t3, -4248($fp)	# spill _tmp2178 from $t3 to $fp-4248
	sw $t4, -4244($fp)	# spill _tmp2179 from $t4 to $fp-4244
	sw $t5, -4252($fp)	# spill _tmp2180 from $t5 to $fp-4252
	sw $t6, -4256($fp)	# spill _tmp2181 from $t6 to $fp-4256
	sw $t7, -4260($fp)	# spill _tmp2182 from $t7 to $fp-4260
	beqz $t7, _L352	# branch if _tmp2182 is zero 
	# _tmp2183 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2184 = _tmp2178 * _tmp2183
	lw $t1, -4248($fp)	# load _tmp2178 from $fp-4248 into $t1
	mul $t2, $t1, $t0	
	# _tmp2185 = _tmp2184 + _tmp2183
	add $t3, $t2, $t0	
	# _tmp2186 = _tmp2176 + _tmp2185
	lw $t4, -4236($fp)	# load _tmp2176 from $fp-4236 into $t4
	add $t5, $t4, $t3	
	# Goto _L353
	# (save modified registers before flow of control change)
	sw $t0, -4264($fp)	# spill _tmp2183 from $t0 to $fp-4264
	sw $t2, -4268($fp)	# spill _tmp2184 from $t2 to $fp-4268
	sw $t3, -4272($fp)	# spill _tmp2185 from $t3 to $fp-4272
	sw $t5, -4272($fp)	# spill _tmp2186 from $t5 to $fp-4272
	b _L353		# unconditional branch
_L352:
	# _tmp2187 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string154: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string154	# load label
	# PushParam _tmp2187
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4276($fp)	# spill _tmp2187 from $t0 to $fp-4276
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L353:
	# _tmp2188 = *(_tmp2186)
	lw $t0, -4272($fp)	# load _tmp2186 from $fp-4272 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2189 = *(_tmp2188)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2190 = *(_tmp2189 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2188
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2191 = ACall _tmp2190
	# (save modified registers before flow of control change)
	sw $t1, -4280($fp)	# spill _tmp2188 from $t1 to $fp-4280
	sw $t2, -4284($fp)	# spill _tmp2189 from $t2 to $fp-4284
	sw $t3, -4288($fp)	# spill _tmp2190 from $t3 to $fp-4288
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2192 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2193 = *(_tmp2192)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2194 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp2195 = _tmp2194 < _tmp2193
	slt $t5, $t4, $t3	
	# _tmp2196 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2197 = _tmp2196 < _tmp2194
	slt $t7, $t6, $t4	
	# _tmp2198 = _tmp2197 && _tmp2195
	and $s0, $t7, $t5	
	# IfZ _tmp2198 Goto _L354
	# (save modified registers before flow of control change)
	sw $t0, -4292($fp)	# spill _tmp2191 from $t0 to $fp-4292
	sw $t2, -4296($fp)	# spill _tmp2192 from $t2 to $fp-4296
	sw $t3, -4300($fp)	# spill _tmp2193 from $t3 to $fp-4300
	sw $t4, -4308($fp)	# spill _tmp2194 from $t4 to $fp-4308
	sw $t5, -4304($fp)	# spill _tmp2195 from $t5 to $fp-4304
	sw $t6, -4312($fp)	# spill _tmp2196 from $t6 to $fp-4312
	sw $t7, -4316($fp)	# spill _tmp2197 from $t7 to $fp-4316
	sw $s0, -4320($fp)	# spill _tmp2198 from $s0 to $fp-4320
	beqz $s0, _L354	# branch if _tmp2198 is zero 
	# _tmp2199 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2200 = _tmp2194 * _tmp2199
	lw $t1, -4308($fp)	# load _tmp2194 from $fp-4308 into $t1
	mul $t2, $t1, $t0	
	# _tmp2201 = _tmp2200 + _tmp2199
	add $t3, $t2, $t0	
	# _tmp2202 = _tmp2192 + _tmp2201
	lw $t4, -4296($fp)	# load _tmp2192 from $fp-4296 into $t4
	add $t5, $t4, $t3	
	# Goto _L355
	# (save modified registers before flow of control change)
	sw $t0, -4324($fp)	# spill _tmp2199 from $t0 to $fp-4324
	sw $t2, -4328($fp)	# spill _tmp2200 from $t2 to $fp-4328
	sw $t3, -4332($fp)	# spill _tmp2201 from $t3 to $fp-4332
	sw $t5, -4332($fp)	# spill _tmp2202 from $t5 to $fp-4332
	b _L355		# unconditional branch
_L354:
	# _tmp2203 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string155: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string155	# load label
	# PushParam _tmp2203
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4336($fp)	# spill _tmp2203 from $t0 to $fp-4336
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L355:
	# _tmp2204 = *(_tmp2202)
	lw $t0, -4332($fp)	# load _tmp2202 from $fp-4332 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2205 = *(_tmp2204)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2206 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp2207 = _tmp2206 < _tmp2205
	slt $t4, $t3, $t2	
	# _tmp2208 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2209 = _tmp2208 < _tmp2206
	slt $t6, $t5, $t3	
	# _tmp2210 = _tmp2209 && _tmp2207
	and $t7, $t6, $t4	
	# IfZ _tmp2210 Goto _L356
	# (save modified registers before flow of control change)
	sw $t1, -4340($fp)	# spill _tmp2204 from $t1 to $fp-4340
	sw $t2, -4344($fp)	# spill _tmp2205 from $t2 to $fp-4344
	sw $t3, -4352($fp)	# spill _tmp2206 from $t3 to $fp-4352
	sw $t4, -4348($fp)	# spill _tmp2207 from $t4 to $fp-4348
	sw $t5, -4356($fp)	# spill _tmp2208 from $t5 to $fp-4356
	sw $t6, -4360($fp)	# spill _tmp2209 from $t6 to $fp-4360
	sw $t7, -4364($fp)	# spill _tmp2210 from $t7 to $fp-4364
	beqz $t7, _L356	# branch if _tmp2210 is zero 
	# _tmp2211 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2212 = _tmp2206 * _tmp2211
	lw $t1, -4352($fp)	# load _tmp2206 from $fp-4352 into $t1
	mul $t2, $t1, $t0	
	# _tmp2213 = _tmp2212 + _tmp2211
	add $t3, $t2, $t0	
	# _tmp2214 = _tmp2204 + _tmp2213
	lw $t4, -4340($fp)	# load _tmp2204 from $fp-4340 into $t4
	add $t5, $t4, $t3	
	# Goto _L357
	# (save modified registers before flow of control change)
	sw $t0, -4368($fp)	# spill _tmp2211 from $t0 to $fp-4368
	sw $t2, -4372($fp)	# spill _tmp2212 from $t2 to $fp-4372
	sw $t3, -4376($fp)	# spill _tmp2213 from $t3 to $fp-4376
	sw $t5, -4376($fp)	# spill _tmp2214 from $t5 to $fp-4376
	b _L357		# unconditional branch
_L356:
	# _tmp2215 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string156: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string156	# load label
	# PushParam _tmp2215
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4380($fp)	# spill _tmp2215 from $t0 to $fp-4380
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L357:
	# _tmp2216 = *(_tmp2214)
	lw $t0, -4376($fp)	# load _tmp2214 from $fp-4376 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2217 = *(_tmp2216)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2218 = *(_tmp2217 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2216
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2219 = ACall _tmp2218
	# (save modified registers before flow of control change)
	sw $t1, -4384($fp)	# spill _tmp2216 from $t1 to $fp-4384
	sw $t2, -4388($fp)	# spill _tmp2217 from $t2 to $fp-4388
	sw $t3, -4392($fp)	# spill _tmp2218 from $t3 to $fp-4392
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2220 = _tmp2219 && _tmp2191
	lw $t1, -4292($fp)	# load _tmp2191 from $fp-4292 into $t1
	and $t2, $t0, $t1	
	# _tmp2221 = _tmp2220 && _tmp2163
	lw $t3, -4080($fp)	# load _tmp2163 from $fp-4080 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp2221 Goto _L344
	# (save modified registers before flow of control change)
	sw $t0, -4396($fp)	# spill _tmp2219 from $t0 to $fp-4396
	sw $t2, -4188($fp)	# spill _tmp2220 from $t2 to $fp-4188
	sw $t4, -4072($fp)	# spill _tmp2221 from $t4 to $fp-4072
	beqz $t4, _L344	# branch if _tmp2221 is zero 
	# _tmp2222 = 2
	li $t0, 2		# load constant value 2 into $t0
	# row = _tmp2222
	move $t1, $t0		# copy value
	# _tmp2223 = 2
	li $t2, 2		# load constant value 2 into $t2
	# column = _tmp2223
	move $t3, $t2		# copy value
	# Goto _L345
	# (save modified registers before flow of control change)
	sw $t0, -4400($fp)	# spill _tmp2222 from $t0 to $fp-4400
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -4404($fp)	# spill _tmp2223 from $t2 to $fp-4404
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L345		# unconditional branch
_L344:
	# _tmp2224 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2225 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2226 = *(_tmp2225)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2227 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp2228 = _tmp2227 < _tmp2226
	slt $t5, $t4, $t3	
	# _tmp2229 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2230 = _tmp2229 < _tmp2227
	slt $t7, $t6, $t4	
	# _tmp2231 = _tmp2230 && _tmp2228
	and $s0, $t7, $t5	
	# IfZ _tmp2231 Goto _L360
	# (save modified registers before flow of control change)
	sw $t0, -4412($fp)	# spill _tmp2224 from $t0 to $fp-4412
	sw $t2, -4420($fp)	# spill _tmp2225 from $t2 to $fp-4420
	sw $t3, -4424($fp)	# spill _tmp2226 from $t3 to $fp-4424
	sw $t4, -4432($fp)	# spill _tmp2227 from $t4 to $fp-4432
	sw $t5, -4428($fp)	# spill _tmp2228 from $t5 to $fp-4428
	sw $t6, -4436($fp)	# spill _tmp2229 from $t6 to $fp-4436
	sw $t7, -4440($fp)	# spill _tmp2230 from $t7 to $fp-4440
	sw $s0, -4444($fp)	# spill _tmp2231 from $s0 to $fp-4444
	beqz $s0, _L360	# branch if _tmp2231 is zero 
	# _tmp2232 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2233 = _tmp2227 * _tmp2232
	lw $t1, -4432($fp)	# load _tmp2227 from $fp-4432 into $t1
	mul $t2, $t1, $t0	
	# _tmp2234 = _tmp2233 + _tmp2232
	add $t3, $t2, $t0	
	# _tmp2235 = _tmp2225 + _tmp2234
	lw $t4, -4420($fp)	# load _tmp2225 from $fp-4420 into $t4
	add $t5, $t4, $t3	
	# Goto _L361
	# (save modified registers before flow of control change)
	sw $t0, -4448($fp)	# spill _tmp2232 from $t0 to $fp-4448
	sw $t2, -4452($fp)	# spill _tmp2233 from $t2 to $fp-4452
	sw $t3, -4456($fp)	# spill _tmp2234 from $t3 to $fp-4456
	sw $t5, -4456($fp)	# spill _tmp2235 from $t5 to $fp-4456
	b _L361		# unconditional branch
_L360:
	# _tmp2236 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string157: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string157	# load label
	# PushParam _tmp2236
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4460($fp)	# spill _tmp2236 from $t0 to $fp-4460
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L361:
	# _tmp2237 = *(_tmp2235)
	lw $t0, -4456($fp)	# load _tmp2235 from $fp-4456 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2238 = *(_tmp2237)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2239 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp2240 = _tmp2239 < _tmp2238
	slt $t4, $t3, $t2	
	# _tmp2241 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2242 = _tmp2241 < _tmp2239
	slt $t6, $t5, $t3	
	# _tmp2243 = _tmp2242 && _tmp2240
	and $t7, $t6, $t4	
	# IfZ _tmp2243 Goto _L362
	# (save modified registers before flow of control change)
	sw $t1, -4464($fp)	# spill _tmp2237 from $t1 to $fp-4464
	sw $t2, -4468($fp)	# spill _tmp2238 from $t2 to $fp-4468
	sw $t3, -4476($fp)	# spill _tmp2239 from $t3 to $fp-4476
	sw $t4, -4472($fp)	# spill _tmp2240 from $t4 to $fp-4472
	sw $t5, -4480($fp)	# spill _tmp2241 from $t5 to $fp-4480
	sw $t6, -4484($fp)	# spill _tmp2242 from $t6 to $fp-4484
	sw $t7, -4488($fp)	# spill _tmp2243 from $t7 to $fp-4488
	beqz $t7, _L362	# branch if _tmp2243 is zero 
	# _tmp2244 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2245 = _tmp2239 * _tmp2244
	lw $t1, -4476($fp)	# load _tmp2239 from $fp-4476 into $t1
	mul $t2, $t1, $t0	
	# _tmp2246 = _tmp2245 + _tmp2244
	add $t3, $t2, $t0	
	# _tmp2247 = _tmp2237 + _tmp2246
	lw $t4, -4464($fp)	# load _tmp2237 from $fp-4464 into $t4
	add $t5, $t4, $t3	
	# Goto _L363
	# (save modified registers before flow of control change)
	sw $t0, -4492($fp)	# spill _tmp2244 from $t0 to $fp-4492
	sw $t2, -4496($fp)	# spill _tmp2245 from $t2 to $fp-4496
	sw $t3, -4500($fp)	# spill _tmp2246 from $t3 to $fp-4500
	sw $t5, -4500($fp)	# spill _tmp2247 from $t5 to $fp-4500
	b _L363		# unconditional branch
_L362:
	# _tmp2248 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string158: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string158	# load label
	# PushParam _tmp2248
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4504($fp)	# spill _tmp2248 from $t0 to $fp-4504
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L363:
	# _tmp2249 = *(_tmp2247)
	lw $t0, -4500($fp)	# load _tmp2247 from $fp-4500 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2250 = *(_tmp2249)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2251 = *(_tmp2250 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2249
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2252 = ACall _tmp2251
	# (save modified registers before flow of control change)
	sw $t1, -4508($fp)	# spill _tmp2249 from $t1 to $fp-4508
	sw $t2, -4512($fp)	# spill _tmp2250 from $t2 to $fp-4512
	sw $t3, -4516($fp)	# spill _tmp2251 from $t3 to $fp-4516
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2253 = _tmp2224 - _tmp2252
	lw $t1, -4412($fp)	# load _tmp2224 from $fp-4412 into $t1
	sub $t2, $t1, $t0	
	# _tmp2254 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp2255 = *(_tmp2254)
	lw $t5, 0($t4) 	# load with offset
	# _tmp2256 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp2257 = _tmp2256 < _tmp2255
	slt $t7, $t6, $t5	
	# _tmp2258 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp2259 = _tmp2258 < _tmp2256
	slt $s1, $s0, $t6	
	# _tmp2260 = _tmp2259 && _tmp2257
	and $s2, $s1, $t7	
	# IfZ _tmp2260 Goto _L364
	# (save modified registers before flow of control change)
	sw $t0, -4520($fp)	# spill _tmp2252 from $t0 to $fp-4520
	sw $t2, -4416($fp)	# spill _tmp2253 from $t2 to $fp-4416
	sw $t4, -4528($fp)	# spill _tmp2254 from $t4 to $fp-4528
	sw $t5, -4532($fp)	# spill _tmp2255 from $t5 to $fp-4532
	sw $t6, -4540($fp)	# spill _tmp2256 from $t6 to $fp-4540
	sw $t7, -4536($fp)	# spill _tmp2257 from $t7 to $fp-4536
	sw $s0, -4544($fp)	# spill _tmp2258 from $s0 to $fp-4544
	sw $s1, -4548($fp)	# spill _tmp2259 from $s1 to $fp-4548
	sw $s2, -4552($fp)	# spill _tmp2260 from $s2 to $fp-4552
	beqz $s2, _L364	# branch if _tmp2260 is zero 
	# _tmp2261 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2262 = _tmp2256 * _tmp2261
	lw $t1, -4540($fp)	# load _tmp2256 from $fp-4540 into $t1
	mul $t2, $t1, $t0	
	# _tmp2263 = _tmp2262 + _tmp2261
	add $t3, $t2, $t0	
	# _tmp2264 = _tmp2254 + _tmp2263
	lw $t4, -4528($fp)	# load _tmp2254 from $fp-4528 into $t4
	add $t5, $t4, $t3	
	# Goto _L365
	# (save modified registers before flow of control change)
	sw $t0, -4556($fp)	# spill _tmp2261 from $t0 to $fp-4556
	sw $t2, -4560($fp)	# spill _tmp2262 from $t2 to $fp-4560
	sw $t3, -4564($fp)	# spill _tmp2263 from $t3 to $fp-4564
	sw $t5, -4564($fp)	# spill _tmp2264 from $t5 to $fp-4564
	b _L365		# unconditional branch
_L364:
	# _tmp2265 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string159: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string159	# load label
	# PushParam _tmp2265
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4568($fp)	# spill _tmp2265 from $t0 to $fp-4568
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L365:
	# _tmp2266 = *(_tmp2264)
	lw $t0, -4564($fp)	# load _tmp2264 from $fp-4564 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2267 = *(_tmp2266)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2268 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp2269 = _tmp2268 < _tmp2267
	slt $t4, $t3, $t2	
	# _tmp2270 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2271 = _tmp2270 < _tmp2268
	slt $t6, $t5, $t3	
	# _tmp2272 = _tmp2271 && _tmp2269
	and $t7, $t6, $t4	
	# IfZ _tmp2272 Goto _L366
	# (save modified registers before flow of control change)
	sw $t1, -4572($fp)	# spill _tmp2266 from $t1 to $fp-4572
	sw $t2, -4576($fp)	# spill _tmp2267 from $t2 to $fp-4576
	sw $t3, -4584($fp)	# spill _tmp2268 from $t3 to $fp-4584
	sw $t4, -4580($fp)	# spill _tmp2269 from $t4 to $fp-4580
	sw $t5, -4588($fp)	# spill _tmp2270 from $t5 to $fp-4588
	sw $t6, -4592($fp)	# spill _tmp2271 from $t6 to $fp-4592
	sw $t7, -4596($fp)	# spill _tmp2272 from $t7 to $fp-4596
	beqz $t7, _L366	# branch if _tmp2272 is zero 
	# _tmp2273 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2274 = _tmp2268 * _tmp2273
	lw $t1, -4584($fp)	# load _tmp2268 from $fp-4584 into $t1
	mul $t2, $t1, $t0	
	# _tmp2275 = _tmp2274 + _tmp2273
	add $t3, $t2, $t0	
	# _tmp2276 = _tmp2266 + _tmp2275
	lw $t4, -4572($fp)	# load _tmp2266 from $fp-4572 into $t4
	add $t5, $t4, $t3	
	# Goto _L367
	# (save modified registers before flow of control change)
	sw $t0, -4600($fp)	# spill _tmp2273 from $t0 to $fp-4600
	sw $t2, -4604($fp)	# spill _tmp2274 from $t2 to $fp-4604
	sw $t3, -4608($fp)	# spill _tmp2275 from $t3 to $fp-4608
	sw $t5, -4608($fp)	# spill _tmp2276 from $t5 to $fp-4608
	b _L367		# unconditional branch
_L366:
	# _tmp2277 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string160: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string160	# load label
	# PushParam _tmp2277
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4612($fp)	# spill _tmp2277 from $t0 to $fp-4612
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L367:
	# _tmp2278 = *(_tmp2276)
	lw $t0, -4608($fp)	# load _tmp2276 from $fp-4608 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2279 = *(_tmp2278)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2280 = *(_tmp2279 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2278
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2281 = ACall _tmp2280
	# (save modified registers before flow of control change)
	sw $t1, -4616($fp)	# spill _tmp2278 from $t1 to $fp-4616
	sw $t2, -4620($fp)	# spill _tmp2279 from $t2 to $fp-4620
	sw $t3, -4624($fp)	# spill _tmp2280 from $t3 to $fp-4624
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2282 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2283 = *(_tmp2282)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2284 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp2285 = _tmp2284 < _tmp2283
	slt $t5, $t4, $t3	
	# _tmp2286 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2287 = _tmp2286 < _tmp2284
	slt $t7, $t6, $t4	
	# _tmp2288 = _tmp2287 && _tmp2285
	and $s0, $t7, $t5	
	# IfZ _tmp2288 Goto _L368
	# (save modified registers before flow of control change)
	sw $t0, -4628($fp)	# spill _tmp2281 from $t0 to $fp-4628
	sw $t2, -4632($fp)	# spill _tmp2282 from $t2 to $fp-4632
	sw $t3, -4636($fp)	# spill _tmp2283 from $t3 to $fp-4636
	sw $t4, -4644($fp)	# spill _tmp2284 from $t4 to $fp-4644
	sw $t5, -4640($fp)	# spill _tmp2285 from $t5 to $fp-4640
	sw $t6, -4648($fp)	# spill _tmp2286 from $t6 to $fp-4648
	sw $t7, -4652($fp)	# spill _tmp2287 from $t7 to $fp-4652
	sw $s0, -4656($fp)	# spill _tmp2288 from $s0 to $fp-4656
	beqz $s0, _L368	# branch if _tmp2288 is zero 
	# _tmp2289 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2290 = _tmp2284 * _tmp2289
	lw $t1, -4644($fp)	# load _tmp2284 from $fp-4644 into $t1
	mul $t2, $t1, $t0	
	# _tmp2291 = _tmp2290 + _tmp2289
	add $t3, $t2, $t0	
	# _tmp2292 = _tmp2282 + _tmp2291
	lw $t4, -4632($fp)	# load _tmp2282 from $fp-4632 into $t4
	add $t5, $t4, $t3	
	# Goto _L369
	# (save modified registers before flow of control change)
	sw $t0, -4660($fp)	# spill _tmp2289 from $t0 to $fp-4660
	sw $t2, -4664($fp)	# spill _tmp2290 from $t2 to $fp-4664
	sw $t3, -4668($fp)	# spill _tmp2291 from $t3 to $fp-4668
	sw $t5, -4668($fp)	# spill _tmp2292 from $t5 to $fp-4668
	b _L369		# unconditional branch
_L368:
	# _tmp2293 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string161: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string161	# load label
	# PushParam _tmp2293
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4672($fp)	# spill _tmp2293 from $t0 to $fp-4672
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L369:
	# _tmp2294 = *(_tmp2292)
	lw $t0, -4668($fp)	# load _tmp2292 from $fp-4668 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2295 = *(_tmp2294)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2296 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp2297 = _tmp2296 < _tmp2295
	slt $t4, $t3, $t2	
	# _tmp2298 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2299 = _tmp2298 < _tmp2296
	slt $t6, $t5, $t3	
	# _tmp2300 = _tmp2299 && _tmp2297
	and $t7, $t6, $t4	
	# IfZ _tmp2300 Goto _L370
	# (save modified registers before flow of control change)
	sw $t1, -4676($fp)	# spill _tmp2294 from $t1 to $fp-4676
	sw $t2, -4680($fp)	# spill _tmp2295 from $t2 to $fp-4680
	sw $t3, -4688($fp)	# spill _tmp2296 from $t3 to $fp-4688
	sw $t4, -4684($fp)	# spill _tmp2297 from $t4 to $fp-4684
	sw $t5, -4692($fp)	# spill _tmp2298 from $t5 to $fp-4692
	sw $t6, -4696($fp)	# spill _tmp2299 from $t6 to $fp-4696
	sw $t7, -4700($fp)	# spill _tmp2300 from $t7 to $fp-4700
	beqz $t7, _L370	# branch if _tmp2300 is zero 
	# _tmp2301 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2302 = _tmp2296 * _tmp2301
	lw $t1, -4688($fp)	# load _tmp2296 from $fp-4688 into $t1
	mul $t2, $t1, $t0	
	# _tmp2303 = _tmp2302 + _tmp2301
	add $t3, $t2, $t0	
	# _tmp2304 = _tmp2294 + _tmp2303
	lw $t4, -4676($fp)	# load _tmp2294 from $fp-4676 into $t4
	add $t5, $t4, $t3	
	# Goto _L371
	# (save modified registers before flow of control change)
	sw $t0, -4704($fp)	# spill _tmp2301 from $t0 to $fp-4704
	sw $t2, -4708($fp)	# spill _tmp2302 from $t2 to $fp-4708
	sw $t3, -4712($fp)	# spill _tmp2303 from $t3 to $fp-4712
	sw $t5, -4712($fp)	# spill _tmp2304 from $t5 to $fp-4712
	b _L371		# unconditional branch
_L370:
	# _tmp2305 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string162: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string162	# load label
	# PushParam _tmp2305
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4716($fp)	# spill _tmp2305 from $t0 to $fp-4716
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L371:
	# _tmp2306 = *(_tmp2304)
	lw $t0, -4712($fp)	# load _tmp2304 from $fp-4712 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2307 = *(_tmp2306)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2308 = *(_tmp2307 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2306
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2309 = ACall _tmp2308
	# (save modified registers before flow of control change)
	sw $t1, -4720($fp)	# spill _tmp2306 from $t1 to $fp-4720
	sw $t2, -4724($fp)	# spill _tmp2307 from $t2 to $fp-4724
	sw $t3, -4728($fp)	# spill _tmp2308 from $t3 to $fp-4728
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2310 = _tmp2309 && _tmp2281
	lw $t1, -4628($fp)	# load _tmp2281 from $fp-4628 into $t1
	and $t2, $t0, $t1	
	# _tmp2311 = _tmp2310 && _tmp2253
	lw $t3, -4416($fp)	# load _tmp2253 from $fp-4416 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp2311 Goto _L358
	# (save modified registers before flow of control change)
	sw $t0, -4732($fp)	# spill _tmp2309 from $t0 to $fp-4732
	sw $t2, -4524($fp)	# spill _tmp2310 from $t2 to $fp-4524
	sw $t4, -4408($fp)	# spill _tmp2311 from $t4 to $fp-4408
	beqz $t4, _L358	# branch if _tmp2311 is zero 
	# _tmp2312 = 0
	li $t0, 0		# load constant value 0 into $t0
	# row = _tmp2312
	move $t1, $t0		# copy value
	# _tmp2313 = 0
	li $t2, 0		# load constant value 0 into $t2
	# column = _tmp2313
	move $t3, $t2		# copy value
	# Goto _L359
	# (save modified registers before flow of control change)
	sw $t0, -4736($fp)	# spill _tmp2312 from $t0 to $fp-4736
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -4740($fp)	# spill _tmp2313 from $t2 to $fp-4740
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L359		# unconditional branch
_L358:
	# _tmp2314 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2315 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2316 = *(_tmp2315)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2317 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp2318 = _tmp2317 < _tmp2316
	slt $t5, $t4, $t3	
	# _tmp2319 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2320 = _tmp2319 < _tmp2317
	slt $t7, $t6, $t4	
	# _tmp2321 = _tmp2320 && _tmp2318
	and $s0, $t7, $t5	
	# IfZ _tmp2321 Goto _L374
	# (save modified registers before flow of control change)
	sw $t0, -4748($fp)	# spill _tmp2314 from $t0 to $fp-4748
	sw $t2, -4756($fp)	# spill _tmp2315 from $t2 to $fp-4756
	sw $t3, -4760($fp)	# spill _tmp2316 from $t3 to $fp-4760
	sw $t4, -4768($fp)	# spill _tmp2317 from $t4 to $fp-4768
	sw $t5, -4764($fp)	# spill _tmp2318 from $t5 to $fp-4764
	sw $t6, -4772($fp)	# spill _tmp2319 from $t6 to $fp-4772
	sw $t7, -4776($fp)	# spill _tmp2320 from $t7 to $fp-4776
	sw $s0, -4780($fp)	# spill _tmp2321 from $s0 to $fp-4780
	beqz $s0, _L374	# branch if _tmp2321 is zero 
	# _tmp2322 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2323 = _tmp2317 * _tmp2322
	lw $t1, -4768($fp)	# load _tmp2317 from $fp-4768 into $t1
	mul $t2, $t1, $t0	
	# _tmp2324 = _tmp2323 + _tmp2322
	add $t3, $t2, $t0	
	# _tmp2325 = _tmp2315 + _tmp2324
	lw $t4, -4756($fp)	# load _tmp2315 from $fp-4756 into $t4
	add $t5, $t4, $t3	
	# Goto _L375
	# (save modified registers before flow of control change)
	sw $t0, -4784($fp)	# spill _tmp2322 from $t0 to $fp-4784
	sw $t2, -4788($fp)	# spill _tmp2323 from $t2 to $fp-4788
	sw $t3, -4792($fp)	# spill _tmp2324 from $t3 to $fp-4792
	sw $t5, -4792($fp)	# spill _tmp2325 from $t5 to $fp-4792
	b _L375		# unconditional branch
_L374:
	# _tmp2326 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string163: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string163	# load label
	# PushParam _tmp2326
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4796($fp)	# spill _tmp2326 from $t0 to $fp-4796
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L375:
	# _tmp2327 = *(_tmp2325)
	lw $t0, -4792($fp)	# load _tmp2325 from $fp-4792 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2328 = *(_tmp2327)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2329 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp2330 = _tmp2329 < _tmp2328
	slt $t4, $t3, $t2	
	# _tmp2331 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2332 = _tmp2331 < _tmp2329
	slt $t6, $t5, $t3	
	# _tmp2333 = _tmp2332 && _tmp2330
	and $t7, $t6, $t4	
	# IfZ _tmp2333 Goto _L376
	# (save modified registers before flow of control change)
	sw $t1, -4800($fp)	# spill _tmp2327 from $t1 to $fp-4800
	sw $t2, -4804($fp)	# spill _tmp2328 from $t2 to $fp-4804
	sw $t3, -4812($fp)	# spill _tmp2329 from $t3 to $fp-4812
	sw $t4, -4808($fp)	# spill _tmp2330 from $t4 to $fp-4808
	sw $t5, -4816($fp)	# spill _tmp2331 from $t5 to $fp-4816
	sw $t6, -4820($fp)	# spill _tmp2332 from $t6 to $fp-4820
	sw $t7, -4824($fp)	# spill _tmp2333 from $t7 to $fp-4824
	beqz $t7, _L376	# branch if _tmp2333 is zero 
	# _tmp2334 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2335 = _tmp2329 * _tmp2334
	lw $t1, -4812($fp)	# load _tmp2329 from $fp-4812 into $t1
	mul $t2, $t1, $t0	
	# _tmp2336 = _tmp2335 + _tmp2334
	add $t3, $t2, $t0	
	# _tmp2337 = _tmp2327 + _tmp2336
	lw $t4, -4800($fp)	# load _tmp2327 from $fp-4800 into $t4
	add $t5, $t4, $t3	
	# Goto _L377
	# (save modified registers before flow of control change)
	sw $t0, -4828($fp)	# spill _tmp2334 from $t0 to $fp-4828
	sw $t2, -4832($fp)	# spill _tmp2335 from $t2 to $fp-4832
	sw $t3, -4836($fp)	# spill _tmp2336 from $t3 to $fp-4836
	sw $t5, -4836($fp)	# spill _tmp2337 from $t5 to $fp-4836
	b _L377		# unconditional branch
_L376:
	# _tmp2338 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string164: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string164	# load label
	# PushParam _tmp2338
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4840($fp)	# spill _tmp2338 from $t0 to $fp-4840
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L377:
	# _tmp2339 = *(_tmp2337)
	lw $t0, -4836($fp)	# load _tmp2337 from $fp-4836 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2340 = *(_tmp2339)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2341 = *(_tmp2340 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2339
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2342 = ACall _tmp2341
	# (save modified registers before flow of control change)
	sw $t1, -4844($fp)	# spill _tmp2339 from $t1 to $fp-4844
	sw $t2, -4848($fp)	# spill _tmp2340 from $t2 to $fp-4848
	sw $t3, -4852($fp)	# spill _tmp2341 from $t3 to $fp-4852
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2343 = _tmp2314 - _tmp2342
	lw $t1, -4748($fp)	# load _tmp2314 from $fp-4748 into $t1
	sub $t2, $t1, $t0	
	# _tmp2344 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp2345 = *(_tmp2344)
	lw $t5, 0($t4) 	# load with offset
	# _tmp2346 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp2347 = _tmp2346 < _tmp2345
	slt $t7, $t6, $t5	
	# _tmp2348 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp2349 = _tmp2348 < _tmp2346
	slt $s1, $s0, $t6	
	# _tmp2350 = _tmp2349 && _tmp2347
	and $s2, $s1, $t7	
	# IfZ _tmp2350 Goto _L378
	# (save modified registers before flow of control change)
	sw $t0, -4856($fp)	# spill _tmp2342 from $t0 to $fp-4856
	sw $t2, -4752($fp)	# spill _tmp2343 from $t2 to $fp-4752
	sw $t4, -4864($fp)	# spill _tmp2344 from $t4 to $fp-4864
	sw $t5, -4868($fp)	# spill _tmp2345 from $t5 to $fp-4868
	sw $t6, -4876($fp)	# spill _tmp2346 from $t6 to $fp-4876
	sw $t7, -4872($fp)	# spill _tmp2347 from $t7 to $fp-4872
	sw $s0, -4880($fp)	# spill _tmp2348 from $s0 to $fp-4880
	sw $s1, -4884($fp)	# spill _tmp2349 from $s1 to $fp-4884
	sw $s2, -4888($fp)	# spill _tmp2350 from $s2 to $fp-4888
	beqz $s2, _L378	# branch if _tmp2350 is zero 
	# _tmp2351 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2352 = _tmp2346 * _tmp2351
	lw $t1, -4876($fp)	# load _tmp2346 from $fp-4876 into $t1
	mul $t2, $t1, $t0	
	# _tmp2353 = _tmp2352 + _tmp2351
	add $t3, $t2, $t0	
	# _tmp2354 = _tmp2344 + _tmp2353
	lw $t4, -4864($fp)	# load _tmp2344 from $fp-4864 into $t4
	add $t5, $t4, $t3	
	# Goto _L379
	# (save modified registers before flow of control change)
	sw $t0, -4892($fp)	# spill _tmp2351 from $t0 to $fp-4892
	sw $t2, -4896($fp)	# spill _tmp2352 from $t2 to $fp-4896
	sw $t3, -4900($fp)	# spill _tmp2353 from $t3 to $fp-4900
	sw $t5, -4900($fp)	# spill _tmp2354 from $t5 to $fp-4900
	b _L379		# unconditional branch
_L378:
	# _tmp2355 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string165: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string165	# load label
	# PushParam _tmp2355
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4904($fp)	# spill _tmp2355 from $t0 to $fp-4904
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L379:
	# _tmp2356 = *(_tmp2354)
	lw $t0, -4900($fp)	# load _tmp2354 from $fp-4900 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2357 = *(_tmp2356)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2358 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp2359 = _tmp2358 < _tmp2357
	slt $t4, $t3, $t2	
	# _tmp2360 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2361 = _tmp2360 < _tmp2358
	slt $t6, $t5, $t3	
	# _tmp2362 = _tmp2361 && _tmp2359
	and $t7, $t6, $t4	
	# IfZ _tmp2362 Goto _L380
	# (save modified registers before flow of control change)
	sw $t1, -4908($fp)	# spill _tmp2356 from $t1 to $fp-4908
	sw $t2, -4912($fp)	# spill _tmp2357 from $t2 to $fp-4912
	sw $t3, -4920($fp)	# spill _tmp2358 from $t3 to $fp-4920
	sw $t4, -4916($fp)	# spill _tmp2359 from $t4 to $fp-4916
	sw $t5, -4924($fp)	# spill _tmp2360 from $t5 to $fp-4924
	sw $t6, -4928($fp)	# spill _tmp2361 from $t6 to $fp-4928
	sw $t7, -4932($fp)	# spill _tmp2362 from $t7 to $fp-4932
	beqz $t7, _L380	# branch if _tmp2362 is zero 
	# _tmp2363 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2364 = _tmp2358 * _tmp2363
	lw $t1, -4920($fp)	# load _tmp2358 from $fp-4920 into $t1
	mul $t2, $t1, $t0	
	# _tmp2365 = _tmp2364 + _tmp2363
	add $t3, $t2, $t0	
	# _tmp2366 = _tmp2356 + _tmp2365
	lw $t4, -4908($fp)	# load _tmp2356 from $fp-4908 into $t4
	add $t5, $t4, $t3	
	# Goto _L381
	# (save modified registers before flow of control change)
	sw $t0, -4936($fp)	# spill _tmp2363 from $t0 to $fp-4936
	sw $t2, -4940($fp)	# spill _tmp2364 from $t2 to $fp-4940
	sw $t3, -4944($fp)	# spill _tmp2365 from $t3 to $fp-4944
	sw $t5, -4944($fp)	# spill _tmp2366 from $t5 to $fp-4944
	b _L381		# unconditional branch
_L380:
	# _tmp2367 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string166: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string166	# load label
	# PushParam _tmp2367
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -4948($fp)	# spill _tmp2367 from $t0 to $fp-4948
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L381:
	# _tmp2368 = *(_tmp2366)
	lw $t0, -4944($fp)	# load _tmp2366 from $fp-4944 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2369 = *(_tmp2368)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2370 = *(_tmp2369 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2368
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2371 = ACall _tmp2370
	# (save modified registers before flow of control change)
	sw $t1, -4952($fp)	# spill _tmp2368 from $t1 to $fp-4952
	sw $t2, -4956($fp)	# spill _tmp2369 from $t2 to $fp-4956
	sw $t3, -4960($fp)	# spill _tmp2370 from $t3 to $fp-4960
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2372 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2373 = *(_tmp2372)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2374 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp2375 = _tmp2374 < _tmp2373
	slt $t5, $t4, $t3	
	# _tmp2376 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2377 = _tmp2376 < _tmp2374
	slt $t7, $t6, $t4	
	# _tmp2378 = _tmp2377 && _tmp2375
	and $s0, $t7, $t5	
	# IfZ _tmp2378 Goto _L382
	# (save modified registers before flow of control change)
	sw $t0, -4964($fp)	# spill _tmp2371 from $t0 to $fp-4964
	sw $t2, -4968($fp)	# spill _tmp2372 from $t2 to $fp-4968
	sw $t3, -4972($fp)	# spill _tmp2373 from $t3 to $fp-4972
	sw $t4, -4980($fp)	# spill _tmp2374 from $t4 to $fp-4980
	sw $t5, -4976($fp)	# spill _tmp2375 from $t5 to $fp-4976
	sw $t6, -4984($fp)	# spill _tmp2376 from $t6 to $fp-4984
	sw $t7, -4988($fp)	# spill _tmp2377 from $t7 to $fp-4988
	sw $s0, -4992($fp)	# spill _tmp2378 from $s0 to $fp-4992
	beqz $s0, _L382	# branch if _tmp2378 is zero 
	# _tmp2379 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2380 = _tmp2374 * _tmp2379
	lw $t1, -4980($fp)	# load _tmp2374 from $fp-4980 into $t1
	mul $t2, $t1, $t0	
	# _tmp2381 = _tmp2380 + _tmp2379
	add $t3, $t2, $t0	
	# _tmp2382 = _tmp2372 + _tmp2381
	lw $t4, -4968($fp)	# load _tmp2372 from $fp-4968 into $t4
	add $t5, $t4, $t3	
	# Goto _L383
	# (save modified registers before flow of control change)
	sw $t0, -4996($fp)	# spill _tmp2379 from $t0 to $fp-4996
	sw $t2, -5000($fp)	# spill _tmp2380 from $t2 to $fp-5000
	sw $t3, -5004($fp)	# spill _tmp2381 from $t3 to $fp-5004
	sw $t5, -5004($fp)	# spill _tmp2382 from $t5 to $fp-5004
	b _L383		# unconditional branch
_L382:
	# _tmp2383 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string167: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string167	# load label
	# PushParam _tmp2383
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -5008($fp)	# spill _tmp2383 from $t0 to $fp-5008
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L383:
	# _tmp2384 = *(_tmp2382)
	lw $t0, -5004($fp)	# load _tmp2382 from $fp-5004 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2385 = *(_tmp2384)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2386 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp2387 = _tmp2386 < _tmp2385
	slt $t4, $t3, $t2	
	# _tmp2388 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2389 = _tmp2388 < _tmp2386
	slt $t6, $t5, $t3	
	# _tmp2390 = _tmp2389 && _tmp2387
	and $t7, $t6, $t4	
	# IfZ _tmp2390 Goto _L384
	# (save modified registers before flow of control change)
	sw $t1, -5012($fp)	# spill _tmp2384 from $t1 to $fp-5012
	sw $t2, -5016($fp)	# spill _tmp2385 from $t2 to $fp-5016
	sw $t3, -5024($fp)	# spill _tmp2386 from $t3 to $fp-5024
	sw $t4, -5020($fp)	# spill _tmp2387 from $t4 to $fp-5020
	sw $t5, -5028($fp)	# spill _tmp2388 from $t5 to $fp-5028
	sw $t6, -5032($fp)	# spill _tmp2389 from $t6 to $fp-5032
	sw $t7, -5036($fp)	# spill _tmp2390 from $t7 to $fp-5036
	beqz $t7, _L384	# branch if _tmp2390 is zero 
	# _tmp2391 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2392 = _tmp2386 * _tmp2391
	lw $t1, -5024($fp)	# load _tmp2386 from $fp-5024 into $t1
	mul $t2, $t1, $t0	
	# _tmp2393 = _tmp2392 + _tmp2391
	add $t3, $t2, $t0	
	# _tmp2394 = _tmp2384 + _tmp2393
	lw $t4, -5012($fp)	# load _tmp2384 from $fp-5012 into $t4
	add $t5, $t4, $t3	
	# Goto _L385
	# (save modified registers before flow of control change)
	sw $t0, -5040($fp)	# spill _tmp2391 from $t0 to $fp-5040
	sw $t2, -5044($fp)	# spill _tmp2392 from $t2 to $fp-5044
	sw $t3, -5048($fp)	# spill _tmp2393 from $t3 to $fp-5048
	sw $t5, -5048($fp)	# spill _tmp2394 from $t5 to $fp-5048
	b _L385		# unconditional branch
_L384:
	# _tmp2395 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string168: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string168	# load label
	# PushParam _tmp2395
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -5052($fp)	# spill _tmp2395 from $t0 to $fp-5052
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L385:
	# _tmp2396 = *(_tmp2394)
	lw $t0, -5048($fp)	# load _tmp2394 from $fp-5048 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2397 = *(_tmp2396)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2398 = *(_tmp2397 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2396
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2399 = ACall _tmp2398
	# (save modified registers before flow of control change)
	sw $t1, -5056($fp)	# spill _tmp2396 from $t1 to $fp-5056
	sw $t2, -5060($fp)	# spill _tmp2397 from $t2 to $fp-5060
	sw $t3, -5064($fp)	# spill _tmp2398 from $t3 to $fp-5064
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2400 = _tmp2399 && _tmp2371
	lw $t1, -4964($fp)	# load _tmp2371 from $fp-4964 into $t1
	and $t2, $t0, $t1	
	# _tmp2401 = _tmp2400 && _tmp2343
	lw $t3, -4752($fp)	# load _tmp2343 from $fp-4752 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp2401 Goto _L372
	# (save modified registers before flow of control change)
	sw $t0, -5068($fp)	# spill _tmp2399 from $t0 to $fp-5068
	sw $t2, -4860($fp)	# spill _tmp2400 from $t2 to $fp-4860
	sw $t4, -4744($fp)	# spill _tmp2401 from $t4 to $fp-4744
	beqz $t4, _L372	# branch if _tmp2401 is zero 
	# _tmp2402 = 0
	li $t0, 0		# load constant value 0 into $t0
	# row = _tmp2402
	move $t1, $t0		# copy value
	# _tmp2403 = 2
	li $t2, 2		# load constant value 2 into $t2
	# column = _tmp2403
	move $t3, $t2		# copy value
	# Goto _L373
	# (save modified registers before flow of control change)
	sw $t0, -5072($fp)	# spill _tmp2402 from $t0 to $fp-5072
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -5076($fp)	# spill _tmp2403 from $t2 to $fp-5076
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L373		# unconditional branch
_L372:
	# _tmp2404 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2405 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2406 = *(_tmp2405)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2407 = 2
	li $t4, 2		# load constant value 2 into $t4
	# _tmp2408 = _tmp2407 < _tmp2406
	slt $t5, $t4, $t3	
	# _tmp2409 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2410 = _tmp2409 < _tmp2407
	slt $t7, $t6, $t4	
	# _tmp2411 = _tmp2410 && _tmp2408
	and $s0, $t7, $t5	
	# IfZ _tmp2411 Goto _L388
	# (save modified registers before flow of control change)
	sw $t0, -5084($fp)	# spill _tmp2404 from $t0 to $fp-5084
	sw $t2, -5092($fp)	# spill _tmp2405 from $t2 to $fp-5092
	sw $t3, -5096($fp)	# spill _tmp2406 from $t3 to $fp-5096
	sw $t4, -5104($fp)	# spill _tmp2407 from $t4 to $fp-5104
	sw $t5, -5100($fp)	# spill _tmp2408 from $t5 to $fp-5100
	sw $t6, -5108($fp)	# spill _tmp2409 from $t6 to $fp-5108
	sw $t7, -5112($fp)	# spill _tmp2410 from $t7 to $fp-5112
	sw $s0, -5116($fp)	# spill _tmp2411 from $s0 to $fp-5116
	beqz $s0, _L388	# branch if _tmp2411 is zero 
	# _tmp2412 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2413 = _tmp2407 * _tmp2412
	lw $t1, -5104($fp)	# load _tmp2407 from $fp-5104 into $t1
	mul $t2, $t1, $t0	
	# _tmp2414 = _tmp2413 + _tmp2412
	add $t3, $t2, $t0	
	# _tmp2415 = _tmp2405 + _tmp2414
	lw $t4, -5092($fp)	# load _tmp2405 from $fp-5092 into $t4
	add $t5, $t4, $t3	
	# Goto _L389
	# (save modified registers before flow of control change)
	sw $t0, -5120($fp)	# spill _tmp2412 from $t0 to $fp-5120
	sw $t2, -5124($fp)	# spill _tmp2413 from $t2 to $fp-5124
	sw $t3, -5128($fp)	# spill _tmp2414 from $t3 to $fp-5128
	sw $t5, -5128($fp)	# spill _tmp2415 from $t5 to $fp-5128
	b _L389		# unconditional branch
_L388:
	# _tmp2416 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string169: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string169	# load label
	# PushParam _tmp2416
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -5132($fp)	# spill _tmp2416 from $t0 to $fp-5132
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L389:
	# _tmp2417 = *(_tmp2415)
	lw $t0, -5128($fp)	# load _tmp2415 from $fp-5128 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2418 = *(_tmp2417)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2419 = 0
	li $t3, 0		# load constant value 0 into $t3
	# _tmp2420 = _tmp2419 < _tmp2418
	slt $t4, $t3, $t2	
	# _tmp2421 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2422 = _tmp2421 < _tmp2419
	slt $t6, $t5, $t3	
	# _tmp2423 = _tmp2422 && _tmp2420
	and $t7, $t6, $t4	
	# IfZ _tmp2423 Goto _L390
	# (save modified registers before flow of control change)
	sw $t1, -5136($fp)	# spill _tmp2417 from $t1 to $fp-5136
	sw $t2, -5140($fp)	# spill _tmp2418 from $t2 to $fp-5140
	sw $t3, -5148($fp)	# spill _tmp2419 from $t3 to $fp-5148
	sw $t4, -5144($fp)	# spill _tmp2420 from $t4 to $fp-5144
	sw $t5, -5152($fp)	# spill _tmp2421 from $t5 to $fp-5152
	sw $t6, -5156($fp)	# spill _tmp2422 from $t6 to $fp-5156
	sw $t7, -5160($fp)	# spill _tmp2423 from $t7 to $fp-5160
	beqz $t7, _L390	# branch if _tmp2423 is zero 
	# _tmp2424 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2425 = _tmp2419 * _tmp2424
	lw $t1, -5148($fp)	# load _tmp2419 from $fp-5148 into $t1
	mul $t2, $t1, $t0	
	# _tmp2426 = _tmp2425 + _tmp2424
	add $t3, $t2, $t0	
	# _tmp2427 = _tmp2417 + _tmp2426
	lw $t4, -5136($fp)	# load _tmp2417 from $fp-5136 into $t4
	add $t5, $t4, $t3	
	# Goto _L391
	# (save modified registers before flow of control change)
	sw $t0, -5164($fp)	# spill _tmp2424 from $t0 to $fp-5164
	sw $t2, -5168($fp)	# spill _tmp2425 from $t2 to $fp-5168
	sw $t3, -5172($fp)	# spill _tmp2426 from $t3 to $fp-5172
	sw $t5, -5172($fp)	# spill _tmp2427 from $t5 to $fp-5172
	b _L391		# unconditional branch
_L390:
	# _tmp2428 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string170: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string170	# load label
	# PushParam _tmp2428
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -5176($fp)	# spill _tmp2428 from $t0 to $fp-5176
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L391:
	# _tmp2429 = *(_tmp2427)
	lw $t0, -5172($fp)	# load _tmp2427 from $fp-5172 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2430 = *(_tmp2429)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2431 = *(_tmp2430 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 12($fp)	# load playerMark from $fp+12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2429
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2432 = ACall _tmp2431
	# (save modified registers before flow of control change)
	sw $t1, -5180($fp)	# spill _tmp2429 from $t1 to $fp-5180
	sw $t2, -5184($fp)	# spill _tmp2430 from $t2 to $fp-5184
	sw $t3, -5188($fp)	# spill _tmp2431 from $t3 to $fp-5188
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2433 = _tmp2404 - _tmp2432
	lw $t1, -5084($fp)	# load _tmp2404 from $fp-5084 into $t1
	sub $t2, $t1, $t0	
	# _tmp2434 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp2435 = *(_tmp2434)
	lw $t5, 0($t4) 	# load with offset
	# _tmp2436 = 1
	li $t6, 1		# load constant value 1 into $t6
	# _tmp2437 = _tmp2436 < _tmp2435
	slt $t7, $t6, $t5	
	# _tmp2438 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp2439 = _tmp2438 < _tmp2436
	slt $s1, $s0, $t6	
	# _tmp2440 = _tmp2439 && _tmp2437
	and $s2, $s1, $t7	
	# IfZ _tmp2440 Goto _L392
	# (save modified registers before flow of control change)
	sw $t0, -5192($fp)	# spill _tmp2432 from $t0 to $fp-5192
	sw $t2, -5088($fp)	# spill _tmp2433 from $t2 to $fp-5088
	sw $t4, -5200($fp)	# spill _tmp2434 from $t4 to $fp-5200
	sw $t5, -5204($fp)	# spill _tmp2435 from $t5 to $fp-5204
	sw $t6, -5212($fp)	# spill _tmp2436 from $t6 to $fp-5212
	sw $t7, -5208($fp)	# spill _tmp2437 from $t7 to $fp-5208
	sw $s0, -5216($fp)	# spill _tmp2438 from $s0 to $fp-5216
	sw $s1, -5220($fp)	# spill _tmp2439 from $s1 to $fp-5220
	sw $s2, -5224($fp)	# spill _tmp2440 from $s2 to $fp-5224
	beqz $s2, _L392	# branch if _tmp2440 is zero 
	# _tmp2441 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2442 = _tmp2436 * _tmp2441
	lw $t1, -5212($fp)	# load _tmp2436 from $fp-5212 into $t1
	mul $t2, $t1, $t0	
	# _tmp2443 = _tmp2442 + _tmp2441
	add $t3, $t2, $t0	
	# _tmp2444 = _tmp2434 + _tmp2443
	lw $t4, -5200($fp)	# load _tmp2434 from $fp-5200 into $t4
	add $t5, $t4, $t3	
	# Goto _L393
	# (save modified registers before flow of control change)
	sw $t0, -5228($fp)	# spill _tmp2441 from $t0 to $fp-5228
	sw $t2, -5232($fp)	# spill _tmp2442 from $t2 to $fp-5232
	sw $t3, -5236($fp)	# spill _tmp2443 from $t3 to $fp-5236
	sw $t5, -5236($fp)	# spill _tmp2444 from $t5 to $fp-5236
	b _L393		# unconditional branch
_L392:
	# _tmp2445 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string171: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string171	# load label
	# PushParam _tmp2445
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -5240($fp)	# spill _tmp2445 from $t0 to $fp-5240
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L393:
	# _tmp2446 = *(_tmp2444)
	lw $t0, -5236($fp)	# load _tmp2444 from $fp-5236 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2447 = *(_tmp2446)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2448 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp2449 = _tmp2448 < _tmp2447
	slt $t4, $t3, $t2	
	# _tmp2450 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2451 = _tmp2450 < _tmp2448
	slt $t6, $t5, $t3	
	# _tmp2452 = _tmp2451 && _tmp2449
	and $t7, $t6, $t4	
	# IfZ _tmp2452 Goto _L394
	# (save modified registers before flow of control change)
	sw $t1, -5244($fp)	# spill _tmp2446 from $t1 to $fp-5244
	sw $t2, -5248($fp)	# spill _tmp2447 from $t2 to $fp-5248
	sw $t3, -5256($fp)	# spill _tmp2448 from $t3 to $fp-5256
	sw $t4, -5252($fp)	# spill _tmp2449 from $t4 to $fp-5252
	sw $t5, -5260($fp)	# spill _tmp2450 from $t5 to $fp-5260
	sw $t6, -5264($fp)	# spill _tmp2451 from $t6 to $fp-5264
	sw $t7, -5268($fp)	# spill _tmp2452 from $t7 to $fp-5268
	beqz $t7, _L394	# branch if _tmp2452 is zero 
	# _tmp2453 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2454 = _tmp2448 * _tmp2453
	lw $t1, -5256($fp)	# load _tmp2448 from $fp-5256 into $t1
	mul $t2, $t1, $t0	
	# _tmp2455 = _tmp2454 + _tmp2453
	add $t3, $t2, $t0	
	# _tmp2456 = _tmp2446 + _tmp2455
	lw $t4, -5244($fp)	# load _tmp2446 from $fp-5244 into $t4
	add $t5, $t4, $t3	
	# Goto _L395
	# (save modified registers before flow of control change)
	sw $t0, -5272($fp)	# spill _tmp2453 from $t0 to $fp-5272
	sw $t2, -5276($fp)	# spill _tmp2454 from $t2 to $fp-5276
	sw $t3, -5280($fp)	# spill _tmp2455 from $t3 to $fp-5280
	sw $t5, -5280($fp)	# spill _tmp2456 from $t5 to $fp-5280
	b _L395		# unconditional branch
_L394:
	# _tmp2457 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string172: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string172	# load label
	# PushParam _tmp2457
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -5284($fp)	# spill _tmp2457 from $t0 to $fp-5284
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L395:
	# _tmp2458 = *(_tmp2456)
	lw $t0, -5280($fp)	# load _tmp2456 from $fp-5280 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2459 = *(_tmp2458)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2460 = *(_tmp2459 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2458
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2461 = ACall _tmp2460
	# (save modified registers before flow of control change)
	sw $t1, -5288($fp)	# spill _tmp2458 from $t1 to $fp-5288
	sw $t2, -5292($fp)	# spill _tmp2459 from $t2 to $fp-5292
	sw $t3, -5296($fp)	# spill _tmp2460 from $t3 to $fp-5296
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2462 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp2463 = *(_tmp2462)
	lw $t3, 0($t2) 	# load with offset
	# _tmp2464 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp2465 = _tmp2464 < _tmp2463
	slt $t5, $t4, $t3	
	# _tmp2466 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp2467 = _tmp2466 < _tmp2464
	slt $t7, $t6, $t4	
	# _tmp2468 = _tmp2467 && _tmp2465
	and $s0, $t7, $t5	
	# IfZ _tmp2468 Goto _L396
	# (save modified registers before flow of control change)
	sw $t0, -5300($fp)	# spill _tmp2461 from $t0 to $fp-5300
	sw $t2, -5304($fp)	# spill _tmp2462 from $t2 to $fp-5304
	sw $t3, -5308($fp)	# spill _tmp2463 from $t3 to $fp-5308
	sw $t4, -5316($fp)	# spill _tmp2464 from $t4 to $fp-5316
	sw $t5, -5312($fp)	# spill _tmp2465 from $t5 to $fp-5312
	sw $t6, -5320($fp)	# spill _tmp2466 from $t6 to $fp-5320
	sw $t7, -5324($fp)	# spill _tmp2467 from $t7 to $fp-5324
	sw $s0, -5328($fp)	# spill _tmp2468 from $s0 to $fp-5328
	beqz $s0, _L396	# branch if _tmp2468 is zero 
	# _tmp2469 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2470 = _tmp2464 * _tmp2469
	lw $t1, -5316($fp)	# load _tmp2464 from $fp-5316 into $t1
	mul $t2, $t1, $t0	
	# _tmp2471 = _tmp2470 + _tmp2469
	add $t3, $t2, $t0	
	# _tmp2472 = _tmp2462 + _tmp2471
	lw $t4, -5304($fp)	# load _tmp2462 from $fp-5304 into $t4
	add $t5, $t4, $t3	
	# Goto _L397
	# (save modified registers before flow of control change)
	sw $t0, -5332($fp)	# spill _tmp2469 from $t0 to $fp-5332
	sw $t2, -5336($fp)	# spill _tmp2470 from $t2 to $fp-5336
	sw $t3, -5340($fp)	# spill _tmp2471 from $t3 to $fp-5340
	sw $t5, -5340($fp)	# spill _tmp2472 from $t5 to $fp-5340
	b _L397		# unconditional branch
_L396:
	# _tmp2473 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string173: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string173	# load label
	# PushParam _tmp2473
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -5344($fp)	# spill _tmp2473 from $t0 to $fp-5344
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L397:
	# _tmp2474 = *(_tmp2472)
	lw $t0, -5340($fp)	# load _tmp2472 from $fp-5340 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2475 = *(_tmp2474)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2476 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp2477 = _tmp2476 < _tmp2475
	slt $t4, $t3, $t2	
	# _tmp2478 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp2479 = _tmp2478 < _tmp2476
	slt $t6, $t5, $t3	
	# _tmp2480 = _tmp2479 && _tmp2477
	and $t7, $t6, $t4	
	# IfZ _tmp2480 Goto _L398
	# (save modified registers before flow of control change)
	sw $t1, -5348($fp)	# spill _tmp2474 from $t1 to $fp-5348
	sw $t2, -5352($fp)	# spill _tmp2475 from $t2 to $fp-5352
	sw $t3, -5360($fp)	# spill _tmp2476 from $t3 to $fp-5360
	sw $t4, -5356($fp)	# spill _tmp2477 from $t4 to $fp-5356
	sw $t5, -5364($fp)	# spill _tmp2478 from $t5 to $fp-5364
	sw $t6, -5368($fp)	# spill _tmp2479 from $t6 to $fp-5368
	sw $t7, -5372($fp)	# spill _tmp2480 from $t7 to $fp-5372
	beqz $t7, _L398	# branch if _tmp2480 is zero 
	# _tmp2481 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp2482 = _tmp2476 * _tmp2481
	lw $t1, -5360($fp)	# load _tmp2476 from $fp-5360 into $t1
	mul $t2, $t1, $t0	
	# _tmp2483 = _tmp2482 + _tmp2481
	add $t3, $t2, $t0	
	# _tmp2484 = _tmp2474 + _tmp2483
	lw $t4, -5348($fp)	# load _tmp2474 from $fp-5348 into $t4
	add $t5, $t4, $t3	
	# Goto _L399
	# (save modified registers before flow of control change)
	sw $t0, -5376($fp)	# spill _tmp2481 from $t0 to $fp-5376
	sw $t2, -5380($fp)	# spill _tmp2482 from $t2 to $fp-5380
	sw $t3, -5384($fp)	# spill _tmp2483 from $t3 to $fp-5384
	sw $t5, -5384($fp)	# spill _tmp2484 from $t5 to $fp-5384
	b _L399		# unconditional branch
_L398:
	# _tmp2485 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string174: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string174	# load label
	# PushParam _tmp2485
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -5388($fp)	# spill _tmp2485 from $t0 to $fp-5388
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L399:
	# _tmp2486 = *(_tmp2484)
	lw $t0, -5384($fp)	# load _tmp2484 from $fp-5384 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2487 = *(_tmp2486)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2488 = *(_tmp2487 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam enemyMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, 8($fp)	# load enemyMark from $fp+8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp2486
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2489 = ACall _tmp2488
	# (save modified registers before flow of control change)
	sw $t1, -5392($fp)	# spill _tmp2486 from $t1 to $fp-5392
	sw $t2, -5396($fp)	# spill _tmp2487 from $t2 to $fp-5396
	sw $t3, -5400($fp)	# spill _tmp2488 from $t3 to $fp-5400
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2490 = _tmp2489 && _tmp2461
	lw $t1, -5300($fp)	# load _tmp2461 from $fp-5300 into $t1
	and $t2, $t0, $t1	
	# _tmp2491 = _tmp2490 && _tmp2433
	lw $t3, -5088($fp)	# load _tmp2433 from $fp-5088 into $t3
	and $t4, $t2, $t3	
	# IfZ _tmp2491 Goto _L386
	# (save modified registers before flow of control change)
	sw $t0, -5404($fp)	# spill _tmp2489 from $t0 to $fp-5404
	sw $t2, -5196($fp)	# spill _tmp2490 from $t2 to $fp-5196
	sw $t4, -5080($fp)	# spill _tmp2491 from $t4 to $fp-5080
	beqz $t4, _L386	# branch if _tmp2491 is zero 
	# _tmp2492 = 2
	li $t0, 2		# load constant value 2 into $t0
	# row = _tmp2492
	move $t1, $t0		# copy value
	# _tmp2493 = 0
	li $t2, 0		# load constant value 0 into $t2
	# column = _tmp2493
	move $t3, $t2		# copy value
	# Goto _L387
	# (save modified registers before flow of control change)
	sw $t0, -5408($fp)	# spill _tmp2492 from $t0 to $fp-5408
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -5412($fp)	# spill _tmp2493 from $t2 to $fp-5412
	sw $t3, -12($fp)	# spill column from $t3 to $fp-12
	b _L387		# unconditional branch
_L386:
_L387:
_L373:
_L359:
_L345:
_L331:
_L317:
_L303:
_L289:
_L275:
_L261:
_L247:
_L233:
_L219:
_L205:
_L191:
_L177:
	# _tmp2494 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp2495 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp2496 = _tmp2494 - _tmp2495
	sub $t2, $t0, $t1	
	# _tmp2497 = row < _tmp2496
	lw $t3, -8($fp)	# load row from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp2498 = _tmp2496 < row
	slt $t5, $t2, $t3	
	# _tmp2499 = _tmp2497 || _tmp2498
	or $t6, $t4, $t5	
	# IfZ _tmp2499 Goto _L400
	# (save modified registers before flow of control change)
	sw $t0, -5416($fp)	# spill _tmp2494 from $t0 to $fp-5416
	sw $t1, -5424($fp)	# spill _tmp2495 from $t1 to $fp-5424
	sw $t2, -5420($fp)	# spill _tmp2496 from $t2 to $fp-5420
	sw $t4, -5428($fp)	# spill _tmp2497 from $t4 to $fp-5428
	sw $t5, -5432($fp)	# spill _tmp2498 from $t5 to $fp-5432
	sw $t6, -5436($fp)	# spill _tmp2499 from $t6 to $fp-5436
	beqz $t6, _L400	# branch if _tmp2499 is zero 
	# _tmp2500 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2501 = *(_tmp2500 + 24)
	lw $t2, 24($t1) 	# load with offset
	# PushParam playerMark
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 12($fp)	# load playerMark from $fp+12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam column
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load column from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam row
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load row from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp2501
	# (save modified registers before flow of control change)
	sw $t1, -5440($fp)	# spill _tmp2500 from $t1 to $fp-5440
	sw $t2, -5444($fp)	# spill _tmp2501 from $t2 to $fp-5444
	jalr $t2            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp2502 = 1
	li $t0, 1		# load constant value 1 into $t0
	# Return _tmp2502
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L401
	b _L401		# unconditional branch
_L400:
	# _tmp2503 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp2503
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
_L401:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Grid
	.data
	.align 2
	Grid:		# label for class Grid vtable
	.word __Grid.BlockedPlay
	.word __Grid.Draw
	.word __Grid.Full
	.word __Grid.GameNotWon
	.word __Grid.Init
	.word __Grid.IsMoveLegal
	.word __Grid.Update
	.text
__Computer.Init:
	# BeginFunc 12
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp2504 = "0"
	.data			# create string constant marked with label
	_string175: .asciiz "0"
	.text
	la $t0, _string175	# load label
	# _tmp2505 = 4
	li $t1, 4		# load constant value 4 into $t1
	# _tmp2506 = this + _tmp2505
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp2506) = _tmp2504
	sw $t0, 0($t3) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Computer.TakeTurn:
	# BeginFunc 172
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 172	# decrement sp to make space for locals/temps
	# _tmp2507 = 0
	li $t0, 0		# load constant value 0 into $t0
	# legalMove = _tmp2507
	move $t1, $t0		# copy value
	# _tmp2508 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp2509 = *(grid)
	lw $t3, 8($fp)	# load grid from $fp+8 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp2510 = *(_tmp2509)
	lw $t5, 0($t4) 	# load with offset
	# _tmp2511 = *(this)
	lw $t6, 4($fp)	# load this from $fp+4 into $t6
	lw $t7, 0($t6) 	# load with offset
	# _tmp2512 = *(_tmp2511)
	lw $s0, 0($t7) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# _tmp2513 = ACall _tmp2512
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp2507 from $t0 to $fp-20
	sw $t1, -16($fp)	# spill legalMove from $t1 to $fp-16
	sw $t2, -24($fp)	# spill _tmp2508 from $t2 to $fp-24
	sw $t4, -32($fp)	# spill _tmp2509 from $t4 to $fp-32
	sw $t5, -36($fp)	# spill _tmp2510 from $t5 to $fp-36
	sw $t7, -40($fp)	# spill _tmp2511 from $t7 to $fp-40
	sw $s0, -44($fp)	# spill _tmp2512 from $s0 to $fp-44
	jalr $s0            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2513
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp2514 = *(human)
	lw $t1, 12($fp)	# load human from $fp+12 into $t1
	lw $t2, 0($t1) 	# load with offset
	# _tmp2515 = *(_tmp2514 + 4)
	lw $t3, 4($t2) 	# load with offset
	# PushParam human
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2516 = ACall _tmp2515
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp2513 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp2514 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp2515 from $t3 to $fp-56
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2516
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, 8($fp)	# load grid from $fp+8 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2517 = ACall _tmp2510
	lw $t2, -36($fp)	# load _tmp2510 from $fp-36 into $t2
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp2516 from $t0 to $fp-60
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp2518 = _tmp2508 - _tmp2517
	lw $t1, -24($fp)	# load _tmp2508 from $fp-24 into $t1
	sub $t2, $t1, $t0	
	# IfZ _tmp2518 Goto _L402
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp2517 from $t0 to $fp-64
	sw $t2, -28($fp)	# spill _tmp2518 from $t2 to $fp-28
	beqz $t2, _L402	# branch if _tmp2518 is zero 
_L404:
	# _tmp2519 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2520 = _tmp2519 - legalMove
	lw $t1, -16($fp)	# load legalMove from $fp-16 into $t1
	sub $t2, $t0, $t1	
	# IfZ _tmp2520 Goto _L405
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp2519 from $t0 to $fp-68
	sw $t2, -72($fp)	# spill _tmp2520 from $t2 to $fp-72
	beqz $t2, _L405	# branch if _tmp2520 is zero 
	# _tmp2521 = *(gRnd)
	lw $t0, 4($gp)	# load gRnd from $gp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2522 = *(_tmp2521 + 8)
	lw $t2, 8($t1) 	# load with offset
	# _tmp2523 = 2
	li $t3, 2		# load constant value 2 into $t3
	# PushParam _tmp2523
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp2524 = 0
	li $t4, 0		# load constant value 0 into $t4
	# PushParam _tmp2524
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam gRnd
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp2525 = ACall _tmp2522
	# (save modified registers before flow of control change)
	sw $t1, -76($fp)	# spill _tmp2521 from $t1 to $fp-76
	sw $t2, -80($fp)	# spill _tmp2522 from $t2 to $fp-80
	sw $t3, -84($fp)	# spill _tmp2523 from $t3 to $fp-84
	sw $t4, -88($fp)	# spill _tmp2524 from $t4 to $fp-88
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# row = _tmp2525
	move $t1, $t0		# copy value
	# _tmp2526 = *(gRnd)
	lw $t2, 4($gp)	# load gRnd from $gp+4 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp2527 = *(_tmp2526 + 8)
	lw $t4, 8($t3) 	# load with offset
	# _tmp2528 = 2
	li $t5, 2		# load constant value 2 into $t5
	# PushParam _tmp2528
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# _tmp2529 = 0
	li $t6, 0		# load constant value 0 into $t6
	# PushParam _tmp2529
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam gRnd
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp2530 = ACall _tmp2527
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp2525 from $t0 to $fp-92
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t3, -96($fp)	# spill _tmp2526 from $t3 to $fp-96
	sw $t4, -100($fp)	# spill _tmp2527 from $t4 to $fp-100
	sw $t5, -104($fp)	# spill _tmp2528 from $t5 to $fp-104
	sw $t6, -108($fp)	# spill _tmp2529 from $t6 to $fp-108
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# column = _tmp2530
	move $t1, $t0		# copy value
	# _tmp2531 = *(grid)
	lw $t2, 8($fp)	# load grid from $fp+8 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp2532 = *(_tmp2531 + 20)
	lw $t4, 20($t3) 	# load with offset
	# PushParam column
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam row
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load row from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp2533 = ACall _tmp2532
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp2530 from $t0 to $fp-112
	sw $t1, -12($fp)	# spill column from $t1 to $fp-12
	sw $t3, -116($fp)	# spill _tmp2531 from $t3 to $fp-116
	sw $t4, -120($fp)	# spill _tmp2532 from $t4 to $fp-120
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# legalMove = _tmp2533
	move $t1, $t0		# copy value
	# Goto _L404
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp2533 from $t0 to $fp-124
	sw $t1, -16($fp)	# spill legalMove from $t1 to $fp-16
	b _L404		# unconditional branch
_L405:
	# _tmp2534 = *(grid)
	lw $t0, 8($fp)	# load grid from $fp+8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2535 = *(_tmp2534 + 24)
	lw $t2, 24($t1) 	# load with offset
	# _tmp2536 = *(this)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp2537 = *(_tmp2536)
	lw $t5, 0($t4) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp2538 = ACall _tmp2537
	# (save modified registers before flow of control change)
	sw $t1, -128($fp)	# spill _tmp2534 from $t1 to $fp-128
	sw $t2, -132($fp)	# spill _tmp2535 from $t2 to $fp-132
	sw $t4, -136($fp)	# spill _tmp2536 from $t4 to $fp-136
	sw $t5, -140($fp)	# spill _tmp2537 from $t5 to $fp-140
	jalr $t5            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2538
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam column
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -12($fp)	# load column from $fp-12 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam row
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, -8($fp)	# load row from $fp-8 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 8($fp)	# load grid from $fp+8 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# ACall _tmp2535
	lw $t4, -132($fp)	# load _tmp2535 from $fp-132 into $t4
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp2538 from $t0 to $fp-144
	jalr $t4            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# _tmp2539 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2540 = row + _tmp2539
	lw $t1, -8($fp)	# load row from $fp-8 into $t1
	add $t2, $t1, $t0	
	# row = _tmp2540
	move $t1, $t2		# copy value
	# _tmp2541 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp2542 = column + _tmp2541
	lw $t4, -12($fp)	# load column from $fp-12 into $t4
	add $t5, $t4, $t3	
	# column = _tmp2542
	move $t4, $t5		# copy value
	# _tmp2543 = "\nThe computer's move is row "
	.data			# create string constant marked with label
	_string176: .asciiz "\nThe computer's move is row "
	.text
	la $t6, _string176	# load label
	# PushParam _tmp2543
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp2539 from $t0 to $fp-152
	sw $t1, -8($fp)	# spill row from $t1 to $fp-8
	sw $t2, -148($fp)	# spill _tmp2540 from $t2 to $fp-148
	sw $t3, -160($fp)	# spill _tmp2541 from $t3 to $fp-160
	sw $t4, -12($fp)	# spill column from $t4 to $fp-12
	sw $t5, -156($fp)	# spill _tmp2542 from $t5 to $fp-156
	sw $t6, -164($fp)	# spill _tmp2543 from $t6 to $fp-164
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam row
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load row from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2544 = " and column "
	.data			# create string constant marked with label
	_string177: .asciiz " and column "
	.text
	la $t0, _string177	# load label
	# PushParam _tmp2544
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp2544 from $t0 to $fp-168
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam column
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load column from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2545 = ".\n"
	.data			# create string constant marked with label
	_string178: .asciiz ".\n"
	.text
	la $t0, _string178	# load label
	# PushParam _tmp2545
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp2545 from $t0 to $fp-172
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L403
	b _L403		# unconditional branch
_L402:
	# _tmp2546 = "Ha! The computer blocked you from winning!\n"
	.data			# create string constant marked with label
	_string179: .asciiz "Ha! The computer blocked you from winning!\n"
	.text
	la $t0, _string179	# load label
	# PushParam _tmp2546
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp2546 from $t0 to $fp-176
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L403:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Computer
	.data
	.align 2
	Computer:		# label for class Computer vtable
	.word __Player.GetMark
	.word __Player.GetName
	.word __Computer.Init
	.word __Computer.TakeTurn
	.text
__InitGame:
	# BeginFunc 24
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 24	# decrement sp to make space for locals/temps
	# _tmp2547 = "\nWelcome to TicTacToe!\n"
	.data			# create string constant marked with label
	_string180: .asciiz "\nWelcome to TicTacToe!\n"
	.text
	la $t0, _string180	# load label
	# PushParam _tmp2547
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp2547 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2548 = "---------------------\n"
	.data			# create string constant marked with label
	_string181: .asciiz "---------------------\n"
	.text
	la $t0, _string181	# load label
	# PushParam _tmp2548
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp2548 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2549 = "Please enter a random number seed: "
	.data			# create string constant marked with label
	_string182: .asciiz "Please enter a random number seed: "
	.text
	la $t0, _string182	# load label
	# PushParam _tmp2549
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp2549 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2550 = *(gRnd)
	lw $t0, 4($gp)	# load gRnd from $gp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2551 = *(_tmp2550)
	lw $t2, 0($t1) 	# load with offset
	# _tmp2552 = LCall _ReadInteger
	# (save modified registers before flow of control change)
	sw $t1, -20($fp)	# spill _tmp2550 from $t1 to $fp-20
	sw $t2, -24($fp)	# spill _tmp2551 from $t2 to $fp-24
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PushParam _tmp2552
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, 4($gp)	# load gRnd from $gp+4 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp2551
	lw $t2, -24($fp)	# load _tmp2551 from $fp-24 into $t2
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp2552 from $t0 to $fp-28
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
main:
	# BeginFunc 324
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 324	# decrement sp to make space for locals/temps
	# _tmp2553 = 8
	li $t0, 8		# load constant value 8 into $t0
	# PushParam _tmp2553
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp2554 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp2553 from $t0 to $fp-36
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2555 = Grid
	la $t1, Grid	# load label
	# *(_tmp2554) = _tmp2555
	sw $t1, 0($t0) 	# store with offset
	# grid = _tmp2554
	move $t2, $t0		# copy value
	# _tmp2556 = 12
	li $t3, 12		# load constant value 12 into $t3
	# PushParam _tmp2556
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp2557 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp2554 from $t0 to $fp-40
	sw $t1, -44($fp)	# spill _tmp2555 from $t1 to $fp-44
	sw $t2, -8($fp)	# spill grid from $t2 to $fp-8
	sw $t3, -48($fp)	# spill _tmp2556 from $t3 to $fp-48
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2558 = Human
	la $t1, Human	# load label
	# *(_tmp2557) = _tmp2558
	sw $t1, 0($t0) 	# store with offset
	# human = _tmp2557
	move $t2, $t0		# copy value
	# _tmp2559 = 12
	li $t3, 12		# load constant value 12 into $t3
	# PushParam _tmp2559
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp2560 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp2557 from $t0 to $fp-52
	sw $t1, -56($fp)	# spill _tmp2558 from $t1 to $fp-56
	sw $t2, -12($fp)	# spill human from $t2 to $fp-12
	sw $t3, -60($fp)	# spill _tmp2559 from $t3 to $fp-60
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2561 = Computer
	la $t1, Computer	# load label
	# *(_tmp2560) = _tmp2561
	sw $t1, 0($t0) 	# store with offset
	# computer = _tmp2560
	move $t2, $t0		# copy value
	# _tmp2562 = 8
	li $t3, 8		# load constant value 8 into $t3
	# PushParam _tmp2562
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp2563 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp2560 from $t0 to $fp-64
	sw $t1, -68($fp)	# spill _tmp2561 from $t1 to $fp-68
	sw $t2, -16($fp)	# spill computer from $t2 to $fp-16
	sw $t3, -72($fp)	# spill _tmp2562 from $t3 to $fp-72
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2564 = rndModule
	la $t1, rndModule	# load label
	# *(_tmp2563) = _tmp2564
	sw $t1, 0($t0) 	# store with offset
	# gRnd = _tmp2563
	move $t2, $t0		# copy value
	# LCall __InitGame
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp2563 from $t0 to $fp-76
	sw $t1, -80($fp)	# spill _tmp2564 from $t1 to $fp-80
	sw $t2, 4($gp)	# spill gRnd from $t2 to $gp+4
	jal __InitGame     	# jump to function
	# _tmp2565 = *(grid)
	lw $t0, -8($fp)	# load grid from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2566 = *(_tmp2565 + 16)
	lw $t2, 16($t1) 	# load with offset
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp2566
	# (save modified registers before flow of control change)
	sw $t1, -84($fp)	# spill _tmp2565 from $t1 to $fp-84
	sw $t2, -88($fp)	# spill _tmp2566 from $t2 to $fp-88
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2567 = *(human)
	lw $t0, -12($fp)	# load human from $fp-12 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2568 = *(_tmp2567 + 16)
	lw $t2, 16($t1) 	# load with offset
	# PushParam human
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp2568
	# (save modified registers before flow of control change)
	sw $t1, -92($fp)	# spill _tmp2567 from $t1 to $fp-92
	sw $t2, -96($fp)	# spill _tmp2568 from $t2 to $fp-96
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2569 = *(computer)
	lw $t0, -16($fp)	# load computer from $fp-16 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2570 = *(_tmp2569 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam computer
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp2570
	# (save modified registers before flow of control change)
	sw $t1, -100($fp)	# spill _tmp2569 from $t1 to $fp-100
	sw $t2, -104($fp)	# spill _tmp2570 from $t2 to $fp-104
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2571 = 0
	li $t0, 0		# load constant value 0 into $t0
	# moveLegal = _tmp2571
	move $t1, $t0		# copy value
	# _tmp2572 = 0
	li $t2, 0		# load constant value 0 into $t2
	# gameOver = _tmp2572
	move $t3, $t2		# copy value
	# _tmp2573 = *(grid)
	lw $t4, -8($fp)	# load grid from $fp-8 into $t4
	lw $t5, 0($t4) 	# load with offset
	# _tmp2574 = *(_tmp2573 + 4)
	lw $t6, 4($t5) 	# load with offset
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t4, 4($sp)	# copy param value to stack
	# ACall _tmp2574
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp2571 from $t0 to $fp-108
	sw $t1, -28($fp)	# spill moveLegal from $t1 to $fp-28
	sw $t2, -112($fp)	# spill _tmp2572 from $t2 to $fp-112
	sw $t3, -32($fp)	# spill gameOver from $t3 to $fp-32
	sw $t5, -116($fp)	# spill _tmp2573 from $t5 to $fp-116
	sw $t6, -120($fp)	# spill _tmp2574 from $t6 to $fp-120
	jalr $t6            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L406:
	# _tmp2575 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2576 = _tmp2575 - gameOver
	lw $t1, -32($fp)	# load gameOver from $fp-32 into $t1
	sub $t2, $t0, $t1	
	# IfZ _tmp2576 Goto _L407
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp2575 from $t0 to $fp-124
	sw $t2, -128($fp)	# spill _tmp2576 from $t2 to $fp-128
	beqz $t2, _L407	# branch if _tmp2576 is zero 
	# _tmp2577 = 0
	li $t0, 0		# load constant value 0 into $t0
	# moveLegal = _tmp2577
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -132($fp)	# spill _tmp2577 from $t0 to $fp-132
	sw $t1, -28($fp)	# spill moveLegal from $t1 to $fp-28
_L408:
	# _tmp2578 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2579 = _tmp2578 - moveLegal
	lw $t1, -28($fp)	# load moveLegal from $fp-28 into $t1
	sub $t2, $t0, $t1	
	# IfZ _tmp2579 Goto _L409
	# (save modified registers before flow of control change)
	sw $t0, -136($fp)	# spill _tmp2578 from $t0 to $fp-136
	sw $t2, -140($fp)	# spill _tmp2579 from $t2 to $fp-140
	beqz $t2, _L409	# branch if _tmp2579 is zero 
	# _tmp2580 = *(human)
	lw $t0, -12($fp)	# load human from $fp-12 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2581 = *(_tmp2580 + 12)
	lw $t2, 12($t1) 	# load with offset
	# PushParam human
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp2582 = ACall _tmp2581
	# (save modified registers before flow of control change)
	sw $t1, -144($fp)	# spill _tmp2580 from $t1 to $fp-144
	sw $t2, -148($fp)	# spill _tmp2581 from $t2 to $fp-148
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# row = _tmp2582
	move $t1, $t0		# copy value
	# _tmp2583 = *(human)
	lw $t2, -12($fp)	# load human from $fp-12 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp2584 = *(_tmp2583)
	lw $t4, 0($t3) 	# load with offset
	# PushParam human
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp2585 = ACall _tmp2584
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp2582 from $t0 to $fp-152
	sw $t1, -20($fp)	# spill row from $t1 to $fp-20
	sw $t3, -156($fp)	# spill _tmp2583 from $t3 to $fp-156
	sw $t4, -160($fp)	# spill _tmp2584 from $t4 to $fp-160
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# column = _tmp2585
	move $t1, $t0		# copy value
	# _tmp2586 = *(grid)
	lw $t2, -8($fp)	# load grid from $fp-8 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp2587 = *(_tmp2586 + 20)
	lw $t4, 20($t3) 	# load with offset
	# PushParam column
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam row
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -20($fp)	# load row from $fp-20 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp2588 = ACall _tmp2587
	# (save modified registers before flow of control change)
	sw $t0, -164($fp)	# spill _tmp2585 from $t0 to $fp-164
	sw $t1, -24($fp)	# spill column from $t1 to $fp-24
	sw $t3, -168($fp)	# spill _tmp2586 from $t3 to $fp-168
	sw $t4, -172($fp)	# spill _tmp2587 from $t4 to $fp-172
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# moveLegal = _tmp2588
	move $t1, $t0		# copy value
	# _tmp2589 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp2590 = _tmp2589 - moveLegal
	sub $t3, $t2, $t1	
	# IfZ _tmp2590 Goto _L410
	# (save modified registers before flow of control change)
	sw $t0, -176($fp)	# spill _tmp2588 from $t0 to $fp-176
	sw $t1, -28($fp)	# spill moveLegal from $t1 to $fp-28
	sw $t2, -180($fp)	# spill _tmp2589 from $t2 to $fp-180
	sw $t3, -184($fp)	# spill _tmp2590 from $t3 to $fp-184
	beqz $t3, _L410	# branch if _tmp2590 is zero 
	# _tmp2591 = "Try again. The square is already taken.\n"
	.data			# create string constant marked with label
	_string183: .asciiz "Try again. The square is already taken.\n"
	.text
	la $t0, _string183	# load label
	# PushParam _tmp2591
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp2591 from $t0 to $fp-188
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L411
	b _L411		# unconditional branch
_L410:
	# _tmp2592 = *(grid)
	lw $t0, -8($fp)	# load grid from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2593 = *(_tmp2592 + 24)
	lw $t2, 24($t1) 	# load with offset
	# _tmp2594 = *(human)
	lw $t3, -12($fp)	# load human from $fp-12 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp2595 = *(_tmp2594 + 4)
	lw $t5, 4($t4) 	# load with offset
	# PushParam human
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp2596 = ACall _tmp2595
	# (save modified registers before flow of control change)
	sw $t1, -192($fp)	# spill _tmp2592 from $t1 to $fp-192
	sw $t2, -196($fp)	# spill _tmp2593 from $t2 to $fp-196
	sw $t4, -200($fp)	# spill _tmp2594 from $t4 to $fp-200
	sw $t5, -204($fp)	# spill _tmp2595 from $t5 to $fp-204
	jalr $t5            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2596
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam column
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -24($fp)	# load column from $fp-24 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam row
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, -20($fp)	# load row from $fp-20 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, -8($fp)	# load grid from $fp-8 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# ACall _tmp2593
	lw $t4, -196($fp)	# load _tmp2593 from $fp-196 into $t4
	# (save modified registers before flow of control change)
	sw $t0, -208($fp)	# spill _tmp2596 from $t0 to $fp-208
	jalr $t4            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
_L411:
	# Goto _L408
	b _L408		# unconditional branch
_L409:
	# _tmp2597 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2598 = *(grid)
	lw $t1, -8($fp)	# load grid from $fp-8 into $t1
	lw $t2, 0($t1) 	# load with offset
	# _tmp2599 = *(_tmp2598 + 12)
	lw $t3, 12($t2) 	# load with offset
	# PushParam human
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load human from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2600 = ACall _tmp2599
	# (save modified registers before flow of control change)
	sw $t0, -212($fp)	# spill _tmp2597 from $t0 to $fp-212
	sw $t2, -220($fp)	# spill _tmp2598 from $t2 to $fp-220
	sw $t3, -224($fp)	# spill _tmp2599 from $t3 to $fp-224
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2601 = _tmp2597 - _tmp2600
	lw $t1, -212($fp)	# load _tmp2597 from $fp-212 into $t1
	sub $t2, $t1, $t0	
	# IfZ _tmp2601 Goto _L412
	# (save modified registers before flow of control change)
	sw $t0, -228($fp)	# spill _tmp2600 from $t0 to $fp-228
	sw $t2, -216($fp)	# spill _tmp2601 from $t2 to $fp-216
	beqz $t2, _L412	# branch if _tmp2601 is zero 
	# _tmp2602 = *(human)
	lw $t0, -12($fp)	# load human from $fp-12 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2603 = *(_tmp2602 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam human
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp2604 = ACall _tmp2603
	# (save modified registers before flow of control change)
	sw $t1, -232($fp)	# spill _tmp2602 from $t1 to $fp-232
	sw $t2, -236($fp)	# spill _tmp2603 from $t2 to $fp-236
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2604
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -240($fp)	# spill _tmp2604 from $t0 to $fp-240
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2605 = ", you won!\n"
	.data			# create string constant marked with label
	_string184: .asciiz ", you won!\n"
	.text
	la $t0, _string184	# load label
	# PushParam _tmp2605
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -244($fp)	# spill _tmp2605 from $t0 to $fp-244
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2606 = 1
	li $t0, 1		# load constant value 1 into $t0
	# gameOver = _tmp2606
	move $t1, $t0		# copy value
	# Goto _L413
	# (save modified registers before flow of control change)
	sw $t0, -248($fp)	# spill _tmp2606 from $t0 to $fp-248
	sw $t1, -32($fp)	# spill gameOver from $t1 to $fp-32
	b _L413		# unconditional branch
_L412:
	# _tmp2607 = *(grid)
	lw $t0, -8($fp)	# load grid from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2608 = *(_tmp2607 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp2609 = ACall _tmp2608
	# (save modified registers before flow of control change)
	sw $t1, -256($fp)	# spill _tmp2607 from $t1 to $fp-256
	sw $t2, -260($fp)	# spill _tmp2608 from $t2 to $fp-260
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2610 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp2611 = _tmp2610 - gameOver
	lw $t2, -32($fp)	# load gameOver from $fp-32 into $t2
	sub $t3, $t1, $t2	
	# _tmp2612 = _tmp2611 && _tmp2609
	and $t4, $t3, $t0	
	# IfZ _tmp2612 Goto _L414
	# (save modified registers before flow of control change)
	sw $t0, -264($fp)	# spill _tmp2609 from $t0 to $fp-264
	sw $t1, -268($fp)	# spill _tmp2610 from $t1 to $fp-268
	sw $t3, -272($fp)	# spill _tmp2611 from $t3 to $fp-272
	sw $t4, -252($fp)	# spill _tmp2612 from $t4 to $fp-252
	beqz $t4, _L414	# branch if _tmp2612 is zero 
	# _tmp2613 = 1
	li $t0, 1		# load constant value 1 into $t0
	# gameOver = _tmp2613
	move $t1, $t0		# copy value
	# _tmp2614 = "There was a tie...You all lose!\n"
	.data			# create string constant marked with label
	_string185: .asciiz "There was a tie...You all lose!\n"
	.text
	la $t2, _string185	# load label
	# PushParam _tmp2614
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -276($fp)	# spill _tmp2613 from $t0 to $fp-276
	sw $t1, -32($fp)	# spill gameOver from $t1 to $fp-32
	sw $t2, -280($fp)	# spill _tmp2614 from $t2 to $fp-280
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L415
	b _L415		# unconditional branch
_L414:
	# _tmp2615 = *(computer)
	lw $t0, -16($fp)	# load computer from $fp-16 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp2616 = *(_tmp2615 + 12)
	lw $t2, 12($t1) 	# load with offset
	# PushParam human
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, -12($fp)	# load human from $fp-12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load grid from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam computer
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp2616
	# (save modified registers before flow of control change)
	sw $t1, -284($fp)	# spill _tmp2615 from $t1 to $fp-284
	sw $t2, -288($fp)	# spill _tmp2616 from $t2 to $fp-288
	jalr $t2            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
_L415:
_L413:
	# _tmp2617 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp2618 = *(grid)
	lw $t1, -8($fp)	# load grid from $fp-8 into $t1
	lw $t2, 0($t1) 	# load with offset
	# _tmp2619 = *(_tmp2618 + 12)
	lw $t3, 12($t2) 	# load with offset
	# PushParam computer
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -16($fp)	# load computer from $fp-16 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam grid
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp2620 = ACall _tmp2619
	# (save modified registers before flow of control change)
	sw $t0, -296($fp)	# spill _tmp2617 from $t0 to $fp-296
	sw $t2, -304($fp)	# spill _tmp2618 from $t2 to $fp-304
	sw $t3, -308($fp)	# spill _tmp2619 from $t3 to $fp-308
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp2621 = _tmp2617 - _tmp2620
	lw $t1, -296($fp)	# load _tmp2617 from $fp-296 into $t1
	sub $t2, $t1, $t0	
	# _tmp2622 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp2623 = _tmp2622 - gameOver
	lw $t4, -32($fp)	# load gameOver from $fp-32 into $t4
	sub $t5, $t3, $t4	
	# _tmp2624 = _tmp2623 && _tmp2621
	and $t6, $t5, $t2	
	# IfZ _tmp2624 Goto _L416
	# (save modified registers before flow of control change)
	sw $t0, -312($fp)	# spill _tmp2620 from $t0 to $fp-312
	sw $t2, -300($fp)	# spill _tmp2621 from $t2 to $fp-300
	sw $t3, -316($fp)	# spill _tmp2622 from $t3 to $fp-316
	sw $t5, -320($fp)	# spill _tmp2623 from $t5 to $fp-320
	sw $t6, -292($fp)	# spill _tmp2624 from $t6 to $fp-292
	beqz $t6, _L416	# branch if _tmp2624 is zero 
	# _tmp2625 = "Loser -- the computer won!\n"
	.data			# create string constant marked with label
	_string186: .asciiz "Loser -- the computer won!\n"
	.text
	la $t0, _string186	# load label
	# PushParam _tmp2625
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -324($fp)	# spill _tmp2625 from $t0 to $fp-324
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2626 = 1
	li $t0, 1		# load constant value 1 into $t0
	# gameOver = _tmp2626
	move $t1, $t0		# copy value
	# Goto _L417
	# (save modified registers before flow of control change)
	sw $t0, -328($fp)	# spill _tmp2626 from $t0 to $fp-328
	sw $t1, -32($fp)	# spill gameOver from $t1 to $fp-32
	b _L417		# unconditional branch
_L416:
_L417:
	# Goto _L406
	b _L406		# unconditional branch
_L407:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
