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
	
__Animal.InitAnimal:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp0 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1 = this + _tmp0
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp1) = h
	lw $t3, 8($fp)	# load h from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# _tmp2 = 8
	li $t4, 8		# load constant value 8 into $t4
	# _tmp3 = this + _tmp2
	add $t5, $t1, $t4	
	# *(_tmp3) = mom
	lw $t6, 12($fp)	# load mom from $fp+12 into $t6
	sw $t6, 0($t5) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Animal.GetHeight:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp4 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# Return _tmp4
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
__Animal.GetMom:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp5 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# Return _tmp5
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
	# VTable for class Animal
	.data
	.align 2
	Animal:		# label for class Animal vtable
	.word __Animal.GetHeight
	.word __Animal.GetMom
	.word __Animal.InitAnimal
	.text
__Cow.InitCow:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp6 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp7 = this + _tmp6
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp7) = spot
	lw $t3, 16($fp)	# load spot from $fp+16 into $t3
	sw $t3, 0($t2) 	# store with offset
	# _tmp8 = *(this)
	lw $t4, 0($t1) 	# load with offset
	# _tmp9 = *(_tmp8 + 8)
	lw $t5, 8($t4) 	# load with offset
	# PushParam m
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, 12($fp)	# load m from $fp+12 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam h
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t7, 8($fp)	# load h from $fp+8 into $t7
	sw $t7, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp9
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp6 from $t0 to $fp-8
	sw $t2, -12($fp)	# spill _tmp7 from $t2 to $fp-12
	sw $t4, -16($fp)	# spill _tmp8 from $t4 to $fp-16
	sw $t5, -20($fp)	# spill _tmp9 from $t5 to $fp-20
	jalr $t5            	# jump to function
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Cow.IsSpottedCow:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp10 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# Return _tmp10
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
	# VTable for class Cow
	.data
	.align 2
	Cow:		# label for class Cow vtable
	.word __Animal.GetHeight
	.word __Animal.GetMom
	.word __Animal.InitAnimal
	.word __Cow.InitCow
	.word __Cow.IsSpottedCow
	.text
main:
	# BeginFunc 84
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 84	# decrement sp to make space for locals/temps
	# _tmp11 = 16
	li $t0, 16		# load constant value 16 into $t0
	# PushParam _tmp11
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp12 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp11 from $t0 to $fp-16
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp13 = Cow
	la $t1, Cow	# load label
	# *(_tmp12) = _tmp13
	sw $t1, 0($t0) 	# store with offset
	# betsy = _tmp12
	move $t2, $t0		# copy value
	# _tmp14 = *(betsy)
	lw $t3, 0($t2) 	# load with offset
	# _tmp15 = *(_tmp14 + 12)
	lw $t4, 12($t3) 	# load with offset
	# _tmp16 = 1
	li $t5, 1		# load constant value 1 into $t5
	# PushParam _tmp16
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# _tmp17 = 0
	li $t6, 0		# load constant value 0 into $t6
	# PushParam _tmp17
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# _tmp18 = 5
	li $t7, 5		# load constant value 5 into $t7
	# PushParam _tmp18
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t7, 4($sp)	# copy param value to stack
	# PushParam betsy
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp15
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp12 from $t0 to $fp-20
	sw $t1, -24($fp)	# spill _tmp13 from $t1 to $fp-24
	sw $t2, -8($fp)	# spill betsy from $t2 to $fp-8
	sw $t3, -28($fp)	# spill _tmp14 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp15 from $t4 to $fp-32
	sw $t5, -36($fp)	# spill _tmp16 from $t5 to $fp-36
	sw $t6, -40($fp)	# spill _tmp17 from $t6 to $fp-40
	sw $t7, -44($fp)	# spill _tmp18 from $t7 to $fp-44
	jalr $t4            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# b = betsy
	lw $t0, -8($fp)	# load betsy from $fp-8 into $t0
	move $t1, $t0		# copy value
	# _tmp19 = *(b)
	lw $t2, 0($t1) 	# load with offset
	# _tmp20 = *(_tmp19 + 4)
	lw $t3, 4($t2) 	# load with offset
	# PushParam b
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp21 = ACall _tmp20
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill b from $t1 to $fp-12
	sw $t2, -48($fp)	# spill _tmp19 from $t2 to $fp-48
	sw $t3, -52($fp)	# spill _tmp20 from $t3 to $fp-52
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp22 = "spots: "
	.data			# create string constant marked with label
	_string1: .asciiz "spots: "
	.text
	la $t1, _string1	# load label
	# PushParam _tmp22
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp21 from $t0 to $fp-56
	sw $t1, -60($fp)	# spill _tmp22 from $t1 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp23 = *(betsy)
	lw $t0, -8($fp)	# load betsy from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp24 = *(_tmp23 + 16)
	lw $t2, 16($t1) 	# load with offset
	# PushParam betsy
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp25 = ACall _tmp24
	# (save modified registers before flow of control change)
	sw $t1, -64($fp)	# spill _tmp23 from $t1 to $fp-64
	sw $t2, -68($fp)	# spill _tmp24 from $t2 to $fp-68
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp25
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintBool
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp25 from $t0 to $fp-72
	jal _PrintBool     	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp26 = "    height: "
	.data			# create string constant marked with label
	_string2: .asciiz "    height: "
	.text
	la $t0, _string2	# load label
	# PushParam _tmp26
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp26 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp27 = *(b)
	lw $t0, -12($fp)	# load b from $fp-12 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp28 = *(_tmp27)
	lw $t2, 0($t1) 	# load with offset
	# PushParam b
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp29 = ACall _tmp28
	# (save modified registers before flow of control change)
	sw $t1, -80($fp)	# spill _tmp27 from $t1 to $fp-80
	sw $t2, -84($fp)	# spill _tmp28 from $t2 to $fp-84
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp29
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp29 from $t0 to $fp-88
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
