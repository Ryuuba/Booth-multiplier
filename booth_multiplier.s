.globl main
main:
    # frame creation
    addi sp, sp, -32
    sw   ra, 32(sp)
    sw   fp, 28(sp)
    addi fp, sp, 32
    # int multiplicand = -1000, multiplier = 1000;
    li   t0, -1000
    sw   t0, -16(fp)
    li   t0, 1000
    sw   t0, -20(fp)
    # int result = booth_multiplier(multiplicand, multiplier);
    lw   a1, -20(fp)
    lw   a0, -16(fp)
    call booth_multiplier
    sw   a0, -24(fp)
    # return 0;
    li   a0, 0
    # free frame
    lw   ra, 32(sp)
    lw   fp, 28(sp)
    addi sp, sp, 32
    ret


.globl booth_multiplier
booth_multiplier:
    # frame creation
    addi sp, sp, -32
    sw   ra, 32(sp)
    sw   fp, 28(sp)
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
L8: lw   t0, -20(fp)
    srai t0, t0, 1
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
    add  t0, t0, t1
    sw   t0, -20(fp)
    j    L4
L3: # else if (booth_modifier == 3)
    lw   t0, -24(fp)
    li   t1, 3
    bne  t0, t1, L5
    # result += m << 16;
    slli t0, a0, 16
    lw   t1, -20(fp)
    add  t0, t0, t1
    sw   t0, -20(fp)
    j    L4
L5: # else if (booth_modifier == 4)
    lw   t0, -24(fp)
    li   t1, 4
    bne  t0, t1, L6
    # result -= m << 16;
    slli t0, a0, 16
    lw   t1, -20(fp)
    sub  t0, t1, t0
    sw   t0, -20(fp)
    j    L4
L6: # else if (booth_modifier == 5 || booth_modifier == 6)
    lw   t0, -24(fp)
    li   t1, 5
    beq  t0, t1, L7
    li   t1, 6
    bne  t0, t1, L4
    # result -= m << 15;
L7: slli t0, a0, 15
    lw   t1, -20(fp)
    sub  t0, t1, t0
    sw   t0, -20(fp)
    # booth_modifier = 0x00000007 & result;
L4: lw   t0, -20(fp)
    andi t0, t0, 7
    sw   t0, -24(fp)
    # result = result >> 1;
    lw   t0, -20(fp)
    srai t0, t0, 1
    sw   t0, -20(fp)
    # counter--;
    lw   t0, -16(fp)
    addi t0, t0, -1
    sw   t0, -16(fp)
L1: # counter > 0
    lw   t0, -16(fp)
    bgt  t0, zero, L8
    # return result;
    lw   a0, -20(fp)
    # Free stack
    lw   ra, 32(sp)
    lw   fp, 28(sp)
    addi sp, sp, 32
L:  j L
    ret


