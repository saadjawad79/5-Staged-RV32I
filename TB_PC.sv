module tb_PC (
);


localparam ADD_WIDTH = 5 ;

logic Clk=0;
logic Rst=0;
logic Stall=0;
logic Ready;
logic [ADD_WIDTH-1:0] PC_out;
    


always begin
    #10
    Clk=~Clk;
end

PC inst(.*);


initial begin
    #100
    Rst=1;
    #50
    repeat(10) @(posedge Clk)begin
    Stall=$random;
    end

end


endmodule