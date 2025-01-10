module tb_main (
);



logic Clk=0;
logic Rst=0;

always begin
#10
Clk=~Clk;
end


main inst(.*);

initial begin
#100
Rst=1;
end



    
endmodule