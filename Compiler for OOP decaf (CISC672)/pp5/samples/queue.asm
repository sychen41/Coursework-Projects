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
	
__QueueItem.Init:
	# BeginFunc 40
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# _tmp0 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp1 = this + _tmp0
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp1) = data
	lw $t3, 8($fp)	# load data from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# _tmp2 = 8
	li $t4, 8		# load constant value 8 into $t4
	# _tmp3 = this + _tmp2
	add $t5, $t1, $t4	
	# *(_tmp3) = next
	lw $t6, 12($fp)	# load next from $fp+12 into $t6
	sw $t6, 0($t5) 	# store with offset
	# _tmp4 = 12
	li $t7, 12		# load constant value 12 into $t7
	# _tmp5 = next + _tmp4
	add $s0, $t6, $t7	
	# *(_tmp5) = this
	sw $t1, 0($s0) 	# store with offset
	# _tmp6 = 12
	li $s1, 12		# load constant value 12 into $s1
	# _tmp7 = this + _tmp6
	add $s2, $t1, $s1	
	# *(_tmp7) = prev
	lw $s3, 16($fp)	# load prev from $fp+16 into $s3
	sw $s3, 0($s2) 	# store with offset
	# _tmp8 = 8
	li $s4, 8		# load constant value 8 into $s4
	# _tmp9 = prev + _tmp8
	add $s5, $s3, $s4	
	# *(_tmp9) = this
	sw $t1, 0($s5) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__QueueItem.GetData:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp10 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
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
__QueueItem.GetNext:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp11 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# Return _tmp11
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
__QueueItem.GetPrev:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp12 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# Return _tmp12
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
__QueueItem.SetNext:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp13 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp14 = this + _tmp13
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp14) = n
	lw $t3, 8($fp)	# load n from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__QueueItem.SetPrev:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp15 = 12
	li $t0, 12		# load constant value 12 into $t0
	# _tmp16 = this + _tmp15
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp16) = p
	lw $t3, 8($fp)	# load p from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class QueueItem
	.data
	.align 2
	QueueItem:		# label for class QueueItem vtable
	.word __QueueItem.GetData
	.word __QueueItem.GetNext
	.word __QueueItem.GetPrev
	.word __QueueItem.Init
	.word __QueueItem.SetNext
	.word __QueueItem.SetPrev
	.text
