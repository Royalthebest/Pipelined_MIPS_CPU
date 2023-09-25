# Pipelined_MIPS_CPU

This project is an Verilog implementation of MIPS pipelined CPU with 10 arithmetic instructions and 4 branch instructions. This implementation uses the following two techniques to improve the performance.

1. Pipelined with 5 stages: Instruction Fetch(IF), Instruction Decode(ID), Execute(EX), Memory Access(MEM), and Write Back(WB). This implementation allows multiple instructions to be executed in the CPU at the same time to improve the throughput of MIPS-CPU.

2. Hazard detection and Data forwarding. The hazard detection unit can detect the occurrence of data hazard and the forwarding unit can ensure the used data is correct. This implementation can reduce the insertion of NOP instruction due to the data hazard and decrease the number of stall cycle in Pipelined-CPU.  

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


