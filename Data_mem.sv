module Data_mem #(parameter DATA_WIDTH=32, D_ADD_WIDTH=5)(
    input logic  Clk, 
    input logic  Rst,
    input logic [DATA_WIDTH-1:0] Mem_in,
    input logic [D_ADD_WIDTH-1:0] Mem_addr,
    input logic [2:0] sel,
    input logic write, 
    input logic read, 
    output logic [DATA_WIDTH-1:0] Mem_out
);


Byte_unit #(DATA_WIDTH) unit(
        .sel(sel),
        .in_data(Mem_out_temp),
        .out_data(Mem_out)
);


logic [DATA_WIDTH-1:0] Mem_out_temp;
logic [7:0] Mem [(2**D_ADD_WIDTH)-1:0];


initial $readmemh("d_mem.hex",Mem);

always_comb begin
    if(read) 
    begin
    
        Mem_out_temp[0+:8]=Mem[Mem_addr];
        Mem_out_temp[8+:8]=Mem[Mem_addr+1];
        Mem_out_temp[16+:8]=Mem[Mem_addr+2];
        Mem_out_temp[24+:8]=Mem[Mem_addr+3];

    end
    else 
        Mem_out_temp=Mem_out_temp;
end

always_ff @(posedge Clk, negedge Rst)
    begin
        
        if(~Rst) begin
            for(int i=0; i<2**D_ADD_WIDTH ; ++i)
                Mem[i]<=0;
        end

        else if (write) begin
            case(sel)
            0:  begin Mem[Mem_addr]<=Mem_in[0+:8]; Mem[Mem_addr+1]<=Mem_in[8+:8]; Mem[Mem_addr+2]<=Mem_in[16+:8]; Mem[Mem_addr+3]<=Mem_in[24+:8]; end // W

            1:  begin Mem[Mem_addr]<=Mem_in[0+:8]; Mem[Mem_addr+1]<=Mem_in[8+:8]; Mem[Mem_addr+2]<=Mem[Mem_addr+2]; Mem[Mem_addr+3]<=Mem[Mem_addr+3]; end // H

            2:  begin Mem[Mem_addr]<=Mem_in[0+:8]; Mem[Mem_addr+1]<=Mem[Mem_addr+1]; Mem[Mem_addr+2]<=Mem[Mem_addr+2]; Mem[Mem_addr+3]<=Mem[Mem_addr+3]; end // B

            default : Mem[Mem_addr]=Mem[Mem_addr];

            endcase
        end

    end


endmodule