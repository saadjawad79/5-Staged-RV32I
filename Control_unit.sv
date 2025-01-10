import core::*;



module Control_unit (
    input logic Clk,
    input logic Rst,
    input OP_Code op_code,
    input logic [2:0] func3,
    input logic  func7,
    input logic Stall,
    output logic R_read,
    output logic M_read,
    output logic R_write,
    output logic M_write,
    output logic Im_sel,
    output logic WB_sel,
    output logic [2:0] sel,
    output logic J,
    output logic [1:0] UI_sel,
    output logic BR,
    output logic JR,
    output ALU_OP Operation
);

always_comb begin 

    if(~Stall)

    begin       



                    R_read=0;
                    M_read=0;
                    R_write=0;
                    J=0;
                    M_write=0;
                    Im_sel=0;
                    WB_sel= 0;
                    sel=0;
                    BR=0;
                    JR=0;
                    UI_sel=0;
                    Operation=ADD;
            
            case(op_code)
        
        LOAD: begin

                    R_read=1;
                    M_read=1;
                    R_write=1;
                    M_write=0;
                    Im_sel=1;
                    JR=0;
                    J=0;
                    BR=0;
                    WB_sel= 1;
                    UI_sel=0;
                    
                    case({func3})

                    3'b000: sel=2;  // B
                    3'b001: sel=1;  // H
                    3'b010: sel=0;  // W
                    3'b100: sel=3;  // BU
                    3'b101: sel=4;  // HU
                    default : sel=0; 
                    
                    endcase
                    
                    Operation=ADD;
        
                end



        BRANCH: begin

                    R_read=1;
                    M_read=0;
                    R_write=0;
                    M_write=0;
                    Im_sel=0;
                    JR=0;
                    J=0;
                    BR=1;
                    WB_sel= 0;
                    UI_sel=0;

                    case({{func3}})
                    
                        3'b000: Operation=BEQ;
                        3'b001: Operation=BNE;
                        3'b100: Operation=BLT;
                        3'b101: Operation=BGE;
                        3'b110: Operation=BLTU;
                        3'b111: Operation=BGEU;
                    
                    endcase
        
                end
        
        STORE: begin
                
                    R_read=1;
                    M_read=0;
                    R_write=0;
                    M_write=1;
                    J=0;
                    JR=0;
                    BR=0;
                    Im_sel=1;
                    WB_sel= 0;
                    UI_sel=0;
                    
                    case({func3})

                        3'b000: sel=2;  // B
                        3'b001: sel=1;  // H
                        3'b010: sel=0;  // W
                        default : sel=0; 
                    
                    endcase
                    
                    Operation=ADD;
                
                end

        LUI: begin
                
                    R_read=0;
                    M_read=0;
                    R_write=1;
                    J=0;
                    M_write=0;
                    Im_sel=1;
                    JR=0;
                    BR=0;
                    WB_sel= 0;
                    sel=0;
                    UI_sel=1;
                    Operation=ADD;
                
                end


        JAL: begin
                
                    R_read=0;
                    M_read=0;
                    R_write=1;
                    J=1;
                    JR=0;
                    M_write=0;
                    Im_sel=0;
                    WB_sel= 0;
                    BR=0;
                    sel=0;
                    UI_sel=2;
                    Operation=ADD;
                
                end


        JALR: begin
                
                    R_read=1;
                    M_read=0;
                    R_write=1;
                    J=1;
                    M_write=0;
                    Im_sel=0;
                    WB_sel= 0;
                    sel=0;
                    BR=0;
                    JR=1;
                    UI_sel=2;
                    Operation=ADD;
                
                end



        AUIPC: begin
                
                    R_read=0;
                    M_read=0;
                    J=0;
                    R_write=1;
                    M_write=0;
                    Im_sel=1;
                    WB_sel= 0;
                    sel=0;
                    BR=0;
                    JR=0;
                    UI_sel=2;
                    Operation=ADD;
                
                end
        
        R_TYPE: begin
                
                    R_read=1;
                    M_read=0;
                    J=0;
                    R_write=1;
                    M_write=0;
                    WB_sel= 0;
                    sel=0;
                    BR=0;
                    JR=0;
                    Im_sel=0;
                    UI_sel=0;

                    case({{func7},{func3}})
                    
                        4'b0000: Operation=ADD;
                        4'b1000: Operation=SUB;
                        4'b0110: Operation=OR;
                        4'b0111: Operation=AND;
                        4'b0100: Operation=XOR;
                        4'b0101: Operation=SRL;
                        4'b1101: Operation=SRA;
                        4'b0001: Operation=SLL;
                        4'b0010: Operation=SLT;
                        4'b0011: Operation=SLTU;
                    
                    endcase
                
                end
        IMM:     begin
                    R_read=1;
                    M_read=0;
                    R_write=1;
                    M_write=0;
                    J=0;
                    JR=0;
                    BR=0;
                    Im_sel=1;
                    sel=0;
                    UI_sel=0;
                    WB_sel= 0;
                        
                        case({{func7},{func3}})
                        
                        4'b0000: Operation=ADD;
                        4'b1000: Operation=ADD;
                        4'b0110: Operation=OR;
                        4'b1110: Operation=OR;
                        4'b0111: Operation=AND;
                        4'b1111: Operation=AND;
                        4'b0100: Operation=XOR;
                        4'b1100: Operation=XOR;
                        4'b0101: Operation=SRL;
                        4'b1101: Operation=SRA;
                        4'b0001: Operation=SLL;
                        4'b0010: Operation=SLT;
                        4'b1010: Operation=SLT;
                        4'b0011: Operation=SLTU;
                        4'b1011: Operation=SLTU;
                    
                        endcase;
                end

        default: 
        begin
                    R_read=0;
                    M_read=0;
                    R_write=0;
                    J=0;
                    M_write=0;
                    Im_sel=0;
                    sel=0;
                    BR=0;
                    JR=0;
                    UI_sel=0;
                    WB_sel= 0;
                    Operation=ADD;
        end
            endcase



    end

 else

        begin
                    R_read=0;
                    M_read=0;
                    R_write=0;
                    J=0;
                    M_write=0;
                    JR=0;
                    BR=0;
                    Im_sel=0;
                    sel=0;
                    UI_sel=0;
                    WB_sel= 0;
                    Operation=ADD;
        end




    end


endmodule