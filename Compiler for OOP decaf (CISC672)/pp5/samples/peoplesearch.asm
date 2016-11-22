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
	
__PrintLine:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp0 = "-------------------------------------------------..."
	.data			# create string constant marked with label
	_string1: .asciiz "------------------------------------------------------------------------\n"
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
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Person.InitPerson:
	# BeginFunc 32
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 32	# decrement sp to make space for locals/temps
	# _tmp1 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp2 = this + _tmp1
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp2) = f
	lw $t3, 8($fp)	# load f from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# _tmp3 = 12
	li $t4, 12		# load constant value 12 into $t4
	# _tmp4 = this + _tmp3
	add $t5, $t1, $t4	
	# *(_tmp4) = l
	lw $t6, 12($fp)	# load l from $fp+12 into $t6
	sw $t6, 0($t5) 	# store with offset
	# _tmp5 = 16
	li $t7, 16		# load constant value 16 into $t7
	# _tmp6 = this + _tmp5
	add $s0, $t1, $t7	
	# *(_tmp6) = p
	lw $s1, 16($fp)	# load p from $fp+16 into $s1
	sw $s1, 0($s0) 	# store with offset
	# _tmp7 = 4
	li $s2, 4		# load constant value 4 into $s2
	# _tmp8 = this + _tmp7
	add $s3, $t1, $s2	
	# *(_tmp8) = a
	lw $s4, 20($fp)	# load a from $fp+20 into $s4
	sw $s4, 0($s3) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Person.SetFirstName:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp9 = 8
	li $t0, 8		# load constant value 8 into $t0
	# _tmp10 = this + _tmp9
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp10) = f
	lw $t3, 8($fp)	# load f from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Person.GetFirstName:
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
__Person.SetLastName:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp12 = 12
	li $t0, 12		# load constant value 12 into $t0
	# _tmp13 = this + _tmp12
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp13) = l
	lw $t3, 8($fp)	# load l from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Person.GetLastName:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp14 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# Return _tmp14
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
__Person.SetPhoneNumber:
	# BeginFunc 8
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp15 = 16
	li $t0, 16		# load constant value 16 into $t0
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
__Person.GetPhoneNumber:
	# BeginFunc 4
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp17 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# Return _tmp17
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
__Person.SetAddress:
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
	# *(_tmp19) = a
	lw $t3, 8($fp)	# load a from $fp+8 into $t3
	sw $t3, 0($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Person.GetAddress:
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
__Person.IsNamed:
	# BeginFunc 20
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 20	# decrement sp to make space for locals/temps
	# _tmp21 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# PushParam _tmp21
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam name
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t2, 8($fp)	# load name from $fp+8 into $t2
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp22 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t1, -16($fp)	# spill _tmp21 from $t1 to $fp-16
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp23 = *(this + 8)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 8($t1) 	# load with offset
	# PushParam _tmp23
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam name
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t3, 8($fp)	# load name from $fp+8 into $t3
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp24 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp22 from $t0 to $fp-12
	sw $t2, -24($fp)	# spill _tmp23 from $t2 to $fp-24
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp25 = _tmp24 || _tmp22
	lw $t1, -12($fp)	# load _tmp22 from $fp-12 into $t1
	or $t2, $t0, $t1	
	# Return _tmp25
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
__Person.PrintInfo:
	# BeginFunc 48
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp26 = "First Name: "
	.data			# create string constant marked with label
	_string2: .asciiz "First Name: "
	.text
	la $t0, _string2	# load label
	# PushParam _tmp26
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp26 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp27 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# PushParam _tmp27
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -12($fp)	# spill _tmp27 from $t1 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp28 = "\n"
	.data			# create string constant marked with label
	_string3: .asciiz "\n"
	.text
	la $t0, _string3	# load label
	# PushParam _tmp28
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp28 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp29 = "Last Name: "
	.data			# create string constant marked with label
	_string4: .asciiz "Last Name: "
	.text
	la $t0, _string4	# load label
	# PushParam _tmp29
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp29 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp30 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# PushParam _tmp30
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -24($fp)	# spill _tmp30 from $t1 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp31 = "\n"
	.data			# create string constant marked with label
	_string5: .asciiz "\n"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp31
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp31 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp32 = "Phone Number: "
	.data			# create string constant marked with label
	_string6: .asciiz "Phone Number: "
	.text
	la $t0, _string6	# load label
	# PushParam _tmp32
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp32 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp33 = *(this + 16)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 16($t0) 	# load with offset
	# PushParam _tmp33
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -36($fp)	# spill _tmp33 from $t1 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp34 = "\n"
	.data			# create string constant marked with label
	_string7: .asciiz "\n"
	.text
	la $t0, _string7	# load label
	# PushParam _tmp34
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp34 from $t0 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp35 = "Address: "
	.data			# create string constant marked with label
	_string8: .asciiz "Address: "
	.text
	la $t0, _string8	# load label
	# PushParam _tmp35
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp35 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp36 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# PushParam _tmp36
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t1, -48($fp)	# spill _tmp36 from $t1 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp37 = "\n"
	.data			# create string constant marked with label
	_string9: .asciiz "\n"
	.text
	la $t0, _string9	# load label
	# PushParam _tmp37
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp37 from $t0 to $fp-52
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Person
	.data
	.align 2
	Person:		# label for class Person vtable
	.word __Person.GetAddress
	.word __Person.GetFirstName
	.word __Person.GetLastName
	.word __Person.GetPhoneNumber
	.word __Person.InitPerson
	.word __Person.IsNamed
	.word __Person.PrintInfo
	.word __Person.SetAddress
	.word __Person.SetFirstName
	.word __Person.SetLastName
	.word __Person.SetPhoneNumber
	.text
__Database.InitDatabase:
	# BeginFunc 64
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 64	# decrement sp to make space for locals/temps
	# _tmp38 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp39 = 4
	li $t1, 4		# load constant value 4 into $t1
	# _tmp40 = this + _tmp39
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	add $t3, $t2, $t1	
	# *(_tmp40) = _tmp38
	sw $t0, 0($t3) 	# store with offset
	# _tmp41 = 8
	li $t4, 8		# load constant value 8 into $t4
	# _tmp42 = this + _tmp41
	add $t5, $t2, $t4	
	# *(_tmp42) = size
	lw $t6, 8($fp)	# load size from $fp+8 into $t6
	sw $t6, 0($t5) 	# store with offset
	# _tmp43 = 0
	li $t7, 0		# load constant value 0 into $t7
	# _tmp44 = size < _tmp43
	slt $s0, $t6, $t7	
	# _tmp45 = size == _tmp43
	seq $s1, $t6, $t7	
	# _tmp46 = _tmp44 || _tmp45
	or $s2, $s0, $s1	
	# IfZ _tmp46 Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp38 from $t0 to $fp-8
	sw $t1, -12($fp)	# spill _tmp39 from $t1 to $fp-12
	sw $t3, -16($fp)	# spill _tmp40 from $t3 to $fp-16
	sw $t4, -20($fp)	# spill _tmp41 from $t4 to $fp-20
	sw $t5, -24($fp)	# spill _tmp42 from $t5 to $fp-24
	sw $t7, -28($fp)	# spill _tmp43 from $t7 to $fp-28
	sw $s0, -32($fp)	# spill _tmp44 from $s0 to $fp-32
	sw $s1, -36($fp)	# spill _tmp45 from $s1 to $fp-36
	sw $s2, -40($fp)	# spill _tmp46 from $s2 to $fp-40
	beqz $s2, _L0	# branch if _tmp46 is zero 
	# _tmp47 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string10: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string10	# load label
	# PushParam _tmp47
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp47 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L0:
	# _tmp48 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp49 = size * _tmp48
	lw $t1, 8($fp)	# load size from $fp+8 into $t1
	mul $t2, $t1, $t0	
	# _tmp50 = _tmp49 + _tmp48
	add $t3, $t2, $t0	
	# PushParam _tmp50
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp51 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp48 from $t0 to $fp-48
	sw $t2, -52($fp)	# spill _tmp49 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp50 from $t3 to $fp-56
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp51) = size
	lw $t1, 8($fp)	# load size from $fp+8 into $t1
	sw $t1, 0($t0) 	# store with offset
	# _tmp52 = 12
	li $t2, 12		# load constant value 12 into $t2
	# _tmp53 = this + _tmp52
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	add $t4, $t3, $t2	
	# *(_tmp53) = _tmp51
	sw $t0, 0($t4) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Database.Search:
	# BeginFunc 192
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 192	# decrement sp to make space for locals/temps
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# _tmp54 = "Enter the name of the person you would like to fi..."
	.data			# create string constant marked with label
	_string11: .asciiz "Enter the name of the person you would like to find: "
	.text
	la $t0, _string11	# load label
	# PushParam _tmp54
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp54 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp55 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# name = _tmp55
	move $t1, $t0		# copy value
	# _tmp56 = 0
	li $t2, 0		# load constant value 0 into $t2
	# found = _tmp56
	move $t3, $t2		# copy value
	# _tmp57 = 0
	li $t4, 0		# load constant value 0 into $t4
	# i = _tmp57
	move $t5, $t4		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp55 from $t0 to $fp-24
	sw $t1, -12($fp)	# spill name from $t1 to $fp-12
	sw $t2, -28($fp)	# spill _tmp56 from $t2 to $fp-28
	sw $t3, -16($fp)	# spill found from $t3 to $fp-16
	sw $t4, -32($fp)	# spill _tmp57 from $t4 to $fp-32
	sw $t5, -8($fp)	# spill i from $t5 to $fp-8
_L1:
	# _tmp58 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp59 = i < _tmp58
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp59 Goto _L2
	# (save modified registers before flow of control change)
	sw $t1, -36($fp)	# spill _tmp58 from $t1 to $fp-36
	sw $t3, -40($fp)	# spill _tmp59 from $t3 to $fp-40
	beqz $t3, _L2	# branch if _tmp59 is zero 
	# _tmp60 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp61 = *(_tmp60)
	lw $t2, 0($t1) 	# load with offset
	# _tmp62 = i < _tmp61
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp63 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp64 = _tmp63 < i
	slt $t6, $t5, $t3	
	# _tmp65 = _tmp64 && _tmp62
	and $t7, $t6, $t4	
	# IfZ _tmp65 Goto _L5
	# (save modified registers before flow of control change)
	sw $t1, -44($fp)	# spill _tmp60 from $t1 to $fp-44
	sw $t2, -48($fp)	# spill _tmp61 from $t2 to $fp-48
	sw $t4, -52($fp)	# spill _tmp62 from $t4 to $fp-52
	sw $t5, -56($fp)	# spill _tmp63 from $t5 to $fp-56
	sw $t6, -60($fp)	# spill _tmp64 from $t6 to $fp-60
	sw $t7, -64($fp)	# spill _tmp65 from $t7 to $fp-64
	beqz $t7, _L5	# branch if _tmp65 is zero 
	# _tmp66 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp67 = i * _tmp66
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp68 = _tmp67 + _tmp66
	add $t3, $t2, $t0	
	# _tmp69 = _tmp60 + _tmp68
	lw $t4, -44($fp)	# load _tmp60 from $fp-44 into $t4
	add $t5, $t4, $t3	
	# Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp66 from $t0 to $fp-68
	sw $t2, -72($fp)	# spill _tmp67 from $t2 to $fp-72
	sw $t3, -76($fp)	# spill _tmp68 from $t3 to $fp-76
	sw $t5, -76($fp)	# spill _tmp69 from $t5 to $fp-76
	b _L6		# unconditional branch
_L5:
	# _tmp70 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string12: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string12	# load label
	# PushParam _tmp70
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp70 from $t0 to $fp-80
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L6:
	# _tmp71 = *(_tmp69)
	lw $t0, -76($fp)	# load _tmp69 from $fp-76 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp72 = *(_tmp71)
	lw $t2, 0($t1) 	# load with offset
	# _tmp73 = *(_tmp72 + 20)
	lw $t3, 20($t2) 	# load with offset
	# PushParam name
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load name from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp71
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp74 = ACall _tmp73
	# (save modified registers before flow of control change)
	sw $t1, -84($fp)	# spill _tmp71 from $t1 to $fp-84
	sw $t2, -88($fp)	# spill _tmp72 from $t2 to $fp-88
	sw $t3, -92($fp)	# spill _tmp73 from $t3 to $fp-92
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp74 Goto _L3
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp74 from $t0 to $fp-96
	beqz $t0, _L3	# branch if _tmp74 is zero 
	# _tmp75 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp76 = _tmp75 - found
	lw $t1, -16($fp)	# load found from $fp-16 into $t1
	sub $t2, $t0, $t1	
	# IfZ _tmp76 Goto _L7
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp75 from $t0 to $fp-100
	sw $t2, -104($fp)	# spill _tmp76 from $t2 to $fp-104
	beqz $t2, _L7	# branch if _tmp76 is zero 
	# _tmp77 = 1
	li $t0, 1		# load constant value 1 into $t0
	# found = _tmp77
	move $t1, $t0		# copy value
	# _tmp78 = "\nListing people with name '"
	.data			# create string constant marked with label
	_string13: .asciiz "\nListing people with name '"
	.text
	la $t2, _string13	# load label
	# PushParam _tmp78
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp77 from $t0 to $fp-108
	sw $t1, -16($fp)	# spill found from $t1 to $fp-16
	sw $t2, -112($fp)	# spill _tmp78 from $t2 to $fp-112
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam name
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load name from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp79 = "'...\n"
	.data			# create string constant marked with label
	_string14: .asciiz "'...\n"
	.text
	la $t0, _string14	# load label
	# PushParam _tmp79
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp79 from $t0 to $fp-116
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# Goto _L8
	b _L8		# unconditional branch
