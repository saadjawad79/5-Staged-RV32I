import core::*;


module main
#(parameter ADD_WIDTH=6, INST_WIDTH=32, DATA_WIDTH=32, REG_NO=8, D_ADD_WIDTH=5)
(
    input logic Clk,
    input logic Rst
//    output logic [DATA_WIDTH-1:0] alu_out
);

//assign alu_out=ALU1_Out;
    



    //////////////////////////////////////////
    ///////// FETCH variables //////////////////
    /////////////////////////////////////////
    logic Stall;
    logic Ready;
    logic [ADD_WIDTH-1:0] PC_out;
    logic [ADD_WIDTH-1:0] PC_J_add;
    logic [INST_WIDTH-1:0] Inst_out;



//********************************************************************//



    //////////////////////////////////////////
    ///////// DECODE variables //////////////////
    /////////////////////////////////////////

    logic [INST_WIDTH-1:0] Inst_out_FD;
    logic [$clog2(REG_NO)-1:0] src1_add;
    logic [$clog2(REG_NO)-1:0] src2_add;
    logic [$clog2(REG_NO)-1:0] dest_add;
    logic [DATA_WIDTH-1:0] Ext_out;
    logic [DATA_WIDTH-1:0] src1_data;
    logic [DATA_WIDTH-1:0] src2_data;
    logic WB_sel;
    logic R_read;
    logic R_write;
    logic J;
    logic JR;
    logic BR;
    logic B_taken;
    logic Im_sel;
    logic M_write;
    logic M_read;
    ALU_OP Operation;
    logic [2:0] sel;
    logic [1:0] UI_sel;
    logic [2:0] func3;
    logic [6:0] func7;
    OP_Code op_code;
    OP_Code op_code_d;
    logic [ADD_WIDTH-1:0] PC_out_FD;




//********************************************************************//


    //////////////////////////////////////////
    ///////// EXECUTE variables //////////////////
    /////////////////////////////////////////

    logic [$clog2(REG_NO)-1:0] dest_add_ED;
    logic [DATA_WIDTH-1:0] src2_data1;
    logic [DATA_WIDTH-1:0] Ext_out_ED;
    logic [DATA_WIDTH-1:0] src1_hazard_out;
    logic [DATA_WIDTH-1:0] src2_hazard_out;
    logic [DATA_WIDTH-1:0] src1_data_ED;
    logic [DATA_WIDTH-1:0] src2_data_ED;
    logic [DATA_WIDTH-1:0] ALU1_Out;
    logic [$clog2(REG_NO)-1:0] src1_add_ED;
    logic [$clog2(REG_NO)-1:0] src2_add_ED;
    logic [$clog2(REG_NO)-1:0] sw_add_ED;
    logic [ADD_WIDTH-1:0] PC_out_ED;
    ALU_OP Operation_ED;
    logic R_write_ED;
    logic J_ED;
    logic JR_ED;
    logic BR_ED;
    logic Im_sel_ED;
    logic WB_sel_ED;
    logic [2:0] sel_ED;
    logic M_write_ED;
    logic [1:0] UI_sel_ED;
    logic M_read_ED;
    logic [1:0] A;
    logic [1:0] B;
    logic C;


//********************************************************************//



    //////////////////////////////////////////
    ///////// MEMORY variables //////////////////
    /////////////////////////////////////////

    logic [$clog2(REG_NO)-1:0] dest_add_ME;
    logic [$clog2(REG_NO)-1:0] sw_add_ME;
    logic [DATA_WIDTH-1:0] src2_data_ME;
    logic [DATA_WIDTH-1:0] WB_data;
    logic [DATA_WIDTH-1:0] ALU1_Out_ME;
    logic [DATA_WIDTH-1:0] Mem_in;
    logic [DATA_WIDTH-1:0] hazard_mem;
    logic [DATA_WIDTH-1:0] Mem_out;
    logic [D_ADD_WIDTH-1:0] Mem_addr;
    logic R_write_ME;
    logic [2:0] sel_ME;
    logic WB_sel_ME;
    logic M_write_ME;
    logic M_read_ME;
    logic [DATA_WIDTH-1:0] Aes_out;


