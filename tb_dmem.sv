module tb_dmem (
);


localparam DATA_WIDTH = 32 ;
localparam D_ADD_WIDTH= 5;
logic Clk=0;

logic Rst=0;
logic [DATA_WIDTH-1:0] Mem_in;
logic [D_ADD_WIDTH-1:0] Mem_addr;
logic [1:0] sel;
logic write;
logic read;
logic [DATA_WIDTH-1:0] Mem_out;

always begin
    #10
    Clk=~Clk;
end

Data_mem inst(.*);

initial begin
    #100
    Rst=1;
    repeat(20)begin
    @(posedge Clk);
    Mem_in=$random;
    Mem_addr=$random;
    sel=$random;
    write=$random;
    @(posedge Clk);
    read=write;
    end
    repeat(10)begin
    @(posedge Clk);
    Mem_in=$random;
    Mem_addr=$random;
    sel=$random;
    write=$random;
    read=~write;
    end

end


    
endmodule