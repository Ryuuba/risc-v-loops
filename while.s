# s1 <-> accum, s2 <-> max
        addi s1, zero, 0
        addi s2, zero, 0
        j    wh1
L1:     addi s1, s1, 1
wh1:    blt  s1, s2, L1
        nop