//********************************************************************//

    //////////////////////////////////////////
    ///////// WRITE bACK variables //////////////////
    /////////////////////////////////////////
    logic R_write_WM;
    logic [DATA_WIDTH-1:0] WB_data_WM;
    logic [$clog2(REG_NO)-1:0] dest_add_WM;


//********************************************************************//


    //////////////////////////////////////////
    //////// ASSIGNMENTS/////////////////////
    /////////////////////////////////////////


    assign src1_add=Inst_out_FD[19:15];
    assign src2_add=Inst_out_FD[24:20];
    assign dest_add=Inst_out_FD[11:7];
    assign Mem_in=src2_data_ME;
    assign func3=Inst_out_FD[14:12];
    assign func7=Inst_out_FD[31-:7];
    assign B_taken= (BR_ED & ALU1_Out[0]);

//********************************************************************//



    ///////////////////////////////////////
    //////// ENUMS ///////////////////////
    //////////////////////////////////////
    // Assign op_code based on some input instruction
    always_comb begin
        case (Inst_out_FD[0+:7]) // Extracting opcode from instruction bits
            7'b0000011: op_code = LOAD;
            7'b0100011: op_code = STORE;
            7'b0110011: op_code = R_TYPE;
            7'b0010011: op_code = IMM;
            7'b0110111: op_code = LUI;
            7'b0010111: op_code = AUIPC;
            7'b1101111: op_code = JAL;
            7'b1100111: op_code = JALR;
            7'b1100011: op_code = BRANCH;
            default:    op_code = NOP; // Default or no-operation code
        endcase
    end



//********************************************************************//


    ///////////////////////////////////////
    //////// FETCH ///////////////////////
    //////////////////////////////////////




    PC #(ADD_WIDTH) pc
    
    (
        .Clk(Clk),
        .Rst(Rst),
        .Stall(Stall),
        .PC_J_add(PC_J_add),
        .J(J_ED | B_taken),
        .Ready(Ready),
        .PC_out(PC_out)
    );






    ROM #(ADD_WIDTH, INST_WIDTH) inst
    
    (
        .PC_out(PC_out),
        .Inst_out(Inst_out)
    );



//********************************************************************//



    always_ff @(posedge Clk, negedge Rst)
        begin
        
        if(~Rst) 

            begin
            
                Inst_out_FD<=0;
                PC_out_FD<=0;
                // PC_inc_FD<=0;

            end


        else if( J_ED | B_taken)

            begin
            
                Inst_out_FD<=0;
                PC_out_FD<=0;
                // PC_inc_FD<=0;

            end



        else if(Stall)
            begin
                
                Inst_out_FD<= Inst_out_FD;
                PC_out_FD<=PC_out_FD;
                // PC_inc_FD<=PC_inc_FD;
            end
        
        else
        
            begin
                PC_out_FD<=PC_out;
                Inst_out_FD<= Inst_out;
                // PC_inc_FD<=PC_inc;

            end
        end



//********************************************************************//



    Control_unit c_unit
    (
        .Clk(Clk),
        .Rst(Rst),
        .op_code(op_code),
        .func3(func3),
        .func7(func7[6]),
        .Stall(Stall),
        .R_read(R_read),
        .M_read(M_read),
        .R_write(R_write),
        .M_write(M_write),
        .Im_sel(Im_sel),
        .WB_sel(WB_sel),
        .sel(sel),
        .J(J),
        .BR(BR),
        .JR(JR),
        .UI_sel(UI_sel),
        .Operation(Operation)
        );


    stall_check #(REG_NO) stall
    (   
        .Clk(Clk),
        .Rst(Rst),
        .op1(op_code),
        .op_d(op_code_d),
        .src1(src1_add),
        .src2(src2_add),
        .src_d(dest_add_ED),
        .Stall(Stall)
    );




