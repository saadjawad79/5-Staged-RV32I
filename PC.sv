module PC #(parameter ADD_WIDTH=5) (
    input logic Clk,
    input logic Rst,
    input logic Stall,
    input logic J,
    input logic [ADD_WIDTH-1:0] PC_J_add,
    // input logic Start,
    output logic Ready,
    output logic [ADD_WIDTH-1:0] PC_out
);



assign Ready=~Stall;


always_ff @(posedge Clk, negedge Rst) begin
    if(~Rst)
 
        PC_out<=0;
 
    else if(Stall)
 
        PC_out<=PC_out;
 
    else if(J)

        PC_out<=PC_J_add;

    else

        PC_out<=PC_out+4;
end








    
endmodule