_L7:
_L8:
	# _tmp80 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp81 = *(_tmp80)
	lw $t2, 0($t1) 	# load with offset
	# _tmp82 = i < _tmp81
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp83 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp84 = _tmp83 < i
	slt $t6, $t5, $t3	
	# _tmp85 = _tmp84 && _tmp82
	and $t7, $t6, $t4	
	# IfZ _tmp85 Goto _L9
	# (save modified registers before flow of control change)
	sw $t1, -120($fp)	# spill _tmp80 from $t1 to $fp-120
	sw $t2, -124($fp)	# spill _tmp81 from $t2 to $fp-124
	sw $t4, -128($fp)	# spill _tmp82 from $t4 to $fp-128
	sw $t5, -132($fp)	# spill _tmp83 from $t5 to $fp-132
	sw $t6, -136($fp)	# spill _tmp84 from $t6 to $fp-136
	sw $t7, -140($fp)	# spill _tmp85 from $t7 to $fp-140
	beqz $t7, _L9	# branch if _tmp85 is zero 
	# _tmp86 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp87 = i * _tmp86
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp88 = _tmp87 + _tmp86
	add $t3, $t2, $t0	
	# _tmp89 = _tmp80 + _tmp88
	lw $t4, -120($fp)	# load _tmp80 from $fp-120 into $t4
	add $t5, $t4, $t3	
	# Goto _L10
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp86 from $t0 to $fp-144
	sw $t2, -148($fp)	# spill _tmp87 from $t2 to $fp-148
	sw $t3, -152($fp)	# spill _tmp88 from $t3 to $fp-152
	sw $t5, -152($fp)	# spill _tmp89 from $t5 to $fp-152
	b _L10		# unconditional branch
_L9:
	# _tmp90 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string15: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string15	# load label
	# PushParam _tmp90
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -156($fp)	# spill _tmp90 from $t0 to $fp-156
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L10:
	# _tmp91 = *(_tmp89)
	lw $t0, -152($fp)	# load _tmp89 from $fp-152 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp92 = *(_tmp91)
	lw $t2, 0($t1) 	# load with offset
	# _tmp93 = *(_tmp92 + 24)
	lw $t3, 24($t2) 	# load with offset
	# PushParam _tmp91
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp93
	# (save modified registers before flow of control change)
	sw $t1, -160($fp)	# spill _tmp91 from $t1 to $fp-160
	sw $t2, -164($fp)	# spill _tmp92 from $t2 to $fp-164
	sw $t3, -168($fp)	# spill _tmp93 from $t3 to $fp-168
	jalr $t3            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp94 = "\n"
	.data			# create string constant marked with label
	_string16: .asciiz "\n"
	.text
	la $t0, _string16	# load label
	# PushParam _tmp94
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp94 from $t0 to $fp-172
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L4
	b _L4		# unconditional branch
_L3:
_L4:
	# _tmp95 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp96 = i + _tmp95
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp96
	move $t1, $t2		# copy value
	# Goto _L1
	# (save modified registers before flow of control change)
	sw $t0, -180($fp)	# spill _tmp95 from $t0 to $fp-180
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -176($fp)	# spill _tmp96 from $t2 to $fp-176
	b _L1		# unconditional branch
_L2:
	# _tmp97 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp98 = _tmp97 - found
	lw $t1, -16($fp)	# load found from $fp-16 into $t1
	sub $t2, $t0, $t1	
	# IfZ _tmp98 Goto _L11
	# (save modified registers before flow of control change)
	sw $t0, -184($fp)	# spill _tmp97 from $t0 to $fp-184
	sw $t2, -188($fp)	# spill _tmp98 from $t2 to $fp-188
	beqz $t2, _L11	# branch if _tmp98 is zero 
	# _tmp99 = "\n"
	.data			# create string constant marked with label
	_string17: .asciiz "\n"
	.text
	la $t0, _string17	# load label
	# PushParam _tmp99
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -192($fp)	# spill _tmp99 from $t0 to $fp-192
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam name
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load name from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp100 = " not found!\n"
	.data			# create string constant marked with label
	_string18: .asciiz " not found!\n"
	.text
	la $t0, _string18	# load label
	# PushParam _tmp100
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -196($fp)	# spill _tmp100 from $t0 to $fp-196
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L12
	b _L12		# unconditional branch
_L11:
_L12:
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Database.PersonExists:
	# BeginFunc 160
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 160	# decrement sp to make space for locals/temps
	# _tmp101 = 0
	li $t0, 0		# load constant value 0 into $t0
	# i = _tmp101
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp101 from $t0 to $fp-12
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
_L13:
	# _tmp102 = *(this + 4)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 4($t0) 	# load with offset
	# _tmp103 = i < _tmp102
	lw $t2, -8($fp)	# load i from $fp-8 into $t2
	slt $t3, $t2, $t1	
	# IfZ _tmp103 Goto _L14
	# (save modified registers before flow of control change)
	sw $t1, -16($fp)	# spill _tmp102 from $t1 to $fp-16
	sw $t3, -20($fp)	# spill _tmp103 from $t3 to $fp-20
	beqz $t3, _L14	# branch if _tmp103 is zero 
	# _tmp104 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp105 = *(_tmp104)
	lw $t2, 0($t1) 	# load with offset
	# _tmp106 = i < _tmp105
	lw $t3, -8($fp)	# load i from $fp-8 into $t3
	slt $t4, $t3, $t2	
	# _tmp107 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp108 = _tmp107 < i
	slt $t6, $t5, $t3	
	# _tmp109 = _tmp108 && _tmp106
	and $t7, $t6, $t4	
	# IfZ _tmp109 Goto _L17
	# (save modified registers before flow of control change)
	sw $t1, -32($fp)	# spill _tmp104 from $t1 to $fp-32
	sw $t2, -36($fp)	# spill _tmp105 from $t2 to $fp-36
	sw $t4, -40($fp)	# spill _tmp106 from $t4 to $fp-40
	sw $t5, -44($fp)	# spill _tmp107 from $t5 to $fp-44
	sw $t6, -48($fp)	# spill _tmp108 from $t6 to $fp-48
	sw $t7, -52($fp)	# spill _tmp109 from $t7 to $fp-52
	beqz $t7, _L17	# branch if _tmp109 is zero 
	# _tmp110 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp111 = i * _tmp110
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp112 = _tmp111 + _tmp110
	add $t3, $t2, $t0	
	# _tmp113 = _tmp104 + _tmp112
	lw $t4, -32($fp)	# load _tmp104 from $fp-32 into $t4
	add $t5, $t4, $t3	
	# Goto _L18
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp110 from $t0 to $fp-56
	sw $t2, -60($fp)	# spill _tmp111 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp112 from $t3 to $fp-64
	sw $t5, -64($fp)	# spill _tmp113 from $t5 to $fp-64
	b _L18		# unconditional branch
_L17:
	# _tmp114 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string19: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string19	# load label
	# PushParam _tmp114
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp114 from $t0 to $fp-68
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L18:
	# _tmp115 = *(_tmp113)
	lw $t0, -64($fp)	# load _tmp113 from $fp-64 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp116 = *(_tmp115)
	lw $t2, 0($t1) 	# load with offset
	# _tmp117 = *(_tmp116 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp115
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp118 = ACall _tmp117
	# (save modified registers before flow of control change)
	sw $t1, -72($fp)	# spill _tmp115 from $t1 to $fp-72
	sw $t2, -76($fp)	# spill _tmp116 from $t2 to $fp-76
	sw $t3, -80($fp)	# spill _tmp117 from $t3 to $fp-80
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, 12($fp)	# load l from $fp+12 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam _tmp118
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp119 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp118 from $t0 to $fp-84
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp120 = *(this + 12)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 12($t1) 	# load with offset
	# _tmp121 = *(_tmp120)
	lw $t3, 0($t2) 	# load with offset
	# _tmp122 = i < _tmp121
	lw $t4, -8($fp)	# load i from $fp-8 into $t4
	slt $t5, $t4, $t3	
	# _tmp123 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp124 = _tmp123 < i
	slt $t7, $t6, $t4	
	# _tmp125 = _tmp124 && _tmp122
	and $s0, $t7, $t5	
	# IfZ _tmp125 Goto _L19
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp119 from $t0 to $fp-28
	sw $t2, -92($fp)	# spill _tmp120 from $t2 to $fp-92
	sw $t3, -96($fp)	# spill _tmp121 from $t3 to $fp-96
	sw $t5, -100($fp)	# spill _tmp122 from $t5 to $fp-100
	sw $t6, -104($fp)	# spill _tmp123 from $t6 to $fp-104
	sw $t7, -108($fp)	# spill _tmp124 from $t7 to $fp-108
	sw $s0, -112($fp)	# spill _tmp125 from $s0 to $fp-112
	beqz $s0, _L19	# branch if _tmp125 is zero 
	# _tmp126 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp127 = i * _tmp126
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	mul $t2, $t1, $t0	
	# _tmp128 = _tmp127 + _tmp126
	add $t3, $t2, $t0	
	# _tmp129 = _tmp120 + _tmp128
	lw $t4, -92($fp)	# load _tmp120 from $fp-92 into $t4
	add $t5, $t4, $t3	
	# Goto _L20
	# (save modified registers before flow of control change)
	sw $t0, -116($fp)	# spill _tmp126 from $t0 to $fp-116
	sw $t2, -120($fp)	# spill _tmp127 from $t2 to $fp-120
	sw $t3, -124($fp)	# spill _tmp128 from $t3 to $fp-124
	sw $t5, -124($fp)	# spill _tmp129 from $t5 to $fp-124
	b _L20		# unconditional branch
_L19:
	# _tmp130 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string20: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string20	# load label
	# PushParam _tmp130
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp130 from $t0 to $fp-128
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L20:
	# _tmp131 = *(_tmp129)
	lw $t0, -124($fp)	# load _tmp129 from $fp-124 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp132 = *(_tmp131)
	lw $t2, 0($t1) 	# load with offset
	# _tmp133 = *(_tmp132 + 4)
	lw $t3, 4($t2) 	# load with offset
	# PushParam _tmp131
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp134 = ACall _tmp133
	# (save modified registers before flow of control change)
	sw $t1, -132($fp)	# spill _tmp131 from $t1 to $fp-132
	sw $t2, -136($fp)	# spill _tmp132 from $t2 to $fp-136
	sw $t3, -140($fp)	# spill _tmp133 from $t3 to $fp-140
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, 8($fp)	# load f from $fp+8 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam _tmp134
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp135 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -144($fp)	# spill _tmp134 from $t0 to $fp-144
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp136 = _tmp135 && _tmp119
	lw $t1, -28($fp)	# load _tmp119 from $fp-28 into $t1
	and $t2, $t0, $t1	
	# IfZ _tmp136 Goto _L15
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp135 from $t0 to $fp-88
	sw $t2, -24($fp)	# spill _tmp136 from $t2 to $fp-24
	beqz $t2, _L15	# branch if _tmp136 is zero 
	# Return i
	lw $t0, -8($fp)	# load i from $fp-8 into $t0
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L16
	b _L16		# unconditional branch
_L15:
_L16:
	# _tmp137 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp138 = i + _tmp137
	lw $t1, -8($fp)	# load i from $fp-8 into $t1
	add $t2, $t1, $t0	
	# i = _tmp138
	move $t1, $t2		# copy value
	# Goto _L13
	# (save modified registers before flow of control change)
	sw $t0, -152($fp)	# spill _tmp137 from $t0 to $fp-152
	sw $t1, -8($fp)	# spill i from $t1 to $fp-8
	sw $t2, -148($fp)	# spill _tmp138 from $t2 to $fp-148
	b _L13		# unconditional branch
