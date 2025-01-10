import core ::*;


module stall_check #(parameter REG_NO=8) (
    input logic Clk,
    input logic Rst,
    input OP_Code op1,
    input OP_Code op_d,
    input logic [$clog2(REG_NO)-1:0] src1,
    input logic [$clog2(REG_NO)-1:0] src2,
    input logic [$clog2(REG_NO)-1:0] src_d,
    output logic Stall
);

logic cond1;
logic cond2;
logic cond_d;
logic temp_stall;

// initial
// Stall=0;

assign cond1=(((src_d==src1)|(src_d==src2)) && src_d!=0) && (op_d == LOAD && (op1 == R_TYPE) ); 
assign cond2=(((src_d==src1)) && src_d!=0) && (op_d == LOAD && (op1 == IMM) ); 



always_ff@(posedge Clk, negedge Rst)
    begin
        if(~Rst)
        
        temp_stall<=0;
    
    
    else  
    
    begin

        temp_stall<=Stall;

    end

    end

always_ff @(posedge Clk ,  negedge Rst)
    begin
        if(~Rst)
            cond_d<=0;
        else
            cond_d<=cond1|cond2;
    end


always_comb begin

if(cond1|cond2 )
        Stall = 1;
    
else if(cond_d)

    Stall=0;

else Stall=temp_stall;


end




endmodule