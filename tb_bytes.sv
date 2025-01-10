
module Byte_unit_tb;

    // Parameters
    parameter DATA_WIDTH = 32;

    // Testbench signals
    logic [DATA_WIDTH-1:0] in_data=0;
    logic [1:0] sel=0;
    logic [DATA_WIDTH-1:0] out_data;

    // Instantiate the DUT (Device Under Test)
    Byte_unit #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .in_data(in_data),
        .sel(sel),
        .out_data(out_data)
    );

    // Test sequence

    initial
    begin


        repeat(100)
        begin
            #100
            sel=$random;
            in_data=$random;
        end


    end


endmodule
