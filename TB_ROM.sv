module tb_ROM (
);


localparam ADD_WIDTH = 5 ;
localparam INST_WIDTH=32;
logic Clk=0;
logic [ADD_WIDTH-1:0] PC_out;
logic [INST_WIDTH-1:0] Inst_out;    



always begin
    #10
    Clk=~Clk;
end

ROM inst(.*);


initial begin
    repeat(10) @(posedge Clk)begin
    PC_out=$random;
    end

end


endmodule