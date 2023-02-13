`timescale 1ns/10ps

module CNT_counter(output reg CNT_valid,
                   output reg [7:0] CNT1_tmp,
                   output reg [7:0] CNT2_tmp,
                   output reg [7:0] CNT3_tmp,
                   output reg [7:0] CNT4_tmp,
                   output reg [7:0] CNT5_tmp,
                   output reg [7:0] CNT6_tmp,
                   input gray_valid,
                   input [7:0] gray_data,
                   input clk,
                   input reset);
    
    localparam TRUE  = 1'b1;
    localparam FALSE = 1'b0;
    
    reg [6:0] pixel_num [5:0]; //A6~A1
    reg gray_valid_tmp;
    wire send_CNT_flg = gray_valid_tmp & !gray_valid;
    
    always @(posedge clk) begin
        if (reset) begin
            gray_valid_tmp <= FALSE;
        end
        else begin
            gray_valid_tmp <= gray_valid;
        end
    end
    always @(posedge clk) begin
        if (reset) begin
            CNT_valid <= FALSE;
        end
        else if (send_CNT_flg) begin
            CNT_valid <= TRUE;
        end
        else begin
            CNT_valid <= FALSE;
        end
    end
    
    always @(posedge clk) begin
        if (reset || send_CNT_flg) begin
            pixel_num[0] <= 7'd0;
            pixel_num[1] <= 7'd0;
            pixel_num[2] <= 7'd0;
            pixel_num[3] <= 7'd0;
            pixel_num[4] <= 7'd0;
            pixel_num[5] <= 7'd0;
        end
        else if (gray_valid) begin
            case(gray_data)
                8'h01: begin
                    pixel_num[0] <= pixel_num[0] + 7'd1;
                end
                8'h02: begin
                    pixel_num[1] <= pixel_num[1] + 7'd1;
                end
                8'h03: begin
                    pixel_num[2] <= pixel_num[2] + 7'd1;
                end
                8'h04: begin
                    pixel_num[3] <= pixel_num[3] + 7'd1;
                end
                8'h05: begin
                    pixel_num[4] <= pixel_num[4] + 7'd1;
                end
                8'h06: begin
                    pixel_num[5] <= pixel_num[5] + 7'd1;
                end
                default begin
                    //error
                end
            endcase
        end
        else begin
            //do nothing
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            CNT1_tmp = 8'd0;
            CNT2_tmp = 8'd0;
            CNT3_tmp = 8'd0;
            CNT4_tmp = 8'd0;
            CNT5_tmp = 8'd0;
            CNT6_tmp = 8'd0;
        end
        else if (send_CNT_flg) begin
            CNT1_tmp = {1'b0, pixel_num[0]};
            CNT2_tmp = {1'b0, pixel_num[1]};
            CNT3_tmp = {1'b0, pixel_num[2]};
            CNT4_tmp = {1'b0, pixel_num[3]};
            CNT5_tmp = {1'b0, pixel_num[4]};
            CNT6_tmp = {1'b0, pixel_num[5]};
        end
        else begin
            CNT1_tmp = 8'd0;
            CNT2_tmp = 8'd0;
            CNT3_tmp = 8'd0;
            CNT4_tmp = 8'd0;
            CNT5_tmp = 8'd0;
            CNT6_tmp = 8'd0;
        end
    end
endmodule
