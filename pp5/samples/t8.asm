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
	
__Squash.Grow:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp0 = "But I don't like squash\n"
	.data			# create string constant marked with label
	_string1: .asciiz "But I don't like squash\n"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp0
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp0 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp1 = 5
	li $t0, 5		# load constant value 5 into $t0
	# _tmp2 = 10
	li $t1, 10		# load constant value 10 into $t1
	# _tmp3 = _tmp2 * _tmp1
	mul $t2, $t1, $t0	
	# PushParam _tmp3
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp1 from $t0 to $fp-16
	sw $t1, -20($fp)	# spill _tmp2 from $t1 to $fp-20
	sw $t2, -12($fp)	# spill _tmp3 from $t2 to $fp-12
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Squash
	.data
	.align 2
	Squash:		# label for class Squash vtable
	.word __Vegetable.Eat
	.word __Squash.Grow
	.text
__Vegetable.Eat:
	# BeginFunc 48
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp4 = 2
	li $t0, 2		# load constant value 2 into $t0
	# _tmp5 = 5
	li $t1, 5		# load constant value 5 into $t1
	# _tmp6 = _tmp5 % _tmp4
	rem $t2, $t1, $t0	
	# _tmp7 = 4
	li $t3, 4		# load constant value 4 into $t3
	# _tmp8 = this + _tmp7
	lw $t4, 4($fp)	# load this from $fp+4 into $t4
	add $t5, $t4, $t3	
	# *(_tmp8) = _tmp6
	sw $t2, 0($t5) 	# store with offset
	# _tmp9 = "Yum! "
	.data			# create string constant marked with label
	_string2: .asciiz "Yum! "
	.text
	la $t6, _string2	# load label
	# PushParam _tmp9
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp4 from $t0 to $fp-20
	sw $t1, -24($fp)	# spill _tmp5 from $t1 to $fp-24
	sw $t2, -16($fp)	# spill _tmp6 from $t2 to $fp-16
	sw $t3, -28($fp)	# spill _tmp7 from $t3 to $fp-28
	sw $t5, -32($fp)	# spill _tmp8 from $t5 to $fp-32
	sw $t6, -36($fp)	# spill _tmp9 from $t6 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp10 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# PushParam _tmp10
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t1, -40($fp)	# spill _tmp10 from $t1 to $fp-40
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp11 = "\n"
	.data			# create string constant marked with label
	_string3: .asciiz "\n"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp11
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp11 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp12 = *(veg)
	lw $t0, 8($fp)	# load veg from $fp+8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp13 = *(_tmp12 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam w
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, -12($fp)	# load w from $fp-12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam s
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load s from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam veg
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp13
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp12 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp13 from $t2 to $fp-52
	jalr $t2            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# Return 
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
__Vegetable.Grow:
	# BeginFunc 12
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp14 = "Grow, little vegetables, grow!\n"
	.data			# create string constant marked with label
	_string4: .asciiz "Grow, little vegetables, grow!\n"
	.text
	la $t0, _string4	# load label
	# PushParam _tmp14
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp14 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp15 = *(this)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp16 = *(_tmp15)
	lw $t2, 0($t1) 	# load with offset
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp16
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp15 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp16 from $t2 to $fp-16
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Vegetable
	.data
	.align 2
	Vegetable:		# label for class Vegetable vtable
	.word __Vegetable.Eat
	.word __Vegetable.Grow
	.text
__Grow:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp17 = "mmm... veggies!\n"
	.data			# create string constant marked with label
	_string5: .asciiz "mmm... veggies!\n"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp17
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp17 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Seeds
	.data
	.align 2
	Seeds:		# label for class Seeds vtable
	.text
