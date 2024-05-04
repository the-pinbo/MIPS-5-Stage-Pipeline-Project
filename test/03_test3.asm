addi $s1 $zero 0x1
sw $s1 0x4($zero)
addi $s2 $s1 0x2
lw $s0 0x4($zero)
add $t0 $s0 $s1
add $t1 $s2 $s0
add $t2 $s0 $s2