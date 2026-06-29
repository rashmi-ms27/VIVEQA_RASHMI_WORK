module largest_fsm_tb;

reg clk;
reg rst;
reg [1:0] din;
wire [1:0] out;

largest_fsm dut(
    .clk(clk),
    .rst(rst),
    .din(din),
    .out(out)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    din = 0;

    #10 rst = 0;

    // Input sequence: 0 1 2 3 2 1 0

    din = 2'd0; #10;
    din = 2'd1; #10;
    din = 2'd2; #10;
    din = 2'd3; #10;
    din = 2'd2; #10;
    din = 2'd1; #10;
    din = 2'd0; #10;

    #20 $finish;
end

endmodule
