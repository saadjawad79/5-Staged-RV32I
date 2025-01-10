module tb_division;

    // Inputs
    logic Clk;
    logic Rst;
    logic data_valid=0;
    // logic [15:0] Remainder_reg;
    logic [DATA_WIDTH-1:0] Divisor;
    logic [DATA_WIDTH-1:0] Divident;
    logic out_valid;
    localparam DATA_WIDTH = 8;

    // Instantiate the module under test
    division #(DATA_WIDTH)uut (
        .Clk(Clk),
        .Rst(Rst),
        .data_valid(data_valid),
        .Divisor(Divisor),
        .Divident(Divident),
        .out_valid(out_valid)
    );

    // Clock generation
    always #10 Clk = ~Clk; // Generate a clock with a period of 10 time units

    // Test sequence
    initial 
    begin
        // Initialize signals
        Clk = 0;
        Rst = 0;
        Divisor = 0;
        Divident=0;
        #100
        Rst=1;
        #50
        data_valid=1;
        Divident=8'b01001000;
        Divisor=8'b00011000;
        #20
        data_valid=1;
        Divident=-7;
        Divisor=-3;
        #20
        data_valid=0;
    end
endmodule