__Queue.Init:
	# BeginFunc 44
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 44	# decrement sp to make space for locals/temps
	# _tmp17 = 16
	li $t0, 16		# load constant value 16 into $t0
	# PushParam _tmp17
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp18 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp17 from $t0 to $fp-8
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp19 = QueueItem
	la $t1, QueueItem	# load label
	# *(_tmp18) = _tmp19
	sw $t1, 0($t0) 	# store with offset
	# _tmp20 = 4
	li $t2, 4		# load constant value 4 into $t2
	# _tmp21 = this + _tmp20
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp21) = _tmp18
	sw $t0, 0($t4) 	# store with offset
	# _tmp22 = *(this + 4)
	lw $t5, 4($t3) 	# load with offset
	# _tmp23 = *(_tmp22)
	lw $t6, 0($t5) 	# load with offset
	# _tmp24 = *(_tmp23 + 12)
	lw $t7, 12($t6) 	# load with offset
	# _tmp25 = *(this + 4)
	lw $s0, 4($t3) 	# load with offset
	# PushParam _tmp25
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s0, 4($sp)	# copy param value to stack
	# _tmp26 = *(this + 4)
	lw $s1, 4($t3) 	# load with offset
	# PushParam _tmp26
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s1, 4($sp)	# copy param value to stack
	# _tmp27 = 0
	li $s2, 0		# load constant value 0 into $s2
	# PushParam _tmp27
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s2, 4($sp)	# copy param value to stack
	# PushParam _tmp22
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# ACall _tmp24
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp18 from $t0 to $fp-12
	sw $t1, -16($fp)	# spill _tmp19 from $t1 to $fp-16
	sw $t2, -20($fp)	# spill _tmp20 from $t2 to $fp-20
	sw $t4, -24($fp)	# spill _tmp21 from $t4 to $fp-24
	sw $t5, -28($fp)	# spill _tmp22 from $t5 to $fp-28
	sw $t6, -32($fp)	# spill _tmp23 from $t6 to $fp-32
	sw $t7, -36($fp)	# spill _tmp24 from $t7 to $fp-36
	sw $s0, -40($fp)	# spill _tmp25 from $s0 to $fp-40
	sw $s1, -44($fp)	# spill _tmp26 from $s1 to $fp-44
	sw $s2, -48($fp)	# spill _tmp27 from $s2 to $fp-48
	jalr $t7            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Queue.EnQueue:
	# BeginFunc 44
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 44	# decrement sp to make space for locals/temps
	# _tmp28 = 16
	li $t0, 16		# load constant value 16 into $t0
	# PushParam _tmp28
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp29 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp28 from $t0 to $fp-12
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp30 = QueueItem
	la $t1, QueueItem	# load label
	# *(_tmp29) = _tmp30
	sw $t1, 0($t0) 	# store with offset
	# temp = _tmp29
	move $t2, $t0		# copy value
	# _tmp31 = *(temp)
	lw $t3, 0($t2) 	# load with offset
	# _tmp32 = *(_tmp31 + 12)
	lw $t4, 12($t3) 	# load with offset
	# _tmp33 = *(this + 4)
	lw $t5, 4($fp)	# load this from $fp+4 into $t5
	lw $t6, 4($t5) 	# load with offset
	# PushParam _tmp33
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# _tmp34 = *(this + 4)
	lw $t7, 4($t5) 	# load with offset
	# _tmp35 = *(_tmp34)
	lw $s0, 0($t7) 	# load with offset
	# _tmp36 = *(_tmp35 + 4)
	lw $s1, 4($s0) 	# load with offset
	# PushParam _tmp34
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t7, 4($sp)	# copy param value to stack
	# _tmp37 = ACall _tmp36
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp29 from $t0 to $fp-16
	sw $t1, -20($fp)	# spill _tmp30 from $t1 to $fp-20
	sw $t2, -8($fp)	# spill temp from $t2 to $fp-8
	sw $t3, -24($fp)	# spill _tmp31 from $t3 to $fp-24
	sw $t4, -28($fp)	# spill _tmp32 from $t4 to $fp-28
	sw $t6, -32($fp)	# spill _tmp33 from $t6 to $fp-32
	sw $t7, -36($fp)	# spill _tmp34 from $t7 to $fp-36
	sw $s0, -40($fp)	# spill _tmp35 from $s0 to $fp-40
	sw $s1, -44($fp)	# spill _tmp36 from $s1 to $fp-44
	jalr $s1            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp37
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, 8($fp)	# load i from $fp+8 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam temp
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, -8($fp)	# load temp from $fp-8 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp32
	lw $t3, -28($fp)	# load _tmp32 from $fp-28 into $t3
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp37 from $t0 to $fp-48
	jalr $t3            	# jump to function
	# PopParams 16
	add $sp, $sp, 16	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Queue.DeQueue:
	# BeginFunc 132
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 132	# decrement sp to make space for locals/temps
	# _tmp38 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp39 = *(_tmp38)
	lw $t2, 0($t1) 	# load with offset
	# _tmp40 = *(_tmp39 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp38
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp41 = ACall _tmp40
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp38 from $t1 to $fp-12
	sw $t2, -16($fp)	# spill _tmp39 from $t2 to $fp-16
	sw $t3, -20($fp)	# spill _tmp40 from $t3 to $fp-20
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp42 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp43 = _tmp41 == _tmp42
	seq $t3, $t0, $t2	
	# IfZ _tmp43 Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp41 from $t0 to $fp-24
	sw $t2, -28($fp)	# spill _tmp42 from $t2 to $fp-28
	sw $t3, -32($fp)	# spill _tmp43 from $t3 to $fp-32
	beqz $t3, _L0	# branch if _tmp43 is zero 
	# _tmp44 = "Queue Is Empty"
	.data			# create string constant marked with label
	_string1: .asciiz "Queue Is Empty"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp44
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp44 from $t0 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp45 = 0
	li $t0, 0		# load constant value 0 into $t0
	# Return _tmp45
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L1
	b _L1		# unconditional branch