//********************************************************************//



    ///////////////////////////////////////
    //////// DECODE ///////////////////////
    //////////////////////////////////////





    sign_ext #(INST_WIDTH, DATA_WIDTH) ext
    
    (   .op_code(op_code),
        .Inst_out(Inst_out_FD),
        .Ext_out(Ext_out)
    );





    Reg_file #(DATA_WIDTH, REG_NO) Reg
    
    (
        .Clk(Clk),
        .Rst(Rst),
        .read(R_read),
        .write(R_write_WM&&~Stall),
        .src1_add(src1_add),
        .src2_add(src2_add),
        .dest_add(dest_add_WM),
        .dest_data(WB_data_WM),
        .src1_data(src1_data),
        .src2_data(src2_data)
    );


//********************************************************************//


    // REG DECODE-> EXECUTE

    always_ff @(posedge Clk, negedge Rst)
       
        begin
       
            if(~Rst) 

            begin
                op_code_d <= NOP;
                src1_data_ED<=0;
                src2_data_ED<=0;
                dest_add_ED<=0;
                Ext_out_ED <=0;
                Operation_ED<=ADD;
                UI_sel_ED<=0;
                sel_ED<=0;
                J_ED<=0;
                JR_ED<=0;
                BR_ED<=0;
                PC_out_ED<=0;
                src1_add_ED<=0;
                src2_add_ED<=0;
                M_read_ED<=0;
                M_write_ED<=0;
                sw_add_ED<=0;
                WB_sel_ED<=0;
                R_write_ED<=0;
                Im_sel_ED<=0;
            end



            else if(J_ED | B_taken)

            begin
                op_code_d <= NOP;
                src1_data_ED<=0;
                src2_data_ED<=0;
                dest_add_ED<=0;
                Ext_out_ED <=0;
                Operation_ED<=ADD;
                UI_sel_ED<=0;
                sel_ED<=0;
                J_ED<=0;
                JR_ED<=0;
                BR_ED<=0;
                PC_out_ED<=0;
                src1_add_ED<=0;
                src2_add_ED<=0;
                M_read_ED<=0;
                M_write_ED<=0;
                sw_add_ED<=0;
                WB_sel_ED<=0;
                R_write_ED<=0;
                Im_sel_ED<=0;
            end

            else

            begin
                op_code_d <= op_code;
                src1_data_ED<=src1_data;
                src2_data_ED<=src2_data;
                src1_add_ED<=src1_add;
                src2_add_ED<=src2_add;
                sw_add_ED<=src2_add;
                PC_out_ED<=PC_out_FD;
                UI_sel_ED<= UI_sel;
                // PC_inc_ED<=PC_inc_FD;
                J_ED<=J;
                JR_ED<=JR;
                BR_ED<=BR;
                sel_ED <= sel;
                dest_add_ED<=dest_add;
                Operation_ED<=Operation;
                Ext_out_ED<=Ext_out;
                M_read_ED<=M_read;
                M_write_ED<=M_write;
                WB_sel_ED<=WB_sel;
                R_write_ED<=R_write;
                Im_sel_ED<=Im_sel;
            end

        end






//********************************************************************//


    ///////////////////////////////////////
    //////// EXECUTE ///////////////////////
    //////////////////////////////////////


    always_comb begin 
        
        
        case(A)
        
        0: 
        begin 

            case(UI_sel_ED)

            0: src1_hazard_out=src1_data_ED;

            1: src1_hazard_out=0;

            2: src1_hazard_out=PC_out_ED;

            endcase

        end

        
        1: src1_hazard_out=WB_data_WM;
        
        2: src1_hazard_out= WB_data;
        
        default: src1_hazard_out=0;
        
        endcase
        
    end


    always_comb begin 
        
        if(Im_sel_ED)
            src2_hazard_out=Ext_out_ED;
        
        else

        case(B)
        
        0: begin 
            
            if(J_ED)
            
            src2_hazard_out=4;
            
            else

            src2_hazard_out=src2_data_ED; 
            
            
            end
        
        1:  src2_hazard_out=WB_data_WM;
        
        2: src2_hazard_out= WB_data;
        
        default: src2_hazard_out=0;
        endcase
        
        
    end



    hazard #(REG_NO) h_unit(
        .src1_add(src1_add_ED),
        .src2_add(src2_add_ED),
        .sw_add_ME(sw_add_ME),
        .dest_add_ME(dest_add_ME),
        .dest_add_WB(dest_add_WM),
        .R_write_ME(R_write_ME),
        .R_write_WB(R_write_WM),
        .A(A),
        .B(B),
        .C(C)
    );


    always_comb 
    begin
        PC_J_add=((JR_ED)?src1_data_ED:PC_out_ED) + Ext_out_ED;
    end


    ALU1 #(DATA_WIDTH) alu1
    
    (
        .operation(Operation_ED),
        .op1(src1_hazard_out),
        .op2(src2_hazard_out),
        .out_data(ALU1_Out)
    );






