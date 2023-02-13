`timescale 1ns/10ps

module Combination(output reg [3:0] node_l,
                   output reg [3:0] node_r,
                   output reg [3:0] root_sel,
                   output reg w_r,
                   output reg cmb_cmp_flg,
                   input [2:0] order1,
                   input [2:0] order2,
                   input [2:0] order3,
                   input [2:0] order4,
                   input [2:0] order5,
                   input [2:0] order6,
                   input [7:0] CNT1,
                   input [7:0] CNT2,
                   input [7:0] CNT3,
                   input [7:0] CNT4,
                   input [7:0] CNT5,
                   input [7:0] CNT6,
                   input start_cmb_flg,
                   input clk,
                   input reset);

localparam TRUE       = 1'b1;
localparam FALSE      = 1'b0;
localparam WRITE      = 1;
localparam READ       = 0;
localparam LEFT       = 1;
localparam RIGHT      = 0;
localparam NODE_EMPTY = 11;

reg started_flg;
reg [2:0] time_counter,order_ptr , root_ptr;
wire [7:0] CNT[5:0];
assign CNT[0] = CNT1;
assign CNT[1] = CNT2;
assign CNT[2] = CNT3;
assign CNT[3] = CNT4;
assign CNT[4] = CNT5;
assign CNT[5] = CNT6;

always @(posedge clk) begin
    if (reset) begin
        cmb_cmp_flg <= FALSE;
    end
    else begin
        cmb_cmp_flg <= (time_counter > 3'd4);
    end
end

always @(posedge clk) begin
    if (reset) begin
        started_flg <= FALSE;
    end
    else if (time_counter > 3'd4) begin
        started_flg <= FALSE;
    end
        else if (start_cmb_flg) begin
        started_flg <= TRUE;
        end
    else begin
        started_flg <= started_flg;
    end
end

reg [7:0] CNT_tmp[5:0];
reg [3:0] node[5:0];
reg order_flg;
always @(posedge clk) begin
    if (reset || start_cmb_flg) begin
        order_flg    <= FALSE;
        node_l       <= NODE_EMPTY;
        node_r       <= NODE_EMPTY;
        root_sel     <= 4'd6;
        w_r          <= READ;
        time_counter <= 3'd4;
        order_ptr    <= 3'd0;
        root_ptr     <= 3'd4;
        CNT_tmp[order1] <= CNT[0];
        CNT_tmp[order2] <= CNT[1];
        CNT_tmp[order3] <= CNT[2];
        CNT_tmp[order4] <= CNT[3];
        CNT_tmp[order5] <= CNT[4];
        CNT_tmp[order6] <= CNT[5];
        node[order1]    <= 4'd0;
        node[order2]    <= 4'd1;
        node[order3]    <= 4'd2;
        node[order4]    <= 4'd3;
        node[order5]    <= 4'd4;
        node[order6]    <= 4'd5;
    end
    else if (started_flg) begin
        if (!order_flg) begin
            order_flg             <= TRUE;
            w_r                   <= WRITE;
            time_counter          <= time_counter - 3'd1;
            order_ptr             <= time_counter;
            root_ptr              <= root_ptr - 3'd1;
            CNT_tmp[time_counter] <= CNT_tmp[time_counter] + CNT_tmp[time_counter + 1'd1];
            node[time_counter]    <= {1'b0, root_ptr} + 4'd6;
            node_l                <= node[time_counter + 3'd1];
            node_r                <= node[time_counter];
            root_sel              <= root_ptr + 3'd6;
        end
        else begin
            w_r <= READ;
            //swap
            if (CNT_tmp[order_ptr] > CNT_tmp[order_ptr - 3'd1]) begin
                CNT_tmp[order_ptr - 3'd1] <= CNT_tmp[order_ptr];
                CNT_tmp[order_ptr]        <= CNT_tmp[order_ptr - 3'd1];
                node[order_ptr - 3'd1]    <= node[order_ptr];
                node[order_ptr]           <= node[order_ptr - 3'd1];
                order_ptr                 <= order_ptr - 3'd1;
            end
            else begin
                order_flg <= FALSE;
            end
        end
    end
    else begin
        node_l   <= NODE_EMPTY;
        node_r   <= NODE_EMPTY;
        root_sel <= 4'd6;
        w_r      <= READ;
    end
end
endmodule
