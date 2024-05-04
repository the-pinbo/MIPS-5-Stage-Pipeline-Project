.text
fib:
    addi $t0, $zero, 0x1
    addi $t1, $zero, 0x1
    addi $t2, $zero, 0x5
loop:
    beq $t2, $zero, done
    addi $t2, $zero, -0x1
    add $s0, $t1, $t0
    add $t0, $zero, $t1
    add $t1, $zero, $s0
    j loop
    add $zero, $zero, $zero
done:
