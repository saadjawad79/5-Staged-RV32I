module Reg_file #(parameter DATA_WIDTH=32, REG_NO=8)(
    input logic Clk,
    input logic Rst,
    input logic read,
    input logic write,
    input logic [$clog2(REG_NO)-1:0] src1_add ,
    input logic [$clog2(REG_NO)-1:0] src2_add ,
    input logic [$clog2(REG_NO)-1:0] dest_add ,
    input logic [DATA_WIDTH-1:0] dest_data,
    output logic [DATA_WIDTH-1:0] src1_data,
    output logic [DATA_WIDTH-1:0] src2_data
);



    
logic [DATA_WIDTH-1:0] Regis [REG_NO-1:0];

assign Regis[0]=0;

always_ff@(posedge Clk, negedge Rst)
begin

for(int i=1; i<REG_NO;++i) begin

    if(~Rst)
            Regis[i]<=i;

    else if(write && i ==dest_add)

        Regis[dest_add]<=dest_data;

    else 

        Regis[i]<=Regis[i];

end

end



always_comb begin  
        if(read) begin
            if(src1_add!=0 && ((src1_add==dest_add) && write))
            
                src1_data=dest_data;
            
            else
            
                    src1_data=Regis[src1_add];
        
            if(src2_add!=0 && ((src2_add==dest_add) && write))

                src2_data=dest_data;

            else
        
                src2_data=Regis[src2_add];
        
            end

        else begin
        src1_data=0;
        src2_data=0;
        end
end





endmodule