_L14:
	# _tmp139 = 0
	li $t0, 0		# load constant value 0 into $t0
	# _tmp140 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp141 = _tmp139 - _tmp140
	sub $t2, $t0, $t1	
	# Return _tmp141
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
__Database.Edit:
	# BeginFunc 624
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 624	# decrement sp to make space for locals/temps
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# _tmp142 = "Editting person...\n\n"
	.data			# create string constant marked with label
	_string21: .asciiz "Editting person...\n\n"
	.text
	la $t0, _string21	# load label
	# PushParam _tmp142
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp142 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp143 = "Enter first name: "
	.data			# create string constant marked with label
	_string22: .asciiz "Enter first name: "
	.text
	la $t0, _string22	# load label
	# PushParam _tmp143
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp143 from $t0 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp144 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# f = _tmp144
	move $t1, $t0		# copy value
	# _tmp145 = "Enter last name: "
	.data			# create string constant marked with label
	_string23: .asciiz "Enter last name: "
	.text
	la $t2, _string23	# load label
	# PushParam _tmp145
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp144 from $t0 to $fp-36
	sw $t1, -8($fp)	# spill f from $t1 to $fp-8
	sw $t2, -40($fp)	# spill _tmp145 from $t2 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp146 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# l = _tmp146
	move $t1, $t0		# copy value
	# _tmp147 = *(this)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp148 = *(_tmp147 + 16)
	lw $t4, 16($t3) 	# load with offset
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load f from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp149 = ACall _tmp148
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp146 from $t0 to $fp-44
	sw $t1, -12($fp)	# spill l from $t1 to $fp-12
	sw $t3, -48($fp)	# spill _tmp147 from $t3 to $fp-48
	sw $t4, -52($fp)	# spill _tmp148 from $t4 to $fp-52
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# index = _tmp149
	move $t1, $t0		# copy value
	# _tmp150 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp151 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp152 = _tmp150 - _tmp151
	sub $t4, $t2, $t3	
	# _tmp153 = index == _tmp152
	seq $t5, $t1, $t4	
	# IfZ _tmp153 Goto _L21
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp149 from $t0 to $fp-56
	sw $t1, -24($fp)	# spill index from $t1 to $fp-24
	sw $t2, -60($fp)	# spill _tmp150 from $t2 to $fp-60
	sw $t3, -68($fp)	# spill _tmp151 from $t3 to $fp-68
	sw $t4, -64($fp)	# spill _tmp152 from $t4 to $fp-64
	sw $t5, -72($fp)	# spill _tmp153 from $t5 to $fp-72
	beqz $t5, _L21	# branch if _tmp153 is zero 
	# _tmp154 = "\n"
	.data			# create string constant marked with label
	_string24: .asciiz "\n"
	.text
	la $t0, _string24	# load label
	# PushParam _tmp154
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp154 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load l from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp155 = ", "
	.data			# create string constant marked with label
	_string25: .asciiz ", "
	.text
	la $t0, _string25	# load label
	# PushParam _tmp155
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp155 from $t0 to $fp-80
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load f from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp156 = " not found!\n"
	.data			# create string constant marked with label
	_string26: .asciiz " not found!\n"
	.text
	la $t0, _string26	# load label
	# PushParam _tmp156
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp156 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L22
	b _L22		# unconditional branch
_L21:
_L22:
	# _tmp157 = "\n"
	.data			# create string constant marked with label
	_string27: .asciiz "\n"
	.text
	la $t0, _string27	# load label
	# PushParam _tmp157
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp157 from $t0 to $fp-88
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load l from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp158 = ", "
	.data			# create string constant marked with label
	_string28: .asciiz ", "
	.text
	la $t0, _string28	# load label
	# PushParam _tmp158
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp158 from $t0 to $fp-92
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load f from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp159 = " found...\n\n"
	.data			# create string constant marked with label
	_string29: .asciiz " found...\n\n"
	.text
	la $t0, _string29	# load label
	# PushParam _tmp159
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp159 from $t0 to $fp-96
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp160 = "Old first name: "
	.data			# create string constant marked with label
	_string30: .asciiz "Old first name: "
	.text
	la $t0, _string30	# load label
	# PushParam _tmp160
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -100($fp)	# spill _tmp160 from $t0 to $fp-100
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp161 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp162 = *(_tmp161)
	lw $t2, 0($t1) 	# load with offset
	# _tmp163 = index < _tmp162
	lw $t3, -24($fp)	# load index from $fp-24 into $t3
	slt $t4, $t3, $t2	
	# _tmp164 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp165 = _tmp164 < index
	slt $t6, $t5, $t3	
	# _tmp166 = _tmp165 && _tmp163
	and $t7, $t6, $t4	
	# IfZ _tmp166 Goto _L23
	# (save modified registers before flow of control change)
	sw $t1, -104($fp)	# spill _tmp161 from $t1 to $fp-104
	sw $t2, -108($fp)	# spill _tmp162 from $t2 to $fp-108
	sw $t4, -112($fp)	# spill _tmp163 from $t4 to $fp-112
	sw $t5, -116($fp)	# spill _tmp164 from $t5 to $fp-116
	sw $t6, -120($fp)	# spill _tmp165 from $t6 to $fp-120
	sw $t7, -124($fp)	# spill _tmp166 from $t7 to $fp-124
	beqz $t7, _L23	# branch if _tmp166 is zero 
	# _tmp167 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp168 = index * _tmp167
	lw $t1, -24($fp)	# load index from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp169 = _tmp168 + _tmp167
	add $t3, $t2, $t0	
	# _tmp170 = _tmp161 + _tmp169
	lw $t4, -104($fp)	# load _tmp161 from $fp-104 into $t4
	add $t5, $t4, $t3	
	# Goto _L24
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp167 from $t0 to $fp-128
	sw $t2, -132($fp)	# spill _tmp168 from $t2 to $fp-132
	sw $t3, -136($fp)	# spill _tmp169 from $t3 to $fp-136
	sw $t5, -136($fp)	# spill _tmp170 from $t5 to $fp-136
	b _L24		# unconditional branch
_L23:
	# _tmp171 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string31: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string31	# load label
	# PushParam _tmp171
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -140($fp)	# spill _tmp171 from $t0 to $fp-140
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L24:
	# _tmp172 = *(_tmp170)
	lw $t0, -136($fp)	# load _tmp170 from $fp-136 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp173 = *(_tmp172)
	lw $t2, 0($t1) 	# load with offset
	# _tmp174 = *(_tmp173 + 4)
	lw $t3, 4($t2) 	# load with offset
	# PushParam _tmp172
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp175 = ACall _tmp174
	# (save modified registers before flow of control change)
	sw $t1, -144($fp)	# spill _tmp172 from $t1 to $fp-144
	sw $t2, -148($fp)	# spill _tmp173 from $t2 to $fp-148
	sw $t3, -152($fp)	# spill _tmp174 from $t3 to $fp-152
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp175
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -156($fp)	# spill _tmp175 from $t0 to $fp-156
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp176 = "\n"
	.data			# create string constant marked with label
	_string32: .asciiz "\n"
	.text
	la $t0, _string32	# load label
	# PushParam _tmp176
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -160($fp)	# spill _tmp176 from $t0 to $fp-160
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp177 = "Enter new first name (or nothing to leave unchang..."
	.data			# create string constant marked with label
	_string33: .asciiz "Enter new first name (or nothing to leave unchanged): "
	.text
	la $t0, _string33	# load label
	# PushParam _tmp177
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -164($fp)	# spill _tmp177 from $t0 to $fp-164
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp178 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# f = _tmp178
	move $t1, $t0		# copy value
	# _tmp179 = ""
	.data			# create string constant marked with label
	_string34: .asciiz ""
	.text
	la $t2, _string34	# load label
	# PushParam _tmp179
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp180 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp178 from $t0 to $fp-168
	sw $t1, -8($fp)	# spill f from $t1 to $fp-8
	sw $t2, -176($fp)	# spill _tmp179 from $t2 to $fp-176
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp180 Goto _L25
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp180 from $t0 to $fp-172
	beqz $t0, _L25	# branch if _tmp180 is zero 
	# _tmp181 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp182 = *(_tmp181)
	lw $t2, 0($t1) 	# load with offset
	# _tmp183 = index < _tmp182
	lw $t3, -24($fp)	# load index from $fp-24 into $t3
	slt $t4, $t3, $t2	
	# _tmp184 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp185 = _tmp184 < index
	slt $t6, $t5, $t3	
	# _tmp186 = _tmp185 && _tmp183
	and $t7, $t6, $t4	
	# IfZ _tmp186 Goto _L27
	# (save modified registers before flow of control change)
	sw $t1, -180($fp)	# spill _tmp181 from $t1 to $fp-180
	sw $t2, -184($fp)	# spill _tmp182 from $t2 to $fp-184
	sw $t4, -188($fp)	# spill _tmp183 from $t4 to $fp-188
	sw $t5, -192($fp)	# spill _tmp184 from $t5 to $fp-192
	sw $t6, -196($fp)	# spill _tmp185 from $t6 to $fp-196
	sw $t7, -200($fp)	# spill _tmp186 from $t7 to $fp-200
	beqz $t7, _L27	# branch if _tmp186 is zero 
	# _tmp187 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp188 = index * _tmp187
	lw $t1, -24($fp)	# load index from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp189 = _tmp188 + _tmp187
	add $t3, $t2, $t0	
	# _tmp190 = _tmp181 + _tmp189
	lw $t4, -180($fp)	# load _tmp181 from $fp-180 into $t4
	add $t5, $t4, $t3	
	# Goto _L28
	# (save modified registers before flow of control change)
	sw $t0, -204($fp)	# spill _tmp187 from $t0 to $fp-204
	sw $t2, -208($fp)	# spill _tmp188 from $t2 to $fp-208
	sw $t3, -212($fp)	# spill _tmp189 from $t3 to $fp-212
	sw $t5, -212($fp)	# spill _tmp190 from $t5 to $fp-212
	b _L28		# unconditional branch
_L27:
	# _tmp191 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string35: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string35	# load label
	# PushParam _tmp191
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -216($fp)	# spill _tmp191 from $t0 to $fp-216
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L28:
	# _tmp192 = *(_tmp190)
	lw $t0, -212($fp)	# load _tmp190 from $fp-212 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp193 = *(_tmp192)
	lw $t2, 0($t1) 	# load with offset
	# _tmp194 = *(_tmp193 + 32)
	lw $t3, 32($t2) 	# load with offset
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -8($fp)	# load f from $fp-8 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp192
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp194
	# (save modified registers before flow of control change)
	sw $t1, -220($fp)	# spill _tmp192 from $t1 to $fp-220
	sw $t2, -224($fp)	# spill _tmp193 from $t2 to $fp-224
	sw $t3, -228($fp)	# spill _tmp194 from $t3 to $fp-228
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L26
	b _L26		# unconditional branch
_L25:
_L26:
	# _tmp195 = "Old last name: "
	.data			# create string constant marked with label
	_string36: .asciiz "Old last name: "
	.text
	la $t0, _string36	# load label
	# PushParam _tmp195
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -232($fp)	# spill _tmp195 from $t0 to $fp-232
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp196 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp197 = *(_tmp196)
	lw $t2, 0($t1) 	# load with offset
	# _tmp198 = index < _tmp197
	lw $t3, -24($fp)	# load index from $fp-24 into $t3
	slt $t4, $t3, $t2	
	# _tmp199 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp200 = _tmp199 < index
	slt $t6, $t5, $t3	
	# _tmp201 = _tmp200 && _tmp198
	and $t7, $t6, $t4	
	# IfZ _tmp201 Goto _L29
	# (save modified registers before flow of control change)
	sw $t1, -236($fp)	# spill _tmp196 from $t1 to $fp-236
	sw $t2, -240($fp)	# spill _tmp197 from $t2 to $fp-240
	sw $t4, -244($fp)	# spill _tmp198 from $t4 to $fp-244
	sw $t5, -248($fp)	# spill _tmp199 from $t5 to $fp-248
	sw $t6, -252($fp)	# spill _tmp200 from $t6 to $fp-252
	sw $t7, -256($fp)	# spill _tmp201 from $t7 to $fp-256
	beqz $t7, _L29	# branch if _tmp201 is zero 
	# _tmp202 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp203 = index * _tmp202
	lw $t1, -24($fp)	# load index from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp204 = _tmp203 + _tmp202
	add $t3, $t2, $t0	
	# _tmp205 = _tmp196 + _tmp204
	lw $t4, -236($fp)	# load _tmp196 from $fp-236 into $t4
	add $t5, $t4, $t3	
	# Goto _L30
	# (save modified registers before flow of control change)
	sw $t0, -260($fp)	# spill _tmp202 from $t0 to $fp-260
	sw $t2, -264($fp)	# spill _tmp203 from $t2 to $fp-264
	sw $t3, -268($fp)	# spill _tmp204 from $t3 to $fp-268
	sw $t5, -268($fp)	# spill _tmp205 from $t5 to $fp-268
	b _L30		# unconditional branch
