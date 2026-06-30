`timescale 1ns/1ps

module neg_edge_detector_tb;

reg clk;
reg a;
wire pulse;

neg_edge_detector U0(
    .clk(clk),
    .a(a),
    .pulse(pulse)
);

always #10 clk = ~clk;

initial
begin
    clk = 0;
    a = 0;

    #20 a = 1;
    #40 a = 0;

    #40 a = 1;
    #40 a = 0;

    #40 $finish;
end

endmodule