main:
	# BeginFunc 248
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 248	# decrement sp to make space for locals/temps
	# _tmp18 = 2
	li $t0, 2		# load constant value 2 into $t0
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
	sw $t0, -12($fp)	# spill _tmp18 from $t0 to $fp-12
	sw $t1, -16($fp)	# spill _tmp19 from $t1 to $fp-16
	sw $t2, -20($fp)	# spill _tmp20 from $t2 to $fp-20
	sw $t3, -24($fp)	# spill _tmp21 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp22 from $t4 to $fp-28
	beqz $t4, _L0	# branch if _tmp22 is zero 
	# _tmp23 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string6: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp23
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp23 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L0:
	# _tmp24 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp25 = _tmp18 * _tmp24
	lw $t1, -12($fp)	# load _tmp18 from $fp-12 into $t1
	mul $t2, $t1, $t0	
	# _tmp26 = _tmp25 + _tmp24
	add $t3, $t2, $t0	
	# PushParam _tmp26
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp27 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp24 from $t0 to $fp-36
	sw $t2, -40($fp)	# spill _tmp25 from $t2 to $fp-40
	sw $t3, -44($fp)	# spill _tmp26 from $t3 to $fp-44
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp27) = _tmp18
	lw $t1, -12($fp)	# load _tmp18 from $fp-12 into $t1
	sw $t1, 0($t0) 	# store with offset
	# veggies = _tmp27
	move $t2, $t0		# copy value
	# _tmp28 = 12
	li $t3, 12		# load constant value 12 into $t3
	# PushParam _tmp28
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp29 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp27 from $t0 to $fp-48
	sw $t2, -8($fp)	# spill veggies from $t2 to $fp-8
	sw $t3, -52($fp)	# spill _tmp28 from $t3 to $fp-52
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp30 = Squash
	la $t1, Squash	# load label
	# *(_tmp29) = _tmp30
	sw $t1, 0($t0) 	# store with offset
	# _tmp31 = *(veggies)
	lw $t2, -8($fp)	# load veggies from $fp-8 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp32 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp33 = _tmp32 < _tmp31
	slt $t5, $t4, $t3	
	# _tmp34 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp35 = _tmp34 < _tmp32
	slt $t7, $t6, $t4	
	# _tmp36 = _tmp35 && _tmp33
	and $s0, $t7, $t5	
	# IfZ _tmp36 Goto _L1
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp29 from $t0 to $fp-56
	sw $t1, -60($fp)	# spill _tmp30 from $t1 to $fp-60
	sw $t3, -64($fp)	# spill _tmp31 from $t3 to $fp-64
	sw $t4, -72($fp)	# spill _tmp32 from $t4 to $fp-72
	sw $t5, -68($fp)	# spill _tmp33 from $t5 to $fp-68
	sw $t6, -76($fp)	# spill _tmp34 from $t6 to $fp-76
	sw $t7, -80($fp)	# spill _tmp35 from $t7 to $fp-80
	sw $s0, -84($fp)	# spill _tmp36 from $s0 to $fp-84
	beqz $s0, _L1	# branch if _tmp36 is zero 
	# _tmp37 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp38 = _tmp32 * _tmp37
	lw $t1, -72($fp)	# load _tmp32 from $fp-72 into $t1
	mul $t2, $t1, $t0	
	# _tmp39 = _tmp38 + _tmp37
	add $t3, $t2, $t0	
	# _tmp40 = veggies + _tmp39
	lw $t4, -8($fp)	# load veggies from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp37 from $t0 to $fp-88
	sw $t2, -92($fp)	# spill _tmp38 from $t2 to $fp-92
	sw $t3, -96($fp)	# spill _tmp39 from $t3 to $fp-96
	sw $t5, -96($fp)	# spill _tmp40 from $t5 to $fp-96
	b _L2		# unconditional branch
