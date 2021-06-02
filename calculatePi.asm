.text

main:

# Initialize the random number generator seed

li	$v0, 30		# get time in milliseconds (as a 64-bit value)
syscall

move	$t0, $a0	# save the lower 32-bits of time , chuyen a0 vao t0

# seed the random generator (just once)
li	$a0, 1		# random generator id (will be used later)
move 	$a1, $t0	# seed from time
li	$v0, 40		# seed random number generator syscall
syscall		# Initialize RNG via syscall

# Compute and print n random floating point values
	lwc1 	$f3,num1
	lwc1	$f6,num2
	la	$t4, n		# address of n
	lw	$t4, 0($t4)	# t4 = n
	and	$t0, $0, $0	# i = 0 #t0 = i = 0\
	and 	$t1, $0, $0	#t1 = 0 tong so diem nam trong hinh tron

loop1:
	#in so thu nhat	 # Compute Random Number
	li	$a0, 0		# Load RNG ID (0 in this case) into $a0
	li	$v0, 43		# Load 43=random_float into $v0
	syscall			# $f0 gets the random number

				# Print Random Number
	mov.s	$f12, $f0	# Copy $f0 to $f12
		# print value in $f12
	
	mov.s 	$f1,$f0
	#ket thuc in so thu nhat
	#in dau phân cách 2 so
	#in so thu 2
	li	$a0, 0		# Load RNG ID (0 in this case) into $a0
	li	$v0, 43		# Load 43=random_float into $v0
	syscall			# $f0 gets the random number

				# Print Random Number
	mov.s	$f12, $f0	# Copy $f0 to $f12
	
	mov.s 	$f2,$f0        #copy f0 vao f2
j insidePoint
        #-------------------------------------------------------#
next:
	addi	$t0, $t0, 1	# increment i (i++)
	slt	$t5, $t0, $t4	# is $t0 < n ? ---- if ($t0 < $t4) $t5 = 1; else $t5 = 0 ( ? ?ây t4=n , t0 = i)
	bne	$t5, $0, loop1	# branch if so ( if(t5!=0) go to loop1)

j finish

insidePoint:
	mul.s   $f1,$f1,$f1     #tinh f1 ^2
	mul.s   $f2,$f2,$f2      #tinh f2 ^2
	add.s   $f0,$f1,$f2      #tinh tong f1^2 va f2^2 cho vao $f0

	mov.s	$f12, $f0	# Copy $f0 to $f12
	c.le.s $f12,$f3     # if $f12(100) <= $f1(122.12) nhay xuong cout
  	bc1t totalPoint	
j next

totalPoint :
		addi	$t1, $t1, 1 #tong cac diem nam trong duong tron
j next
	


# Exit Gracefully exit (terminate execution)
finish:
#print --------------------- t1 ---------------------------
	li	$v0, 4		# Load 4=print_string into $v0
	la	$a0, totalPointIs	# Load address of totalPointIs into $a0 --- xu?ng dòng
	syscall	
	add $a0,$zero,$t1 
	addi $v0,$zero,1
	syscall
#print Pi --------------------------------------------------
	li	$v0, 4		# Load 4=print_string into $v0
	la	$a0, newline
	syscall
	li  $v0, 1	
	mtc1 $t1,$f1
	mtc1 $t4,$f2
	cvt.s.w $f1, $f1
	cvt.s.w $f2, $f2
	div.s $f12,$f1,$f2
	mul.s $f12,$f12,$f6
	li	$v0, 4		# Load 4=print_string into $v0
	la	$a0, pi	# Load address of newline into $a0 --- xu?ng dòng
	syscall	
	li	$v0, 2		# Load 2=print_float into $v0 # ub ra gia tri tu $v0
	syscall

	
	#--------------------- ket thuc ---------------
	li	$v0, 10
	syscall


.data
	.align 0
n:
	.word 100000 #number of random
num1:	.float 1.0
num2: 	.float 4.0
newline:
	.asciiz "\n"
spacevalue:
	.asciiz "-------"
totalPointIs:
	.asciiz "total Point is: "
pi:
	.asciiz "pi = "
point:
	.asciiz "."
