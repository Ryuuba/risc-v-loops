# s1 <-> max, s2 <-> accum
        addi s1, zero, 0
        addi s2, zero, 0
        j    for1
L1:     addi s1, s1, 1
for1:   blt  s1, s2, L1
        nop