# Pipelined_MIPS_CPU

## This project is an implementation of MIPS pipelined CPU with 10 arithmetic instructions and 4 branch instructions which supports hazard detection and data forwarding. 
The 10 arithmetic instructions are as follows:
1. ADD
2. ADDI
3. SUB
4. AND
5. OR
6. SLT
7. SLTI
8. LW
9. SW
10. MUTI

The 4 branch instructions are as follows:
1. BEQ
2. BNE
3. BGE
4. BGT

## There are two testbenches used in this project. 
The first one is 
1. addi $1,$0,16
2. mult $2,$1,$1
3. addi $3,$0,8
4. sw $1,4($0)
5. lw $4,4($0)
6. sub $5,$4,$3
7. add $6,$3,$1
8. addi $7,$1,10
9. and $8,$7,$3
10. slt $9,$8,$7

The second one is 
1. addi $2, $0, 3
2. sw $2, 0($0)
3. addi $2, $0, 1
4. sw $2, 4($0)
5. sw $0, 8($0)
6. addi $2, $0, 5
7. sw $2, 12($0)
8. addi $2, $0, 0
9. addi $5, $0, 16
10. addi $8, $0, 2
11. beq $0, $0, 2
12. addi $2, $2, 4
13. bge $2, $5, 6
14. lw $3, 0($2)
15. bgt $3, $8, 1
16. beq $0, $0, -5
17. addi $3, $3, 1
18. sw $3, 0($2)
19. beq $0, $0, -8