_L29:
	# _tmp206 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string37: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string37	# load label
	# PushParam _tmp206
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -272($fp)	# spill _tmp206 from $t0 to $fp-272
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L30:
	# _tmp207 = *(_tmp205)
	lw $t0, -268($fp)	# load _tmp205 from $fp-268 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp208 = *(_tmp207)
	lw $t2, 0($t1) 	# load with offset
	# _tmp209 = *(_tmp208 + 8)
	lw $t3, 8($t2) 	# load with offset
	# PushParam _tmp207
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp210 = ACall _tmp209
	# (save modified registers before flow of control change)
	sw $t1, -276($fp)	# spill _tmp207 from $t1 to $fp-276
	sw $t2, -280($fp)	# spill _tmp208 from $t2 to $fp-280
	sw $t3, -284($fp)	# spill _tmp209 from $t3 to $fp-284
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp210
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -288($fp)	# spill _tmp210 from $t0 to $fp-288
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp211 = "\n"
	.data			# create string constant marked with label
	_string38: .asciiz "\n"
	.text
	la $t0, _string38	# load label
	# PushParam _tmp211
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -292($fp)	# spill _tmp211 from $t0 to $fp-292
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp212 = "Enter new first name (or nothing to leave unchang..."
	.data			# create string constant marked with label
	_string39: .asciiz "Enter new first name (or nothing to leave unchanged): "
	.text
	la $t0, _string39	# load label
	# PushParam _tmp212
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -296($fp)	# spill _tmp212 from $t0 to $fp-296
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp213 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# l = _tmp213
	move $t1, $t0		# copy value
	# _tmp214 = ""
	.data			# create string constant marked with label
	_string40: .asciiz ""
	.text
	la $t2, _string40	# load label
	# PushParam _tmp214
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp215 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -300($fp)	# spill _tmp213 from $t0 to $fp-300
	sw $t1, -12($fp)	# spill l from $t1 to $fp-12
	sw $t2, -308($fp)	# spill _tmp214 from $t2 to $fp-308
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp215 Goto _L31
	# (save modified registers before flow of control change)
	sw $t0, -304($fp)	# spill _tmp215 from $t0 to $fp-304
	beqz $t0, _L31	# branch if _tmp215 is zero 
	# _tmp216 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp217 = *(_tmp216)
	lw $t2, 0($t1) 	# load with offset
	# _tmp218 = index < _tmp217
	lw $t3, -24($fp)	# load index from $fp-24 into $t3
	slt $t4, $t3, $t2	
	# _tmp219 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp220 = _tmp219 < index
	slt $t6, $t5, $t3	
	# _tmp221 = _tmp220 && _tmp218
	and $t7, $t6, $t4	
	# IfZ _tmp221 Goto _L33
	# (save modified registers before flow of control change)
	sw $t1, -312($fp)	# spill _tmp216 from $t1 to $fp-312
	sw $t2, -316($fp)	# spill _tmp217 from $t2 to $fp-316
	sw $t4, -320($fp)	# spill _tmp218 from $t4 to $fp-320
	sw $t5, -324($fp)	# spill _tmp219 from $t5 to $fp-324
	sw $t6, -328($fp)	# spill _tmp220 from $t6 to $fp-328
	sw $t7, -332($fp)	# spill _tmp221 from $t7 to $fp-332
	beqz $t7, _L33	# branch if _tmp221 is zero 
	# _tmp222 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp223 = index * _tmp222
	lw $t1, -24($fp)	# load index from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp224 = _tmp223 + _tmp222
	add $t3, $t2, $t0	
	# _tmp225 = _tmp216 + _tmp224
	lw $t4, -312($fp)	# load _tmp216 from $fp-312 into $t4
	add $t5, $t4, $t3	
	# Goto _L34
	# (save modified registers before flow of control change)
	sw $t0, -336($fp)	# spill _tmp222 from $t0 to $fp-336
	sw $t2, -340($fp)	# spill _tmp223 from $t2 to $fp-340
	sw $t3, -344($fp)	# spill _tmp224 from $t3 to $fp-344
	sw $t5, -344($fp)	# spill _tmp225 from $t5 to $fp-344
	b _L34		# unconditional branch
_L33:
	# _tmp226 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string41: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string41	# load label
	# PushParam _tmp226
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -348($fp)	# spill _tmp226 from $t0 to $fp-348
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L34:
	# _tmp227 = *(_tmp225)
	lw $t0, -344($fp)	# load _tmp225 from $fp-344 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp228 = *(_tmp227)
	lw $t2, 0($t1) 	# load with offset
	# _tmp229 = *(_tmp228 + 36)
	lw $t3, 36($t2) 	# load with offset
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -12($fp)	# load l from $fp-12 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp227
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp229
	# (save modified registers before flow of control change)
	sw $t1, -352($fp)	# spill _tmp227 from $t1 to $fp-352
	sw $t2, -356($fp)	# spill _tmp228 from $t2 to $fp-356
	sw $t3, -360($fp)	# spill _tmp229 from $t3 to $fp-360
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L32
	b _L32		# unconditional branch
_L31:
_L32:
	# _tmp230 = "Old phone number: "
	.data			# create string constant marked with label
	_string42: .asciiz "Old phone number: "
	.text
	la $t0, _string42	# load label
	# PushParam _tmp230
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -364($fp)	# spill _tmp230 from $t0 to $fp-364
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp231 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp232 = *(_tmp231)
	lw $t2, 0($t1) 	# load with offset
	# _tmp233 = index < _tmp232
	lw $t3, -24($fp)	# load index from $fp-24 into $t3
	slt $t4, $t3, $t2	
	# _tmp234 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp235 = _tmp234 < index
	slt $t6, $t5, $t3	
	# _tmp236 = _tmp235 && _tmp233
	and $t7, $t6, $t4	
	# IfZ _tmp236 Goto _L35
	# (save modified registers before flow of control change)
	sw $t1, -368($fp)	# spill _tmp231 from $t1 to $fp-368
	sw $t2, -372($fp)	# spill _tmp232 from $t2 to $fp-372
	sw $t4, -376($fp)	# spill _tmp233 from $t4 to $fp-376
	sw $t5, -380($fp)	# spill _tmp234 from $t5 to $fp-380
	sw $t6, -384($fp)	# spill _tmp235 from $t6 to $fp-384
	sw $t7, -388($fp)	# spill _tmp236 from $t7 to $fp-388
	beqz $t7, _L35	# branch if _tmp236 is zero 
	# _tmp237 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp238 = index * _tmp237
	lw $t1, -24($fp)	# load index from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp239 = _tmp238 + _tmp237
	add $t3, $t2, $t0	
	# _tmp240 = _tmp231 + _tmp239
	lw $t4, -368($fp)	# load _tmp231 from $fp-368 into $t4
	add $t5, $t4, $t3	
	# Goto _L36
	# (save modified registers before flow of control change)
	sw $t0, -392($fp)	# spill _tmp237 from $t0 to $fp-392
	sw $t2, -396($fp)	# spill _tmp238 from $t2 to $fp-396
	sw $t3, -400($fp)	# spill _tmp239 from $t3 to $fp-400
	sw $t5, -400($fp)	# spill _tmp240 from $t5 to $fp-400
	b _L36		# unconditional branch
_L35:
	# _tmp241 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string43: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string43	# load label
	# PushParam _tmp241
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -404($fp)	# spill _tmp241 from $t0 to $fp-404
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L36:
	# _tmp242 = *(_tmp240)
	lw $t0, -400($fp)	# load _tmp240 from $fp-400 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp243 = *(_tmp242)
	lw $t2, 0($t1) 	# load with offset
	# _tmp244 = *(_tmp243 + 12)
	lw $t3, 12($t2) 	# load with offset
	# PushParam _tmp242
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp245 = ACall _tmp244
	# (save modified registers before flow of control change)
	sw $t1, -408($fp)	# spill _tmp242 from $t1 to $fp-408
	sw $t2, -412($fp)	# spill _tmp243 from $t2 to $fp-412
	sw $t3, -416($fp)	# spill _tmp244 from $t3 to $fp-416
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp245
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -420($fp)	# spill _tmp245 from $t0 to $fp-420
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp246 = "\n"
	.data			# create string constant marked with label
	_string44: .asciiz "\n"
	.text
	la $t0, _string44	# load label
	# PushParam _tmp246
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -424($fp)	# spill _tmp246 from $t0 to $fp-424
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp247 = "Enter new first name (or nothing to leave unchang..."
	.data			# create string constant marked with label
	_string45: .asciiz "Enter new first name (or nothing to leave unchanged): "
	.text
	la $t0, _string45	# load label
	# PushParam _tmp247
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -428($fp)	# spill _tmp247 from $t0 to $fp-428
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp248 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# p = _tmp248
	move $t1, $t0		# copy value
	# _tmp249 = ""
	.data			# create string constant marked with label
	_string46: .asciiz ""
	.text
	la $t2, _string46	# load label
	# PushParam _tmp249
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam p
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp250 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -432($fp)	# spill _tmp248 from $t0 to $fp-432
	sw $t1, -16($fp)	# spill p from $t1 to $fp-16
	sw $t2, -440($fp)	# spill _tmp249 from $t2 to $fp-440
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp250 Goto _L37
	# (save modified registers before flow of control change)
	sw $t0, -436($fp)	# spill _tmp250 from $t0 to $fp-436
	beqz $t0, _L37	# branch if _tmp250 is zero 
	# _tmp251 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp252 = *(_tmp251)
	lw $t2, 0($t1) 	# load with offset
	# _tmp253 = index < _tmp252
	lw $t3, -24($fp)	# load index from $fp-24 into $t3
	slt $t4, $t3, $t2	
	# _tmp254 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp255 = _tmp254 < index
	slt $t6, $t5, $t3	
	# _tmp256 = _tmp255 && _tmp253
	and $t7, $t6, $t4	
	# IfZ _tmp256 Goto _L39
	# (save modified registers before flow of control change)
	sw $t1, -444($fp)	# spill _tmp251 from $t1 to $fp-444
	sw $t2, -448($fp)	# spill _tmp252 from $t2 to $fp-448
	sw $t4, -452($fp)	# spill _tmp253 from $t4 to $fp-452
	sw $t5, -456($fp)	# spill _tmp254 from $t5 to $fp-456
	sw $t6, -460($fp)	# spill _tmp255 from $t6 to $fp-460
	sw $t7, -464($fp)	# spill _tmp256 from $t7 to $fp-464
	beqz $t7, _L39	# branch if _tmp256 is zero 
	# _tmp257 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp258 = index * _tmp257
	lw $t1, -24($fp)	# load index from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp259 = _tmp258 + _tmp257
	add $t3, $t2, $t0	
	# _tmp260 = _tmp251 + _tmp259
	lw $t4, -444($fp)	# load _tmp251 from $fp-444 into $t4
	add $t5, $t4, $t3	
	# Goto _L40
	# (save modified registers before flow of control change)
	sw $t0, -468($fp)	# spill _tmp257 from $t0 to $fp-468
	sw $t2, -472($fp)	# spill _tmp258 from $t2 to $fp-472
	sw $t3, -476($fp)	# spill _tmp259 from $t3 to $fp-476
	sw $t5, -476($fp)	# spill _tmp260 from $t5 to $fp-476
	b _L40		# unconditional branch
_L39:
	# _tmp261 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string47: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string47	# load label
	# PushParam _tmp261
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -480($fp)	# spill _tmp261 from $t0 to $fp-480
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L40:
	# _tmp262 = *(_tmp260)
	lw $t0, -476($fp)	# load _tmp260 from $fp-476 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp263 = *(_tmp262)
	lw $t2, 0($t1) 	# load with offset
	# _tmp264 = *(_tmp263 + 40)
	lw $t3, 40($t2) 	# load with offset
	# PushParam p
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -16($fp)	# load p from $fp-16 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp262
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp264
	# (save modified registers before flow of control change)
	sw $t1, -484($fp)	# spill _tmp262 from $t1 to $fp-484
	sw $t2, -488($fp)	# spill _tmp263 from $t2 to $fp-488
	sw $t3, -492($fp)	# spill _tmp264 from $t3 to $fp-492
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L38
	b _L38		# unconditional branch