_L1:
	# _tmp41 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string7: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp41
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp41 from $t0 to $fp-100
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L2:
	# *(_tmp40) = _tmp29
	lw $t0, -56($fp)	# load _tmp29 from $fp-56 into $t0
	lw $t1, -96($fp)	# load _tmp40 from $fp-96 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp42 = 12
	li $t2, 12		# load constant value 12 into $t2
	# PushParam _tmp42
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp43 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t2, -104($fp)	# spill _tmp42 from $t2 to $fp-104
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp44 = Vegetable
	la $t1, Vegetable	# load label
	# *(_tmp43) = _tmp44
	sw $t1, 0($t0) 	# store with offset
	# _tmp45 = *(veggies)
	lw $t2, -8($fp)	# load veggies from $fp-8 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp46 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp47 = _tmp46 < _tmp45
	slt $t5, $t4, $t3	
	# _tmp48 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp49 = _tmp48 < _tmp46
	slt $t7, $t6, $t4	
	# _tmp50 = _tmp49 && _tmp47
	and $s0, $t7, $t5	
	# IfZ _tmp50 Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp43 from $t0 to $fp-108
	sw $t1, -112($fp)	# spill _tmp44 from $t1 to $fp-112
	sw $t3, -116($fp)	# spill _tmp45 from $t3 to $fp-116
	sw $t4, -124($fp)	# spill _tmp46 from $t4 to $fp-124
	sw $t5, -120($fp)	# spill _tmp47 from $t5 to $fp-120
	sw $t6, -128($fp)	# spill _tmp48 from $t6 to $fp-128
	sw $t7, -132($fp)	# spill _tmp49 from $t7 to $fp-132
	sw $s0, -136($fp)	# spill _tmp50 from $s0 to $fp-136
	beqz $s0, _L3	# branch if _tmp50 is zero 
	# _tmp51 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp52 = _tmp46 * _tmp51
	lw $t1, -124($fp)	# load _tmp46 from $fp-124 into $t1
	mul $t2, $t1, $t0	
	# _tmp53 = _tmp52 + _tmp51
	add $t3, $t2, $t0	
	# _tmp54 = veggies + _tmp53
	lw $t4, -8($fp)	# load veggies from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp51 from $t0 to $fp-140
	sw $t2, -144($fp)	# spill _tmp52 from $t2 to $fp-144
	sw $t3, -148($fp)	# spill _tmp53 from $t3 to $fp-148
	sw $t5, -148($fp)	# spill _tmp54 from $t5 to $fp-148
	b _L4		# unconditional branch
_L3:
	# _tmp55 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string8: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string8	# load label
	# PushParam _tmp55
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp55 from $t0 to $fp-152
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L4:
	# *(_tmp54) = _tmp43
	lw $t0, -108($fp)	# load _tmp43 from $fp-108 into $t0
	lw $t1, -148($fp)	# load _tmp54 from $fp-148 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp56 = 10
	li $t2, 10		# load constant value 10 into $t2
	# PushParam _tmp56
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall __Grow
	# (save modified registers before flow of control change)
	sw $t2, -156($fp)	# spill _tmp56 from $t2 to $fp-156
	jal __Grow         	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp57 = *(veggies)
	lw $t0, -8($fp)	# load veggies from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp58 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp59 = _tmp58 < _tmp57
	slt $t3, $t2, $t1	
	# _tmp60 = -1
	li $t4, -1		# load constant value -1 into $t4
	# _tmp61 = _tmp60 < _tmp58
	slt $t5, $t4, $t2	
	# _tmp62 = _tmp61 && _tmp59
	and $t6, $t5, $t3	
	# IfZ _tmp62 Goto _L5
	# (save modified registers before flow of control change)
	sw $t1, -160($fp)	# spill _tmp57 from $t1 to $fp-160
	sw $t2, -168($fp)	# spill _tmp58 from $t2 to $fp-168
	sw $t3, -164($fp)	# spill _tmp59 from $t3 to $fp-164
	sw $t4, -172($fp)	# spill _tmp60 from $t4 to $fp-172
	sw $t5, -176($fp)	# spill _tmp61 from $t5 to $fp-176
	sw $t6, -180($fp)	# spill _tmp62 from $t6 to $fp-180
	beqz $t6, _L5	# branch if _tmp62 is zero 
	# _tmp63 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp64 = _tmp58 * _tmp63
	lw $t1, -168($fp)	# load _tmp58 from $fp-168 into $t1
	mul $t2, $t1, $t0	
	# _tmp65 = _tmp64 + _tmp63
	add $t3, $t2, $t0	
	# _tmp66 = veggies + _tmp65
	lw $t4, -8($fp)	# load veggies from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -184($fp)	# spill _tmp63 from $t0 to $fp-184
	sw $t2, -188($fp)	# spill _tmp64 from $t2 to $fp-188
	sw $t3, -192($fp)	# spill _tmp65 from $t3 to $fp-192
	sw $t5, -192($fp)	# spill _tmp66 from $t5 to $fp-192
	b _L6		# unconditional branch
