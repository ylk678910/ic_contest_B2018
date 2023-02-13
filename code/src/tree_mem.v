`timescale 1ns/10ps

module tree_mem(output reg [3:0] node_l_o,
                output reg [3:0] node_r_o,
                input [3:0] node_l_i,
                input [3:0] node_r_i,
                input [3:0] root_sel,
                input w_r,
                input clear,
                input clk,
                input reset);

localparam WRITE      = 1;
localparam READ       = 0;
localparam LEFT       = 1;
localparam RIGHT      = 0;
localparam NODE_EMPTY = 11;

wire [3:0] root_ptr = root_sel-4'd6;

//0~5 node
//6~10 root
//11 empty
reg [3:0] root_left[4:0];
reg [3:0] root_right[4:0];
always @(negedge clk) begin
    if (reset || clear) begin
        node_l_o      <= NODE_EMPTY;
        node_r_o      <= NODE_EMPTY;
        root_left[0]  <= NODE_EMPTY; //not defined
        root_left[1]  <= NODE_EMPTY; //not defined
        root_left[2]  <= NODE_EMPTY; //not defined
        root_left[3]  <= NODE_EMPTY; //not defined
        root_left[4]  <= NODE_EMPTY; //not defined
        root_right[0] <= NODE_EMPTY; //not defined
        root_right[1] <= NODE_EMPTY; //not defined
        root_right[2] <= NODE_EMPTY; //not defined
        root_right[3] <= NODE_EMPTY; //not defined
        root_right[4] <= NODE_EMPTY; //not defined
    end
    else begin
        case(w_r)
            WRITE: begin
                root_left[root_ptr]  <= node_l_i;
                root_right[root_ptr] <= node_r_i;
            end
            READ: begin
                node_l_o <= root_left[root_ptr];
                node_r_o <= root_right[root_ptr];
            end
        endcase
    end
end
endmodule