_L37:
_L38:
	# _tmp265 = "Old first name: "
	.data			# create string constant marked with label
	_string48: .asciiz "Old first name: "
	.text
	la $t0, _string48	# load label
	# PushParam _tmp265
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -496($fp)	# spill _tmp265 from $t0 to $fp-496
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp266 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp267 = *(_tmp266)
	lw $t2, 0($t1) 	# load with offset
	# _tmp268 = index < _tmp267
	lw $t3, -24($fp)	# load index from $fp-24 into $t3
	slt $t4, $t3, $t2	
	# _tmp269 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp270 = _tmp269 < index
	slt $t6, $t5, $t3	
	# _tmp271 = _tmp270 && _tmp268
	and $t7, $t6, $t4	
	# IfZ _tmp271 Goto _L41
	# (save modified registers before flow of control change)
	sw $t1, -500($fp)	# spill _tmp266 from $t1 to $fp-500
	sw $t2, -504($fp)	# spill _tmp267 from $t2 to $fp-504
	sw $t4, -508($fp)	# spill _tmp268 from $t4 to $fp-508
	sw $t5, -512($fp)	# spill _tmp269 from $t5 to $fp-512
	sw $t6, -516($fp)	# spill _tmp270 from $t6 to $fp-516
	sw $t7, -520($fp)	# spill _tmp271 from $t7 to $fp-520
	beqz $t7, _L41	# branch if _tmp271 is zero 
	# _tmp272 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp273 = index * _tmp272
	lw $t1, -24($fp)	# load index from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp274 = _tmp273 + _tmp272
	add $t3, $t2, $t0	
	# _tmp275 = _tmp266 + _tmp274
	lw $t4, -500($fp)	# load _tmp266 from $fp-500 into $t4
	add $t5, $t4, $t3	
	# Goto _L42
	# (save modified registers before flow of control change)
	sw $t0, -524($fp)	# spill _tmp272 from $t0 to $fp-524
	sw $t2, -528($fp)	# spill _tmp273 from $t2 to $fp-528
	sw $t3, -532($fp)	# spill _tmp274 from $t3 to $fp-532
	sw $t5, -532($fp)	# spill _tmp275 from $t5 to $fp-532
	b _L42		# unconditional branch
_L41:
	# _tmp276 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string49: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string49	# load label
	# PushParam _tmp276
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -536($fp)	# spill _tmp276 from $t0 to $fp-536
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L42:
	# _tmp277 = *(_tmp275)
	lw $t0, -532($fp)	# load _tmp275 from $fp-532 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp278 = *(_tmp277)
	lw $t2, 0($t1) 	# load with offset
	# _tmp279 = *(_tmp278)
	lw $t3, 0($t2) 	# load with offset
	# PushParam _tmp277
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp280 = ACall _tmp279
	# (save modified registers before flow of control change)
	sw $t1, -540($fp)	# spill _tmp277 from $t1 to $fp-540
	sw $t2, -544($fp)	# spill _tmp278 from $t2 to $fp-544
	sw $t3, -548($fp)	# spill _tmp279 from $t3 to $fp-548
	jalr $t3            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp280
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -552($fp)	# spill _tmp280 from $t0 to $fp-552
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp281 = "\n"
	.data			# create string constant marked with label
	_string50: .asciiz "\n"
	.text
	la $t0, _string50	# load label
	# PushParam _tmp281
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -556($fp)	# spill _tmp281 from $t0 to $fp-556
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp282 = "Enter new address (or nothing to leave unchanged)..."
	.data			# create string constant marked with label
	_string51: .asciiz "Enter new address (or nothing to leave unchanged): "
	.text
	la $t0, _string51	# load label
	# PushParam _tmp282
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -560($fp)	# spill _tmp282 from $t0 to $fp-560
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp283 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# a = _tmp283
	move $t1, $t0		# copy value
	# _tmp284 = ""
	.data			# create string constant marked with label
	_string52: .asciiz ""
	.text
	la $t2, _string52	# load label
	# PushParam _tmp284
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam a
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp285 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -564($fp)	# spill _tmp283 from $t0 to $fp-564
	sw $t1, -20($fp)	# spill a from $t1 to $fp-20
	sw $t2, -572($fp)	# spill _tmp284 from $t2 to $fp-572
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp285 Goto _L43
	# (save modified registers before flow of control change)
	sw $t0, -568($fp)	# spill _tmp285 from $t0 to $fp-568
	beqz $t0, _L43	# branch if _tmp285 is zero 
	# _tmp286 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp287 = *(_tmp286)
	lw $t2, 0($t1) 	# load with offset
	# _tmp288 = index < _tmp287
	lw $t3, -24($fp)	# load index from $fp-24 into $t3
	slt $t4, $t3, $t2	
	# _tmp289 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp290 = _tmp289 < index
	slt $t6, $t5, $t3	
	# _tmp291 = _tmp290 && _tmp288
	and $t7, $t6, $t4	
	# IfZ _tmp291 Goto _L45
	# (save modified registers before flow of control change)
	sw $t1, -576($fp)	# spill _tmp286 from $t1 to $fp-576
	sw $t2, -580($fp)	# spill _tmp287 from $t2 to $fp-580
	sw $t4, -584($fp)	# spill _tmp288 from $t4 to $fp-584
	sw $t5, -588($fp)	# spill _tmp289 from $t5 to $fp-588
	sw $t6, -592($fp)	# spill _tmp290 from $t6 to $fp-592
	sw $t7, -596($fp)	# spill _tmp291 from $t7 to $fp-596
	beqz $t7, _L45	# branch if _tmp291 is zero 
	# _tmp292 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp293 = index * _tmp292
	lw $t1, -24($fp)	# load index from $fp-24 into $t1
	mul $t2, $t1, $t0	
	# _tmp294 = _tmp293 + _tmp292
	add $t3, $t2, $t0	
	# _tmp295 = _tmp286 + _tmp294
	lw $t4, -576($fp)	# load _tmp286 from $fp-576 into $t4
	add $t5, $t4, $t3	
	# Goto _L46
	# (save modified registers before flow of control change)
	sw $t0, -600($fp)	# spill _tmp292 from $t0 to $fp-600
	sw $t2, -604($fp)	# spill _tmp293 from $t2 to $fp-604
	sw $t3, -608($fp)	# spill _tmp294 from $t3 to $fp-608
	sw $t5, -608($fp)	# spill _tmp295 from $t5 to $fp-608
	b _L46		# unconditional branch
_L45:
	# _tmp296 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string53: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string53	# load label
	# PushParam _tmp296
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -612($fp)	# spill _tmp296 from $t0 to $fp-612
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L46:
	# _tmp297 = *(_tmp295)
	lw $t0, -608($fp)	# load _tmp295 from $fp-608 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp298 = *(_tmp297)
	lw $t2, 0($t1) 	# load with offset
	# _tmp299 = *(_tmp298 + 28)
	lw $t3, 28($t2) 	# load with offset
	# PushParam a
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -20($fp)	# load a from $fp-20 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam _tmp297
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp299
	# (save modified registers before flow of control change)
	sw $t1, -616($fp)	# spill _tmp297 from $t1 to $fp-616
	sw $t2, -620($fp)	# spill _tmp298 from $t2 to $fp-620
	sw $t3, -624($fp)	# spill _tmp299 from $t3 to $fp-624
	jalr $t3            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# Goto _L44
	b _L44		# unconditional branch
_L43:
_L44:
	# _tmp300 = "\nChanges successfully saved!\n"
	.data			# create string constant marked with label
	_string54: .asciiz "\nChanges successfully saved!\n"
	.text
	la $t0, _string54	# load label
	# PushParam _tmp300
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -628($fp)	# spill _tmp300 from $t0 to $fp-628
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Database.Add:
	# BeginFunc 428
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 428	# decrement sp to make space for locals/temps
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# _tmp301 = "Adding New Person...\n\n"
	.data			# create string constant marked with label
	_string55: .asciiz "Adding New Person...\n\n"
	.text
	la $t0, _string55	# load label
	# PushParam _tmp301
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp301 from $t0 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp302 = "Enter first name: "
	.data			# create string constant marked with label
	_string56: .asciiz "Enter first name: "
	.text
	la $t0, _string56	# load label
	# PushParam _tmp302
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp302 from $t0 to $fp-28
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp303 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# f = _tmp303
	move $t1, $t0		# copy value
	# _tmp304 = "Enter last name: "
	.data			# create string constant marked with label
	_string57: .asciiz "Enter last name: "
	.text
	la $t2, _string57	# load label
	# PushParam _tmp304
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -32($fp)	# spill _tmp303 from $t0 to $fp-32
	sw $t1, -8($fp)	# spill f from $t1 to $fp-8
	sw $t2, -36($fp)	# spill _tmp304 from $t2 to $fp-36
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp305 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# l = _tmp305
	move $t1, $t0		# copy value
	# _tmp306 = *(this)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp307 = *(_tmp306 + 16)
	lw $t4, 16($t3) 	# load with offset
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load f from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp308 = ACall _tmp307
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp305 from $t0 to $fp-40
	sw $t1, -12($fp)	# spill l from $t1 to $fp-12
	sw $t3, -44($fp)	# spill _tmp306 from $t3 to $fp-44
	sw $t4, -48($fp)	# spill _tmp307 from $t4 to $fp-48
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# _tmp309 = 0
	li $t1, 0		# load constant value 0 into $t1
	# _tmp310 = _tmp309 < _tmp308
	slt $t2, $t1, $t0	
	# _tmp311 = _tmp308 == _tmp309
	seq $t3, $t0, $t1	
	# _tmp312 = _tmp310 || _tmp311
	or $t4, $t2, $t3	
	# IfZ _tmp312 Goto _L47
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp308 from $t0 to $fp-52
	sw $t1, -56($fp)	# spill _tmp309 from $t1 to $fp-56
	sw $t2, -60($fp)	# spill _tmp310 from $t2 to $fp-60
	sw $t3, -64($fp)	# spill _tmp311 from $t3 to $fp-64
	sw $t4, -68($fp)	# spill _tmp312 from $t4 to $fp-68
	beqz $t4, _L47	# branch if _tmp312 is zero 
	# _tmp313 = "\n"
	.data			# create string constant marked with label
	_string58: .asciiz "\n"
	.text
	la $t0, _string58	# load label
	# PushParam _tmp313
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -72($fp)	# spill _tmp313 from $t0 to $fp-72
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load l from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp314 = ", "
	.data			# create string constant marked with label
	_string59: .asciiz ", "
	.text
	la $t0, _string59	# load label
	# PushParam _tmp314
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp314 from $t0 to $fp-76
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load f from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp315 = " already exists in the db!\n"
	.data			# create string constant marked with label
	_string60: .asciiz " already exists in the db!\n"
	.text
	la $t0, _string60	# load label
	# PushParam _tmp315
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp315 from $t0 to $fp-80
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# Return 
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L48
	b _L48		# unconditional branch
_L47:
_L48:
	# _tmp316 = "Enter phone number: "
	.data			# create string constant marked with label
	_string61: .asciiz "Enter phone number: "
	.text
	la $t0, _string61	# load label
	# PushParam _tmp316
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp316 from $t0 to $fp-84
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp317 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# p = _tmp317
	move $t1, $t0		# copy value
	# _tmp318 = "Enter address: "
	.data			# create string constant marked with label
	_string62: .asciiz "Enter address: "
	.text
	la $t2, _string62	# load label
	# PushParam _tmp318
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -88($fp)	# spill _tmp317 from $t0 to $fp-88
	sw $t1, -16($fp)	# spill p from $t1 to $fp-16
	sw $t2, -92($fp)	# spill _tmp318 from $t2 to $fp-92
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp319 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# a = _tmp319
	move $t1, $t0		# copy value
	# _tmp320 = *(this + 4)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 4($t2) 	# load with offset
	# _tmp321 = *(this + 8)
	lw $t4, 8($t2) 	# load with offset
	# _tmp322 = _tmp320 == _tmp321
	seq $t5, $t3, $t4	
	# IfZ _tmp322 Goto _L49
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp319 from $t0 to $fp-96
	sw $t1, -20($fp)	# spill a from $t1 to $fp-20
	sw $t3, -100($fp)	# spill _tmp320 from $t3 to $fp-100
	sw $t4, -104($fp)	# spill _tmp321 from $t4 to $fp-104
	sw $t5, -108($fp)	# spill _tmp322 from $t5 to $fp-108
	beqz $t5, _L49	# branch if _tmp322 is zero 
	# _tmp323 = *(this + 8)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 8($t0) 	# load with offset
	# cur = _tmp323
	move $t2, $t1		# copy value
	# _tmp324 = 2
	li $t3, 2		# load constant value 2 into $t3
	# _tmp325 = *(this + 8)
	lw $t4, 8($t0) 	# load with offset
	# _tmp326 = _tmp325 * _tmp324
	mul $t5, $t4, $t3	
	# _tmp327 = 8
	li $t6, 8		# load constant value 8 into $t6
	# _tmp328 = this + _tmp327
	add $t7, $t0, $t6	
	# *(_tmp328) = _tmp326
	sw $t5, 0($t7) 	# store with offset
	# _tmp329 = *(this + 8)
	lw $s0, 8($t0) 	# load with offset
	# _tmp330 = 0
	li $s1, 0		# load constant value 0 into $s1
	# _tmp331 = _tmp329 < _tmp330
	slt $s2, $s0, $s1	
	# _tmp332 = _tmp329 == _tmp330
	seq $s3, $s0, $s1	
	# _tmp333 = _tmp331 || _tmp332
	or $s4, $s2, $s3	
	# IfZ _tmp333 Goto _L51
	# (save modified registers before flow of control change)
	sw $t1, -124($fp)	# spill _tmp323 from $t1 to $fp-124
	sw $t2, -116($fp)	# spill cur from $t2 to $fp-116
	sw $t3, -132($fp)	# spill _tmp324 from $t3 to $fp-132
	sw $t4, -136($fp)	# spill _tmp325 from $t4 to $fp-136
	sw $t5, -128($fp)	# spill _tmp326 from $t5 to $fp-128
	sw $t6, -140($fp)	# spill _tmp327 from $t6 to $fp-140
	sw $t7, -144($fp)	# spill _tmp328 from $t7 to $fp-144
	sw $s0, -148($fp)	# spill _tmp329 from $s0 to $fp-148
	sw $s1, -152($fp)	# spill _tmp330 from $s1 to $fp-152
	sw $s2, -156($fp)	# spill _tmp331 from $s2 to $fp-156
	sw $s3, -160($fp)	# spill _tmp332 from $s3 to $fp-160
	sw $s4, -164($fp)	# spill _tmp333 from $s4 to $fp-164
	beqz $s4, _L51	# branch if _tmp333 is zero 
	# _tmp334 = "Decaf runtime error: Array size is <= 0"
	.data			# create string constant marked with label
	_string63: .asciiz "Decaf runtime error: Array size is <= 0"
	.text
	la $t0, _string63	# load label
	# PushParam _tmp334
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp334 from $t0 to $fp-168
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L51:
	# _tmp335 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp336 = _tmp329 * _tmp335
	lw $t1, -148($fp)	# load _tmp329 from $fp-148 into $t1
	mul $t2, $t1, $t0	
	# _tmp337 = _tmp336 + _tmp335
	add $t3, $t2, $t0	
	# PushParam _tmp337
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp338 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -172($fp)	# spill _tmp335 from $t0 to $fp-172
	sw $t2, -176($fp)	# spill _tmp336 from $t2 to $fp-176
	sw $t3, -180($fp)	# spill _tmp337 from $t3 to $fp-180
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# *(_tmp338) = _tmp329
	lw $t1, -148($fp)	# load _tmp329 from $fp-148 into $t1
	sw $t1, 0($t0) 	# store with offset
	# newPeople = _tmp338
	move $t2, $t0		# copy value
	# _tmp339 = 0
	li $t3, 0		# load constant value 0 into $t3
	# i = _tmp339
	move $t4, $t3		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -184($fp)	# spill _tmp338 from $t0 to $fp-184
	sw $t2, -120($fp)	# spill newPeople from $t2 to $fp-120
	sw $t3, -188($fp)	# spill _tmp339 from $t3 to $fp-188
	sw $t4, -112($fp)	# spill i from $t4 to $fp-112
_L52:
	# _tmp340 = i < cur
	lw $t0, -112($fp)	# load i from $fp-112 into $t0
	lw $t1, -116($fp)	# load cur from $fp-116 into $t1
	slt $t2, $t0, $t1	
	# IfZ _tmp340 Goto _L53
	# (save modified registers before flow of control change)
	sw $t2, -192($fp)	# spill _tmp340 from $t2 to $fp-192
	beqz $t2, _L53	# branch if _tmp340 is zero 
	# _tmp341 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp342 = *(_tmp341)
	lw $t2, 0($t1) 	# load with offset
	# _tmp343 = i < _tmp342
	lw $t3, -112($fp)	# load i from $fp-112 into $t3
	slt $t4, $t3, $t2	
	# _tmp344 = -1
	li $t5, -1		# load constant value -1 into $t5
	# _tmp345 = _tmp344 < i
	slt $t6, $t5, $t3	
	# _tmp346 = _tmp345 && _tmp343
	and $t7, $t6, $t4	
	# IfZ _tmp346 Goto _L54
	# (save modified registers before flow of control change)
	sw $t1, -196($fp)	# spill _tmp341 from $t1 to $fp-196
	sw $t2, -200($fp)	# spill _tmp342 from $t2 to $fp-200
	sw $t4, -204($fp)	# spill _tmp343 from $t4 to $fp-204
	sw $t5, -208($fp)	# spill _tmp344 from $t5 to $fp-208
	sw $t6, -212($fp)	# spill _tmp345 from $t6 to $fp-212
	sw $t7, -216($fp)	# spill _tmp346 from $t7 to $fp-216
	beqz $t7, _L54	# branch if _tmp346 is zero 
	# _tmp347 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp348 = i * _tmp347
	lw $t1, -112($fp)	# load i from $fp-112 into $t1
	mul $t2, $t1, $t0	
	# _tmp349 = _tmp348 + _tmp347
	add $t3, $t2, $t0	
	# _tmp350 = _tmp341 + _tmp349
	lw $t4, -196($fp)	# load _tmp341 from $fp-196 into $t4
	add $t5, $t4, $t3	
	# Goto _L55
	# (save modified registers before flow of control change)
	sw $t0, -220($fp)	# spill _tmp347 from $t0 to $fp-220
	sw $t2, -224($fp)	# spill _tmp348 from $t2 to $fp-224
	sw $t3, -228($fp)	# spill _tmp349 from $t3 to $fp-228
	sw $t5, -228($fp)	# spill _tmp350 from $t5 to $fp-228
	b _L55		# unconditional branch
_L54:
	# _tmp351 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string64: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string64	# load label
	# PushParam _tmp351
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -232($fp)	# spill _tmp351 from $t0 to $fp-232
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L55:
	# _tmp352 = *(_tmp350)
	lw $t0, -228($fp)	# load _tmp350 from $fp-228 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp353 = *(newPeople)
	lw $t2, -120($fp)	# load newPeople from $fp-120 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp354 = i < _tmp353
	lw $t4, -112($fp)	# load i from $fp-112 into $t4
	slt $t5, $t4, $t3	
	# _tmp355 = -1
	li $t6, -1		# load constant value -1 into $t6
	# _tmp356 = _tmp355 < i
	slt $t7, $t6, $t4	
	# _tmp357 = _tmp356 && _tmp354
	and $s0, $t7, $t5	
	# IfZ _tmp357 Goto _L56
	# (save modified registers before flow of control change)
	sw $t1, -236($fp)	# spill _tmp352 from $t1 to $fp-236
	sw $t3, -240($fp)	# spill _tmp353 from $t3 to $fp-240
	sw $t5, -244($fp)	# spill _tmp354 from $t5 to $fp-244
	sw $t6, -248($fp)	# spill _tmp355 from $t6 to $fp-248
	sw $t7, -252($fp)	# spill _tmp356 from $t7 to $fp-252
	sw $s0, -256($fp)	# spill _tmp357 from $s0 to $fp-256
	beqz $s0, _L56	# branch if _tmp357 is zero 
	# _tmp358 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp359 = i * _tmp358
	lw $t1, -112($fp)	# load i from $fp-112 into $t1
	mul $t2, $t1, $t0	
	# _tmp360 = _tmp359 + _tmp358
	add $t3, $t2, $t0	
	# _tmp361 = newPeople + _tmp360
	lw $t4, -120($fp)	# load newPeople from $fp-120 into $t4
	add $t5, $t4, $t3	
	# Goto _L57
	# (save modified registers before flow of control change)
	sw $t0, -260($fp)	# spill _tmp358 from $t0 to $fp-260
	sw $t2, -264($fp)	# spill _tmp359 from $t2 to $fp-264
	sw $t3, -268($fp)	# spill _tmp360 from $t3 to $fp-268
	sw $t5, -268($fp)	# spill _tmp361 from $t5 to $fp-268
	b _L57		# unconditional branch
_L56:
	# _tmp362 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string65: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string65	# load label
	# PushParam _tmp362
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -272($fp)	# spill _tmp362 from $t0 to $fp-272
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L57:
	# *(_tmp361) = _tmp352
	lw $t0, -236($fp)	# load _tmp352 from $fp-236 into $t0
	lw $t1, -268($fp)	# load _tmp361 from $fp-268 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp363 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp364 = i + _tmp363
	lw $t3, -112($fp)	# load i from $fp-112 into $t3
	add $t4, $t3, $t2	
	# i = _tmp364
	move $t3, $t4		# copy value
	# Goto _L52
	# (save modified registers before flow of control change)
	sw $t2, -280($fp)	# spill _tmp363 from $t2 to $fp-280
	sw $t3, -112($fp)	# spill i from $t3 to $fp-112
	sw $t4, -276($fp)	# spill _tmp364 from $t4 to $fp-276
	b _L52		# unconditional branch
_L53:
	# _tmp365 = 12
	li $t0, 12		# load constant value 12 into $t0
	# _tmp366 = this + _tmp365
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	add $t2, $t1, $t0	
	# *(_tmp366) = newPeople
	lw $t3, -120($fp)	# load newPeople from $fp-120 into $t3
	sw $t3, 0($t2) 	# store with offset
	# Goto _L50
	# (save modified registers before flow of control change)
	sw $t0, -284($fp)	# spill _tmp365 from $t0 to $fp-284
	sw $t2, -288($fp)	# spill _tmp366 from $t2 to $fp-288
	b _L50		# unconditional branch
_L49:
_L50:
	# _tmp367 = 20
	li $t0, 20		# load constant value 20 into $t0
	# PushParam _tmp367
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp368 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -292($fp)	# spill _tmp367 from $t0 to $fp-292
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp369 = Person
	la $t1, Person	# load label
	# *(_tmp368) = _tmp369
	sw $t1, 0($t0) 	# store with offset
	# _tmp370 = *(this + 12)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 12($t2) 	# load with offset
	# _tmp371 = *(_tmp370)
	lw $t4, 0($t3) 	# load with offset
	# _tmp372 = *(this + 4)
	lw $t5, 4($t2) 	# load with offset
	# _tmp373 = _tmp372 < _tmp371
	slt $t6, $t5, $t4	
	# _tmp374 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp375 = _tmp374 < _tmp372
	slt $s0, $t7, $t5	
	# _tmp376 = _tmp375 && _tmp373
	and $s1, $s0, $t6	
	# IfZ _tmp376 Goto _L58
	# (save modified registers before flow of control change)
	sw $t0, -296($fp)	# spill _tmp368 from $t0 to $fp-296
	sw $t1, -300($fp)	# spill _tmp369 from $t1 to $fp-300
	sw $t3, -304($fp)	# spill _tmp370 from $t3 to $fp-304
	sw $t4, -308($fp)	# spill _tmp371 from $t4 to $fp-308
	sw $t5, -316($fp)	# spill _tmp372 from $t5 to $fp-316
	sw $t6, -312($fp)	# spill _tmp373 from $t6 to $fp-312
	sw $t7, -320($fp)	# spill _tmp374 from $t7 to $fp-320
	sw $s0, -324($fp)	# spill _tmp375 from $s0 to $fp-324
	sw $s1, -328($fp)	# spill _tmp376 from $s1 to $fp-328
	beqz $s1, _L58	# branch if _tmp376 is zero 
	# _tmp377 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp378 = _tmp372 * _tmp377
	lw $t1, -316($fp)	# load _tmp372 from $fp-316 into $t1
	mul $t2, $t1, $t0	
	# _tmp379 = _tmp378 + _tmp377
	add $t3, $t2, $t0	
	# _tmp380 = _tmp370 + _tmp379
	lw $t4, -304($fp)	# load _tmp370 from $fp-304 into $t4
	add $t5, $t4, $t3	
	# Goto _L59
	# (save modified registers before flow of control change)
	sw $t0, -332($fp)	# spill _tmp377 from $t0 to $fp-332
	sw $t2, -336($fp)	# spill _tmp378 from $t2 to $fp-336
	sw $t3, -340($fp)	# spill _tmp379 from $t3 to $fp-340
	sw $t5, -340($fp)	# spill _tmp380 from $t5 to $fp-340
	b _L59		# unconditional branch