_L5:
	# _tmp67 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string9: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp67
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -196($fp)	# spill _tmp67 from $t0 to $fp-196
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L6:
	# _tmp68 = *(_tmp66)
	lw $t0, -192($fp)	# load _tmp66 from $fp-192 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp69 = *(_tmp68)
	lw $t2, 0($t1) 	# load with offset
	# _tmp70 = *(_tmp69)
	lw $t3, 0($t2) 	# load with offset
	# _tmp71 = *(veggies)
	lw $t4, -8($fp)	# load veggies from $fp-8 into $t4
	lw $t5, 0($t4) 	# load with offset
	# _tmp72 = 0
	li $t6, 0		# load constant value 0 into $t6
	# _tmp73 = _tmp72 < _tmp71
	slt $t7, $t6, $t5	
	# _tmp74 = -1
	li $s0, -1		# load constant value -1 into $s0
	# _tmp75 = _tmp74 < _tmp72
	slt $s1, $s0, $t6	
	# _tmp76 = _tmp75 && _tmp73
	and $s2, $s1, $t7	
	# IfZ _tmp76 Goto _L7
	# (save modified registers before flow of control change)
	sw $t1, -200($fp)	# spill _tmp68 from $t1 to $fp-200
	sw $t2, -204($fp)	# spill _tmp69 from $t2 to $fp-204
	sw $t3, -208($fp)	# spill _tmp70 from $t3 to $fp-208
	sw $t5, -212($fp)	# spill _tmp71 from $t5 to $fp-212
	sw $t6, -220($fp)	# spill _tmp72 from $t6 to $fp-220
	sw $t7, -216($fp)	# spill _tmp73 from $t7 to $fp-216
	sw $s0, -224($fp)	# spill _tmp74 from $s0 to $fp-224
	sw $s1, -228($fp)	# spill _tmp75 from $s1 to $fp-228
	sw $s2, -232($fp)	# spill _tmp76 from $s2 to $fp-232
	beqz $s2, _L7	# branch if _tmp76 is zero 
	# _tmp77 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp78 = _tmp72 * _tmp77
	lw $t1, -220($fp)	# load _tmp72 from $fp-220 into $t1
	mul $t2, $t1, $t0	
	# _tmp79 = _tmp78 + _tmp77
	add $t3, $t2, $t0	
	# _tmp80 = veggies + _tmp79
	lw $t4, -8($fp)	# load veggies from $fp-8 into $t4
	add $t5, $t4, $t3	
	# Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -236($fp)	# spill _tmp77 from $t0 to $fp-236
	sw $t2, -240($fp)	# spill _tmp78 from $t2 to $fp-240
	sw $t3, -244($fp)	# spill _tmp79 from $t3 to $fp-244
	sw $t5, -244($fp)	# spill _tmp80 from $t5 to $fp-244
	b _L8		# unconditional branch
_L7:
	# _tmp81 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp81
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -248($fp)	# spill _tmp81 from $t0 to $fp-248
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L8:
	# _tmp82 = *(_tmp80)
	lw $t0, -244($fp)	# load _tmp80 from $fp-244 into $t0
	lw $t1, 0($t0) 	# load with offset
	# PushParam _tmp82
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam _tmp68
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, -200($fp)	# load _tmp68 from $fp-200 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp70
	lw $t3, -208($fp)	# load _tmp70 from $fp-208 into $t3
	# (save modified registers before flow of control change)
	sw $t1, -252($fp)	# spill _tmp82 from $t1 to $fp-252
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
