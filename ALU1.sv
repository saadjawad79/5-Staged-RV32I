import core :: *;



module ALU1#(parameter Data_Width=32)(
    input logic [Data_Width-1:0] op1,
    input logic [Data_Width-1:0] op2,
    input ALU_OP operation,
    output logic [Data_Width-1:0]  out_data
);


logic[4:0] shift_amount;

assign shift_amount=op2[4:0];


always_comb
    begin
        case(operation)
        
        ADD: begin  
            out_data=$signed(op1)+$signed(op2); 
                    if(op1[31] & op2[31] & ~out_data[31])
                        out_data=32'h80000000;
                    else if (~op1[31] & ~op2[31] & out_data[31])
                        out_data=32'h7FFFFFFF;
                    else
                        out_data=out_data;
                                    
                                    end

        SUB: begin 
                out_data= $signed(op2)-$signed(op1);
                     
                    if(~op1[31] & op2[31] & ~out_data[31])
                        out_data=32'h80000000;
                    else if (op1[31] & ~op2[31] & out_data[31])
                        out_data=32'h7FFFFFFF;
                    else
                        out_data=out_data;

                                            end

        AND:out_data=op2&op1;
        XOR:out_data=op2^op1;
        OR:out_data=op2|op1;
        SLL:out_data=op1<<shift_amount;
        SRL:out_data=op1>>shift_amount;
        SRA:begin  out_data= $signed(op1)>>>shift_amount; end 
        SLT: out_data=($signed(op1)<$signed(op2))?1:0;
        SLTU: out_data=($unsigned(op1)<$unsigned(op2))?1:0;
        BEQ: out_data = op1 == op2;
        BNE: out_data = op1!=op2;
        BLT: out_data = $signed(op1) < $signed(op2);
        BGE: out_data = $signed(op1) >= $signed(op2);
        BGEU: out_data = $unsigned(op1) >= $unsigned(op2);
        BLTU: out_data = $unsigned(op1) < $unsigned(op2);
        default: out_data =out_data;
        
        
        endcase

    end






    
endmodule