_L58:
	# _tmp381 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string66: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string66	# load label
	# PushParam _tmp381
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -344($fp)	# spill _tmp381 from $t0 to $fp-344
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L59:
	# *(_tmp380) = _tmp368
	lw $t0, -296($fp)	# load _tmp368 from $fp-296 into $t0
	lw $t1, -340($fp)	# load _tmp380 from $fp-340 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp382 = *(this + 12)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 12($t2) 	# load with offset
	# _tmp383 = *(_tmp382)
	lw $t4, 0($t3) 	# load with offset
	# _tmp384 = *(this + 4)
	lw $t5, 4($t2) 	# load with offset
	# _tmp385 = _tmp384 < _tmp383
	slt $t6, $t5, $t4	
	# _tmp386 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp387 = _tmp386 < _tmp384
	slt $s0, $t7, $t5	
	# _tmp388 = _tmp387 && _tmp385
	and $s1, $s0, $t6	
	# IfZ _tmp388 Goto _L60
	# (save modified registers before flow of control change)
	sw $t3, -348($fp)	# spill _tmp382 from $t3 to $fp-348
	sw $t4, -352($fp)	# spill _tmp383 from $t4 to $fp-352
	sw $t5, -360($fp)	# spill _tmp384 from $t5 to $fp-360
	sw $t6, -356($fp)	# spill _tmp385 from $t6 to $fp-356
	sw $t7, -364($fp)	# spill _tmp386 from $t7 to $fp-364
	sw $s0, -368($fp)	# spill _tmp387 from $s0 to $fp-368
	sw $s1, -372($fp)	# spill _tmp388 from $s1 to $fp-372
	beqz $s1, _L60	# branch if _tmp388 is zero 
	# _tmp389 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp390 = _tmp384 * _tmp389
	lw $t1, -360($fp)	# load _tmp384 from $fp-360 into $t1
	mul $t2, $t1, $t0	
	# _tmp391 = _tmp390 + _tmp389
	add $t3, $t2, $t0	
	# _tmp392 = _tmp382 + _tmp391
	lw $t4, -348($fp)	# load _tmp382 from $fp-348 into $t4
	add $t5, $t4, $t3	
	# Goto _L61
	# (save modified registers before flow of control change)
	sw $t0, -376($fp)	# spill _tmp389 from $t0 to $fp-376
	sw $t2, -380($fp)	# spill _tmp390 from $t2 to $fp-380
	sw $t3, -384($fp)	# spill _tmp391 from $t3 to $fp-384
	sw $t5, -384($fp)	# spill _tmp392 from $t5 to $fp-384
	b _L61		# unconditional branch
_L60:
	# _tmp393 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string67: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string67	# load label
	# PushParam _tmp393
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -388($fp)	# spill _tmp393 from $t0 to $fp-388
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L61:
	# _tmp394 = *(_tmp392)
	lw $t0, -384($fp)	# load _tmp392 from $fp-384 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp395 = *(_tmp394)
	lw $t2, 0($t1) 	# load with offset
	# _tmp396 = *(_tmp395 + 16)
	lw $t3, 16($t2) 	# load with offset
	# PushParam a
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t4, -20($fp)	# load a from $fp-20 into $t4
	sw $t4, 4($sp)	# copy param value to stack
	# PushParam p
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -16($fp)	# load p from $fp-16 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t6, -12($fp)	# load l from $fp-12 into $t6
	sw $t6, 4($sp)	# copy param value to stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t7, -8($fp)	# load f from $fp-8 into $t7
	sw $t7, 4($sp)	# copy param value to stack
	# PushParam _tmp394
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# ACall _tmp396
	# (save modified registers before flow of control change)
	sw $t1, -392($fp)	# spill _tmp394 from $t1 to $fp-392
	sw $t2, -396($fp)	# spill _tmp395 from $t2 to $fp-396
	sw $t3, -400($fp)	# spill _tmp396 from $t3 to $fp-400
	jalr $t3            	# jump to function
	# PopParams 20
	add $sp, $sp, 20	# pop params off stack
	# _tmp397 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp398 = *(this + 4)
	lw $t1, 4($fp)	# load this from $fp+4 into $t1
	lw $t2, 4($t1) 	# load with offset
	# _tmp399 = _tmp398 + _tmp397
	add $t3, $t2, $t0	
	# _tmp400 = 4
	li $t4, 4		# load constant value 4 into $t4
	# _tmp401 = this + _tmp400
	add $t5, $t1, $t4	
	# *(_tmp401) = _tmp399
	sw $t3, 0($t5) 	# store with offset
	# _tmp402 = "\n"
	.data			# create string constant marked with label
	_string68: .asciiz "\n"
	.text
	la $t6, _string68	# load label
	# PushParam _tmp402
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -408($fp)	# spill _tmp397 from $t0 to $fp-408
	sw $t2, -412($fp)	# spill _tmp398 from $t2 to $fp-412
	sw $t3, -404($fp)	# spill _tmp399 from $t3 to $fp-404
	sw $t4, -416($fp)	# spill _tmp400 from $t4 to $fp-416
	sw $t5, -420($fp)	# spill _tmp401 from $t5 to $fp-420
	sw $t6, -424($fp)	# spill _tmp402 from $t6 to $fp-424
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load l from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp403 = ", "
	.data			# create string constant marked with label
	_string69: .asciiz ", "
	.text
	la $t0, _string69	# load label
	# PushParam _tmp403
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -428($fp)	# spill _tmp403 from $t0 to $fp-428
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load f from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp404 = " successfully added!\n"
	.data			# create string constant marked with label
	_string70: .asciiz " successfully added!\n"
	.text
	la $t0, _string70	# load label
	# PushParam _tmp404
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -432($fp)	# spill _tmp404 from $t0 to $fp-432
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
__Database.Delete:
	# BeginFunc 208
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 208	# decrement sp to make space for locals/temps
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# _tmp405 = "Deleting person...\n\n"
	.data			# create string constant marked with label
	_string71: .asciiz "Deleting person...\n\n"
	.text
	la $t0, _string71	# load label
	# PushParam _tmp405
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp405 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp406 = "Enter first name: "
	.data			# create string constant marked with label
	_string72: .asciiz "Enter first name: "
	.text
	la $t0, _string72	# load label
	# PushParam _tmp406
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp406 from $t0 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp407 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# f = _tmp407
	move $t1, $t0		# copy value
	# _tmp408 = "Enter last name: "
	.data			# create string constant marked with label
	_string73: .asciiz "Enter last name: "
	.text
	la $t2, _string73	# load label
	# PushParam _tmp408
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp407 from $t0 to $fp-28
	sw $t1, -8($fp)	# spill f from $t1 to $fp-8
	sw $t2, -32($fp)	# spill _tmp408 from $t2 to $fp-32
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp409 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# l = _tmp409
	move $t1, $t0		# copy value
	# _tmp410 = *(this)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 0($t2) 	# load with offset
	# _tmp411 = *(_tmp410 + 16)
	lw $t4, 16($t3) 	# load with offset
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t5, -8($fp)	# load f from $fp-8 into $t5
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam this
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# _tmp412 = ACall _tmp411
	# (save modified registers before flow of control change)
	sw $t0, -36($fp)	# spill _tmp409 from $t0 to $fp-36
	sw $t1, -12($fp)	# spill l from $t1 to $fp-12
	sw $t3, -40($fp)	# spill _tmp410 from $t3 to $fp-40
	sw $t4, -44($fp)	# spill _tmp411 from $t4 to $fp-44
	jalr $t4            	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 12
	add $sp, $sp, 12	# pop params off stack
	# index = _tmp412
	move $t1, $t0		# copy value
	# _tmp413 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp414 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp415 = _tmp413 - _tmp414
	sub $t4, $t2, $t3	
	# _tmp416 = index < _tmp415
	slt $t5, $t1, $t4	
	# _tmp417 = _tmp415 < index
	slt $t6, $t4, $t1	
	# _tmp418 = _tmp416 || _tmp417
	or $t7, $t5, $t6	
	# IfZ _tmp418 Goto _L62
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp412 from $t0 to $fp-48
	sw $t1, -16($fp)	# spill index from $t1 to $fp-16
	sw $t2, -52($fp)	# spill _tmp413 from $t2 to $fp-52
	sw $t3, -60($fp)	# spill _tmp414 from $t3 to $fp-60
	sw $t4, -56($fp)	# spill _tmp415 from $t4 to $fp-56
	sw $t5, -64($fp)	# spill _tmp416 from $t5 to $fp-64
	sw $t6, -68($fp)	# spill _tmp417 from $t6 to $fp-68
	sw $t7, -72($fp)	# spill _tmp418 from $t7 to $fp-72
	beqz $t7, _L62	# branch if _tmp418 is zero 
	# _tmp419 = *(this + 12)
	lw $t0, 4($fp)	# load this from $fp+4 into $t0
	lw $t1, 12($t0) 	# load with offset
	# _tmp420 = *(_tmp419)
	lw $t2, 0($t1) 	# load with offset
	# _tmp421 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp422 = *(this + 4)
	lw $t4, 4($t0) 	# load with offset
	# _tmp423 = _tmp422 - _tmp421
	sub $t5, $t4, $t3	
	# _tmp424 = _tmp423 < _tmp420
	slt $t6, $t5, $t2	
	# _tmp425 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp426 = _tmp425 < _tmp423
	slt $s0, $t7, $t5	
	# _tmp427 = _tmp426 && _tmp424
	and $s1, $s0, $t6	
	# IfZ _tmp427 Goto _L64
	# (save modified registers before flow of control change)
	sw $t1, -76($fp)	# spill _tmp419 from $t1 to $fp-76
	sw $t2, -80($fp)	# spill _tmp420 from $t2 to $fp-80
	sw $t3, -92($fp)	# spill _tmp421 from $t3 to $fp-92
	sw $t4, -96($fp)	# spill _tmp422 from $t4 to $fp-96
	sw $t5, -88($fp)	# spill _tmp423 from $t5 to $fp-88
	sw $t6, -84($fp)	# spill _tmp424 from $t6 to $fp-84
	sw $t7, -100($fp)	# spill _tmp425 from $t7 to $fp-100
	sw $s0, -104($fp)	# spill _tmp426 from $s0 to $fp-104
	sw $s1, -108($fp)	# spill _tmp427 from $s1 to $fp-108
	beqz $s1, _L64	# branch if _tmp427 is zero 
	# _tmp428 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp429 = _tmp423 * _tmp428
	lw $t1, -88($fp)	# load _tmp423 from $fp-88 into $t1
	mul $t2, $t1, $t0	
	# _tmp430 = _tmp429 + _tmp428
	add $t3, $t2, $t0	
	# _tmp431 = _tmp419 + _tmp430
	lw $t4, -76($fp)	# load _tmp419 from $fp-76 into $t4
	add $t5, $t4, $t3	
	# Goto _L65
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp428 from $t0 to $fp-112
	sw $t2, -116($fp)	# spill _tmp429 from $t2 to $fp-116
	sw $t3, -120($fp)	# spill _tmp430 from $t3 to $fp-120
	sw $t5, -120($fp)	# spill _tmp431 from $t5 to $fp-120
	b _L65		# unconditional branch
_L64:
	# _tmp432 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string74: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string74	# load label
	# PushParam _tmp432
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp432 from $t0 to $fp-124
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L65:
	# _tmp433 = *(_tmp431)
	lw $t0, -120($fp)	# load _tmp431 from $fp-120 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp434 = *(this + 12)
	lw $t2, 4($fp)	# load this from $fp+4 into $t2
	lw $t3, 12($t2) 	# load with offset
	# _tmp435 = *(_tmp434)
	lw $t4, 0($t3) 	# load with offset
	# _tmp436 = index < _tmp435
	lw $t5, -16($fp)	# load index from $fp-16 into $t5
	slt $t6, $t5, $t4	
	# _tmp437 = -1
	li $t7, -1		# load constant value -1 into $t7
	# _tmp438 = _tmp437 < index
	slt $s0, $t7, $t5	
	# _tmp439 = _tmp438 && _tmp436
	and $s1, $s0, $t6	
	# IfZ _tmp439 Goto _L66
	# (save modified registers before flow of control change)
	sw $t1, -128($fp)	# spill _tmp433 from $t1 to $fp-128
	sw $t3, -132($fp)	# spill _tmp434 from $t3 to $fp-132
	sw $t4, -136($fp)	# spill _tmp435 from $t4 to $fp-136
	sw $t6, -140($fp)	# spill _tmp436 from $t6 to $fp-140
	sw $t7, -144($fp)	# spill _tmp437 from $t7 to $fp-144
	sw $s0, -148($fp)	# spill _tmp438 from $s0 to $fp-148
	sw $s1, -152($fp)	# spill _tmp439 from $s1 to $fp-152
	beqz $s1, _L66	# branch if _tmp439 is zero 
	# _tmp440 = 4
	li $t0, 4		# load constant value 4 into $t0
	# _tmp441 = index * _tmp440
	lw $t1, -16($fp)	# load index from $fp-16 into $t1
	mul $t2, $t1, $t0	
	# _tmp442 = _tmp441 + _tmp440
	add $t3, $t2, $t0	
	# _tmp443 = _tmp434 + _tmp442
	lw $t4, -132($fp)	# load _tmp434 from $fp-132 into $t4
	add $t5, $t4, $t3	
	# Goto _L67
	# (save modified registers before flow of control change)
	sw $t0, -156($fp)	# spill _tmp440 from $t0 to $fp-156
	sw $t2, -160($fp)	# spill _tmp441 from $t2 to $fp-160
	sw $t3, -164($fp)	# spill _tmp442 from $t3 to $fp-164
	sw $t5, -164($fp)	# spill _tmp443 from $t5 to $fp-164
	b _L67		# unconditional branch
