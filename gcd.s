# s1 <-> a, s2 <-> b, s3 <-> gcd, s4 <-> aux, s5 <-> r
        addi s1, zero, 120      # a <- 15
        addi s2, zero, 30       # b <- 150
        add  s3, zero, s2       # gcd <- b
        add  s4, zero, s1       # aux <- a
        rem  s5, s4, s3         # r <- aux % gcd
        j    wh1                # jumps to while condition
LW1:    add  s4, zero, s3       # aux <- gcd
        add  s3, zero, s5       # gcd <- r
        rem  s5, s4, s3         # r <- aux % gcd
wh1:    bne  s5, zero, LW1      # branches to LW1 if r != 0
        nop