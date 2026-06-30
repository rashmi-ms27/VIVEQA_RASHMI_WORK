module largest_fsm(
    input clk,
    input rst,
    input [1:0] din,
    output reg [1:0] out
);

reg [1:0] state;

always @(posedge clk) begin
    if(rst)
        state <= 2'd0;
    else begin
        if(din > state)
            state <= din;
        else
            state <= state;
    end
end

always @(*) begin
    out = state;
end

endmodule