_L66:
	# _tmp444 = "Decaf runtime error: Array script out of bounds"
	.data			# create string constant marked with label
	_string75: .asciiz "Decaf runtime error: Array script out of bounds"
	.text
	la $t0, _string75	# load label
	# PushParam _tmp444
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -168($fp)	# spill _tmp444 from $t0 to $fp-168
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	jal _Halt          	# jump to function
_L67:
	# *(_tmp443) = _tmp433
	lw $t0, -128($fp)	# load _tmp433 from $fp-128 into $t0
	lw $t1, -164($fp)	# load _tmp443 from $fp-164 into $t1
	sw $t0, 0($t1) 	# store with offset
	# _tmp445 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp446 = *(this + 4)
	lw $t3, 4($fp)	# load this from $fp+4 into $t3
	lw $t4, 4($t3) 	# load with offset
	# _tmp447 = _tmp446 - _tmp445
	sub $t5, $t4, $t2	
	# _tmp448 = 4
	li $t6, 4		# load constant value 4 into $t6
	# _tmp449 = this + _tmp448
	add $t7, $t3, $t6	
	# *(_tmp449) = _tmp447
	sw $t5, 0($t7) 	# store with offset
	# _tmp450 = "\n"
	.data			# create string constant marked with label
	_string76: .asciiz "\n"
	.text
	la $s0, _string76	# load label
	# PushParam _tmp450
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $s0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t2, -176($fp)	# spill _tmp445 from $t2 to $fp-176
	sw $t4, -180($fp)	# spill _tmp446 from $t4 to $fp-180
	sw $t5, -172($fp)	# spill _tmp447 from $t5 to $fp-172
	sw $t6, -184($fp)	# spill _tmp448 from $t6 to $fp-184
	sw $t7, -188($fp)	# spill _tmp449 from $t7 to $fp-188
	sw $s0, -192($fp)	# spill _tmp450 from $s0 to $fp-192
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load l from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp451 = ", "
	.data			# create string constant marked with label
	_string77: .asciiz ", "
	.text
	la $t0, _string77	# load label
	# PushParam _tmp451
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -196($fp)	# spill _tmp451 from $t0 to $fp-196
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load f from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp452 = " successfully deleted!\n"
	.data			# create string constant marked with label
	_string78: .asciiz " successfully deleted!\n"
	.text
	la $t0, _string78	# load label
	# PushParam _tmp452
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -200($fp)	# spill _tmp452 from $t0 to $fp-200
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# Goto _L63
	b _L63		# unconditional branch
_L62:
	# _tmp453 = "\n"
	.data			# create string constant marked with label
	_string79: .asciiz "\n"
	.text
	la $t0, _string79	# load label
	# PushParam _tmp453
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -204($fp)	# spill _tmp453 from $t0 to $fp-204
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam l
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -12($fp)	# load l from $fp-12 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp454 = ", "
	.data			# create string constant marked with label
	_string80: .asciiz ", "
	.text
	la $t0, _string80	# load label
	# PushParam _tmp454
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -208($fp)	# spill _tmp454 from $t0 to $fp-208
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam f
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load f from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp455 = " not found!\n"
	.data			# create string constant marked with label
	_string81: .asciiz " not found!\n"
	.text
	la $t0, _string81	# load label
	# PushParam _tmp455
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -212($fp)	# spill _tmp455 from $t0 to $fp-212
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
_L63:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# VTable for class Database
	.data
	.align 2
	Database:		# label for class Database vtable
	.word __Database.Add
	.word __Database.Delete
	.word __Database.Edit
	.word __Database.InitDatabase
	.word __Database.PersonExists
	.word __Database.Search
	.text
__PrintHelp:
	# BeginFunc 20
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 20	# decrement sp to make space for locals/temps
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# _tmp456 = "List of Commands...\n\n"
	.data			# create string constant marked with label
	_string82: .asciiz "List of Commands...\n\n"
	.text
	la $t0, _string82	# load label
	# PushParam _tmp456
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp456 from $t0 to $fp-8
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp457 = "add - lets you add a person\n"
	.data			# create string constant marked with label
	_string83: .asciiz "add - lets you add a person\n"
	.text
	la $t0, _string83	# load label
	# PushParam _tmp457
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp457 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp458 = "delete - lets you delete a person\n"
	.data			# create string constant marked with label
	_string84: .asciiz "delete - lets you delete a person\n"
	.text
	la $t0, _string84	# load label
	# PushParam _tmp458
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp458 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp459 = "search - lets you search for a specific person\n"
	.data			# create string constant marked with label
	_string85: .asciiz "search - lets you search for a specific person\n"
	.text
	la $t0, _string85	# load label
	# PushParam _tmp459
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp459 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp460 = "edit - lets you edit the attributes of a specific..."
	.data			# create string constant marked with label
	_string86: .asciiz "edit - lets you edit the attributes of a specific person\n"
	.text
	la $t0, _string86	# load label
	# PushParam _tmp460
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp460 from $t0 to $fp-24
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
main:
	# BeginFunc 132
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 132	# decrement sp to make space for locals/temps
	# _tmp461 = 16
	li $t0, 16		# load constant value 16 into $t0
	# PushParam _tmp461
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp462 = LCall _Alloc
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp461 from $t0 to $fp-16
	jal _Alloc         	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp463 = Database
	la $t1, Database	# load label
	# *(_tmp462) = _tmp463
	sw $t1, 0($t0) 	# store with offset
	# db = _tmp462
	move $t2, $t0		# copy value
	# _tmp464 = *(db)
	lw $t3, 0($t2) 	# load with offset
	# _tmp465 = *(_tmp464 + 12)
	lw $t4, 12($t3) 	# load with offset
	# _tmp466 = 10
	li $t5, 10		# load constant value 10 into $t5
	# PushParam _tmp466
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam db
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# ACall _tmp465
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp462 from $t0 to $fp-20
	sw $t1, -24($fp)	# spill _tmp463 from $t1 to $fp-24
	sw $t2, -8($fp)	# spill db from $t2 to $fp-8
	sw $t3, -28($fp)	# spill _tmp464 from $t3 to $fp-28
	sw $t4, -32($fp)	# spill _tmp465 from $t4 to $fp-32
	sw $t5, -36($fp)	# spill _tmp466 from $t5 to $fp-36
	jalr $t4            	# jump to function
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# _tmp467 = "Welcome to PeopleSearch!\n"
	.data			# create string constant marked with label
	_string87: .asciiz "Welcome to PeopleSearch!\n"
	.text
	la $t0, _string87	# load label
	# PushParam _tmp467
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp467 from $t0 to $fp-40
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# LCall __PrintLine
	jal __PrintLine    	# jump to function
	# _tmp468 = "\n"
	.data			# create string constant marked with label
	_string88: .asciiz "\n"
	.text
	la $t0, _string88	# load label
	# PushParam _tmp468
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp468 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp469 = ""
	.data			# create string constant marked with label
	_string89: .asciiz ""
	.text
	la $t0, _string89	# load label
	# input = _tmp469
	move $t1, $t0		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp469 from $t0 to $fp-48
	sw $t1, -12($fp)	# spill input from $t1 to $fp-12
_L68:
	# _tmp470 = "quit"
	.data			# create string constant marked with label
	_string90: .asciiz "quit"
	.text
	la $t0, _string90	# load label
	# PushParam _tmp470
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -12($fp)	# load input from $fp-12 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp471 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp470 from $t0 to $fp-56
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp471 Goto _L69
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp471 from $t0 to $fp-52
	beqz $t0, _L69	# branch if _tmp471 is zero 
	# _tmp472 = "Please enter your command(type help for a list of..."
	.data			# create string constant marked with label
	_string91: .asciiz "Please enter your command(type help for a list of commands): "
	.text
	la $t0, _string91	# load label
	# PushParam _tmp472
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp472 from $t0 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp473 = LCall _ReadLine
	jal _ReadLine      	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# input = _tmp473
	move $t1, $t0		# copy value
	# _tmp474 = "help"
	.data			# create string constant marked with label
	_string92: .asciiz "help"
	.text
	la $t2, _string92	# load label
	# PushParam _tmp474
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t2, 4($sp)	# copy param value to stack
	# PushParam input
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp475 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -64($fp)	# spill _tmp473 from $t0 to $fp-64
	sw $t1, -12($fp)	# spill input from $t1 to $fp-12
	sw $t2, -72($fp)	# spill _tmp474 from $t2 to $fp-72
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp475 Goto _L70
	# (save modified registers before flow of control change)
	sw $t0, -68($fp)	# spill _tmp475 from $t0 to $fp-68
	beqz $t0, _L70	# branch if _tmp475 is zero 
	# LCall __PrintHelp
	jal __PrintHelp    	# jump to function
	# Goto _L71
	b _L71		# unconditional branch
_L70:
_L71:
	# _tmp476 = "search"
	.data			# create string constant marked with label
	_string93: .asciiz "search"
	.text
	la $t0, _string93	# load label
	# PushParam _tmp476
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -12($fp)	# load input from $fp-12 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp477 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -80($fp)	# spill _tmp476 from $t0 to $fp-80
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp477 Goto _L72
	# (save modified registers before flow of control change)
	sw $t0, -76($fp)	# spill _tmp477 from $t0 to $fp-76
	beqz $t0, _L72	# branch if _tmp477 is zero 
	# _tmp478 = *(db)
	lw $t0, -8($fp)	# load db from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp479 = *(_tmp478 + 20)
	lw $t2, 20($t1) 	# load with offset
	# PushParam db
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp479
	# (save modified registers before flow of control change)
	sw $t1, -84($fp)	# spill _tmp478 from $t1 to $fp-84
	sw $t2, -88($fp)	# spill _tmp479 from $t2 to $fp-88
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L73
	b _L73		# unconditional branch
_L72:
_L73:
	# _tmp480 = "add"
	.data			# create string constant marked with label
	_string94: .asciiz "add"
	.text
	la $t0, _string94	# load label
	# PushParam _tmp480
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -12($fp)	# load input from $fp-12 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp481 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -96($fp)	# spill _tmp480 from $t0 to $fp-96
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp481 Goto _L74
	# (save modified registers before flow of control change)
	sw $t0, -92($fp)	# spill _tmp481 from $t0 to $fp-92
	beqz $t0, _L74	# branch if _tmp481 is zero 
	# _tmp482 = *(db)
	lw $t0, -8($fp)	# load db from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp483 = *(_tmp482)
	lw $t2, 0($t1) 	# load with offset
	# PushParam db
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp483
	# (save modified registers before flow of control change)
	sw $t1, -100($fp)	# spill _tmp482 from $t1 to $fp-100
	sw $t2, -104($fp)	# spill _tmp483 from $t2 to $fp-104
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L75
	b _L75		# unconditional branch
_L74:
_L75:
	# _tmp484 = "delete"
	.data			# create string constant marked with label
	_string95: .asciiz "delete"
	.text
	la $t0, _string95	# load label
	# PushParam _tmp484
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -12($fp)	# load input from $fp-12 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp485 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -112($fp)	# spill _tmp484 from $t0 to $fp-112
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp485 Goto _L76
	# (save modified registers before flow of control change)
	sw $t0, -108($fp)	# spill _tmp485 from $t0 to $fp-108
	beqz $t0, _L76	# branch if _tmp485 is zero 
	# _tmp486 = *(db)
	lw $t0, -8($fp)	# load db from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp487 = *(_tmp486 + 4)
	lw $t2, 4($t1) 	# load with offset
	# PushParam db
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp487
	# (save modified registers before flow of control change)
	sw $t1, -116($fp)	# spill _tmp486 from $t1 to $fp-116
	sw $t2, -120($fp)	# spill _tmp487 from $t2 to $fp-120
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L77
	b _L77		# unconditional branch
_L76:
_L77:
	# _tmp488 = "edit"
	.data			# create string constant marked with label
	_string96: .asciiz "edit"
	.text
	la $t0, _string96	# load label
	# PushParam _tmp488
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t1, -12($fp)	# load input from $fp-12 into $t1
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp489 = LCall _StringEqual
	# (save modified registers before flow of control change)
	sw $t0, -128($fp)	# spill _tmp488 from $t0 to $fp-128
	jal _StringEqual   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp489 Goto _L78
	# (save modified registers before flow of control change)
	sw $t0, -124($fp)	# spill _tmp489 from $t0 to $fp-124
	beqz $t0, _L78	# branch if _tmp489 is zero 
	# _tmp490 = *(db)
	lw $t0, -8($fp)	# load db from $fp-8 into $t0
	lw $t1, 0($t0) 	# load with offset
	# _tmp491 = *(_tmp490 + 8)
	lw $t2, 8($t1) 	# load with offset
	# PushParam db
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp491
	# (save modified registers before flow of control change)
	sw $t1, -132($fp)	# spill _tmp490 from $t1 to $fp-132
	sw $t2, -136($fp)	# spill _tmp491 from $t2 to $fp-136
	jalr $t2            	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L79
	b _L79		# unconditional branch
_L78:
_L79:
	# Goto _L68
	b _L68		# unconditional branch
_L69:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
