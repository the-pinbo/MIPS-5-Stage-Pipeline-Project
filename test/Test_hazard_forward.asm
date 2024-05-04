lw $s1 , 64($zero)
add $s1, $s1, $s1
beq $s1, $s1, check
sw $s1, 80($zero)
check: lw $s2, 68($zero)
add $s1, $s1, $s2
sw $s1, 80($zero)
done: 