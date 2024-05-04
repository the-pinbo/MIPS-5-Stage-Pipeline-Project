# fact_n => $s1
# count => $s0
# count => $t1
.text
INIT:
    addi $s0, $zero, 0x6
    addi $t0, $zero, 0x1
    addi $s1, $zero, 0x1
LOOP:
    beq $t0, $s0, DONE
    mul  $s1, $s1  , $t0
    addi $t0, $t0, 0x1
    j LOOP
DONE:
    addi $t9, $zero, 0x1