_L0:
	# _tmp46 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp47 = *(_tmp46)
	lw $t2, 0($t1) 	# load with offset
	# _tmp48 = *(_tmp47 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp46
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp49 = ACall _tmp48
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp46 from $t1 to $fp-48
	sw $t2, -52($fp)	# spill _tmp47 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp48 from $t3 to $fp-56
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# temp = _tmp49
	move $t1, $t0		# copy value
	# _tmp50 = *(temp)
	lw $t2, 0($t1) 	# load with offset
	# _tmp51 = *(_tmp50)
	lw $t3, 0($t2) 	# load with offset
	# PushParam temp
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp52 = ACall _tmp51
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp49 from $t0 to $fp-60
	sw $t1, -44($fp)	# spill temp from $t1 to $fp-44
	sw $t2, -64($fp)	# spill _tmp50 from $t2 to $fp-64
	sw $t3, -68($fp)	# spill _tmp51 from $t3 to $fp-68
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# val = _tmp52
	move $t1, $t0		# copy value
	# _tmp53 = *(temp)
	lw $t2, -44($fp)	# load temp from $fp-44 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp54 = *(_tmp53 + 8)
	lw $t4, 8($t3) 	# load with offset
	# PushParam temp
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp55 = ACall _tmp54
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp52 from $t0 to $fp-72
	sw $t1, -8($fp)	# spill val from $t1 to $fp-8
	sw $t3, -76($fp)	# spill _tmp53 from $t3 to $fp-76
	sw $t4, -80($fp)	# spill _tmp54 from $t4 to $fp-80
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp56 = *(_tmp55)
	lw $t1, 0($t0) 	# load with offset
	# _tmp57 = *(_tmp56 + 16)
	lw $t2, 16($t1) 	# load with offset
	# _tmp58 = *(temp)
	lw $t3, -44($fp)	# load temp from $fp-44 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp59 = *(_tmp58 + 4)
	lw $t5, 4($t4) 	# load with offset
	# PushParam temp
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp60 = ACall _tmp59
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp55 from $t0 to $fp-84
	sw $t1, -88($fp)	# spill _tmp56 from $t1 to $fp-88
	sw $t2, -92($fp)	# spill _tmp57 from $t2 to $fp-92
	sw $t4, -96($fp)	# spill _tmp58 from $t4 to $fp-96
	sw $t5, -100($fp)	# spill _tmp59 from $t5 to $fp-100
	jalr $t5            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp60
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp55
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -84($fp)	# load _tmp55 from $fp-84 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp57
	lw $t2, -92($fp)	# load _tmp57 from $fp-92 into $t2
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp60 from $t0 to $fp-104
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp61 = *(temp)
	lw $t0, -44($fp)	# load temp from $fp-44 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp62 = *(_tmp61 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam temp
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp63 = ACall _tmp62
	# (save modified registers before flow of control change)
	sw $t1, -108($fp)	# spill _tmp61 from $t1 to $fp-108
	sw $t2, -112($fp)	# spill _tmp62 from $t2 to $fp-112
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp64 = *(_tmp63)
	lw $t1, 0($t0) 	# load with offset
	# _tmp65 = *(_tmp64 + 20)
	lw $t2, 20($t1) 	# load with offset
	# _tmp66 = *(temp)
	lw $t3, -44($fp)	# load temp from $fp-44 into $t3
	lw $t4, 0($t3) 	# load with offset
	# _tmp67 = *(_tmp66 + 8)
	lw $t5, 8($t4) 	# load with offset
	# PushParam temp
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp68 = ACall _tmp67
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp63 from $t0 to $fp-116
	sw $t1, -120($fp)	# spill _tmp64 from $t1 to $fp-120
	sw $t2, -124($fp)	# spill _tmp65 from $t2 to $fp-124
	sw $t4, -128($fp)	# spill _tmp66 from $t4 to $fp-128
	sw $t5, -132($fp)	# spill _tmp67 from $t5 to $fp-132
	jalr $t5            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp68
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp63
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -116($fp)	# load _tmp63 from $fp-116 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp65
	lw $t2, -124($fp)	# load _tmp65 from $fp-124 into $t2
	# (save modified registers before flow of control change)
	sw $t0, -136($fp)	# spill _tmp68 from $t0 to $fp-136
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
_L1:
	# Return val
	lw $t0, -8($fp)	# load val from $fp-8 into $t0
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
	# VTable for class Queue
	.data
	.align 2
	Queue:		# label for class Queue vtable
	.word __Queue.DeQueue
	.word __Queue.EnQueue
	.word __Queue.Init
	.text
