`timescale 1ns/10ps

module order_gen(output reg [2:0] order1,
                 output reg [2:0] order2,
                 output reg [2:0] order3,
                 output reg [2:0] order4,
                 output reg [2:0] order5,
                 output reg [2:0] order6,
                 output order_cmp_flg,
                 input [7:0] CNT1,
                 input [7:0] CNT2,
                 input [7:0] CNT3,
                 input [7:0] CNT4,
                 input [7:0] CNT5,
                 input [7:0] CNT6,
                 input start_order_flg,
                 input clk,
                 input reset);

localparam TRUE  = 1'b1;
localparam FALSE = 1'b0;

reg [2:0] order_ptr;
reg [7:0] order_sel;
assign order_cmp_flg = (order_ptr == 6);

reg [7:0] CNT_tmp [5:0];
always @(*) begin
    CNT_tmp[0] = CNT1;
    CNT_tmp[1] = CNT2;
    CNT_tmp[2] = CNT3;
    CNT_tmp[3] = CNT4;
    CNT_tmp[4] = CNT5;
    CNT_tmp[5] = CNT6;
end

always @(*) begin
    order_sel = CNT_tmp[order_ptr];
end

reg started_flg;
always @(posedge clk) begin
    if (reset || order_cmp_flg) begin
        started_flg <= FALSE;
    end
    else if (start_order_flg) begin
        started_flg <= TRUE;
    end
    else begin
        started_flg <= started_flg;
    end
end

always @(posedge clk) begin
    if (reset || start_order_flg) begin
        order1    <= 3'd0;
        order2    <= 3'd0;
        order3    <= 3'd0;
        order4    <= 3'd0;
        order5    <= 3'd0;
        order6    <= 3'd0;
        order_ptr <= 0;
    end
    else if (started_flg) begin
        order_ptr <= order_ptr + 1;
        
        if (CNT_tmp[0] < order_sel) begin
            order1 <= order1 + 1;
        end
        else if (CNT_tmp[0] == order_sel) begin
            if (order_ptr < 0) begin
                order1 <= order1 + 1;
            end
        end
        else begin
        end
        
        if (CNT_tmp[1] < order_sel) begin
            order2 <= order2 + 1;
        end
        else if (CNT_tmp[1] == order_sel) begin
            if (order_ptr < 1) begin
                order2 <= order2 + 1;
            end
        end
        else begin
        end
        
        if (CNT_tmp[2] < order_sel) begin
            order3 <= order3 + 1;
        end
        else if (CNT_tmp[2] == order_sel) begin
            if (order_ptr < 2) begin
                order3 <= order3 + 1;
            end
        end
        else begin
        end
        
        if (CNT_tmp[3] < order_sel) begin
            order4 <= order4 + 1;
        end
        else if (CNT_tmp[3] == order_sel) begin
            if (order_ptr < 3) begin
                order4 <= order4 + 1;
            end
        end
        else begin
        end
        
        if (CNT_tmp[4] < order_sel) begin
            order5 <= order5 + 1;
        end
        else if (CNT_tmp[4] == order_sel) begin
            if (order_ptr < 4) begin
                order5 <= order5 + 1;
            end
        end
        else begin
        end
        
        if (CNT_tmp[5] < order_sel) begin
            order6 <= order6 + 1;
        end
        else if (CNT_tmp[5] == order_sel) begin
            if (order_ptr < 5) begin
                order6 <= order6 + 1;
            end
        end
        else begin
            
        end
    end
    else begin
        
    end
end
endmodule
