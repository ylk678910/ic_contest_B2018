`timescale 1ns/10ps

module decorder(output reg code_valid,
                output [47:0] HC,
                output [47:0] M,
                output reg [3:0] root_sel,
                input [3:0] node_l_sel,
                input [3:0] node_r_sel,
                input cmb_cmp_flg,
                input clk,
                input reset);
    
    localparam TRUE       = 1'b1;
    localparam FALSE      = 1'b0;
    localparam WRITE      = 1;
    localparam READ       = 0;
    localparam LEFT       = 1;
    localparam RIGHT      = 0;
    localparam NODE_EMPTY = 11;
    
    reg [7:0] HC_tmp[5:0];
    reg [7:0] M_tmp[5:0];
    assign HC = {HC_tmp[0], HC_tmp[1], HC_tmp[2], HC_tmp[3], HC_tmp[4], HC_tmp[5]};
    assign M  = {M_tmp[0], M_tmp[1], M_tmp[2], M_tmp[3], M_tmp[4], M_tmp[5]};
    
    reg cmb_cmp_flg_tmp;
    wire started_flg = cmb_cmp_flg && !cmb_cmp_flg_tmp;
    always @(posedge clk) begin
        cmb_cmp_flg_tmp <= cmb_cmp_flg;
    end
    
    reg [6:0] now_code, now_mask;
    reg [3:0] node_stack[3:0];
    reg [1:0] layer;
    reg [1:0] layer_stack[3:0];
    reg [1:0] stack_ptr;
    reg detect_l_w;
    always @(posedge clk) begin
        if (reset || started_flg) begin
            code_valid     <= FALSE;
            detect_l_w     <= RIGHT;
            root_sel       <= 4'd6;
            HC_tmp[0]      <= 8'd0;
            HC_tmp[1]      <= 8'd0;
            HC_tmp[2]      <= 8'd0;
            HC_tmp[3]      <= 8'd0;
            HC_tmp[4]      <= 8'd0;
            HC_tmp[5]      <= 8'd0;
            M_tmp[0]       <= 8'd0;
            M_tmp[1]       <= 8'd0;
            M_tmp[2]       <= 8'd0;
            M_tmp[3]       <= 8'd0;
            M_tmp[4]       <= 8'd0;
            M_tmp[5]       <= 8'd0;
            now_code       <= 7'b000_0000;
            now_mask       <= 7'b000_0000;
            node_stack[0]  <= 4'd0;
            node_stack[1]  <= 4'd0;
            node_stack[2]  <= 4'd0;
            node_stack[3]  <= 4'd0;
            layer          <= 2'd0;
            layer_stack[0] <= 2'd0;
            layer_stack[1] <= 2'd0;
            layer_stack[2] <= 2'd0;
            layer_stack[3] <= 2'd0;
            stack_ptr      <= 2'd0;
        end
        else if (cmb_cmp_flg_tmp && !code_valid) begin
            if (detect_l_w == LEFT) begin
                if (node_l_sel < 6) begin //is node
                    HC_tmp[node_l_sel] <= {now_code, 1'b1};
                    M_tmp[node_l_sel]  <= {now_mask, 1'b1};
                    if (stack_ptr == 0)begin
                        code_valid <= TRUE;
                    end
                    else begin
                        layer      <= layer_stack[stack_ptr-2'd1];
                        root_sel   <= node_stack[stack_ptr-2'd1];
                        detect_l_w <= LEFT;
                        now_code   <= now_code >> (layer-layer_stack[stack_ptr-2'd1]);
                        now_mask   <= now_mask >> (layer-layer_stack[stack_ptr-2'd1]);
                        stack_ptr  <= stack_ptr - 2'd1;
                    end
                end
                else begin
                    layer      <= layer + 2'd1;
                    root_sel   <= node_l_sel;
                    detect_l_w <= RIGHT;
                    now_code   <= {now_code[5:0], 1'b1};
                    now_mask   <= {now_mask[5:0], 1'b1};
                end
            end
            else begin
                if (node_r_sel < 6) begin //is node
                    detect_l_w         <= LEFT;
                    HC_tmp[node_r_sel] <= {now_code, 1'b0};
                    M_tmp[node_r_sel]  <= {now_mask, 1'b1};
                end
                else begin
                    layer                  <= layer + 2'd1;
                    root_sel               <= node_r_sel;
                    detect_l_w             <= RIGHT;
                    now_code               <= {now_code[5:0], 1'b0};
                    now_mask               <= {now_mask[5:0], 1'b1};
                    node_stack[stack_ptr]  <= root_sel;
                    layer_stack[stack_ptr] <= layer;
                    stack_ptr              <= stack_ptr+2'd1;
                end
            end
        end
        else begin
            
        end
    end
    
endmodule
