lw $t0, 64($zero)
lw $t1, 68($zero)
lw $t2, 72($zero)
lw $t3, 76($zero)
lw $t4, 80($zero)
add $t5, $t0, $zero
sw $t5, 84($zero)
add $t6, $t0, $t1
sub $t7, $t1, $t2
slt $t8, $t2, $t3
beq $zero, $zero, done
add $t0, $t0, $t1
add $t1, $t1, $t2
add $t2, $t2, $t3
add $t3, $t3, $t5
add $t4, $t4, $t6
done:
