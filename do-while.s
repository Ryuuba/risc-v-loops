# s1 <-> accum, s2 <-> max
        addi accum, zero, 0
        addi max, zero, 0
do1:    addi accum, accum, 1
        blt  accum, max, do1
        nop