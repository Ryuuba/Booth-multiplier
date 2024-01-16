.globl main
main:


.globl booth_multiplier
booth_multiplier:
    # frame creation
    addi sp, sp, -32
    lw   ra, 32(fp)
    lw   fp, 28(fp)
    addi fp, sp, 32
    # int counter = 8
    li   t0, 8
    sw   t0, -16(fp)
    # int result = 0x0000FFFF & q
    li   t0, 0x0000FFFF
    and  t0, t0, a1
    sw   t0, -20(fp)
    # int booth_modifier = (0x00000003 & result) << 1;
    lw   t0, -20(fp)
    andi t0, t0, 3
    slli t0, t0, 1
    sw   t0, -24(fp)
    # while (counter > 0)
    j    L1
    # result = result >> 1;
    lw   t0, -20(fp)
    srli t0, t0, 1
    sw   t0, -20(fp)
    # If (booth_modifier == 1 || booth_modifier == 2)
    lw   t0, -24(fp)
    li   t1, 1
    beq  t0, t1, L2
    li   t1, 2
    bne  t0, t1, L3
    # result += m << 15;
L2: slli t0, a0, 15
    lw   t1, -20(fp)
    addi t0, t0, t1
    sw   t0, -20(fp)
    j    L4
L3: # else if (booth_modifier == 3)
    lw   t0, -24(fp)
    li   t1, 3
    bne  t0, t1, L5
    # result += m << 16;
    slli t0, a0, 16
    lw   t1, -20(fp)
    addi t0, t0, t1
    sw   t0, -20(fp)
    j    L4