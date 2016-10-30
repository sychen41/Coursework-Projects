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
	
__fib:
	# BeginFunc 68
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 68	# decrement sp to make space for locals/temps
	# _tmp0 = 1
	li $t0, 1		# load constant value 1 into $t0
	# _tmp1 = base < _tmp0
	lw $t1, 4($fp)	# load base from $fp+4 into $t1
	slt $t2, $t1, $t0	
	# _tmp2 = base == _tmp0
	seq $t3, $t1, $t0	
	# _tmp3 = _tmp1 || _tmp2
	or $t4, $t2, $t3	
	# IfZ _tmp3 Goto _L0
	# (save modified registers before flow of control change)
	sw $t0, -8($fp)	# spill _tmp0 from $t0 to $fp-8
	sw $t2, -12($fp)	# spill _tmp1 from $t2 to $fp-12
	sw $t3, -16($fp)	# spill _tmp2 from $t3 to $fp-16
	sw $t4, -20($fp)	# spill _tmp3 from $t4 to $fp-20
	beqz $t4, _L0	# branch if _tmp3 is zero 
	# Return base
	lw $t0, 4($fp)	# load base from $fp+4 into $t0
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L1
	b _L1		# unconditional branch
_L0:
	# _tmp4 = 0
	li $t0, 0		# load constant value 0 into $t0
	# f0 = _tmp4
	move $t1, $t0		# copy value
	# _tmp5 = 1
	li $t2, 1		# load constant value 1 into $t2
	# f1 = _tmp5
	move $t3, $t2		# copy value
	# _tmp6 = 2
	li $t4, 2		# load constant value 2 into $t4
	# i = _tmp6
	move $t5, $t4		# copy value
	# (save modified registers before flow of control change)
	sw $t0, -40($fp)	# spill _tmp4 from $t0 to $fp-40
	sw $t1, -28($fp)	# spill f0 from $t1 to $fp-28
	sw $t2, -44($fp)	# spill _tmp5 from $t2 to $fp-44
	sw $t3, -32($fp)	# spill f1 from $t3 to $fp-32
	sw $t4, -48($fp)	# spill _tmp6 from $t4 to $fp-48
	sw $t5, -24($fp)	# spill i from $t5 to $fp-24
_L2:
	# _tmp7 = i < base
	lw $t0, -24($fp)	# load i from $fp-24 into $t0
	lw $t1, 4($fp)	# load base from $fp+4 into $t1
	slt $t2, $t0, $t1	
	# _tmp8 = i == base
	seq $t3, $t0, $t1	
	# _tmp9 = _tmp7 || _tmp8
	or $t4, $t2, $t3	
	# IfZ _tmp9 Goto _L3
	# (save modified registers before flow of control change)
	sw $t2, -52($fp)	# spill _tmp7 from $t2 to $fp-52
	sw $t3, -56($fp)	# spill _tmp8 from $t3 to $fp-56
	sw $t4, -60($fp)	# spill _tmp9 from $t4 to $fp-60
	beqz $t4, _L3	# branch if _tmp9 is zero 
	# _tmp10 = f0 + f1
	lw $t0, -28($fp)	# load f0 from $fp-28 into $t0
	lw $t1, -32($fp)	# load f1 from $fp-32 into $t1
	add $t2, $t0, $t1	
	# f2 = _tmp10
	move $t3, $t2		# copy value
	# f0 = f1
	move $t0, $t1		# copy value
	# f1 = f2
	move $t1, $t3		# copy value
	# _tmp11 = 1
	li $t4, 1		# load constant value 1 into $t4
	# _tmp12 = i + _tmp11
	lw $t5, -24($fp)	# load i from $fp-24 into $t5
	add $t6, $t5, $t4	
	# i = _tmp12
	move $t5, $t6		# copy value
	# Goto _L2
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill f0 from $t0 to $fp-28
	sw $t1, -32($fp)	# spill f1 from $t1 to $fp-32
	sw $t2, -64($fp)	# spill _tmp10 from $t2 to $fp-64
	sw $t3, -36($fp)	# spill f2 from $t3 to $fp-36
	sw $t4, -72($fp)	# spill _tmp11 from $t4 to $fp-72
	sw $t5, -24($fp)	# spill i from $t5 to $fp-24
	sw $t6, -68($fp)	# spill _tmp12 from $t6 to $fp-68
	b _L2		# unconditional branch
