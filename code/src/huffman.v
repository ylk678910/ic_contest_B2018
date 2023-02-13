`timescale 1ns/10ps

module huffman(clk,
               reset,
               gray_valid,
               gray_data,
               CNT_valid,
               CNT1,
               CNT2,
               CNT3,
               CNT4,
               CNT5,
               CNT6,
               code_valid,
               HC1,
               HC2,
               HC3,
               HC4,
               HC5,
               HC6,
               M1,
               M2,
               M3,
               M4,
               M5,
               M6);
    
    input clk;
    input reset;
    input gray_valid;
    input [7:0] gray_data;
    output CNT_valid;
    output [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
    output code_valid;
    output [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
    output [7:0] M1, M2, M3, M4, M5, M6;
    
    localparam TRUE  = 1'b1;
    localparam FALSE = 1'b0;
    localparam WRITE = 1;
    localparam READ  = 0;
    
    reg [7:0] CNT1_tmp, CNT2_tmp, CNT3_tmp, CNT4_tmp, CNT5_tmp, CNT6_tmp;
    always @(posedge clk) begin
        if (reset) begin
            CNT1_tmp <= 8'd0;
            CNT2_tmp <= 8'd0;
            CNT3_tmp <= 8'd0;
            CNT4_tmp <= 8'd0;
            CNT5_tmp <= 8'd0;
            CNT6_tmp <= 8'd0;
        end
        else if (CNT_valid) begin
            CNT1_tmp <= CNT1;
            CNT2_tmp <= CNT2;
            CNT3_tmp <= CNT3;
            CNT4_tmp <= CNT4;
            CNT5_tmp <= CNT5;
            CNT6_tmp <= CNT6;
        end
        else begin
            
        end
    end
    
    CNT_counter CNT_counter1(
    .CNT_valid(CNT_valid),
    .CNT1_tmp(CNT1),
    .CNT2_tmp(CNT2),
    .CNT3_tmp(CNT3),
    .CNT4_tmp(CNT4),
    .CNT5_tmp(CNT5),
    .CNT6_tmp(CNT6),
    .gray_valid(gray_valid),
    .gray_data(gray_data),
    .clk(clk),
    .reset(reset)
    );
    
    wire start_order_flg = CNT_valid;
    wire [2:0] order1;
    wire [2:0] order2;
    wire [2:0] order3;
    wire [2:0] order4;
    wire [2:0] order5;
    wire [2:0] order6;
    wire order_cmp_flg;
    order_gen order_gen1(
    .order1(order1),
    .order2(order2),
    .order3(order3),
    .order4(order4),
    .order5(order5),
    .order6(order6),
    .order_cmp_flg(order_cmp_flg),
    .CNT1(CNT1_tmp),
    .CNT2(CNT2_tmp),
    .CNT3(CNT3_tmp),
    .CNT4(CNT4_tmp),
    .CNT5(CNT5_tmp),
    .CNT6(CNT6_tmp),
    .start_order_flg(start_order_flg),
    .clk(clk),
    .reset(reset)
    );
    
    reg order_cmp_flg_tmp;
    always @(posedge clk) begin
        order_cmp_flg_tmp <= order_cmp_flg;
    end
    
    wire node_w_r, cmb_cmp_flg;
    wire start_cmb_flg = order_cmp_flg && !order_cmp_flg_tmp;
    wire [3:0] root_sel_dcd;
    wire [3:0] node_l_o, node_r_o, node_l_i, node_r_i, root_sel_cmb;
    
    wire [3:0] root_sel_i = cmb_cmp_flg ? root_sel_dcd : root_sel_cmb;
    wire w_r              = cmb_cmp_flg ? READ : node_w_r;
    
    tree_mem tree_mem1(
    .node_l_o(node_l_o),
    .node_r_o(node_r_o),
    .node_l_i(node_l_i),
    .node_r_i(node_r_i),
    .root_sel(root_sel_i),
    .w_r(w_r),
    .clear(start_cmb_flg),
    .clk(clk),
    .reset(reset)
    );
    
    Combination Combination1(
    .node_l(node_l_i),
    .node_r(node_r_i),
    .root_sel(root_sel_cmb),
    .w_r(node_w_r),
    .cmb_cmp_flg(cmb_cmp_flg),
    .order1(order1),
    .order2(order2),
    .order3(order3),
    .order4(order4),
    .order5(order5),
    .order6(order6),
    .CNT1(CNT1_tmp),
    .CNT2(CNT2_tmp),
    .CNT3(CNT3_tmp),
    .CNT4(CNT4_tmp),
    .CNT5(CNT5_tmp),
    .CNT6(CNT6_tmp),
    .start_cmb_flg(start_cmb_flg),
    .clk(clk),
    .reset(reset));
    
    decorder decorder1(
    .code_valid(code_valid),
    .HC({HC1, HC2, HC3, HC4, HC5, HC6}),
    .M({M1, M2, M3, M4, M5, M6}),
    .root_sel(root_sel_dcd),
    .node_l_sel(node_l_o),
    .node_r_sel(node_r_o),
    .cmb_cmp_flg(cmb_cmp_flg),
    .clk(clk),
    .reset(reset));
endmodule