main:
	# BeginFunc 196
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 196	# decrement sp to make space for locals/temps
	# _tmp69 = 8
	li $t0, 8		# load constant value 8 into $t0
	# PushParam _tmp69
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp70 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp69 from $t0 to $fp-16
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp71 = Queue
	la $t1, Queue	# load label
	# *(_tmp70) = _tmp71
	sw $t1, 0($t0) 	# store with offset
	# q = _tmp70
	move $t2, $t0		# copy value
	# _tmp72 = *(q)
	lw $t3, 0($t2) 	# load with offset
	# _tmp73 = *(_tmp72 + 8)
	lw $t4, 8($t3) 	# load with offset
	# PushParam q
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp73
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp70 from $t0 to $fp-20
	sw $t1, -24($fp)	# spill _tmp71 from $t1 to $fp-24
	sw $t2, -8($fp)	# spill q from $t2 to $fp-8
	sw $t3, -28($fp)	# spill _tmp72 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp73 from $t4 to $fp-32
	jalr $t4            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp74 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp74
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp74 from $t0 to $fp-36
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
_L2:
	# _tmp75 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp76 = i < _tmp75
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# _tmp77 = _tmp75 < i
	slt $t3, $t0, $t1	
	# _tmp78 = _tmp76 || _tmp77
	or $t4, $t2, $t3	
	# IfZ _tmp78 Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp75 from $t0 to $fp-40
	sw $t2, -44($fp)	# spill _tmp76 from $t2 to $fp-44
	sw $t3, -48($fp)	# spill _tmp77 from $t3 to $fp-48
	sw $t4, -52($fp)	# spill _tmp78 from $t4 to $fp-52
	beqz $t4, _L3	# branch if _tmp78 is zero 
	# _tmp79 = *(q)
	lw $t0, -8($fp)	# load q from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp80 = *(_tmp79 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, -12($fp)	# load i from $fp-12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam q
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp80
	# (save modified registers before flow of control change)
	sw $t1, -56($fp)	# spill _tmp79 from $t1 to $fp-56
	sw $t2, -60($fp)	# spill _tmp80 from $t2 to $fp-60
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp81 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp82 = i + _tmp81
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	add $t2, $t1, $t0	
	# i = _tmp82
	move $t1, $t2		# copy value
	# Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp81 from $t0 to $fp-68
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
	sw $t2, -64($fp)	# spill _tmp82 from $t2 to $fp-64
	b _L2		# unconditional branch
_L3:
	# _tmp83 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp83
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp83 from $t0 to $fp-72
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
_L4:
	# _tmp84 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp85 = i < _tmp84
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# _tmp86 = _tmp84 < i
	slt $t3, $t0, $t1	
	# _tmp87 = _tmp85 || _tmp86
	or $t4, $t2, $t3	
	# IfZ _tmp87 Goto _L5
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp84 from $t0 to $fp-76
	sw $t2, -80($fp)	# spill _tmp85 from $t2 to $fp-80
	sw $t3, -84($fp)	# spill _tmp86 from $t3 to $fp-84
	sw $t4, -88($fp)	# spill _tmp87 from $t4 to $fp-88
	beqz $t4, _L5	# branch if _tmp87 is zero 
	# _tmp88 = *(q)
	lw $t0, -8($fp)	# load q from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp89 = *(_tmp88)
	lw $t2, 0($t1) 	# load with offset
	# PushParam q
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp90 = ACall _tmp89
	# (save modified registers before flow of control change)
	sw $t1, -92($fp)	# spill _tmp88 from $t1 to $fp-92
	sw $t2, -96($fp)	# spill _tmp89 from $t2 to $fp-96
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp90
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp90 from $t0 to $fp-100
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp91 = " "
	.data			# create string constant marked with label
	_string2: .asciiz " "
	.text
	la $t0, _string2	# load label
	# PushParam _tmp91
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -104($fp)	# spill _tmp91 from $t0 to $fp-104
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp92 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp93 = i + _tmp92
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	add $t2, $t1, $t0	
	# i = _tmp93
	move $t1, $t2		# copy value
	# Goto _L4
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp92 from $t0 to $fp-112
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
	sw $t2, -108($fp)	# spill _tmp93 from $t2 to $fp-108
	b _L4		# unconditional branch
_L5:
	# _tmp94 = "\n"
	.data			# create string constant marked with label
	_string3: .asciiz "\n"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp94
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp94 from $t0 to $fp-116
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp95 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp95
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -120($fp)	# spill _tmp95 from $t0 to $fp-120
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
_L6:
	# _tmp96 = 10
	li $t0, 10		# load constant value 10 into $t0
	# _tmp97 = i < _tmp96
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# _tmp98 = _tmp96 < i
	slt $t3, $t0, $t1	
	# _tmp99 = _tmp97 || _tmp98
	or $t4, $t2, $t3	
	# IfZ _tmp99 Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp96 from $t0 to $fp-124
	sw $t2, -128($fp)	# spill _tmp97 from $t2 to $fp-128
	sw $t3, -132($fp)	# spill _tmp98 from $t3 to $fp-132
	sw $t4, -136($fp)	# spill _tmp99 from $t4 to $fp-136
	beqz $t4, _L7	# branch if _tmp99 is zero 
	# _tmp100 = *(q)
	lw $t0, -8($fp)	# load q from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp101 = *(_tmp100 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam i
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, -12($fp)	# load i from $fp-12 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# PushParam q
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp101
	# (save modified registers before flow of control change)
	sw $t1, -140($fp)	# spill _tmp100 from $t1 to $fp-140
	sw $t2, -144($fp)	# spill _tmp101 from $t2 to $fp-144
	jalr $t2            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp102 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp103 = i + _tmp102
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	add $t2, $t1, $t0	
	# i = _tmp103
	move $t1, $t2		# copy value
	# Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp102 from $t0 to $fp-152
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
	sw $t2, -148($fp)	# spill _tmp103 from $t2 to $fp-148
	b _L6		# unconditional branch
_L7:
	# _tmp104 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp104
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -156($fp)	# spill _tmp104 from $t0 to $fp-156
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
_L8:
	# _tmp105 = 17
	li $t0, 17		# load constant value 17 into $t0
	# _tmp106 = i < _tmp105
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	slt $t2, $t1, $t0	
	# _tmp107 = _tmp105 < i
	slt $t3, $t0, $t1	
	# _tmp108 = _tmp106 || _tmp107
	or $t4, $t2, $t3	
	# IfZ _tmp108 Goto _L9
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp105 from $t0 to $fp-160
	sw $t2, -164($fp)	# spill _tmp106 from $t2 to $fp-164
	sw $t3, -168($fp)	# spill _tmp107 from $t3 to $fp-168
	sw $t4, -172($fp)	# spill _tmp108 from $t4 to $fp-172
	beqz $t4, _L9	# branch if _tmp108 is zero 
	# _tmp109 = *(q)
	lw $t0, -8($fp)	# load q from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp110 = *(_tmp109)
	lw $t2, 0($t1) 	# load with offset
	# PushParam q
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp111 = ACall _tmp110
	# (save modified registers before flow of control change)
	sw $t1, -176($fp)	# spill _tmp109 from $t1 to $fp-176
	sw $t2, -180($fp)	# spill _tmp110 from $t2 to $fp-180
	jalr $t2            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp111
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -184($fp)	# spill _tmp111 from $t0 to $fp-184
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp112 = " "
	.data			# create string constant marked with label
	_string4: .asciiz " "
	.text
	la $t0, _string4	# load label
	# PushParam _tmp112
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -188($fp)	# spill _tmp112 from $t0 to $fp-188
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp113 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp114 = i + _tmp113
	lw $t1, -12($fp)	# load i from $fp-12 into $t1
	add $t2, $t1, $t0	
	# i = _tmp114
	move $t1, $t2		# copy value
	# Goto _L8
	# (save modified registers before flow of control change)
	sw $t0, -196($fp)	# spill _tmp113 from $t0 to $fp-196
	sw $t1, -12($fp)	# spill i from $t1 to $fp-12
	sw $t2, -192($fp)	# spill _tmp114 from $t2 to $fp-192
	b _L8		# unconditional branch
_L9:
	# _tmp115 = "\n"
	.data			# create string constant marked with label
	_string5: .asciiz "\n"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp115
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -200($fp)	# spill _tmp115 from $t0 to $fp-200
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
