package core;

typedef enum logic[6:0] { 
    
    LOAD = 7'b0000011, 
    STORE = 7'b0100011, 
    R_TYPE= 7'b0110011, 
    IMM= 7'b0010011, 
    LUI= 7'b0110111, 
    AUIPC= 7'b0010111,
    BRANCH= 7'b1100011, 
    JAL= 7'b1101111, 
    JALR= 7'b1100111, 
    NOP=7'b0000000 
    
    } OP_Code;

typedef enum logic[3:0] { 
    ADD=0,
    SUB=1,
    XOR=2,
    OR=3,
    AND=4,
    SLL=5,
    SRL=6,
    SRA=7,
    SLT=8,
    SLTU=9,
    BEQ=10,
    BNE=11,
    BLT=12,
    BGE=13,
    BLTU=14,
    BGEU=15
} ALU_OP;

endpackage