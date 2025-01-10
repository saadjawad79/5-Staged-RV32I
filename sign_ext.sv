import core ::*;

module sign_ext #(parameter INST_WIDTH=32, DATA_WIDTH=32)(
    input logic [INST_WIDTH-1:0] Inst_out,
    input OP_Code op_code,
    output logic [DATA_WIDTH-1:0] Ext_out
);



always_comb begin
    case(op_code)
    LUI:Ext_out={{Inst_out[31:12]},{12{1'b0}}}; //LUI 
    AUIPC:Ext_out={{Inst_out[31:12]},{12{1'b0}}}; //AUIPC
    LOAD:Ext_out={{20{Inst_out[31]}},{Inst_out[31-:12]}}; //Load 
    STORE: Ext_out={{20{Inst_out[31]}},{Inst_out[31:25]},{Inst_out[11:7]}}; //STORE
    IMM: Ext_out={{20{Inst_out[31]}},{Inst_out[31-:12]}}; //I
    JAL : Ext_out={{12{Inst_out[31]}},{Inst_out[12+:7]},{Inst_out[20]},{Inst_out[30-:10]}};
    JALR :  Ext_out={{20{Inst_out[31]}},{Inst_out[31-:12]}};
    BRANCH: Ext_out={{19{Inst_out[31]}},{Inst_out[31]},{Inst_out[7]},{Inst_out[30-:6]},{Inst_out[8+:4]},{1'b0}};
    default: Ext_out=0;
    endcase

end
    
endmodule