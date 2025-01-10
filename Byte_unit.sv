module Byte_unit #(parameter DATA_WIDTH=32)(
    input logic [DATA_WIDTH-1:0] in_data,
    input logic [2:0] sel,
    output logic [DATA_WIDTH-1:0] out_data
);
    


    always_comb 
    
    begin
    
        case(sel)

    0: out_data=in_data; // W

     
    1: out_data={{(DATA_WIDTH/2){in_data[(DATA_WIDTH/2)-1]}},{in_data[0+:DATA_WIDTH/2]}};   // H


    2: out_data={{(3*DATA_WIDTH/4){in_data[(DATA_WIDTH/4)-1]}},{in_data[0+:DATA_WIDTH/4]}};   // B
    
    3: out_data={{(3*DATA_WIDTH/4){1'b0}},{in_data[0+:DATA_WIDTH/4]}};   // BU
    
    4: out_data={{(DATA_WIDTH/2){1'b0}},{in_data[0+:DATA_WIDTH/2]}};   // HU
    
    default : out_data=0;


        endcase
    
    
    end




endmodule