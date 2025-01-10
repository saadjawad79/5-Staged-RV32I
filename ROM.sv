module ROM #(parameter ADD_WIDTH=5, INST_WIDTH=32)(
    input logic[ADD_WIDTH-1:0] PC_out,
    output logic [INST_WIDTH-1:0] Inst_out
);



logic [INST_WIDTH-1:0] rom_depth[2**(ADD_WIDTH)-1:0];



initial $readmemh("rom2.hex",rom_depth);

assign Inst_out=rom_depth[PC_out];


    
endmodule