//********************************************************************//





    // REG EXECUTE-> MEMORY
    always_ff @(posedge Clk, negedge Rst)
        
        begin
        
            if(~Rst) 
            
                begin
            
                    ALU1_Out_ME<=0;
                    M_read_ME<=0;
                    M_write_ME<=0;
                    sel_ME<=0;
                    dest_add_ME<=0;
                    WB_sel_ME<=0;
                    src2_data_ME<=0;
                    R_write_ME<=0;
                    sw_add_ME<=0;
            
                end
            
            else
            
                begin
            
                    ALU1_Out_ME<=ALU1_Out;
                    M_write_ME<=M_write_ED;
                    M_read_ME<=M_read_ED;
                    sw_add_ME<=sw_add_ED;
                    sel_ME<=sel_ED;
                    dest_add_ME<=dest_add_ED;           
                    WB_sel_ME<=WB_sel_ED;
                    src2_data_ME<=src2_data_ED;
                    R_write_ME<=R_write_ED;
            
                end

        end




//********************************************************************//


    ///////////////////////////////////////
    //////// MEMORY ///////////////////////
    //////////////////////////////////////





    always_comb begin 

        hazard_mem=(C)?WB_data_WM:Mem_in;
        

    end    



    Data_mem #(DATA_WIDTH, D_ADD_WIDTH) Dmem
    
    (
        .Clk(Clk),
        .Rst(1),
        .sel(sel_ME),
        .Mem_in(hazard_mem),
        .Mem_addr(ALU1_Out_ME[D_ADD_WIDTH-1:0]),
        .write(M_write_ME&&~Stall),
        .read(M_read_ME),
        .Mem_out(Mem_out)
    );


    /////////////////////////////////////////////////////
    //////// ADDRESS DEC ///////////////////////////
    //////////////////////////////////////////////

    logic chipselect_i;
    logic read_valid;
    always_comb 
    
    begin
            chipselect_i=(ALU1_Out_ME>=0 && ALU1_Out_ME <= 144);
    end





    AES_Cont aes(
        .clk(Clk),
        .rst(Rst),
        .chipselect_i(chipselect_i),
        .address_i(ALU1_Out_ME),
        .write(M_write_ME && ~Stall),
        .read(M_read_ME),
        .data_valid(M_write_ME),
        .write_data(hazard_mem),
        .read_data(Aes_out),
        .read_valid(read_valid)
    );




    always_comb 

        begin
            
            case(WB_sel_ME)
            
                0: WB_data=ALU1_Out_ME;

                1: WB_data=(chipselect_i && read_valid)?Aes_out:Mem_out;
            
            endcase


        end


//********************************************************************//



    ///////////////////////////////////////
    //////// WRITE_BACK ///////////////////////
    //////////////////////////////////////





    // REG MEMORY-> WRITE_BACK
    always_ff @(posedge Clk, negedge Rst)

        begin
        
            if(~Rst)
                begin
                    WB_data_WM<=0;
                    dest_add_WM<=0;
                    R_write_WM<=0;
                end

            else begin
                    dest_add_WM<=dest_add_ME;
                    WB_data_WM<=WB_data;
                    R_write_WM<=R_write_ME;
            end 

        end








endmodule