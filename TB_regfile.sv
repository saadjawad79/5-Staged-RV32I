module tb_reg (
);


localparam Data_width= 32 ;

logic Clk=0;
logic Rst=0;
logic read;
logic write;
logic [4:0] src1_add ;
logic [4:0] src2_add ;
logic [4:0] dest_add ;
logic [Data_width-1:0] dest_data;
logic [Data_width-1:0] src1_data;
logic [Data_width-1:0] src2_data;
    
    
always begin
    #10
    Clk=~Clk;
end

Reg_file inst(.*);


initial begin
    #100
    Rst=1;
    #50
    repeat(15) @(posedge Clk)begin
    read=$random;
    write=$random;
    src1_add =$random;
    src2_add =$random;
    dest_add =$random;
    dest_data=$random;
    end

end


endmodule