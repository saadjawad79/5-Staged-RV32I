module hazard #(parameter REG_NO = 8) (
    input logic [$clog2(REG_NO)-1:0] src1_add,
    input logic [$clog2(REG_NO)-1:0] src2_add,
    input logic [$clog2(REG_NO)-1:0] sw_add_ME,
    input logic [$clog2(REG_NO)-1:0] dest_add_ME,
    input logic [$clog2(REG_NO)-1:0] dest_add_WB,
    input logic R_write_ME,
    input logic R_write_WB,
    output logic [1:0] A,
    output logic [1:0] B,
    output logic C
);
    



always_comb begin

    if( dest_add_ME!=0 && ((src1_add==dest_add_ME) && R_write_ME))
        A=2;
    else if( dest_add_WB!=0 && (src1_add== dest_add_WB)&& R_write_WB)
        A=1;
    else
        A=0;

end


always_comb begin

    if( dest_add_ME!=0 && ((src2_add==dest_add_ME) && R_write_ME))
        B=2;
    else if( dest_add_WB!=0 && (src2_add== dest_add_WB)&& R_write_WB)
        B=1;
    else
        B=0;

end


always_comb begin

    if( dest_add_WB!=0 && ((sw_add_ME==dest_add_WB) && R_write_WB))
        
        C=1;

    else

        C=0;

end







endmodule