addi $t0 $zero 0x1
addi $s2 $zero 0x2
sub $t1 $s2 $t0 //$t1 should have 1
beq $t0 $s2 0x4 //not taken
beq $t0 $t1 0x5 //taken
addi $s0 $zero 0x1
addi $s0 $s0 0x1
addi $s0 $s0 0x1
addi $s0 $s0 0x1
addi $s0 $s0 0x1
sw $s2 0x8($zero) //beq will go to here
slt $s1 $t0 $s2
lw $s3 0x8($zero)
add $s4 $s3 $s1