_L3:
	# Return f2
	lw $t0, -36($fp)	# load f2 from $fp-36 into $t0
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
_L1:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
main:
	# BeginFunc 56
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 56	# decrement sp to make space for locals/temps
	# _tmp13 = "\nThis program computes Fibonacci numbers (slowly..."
	.data			# create string constant marked with label
	_string1: .asciiz "\nThis program computes Fibonacci numbers (slowly.. but correctly!)\n"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp13
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp13 from $t0 to $fp-12
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L4:
	# _tmp14 = 1
	li $t0, 1		# load constant value 1 into $t0
	# IfZ _tmp14 Goto _L5
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp14 from $t0 to $fp-16
	beqz $t0, _L5	# branch if _tmp14 is zero 
	# _tmp15 = "\nEnter the fibonacci number you want: (-1 to qui..."
	.data			# create string constant marked with label
	_string2: .asciiz "\nEnter the fibonacci number you want: (-1 to quit) "
	.text
	la $t0, _string2	# load label
	# PushParam _tmp15
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -20($fp)	# spill _tmp15 from $t0 to $fp-20
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp16 = LCall _ReadInteger
	jal _ReadInteger   	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# n = _tmp16
	move $t1, $t0		# copy value
	# _tmp17 = 0
	li $t2, 0		# load constant value 0 into $t2
	# _tmp18 = 1
	li $t3, 1		# load constant value 1 into $t3
	# _tmp19 = _tmp17 - _tmp18
	sub $t4, $t2, $t3	
	# _tmp20 = n == _tmp19
	seq $t5, $t1, $t4	
	# IfZ _tmp20 Goto _L6
	# (save modified registers before flow of control change)
	sw $t0, -24($fp)	# spill _tmp16 from $t0 to $fp-24
	sw $t1, -8($fp)	# spill n from $t1 to $fp-8
	sw $t2, -28($fp)	# spill _tmp17 from $t2 to $fp-28
	sw $t3, -36($fp)	# spill _tmp18 from $t3 to $fp-36
	sw $t4, -32($fp)	# spill _tmp19 from $t4 to $fp-32
	sw $t5, -40($fp)	# spill _tmp20 from $t5 to $fp-40
	beqz $t5, _L6	# branch if _tmp20 is zero 
	# Goto _L5
	b _L5		# unconditional branch
	# Goto _L7
	b _L7		# unconditional branch
_L6:
_L7:
	# _tmp21 = "Fib("
	.data			# create string constant marked with label
	_string3: .asciiz "Fib("
	.text
	la $t0, _string3	# load label
	# PushParam _tmp21
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -44($fp)	# spill _tmp21 from $t0 to $fp-44
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam n
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load n from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp22 = ") = "
	.data			# create string constant marked with label
	_string4: .asciiz ") = "
	.text
	la $t0, _string4	# load label
	# PushParam _tmp22
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -48($fp)	# spill _tmp22 from $t0 to $fp-48
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam n
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, -8($fp)	# load n from $fp-8 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp23 = LCall __fib
	jal __fib          	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp23
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp23 from $t0 to $fp-52
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp24 = "\n"
	.data			# create string constant marked with label
	_string5: .asciiz "\n"
	.text
	la $t0, _string5	# load label
	# PushParam _tmp24
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -56($fp)	# spill _tmp24 from $t0 to $fp-56
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# Goto _L4
	b _L4		# unconditional branch
_L5:
	# _tmp25 = "Goodbye!\n"
	.data			# create string constant marked with label
	_string6: .asciiz "Goodbye!\n"
	.text
	la $t0, _string6	# load label
	# PushParam _tmp25
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -60($fp)	# spill _tmp25 from $t0 to $fp-60
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
