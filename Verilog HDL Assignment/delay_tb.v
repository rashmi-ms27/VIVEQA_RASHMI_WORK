`timescale 1ns/1ps

module delay_tb;

reg clk;
reg a;
wire a_delay;

delay U0 (
    .a(a),
    .clk(clk),
    .a_delay(a_delay)
);

always #10 clk = ~clk;

initial begin
    clk = 0;
    a = 0;

    // Apply input exactly on clock edge
    @(posedge clk);
    a = 1;

    @(posedge clk);
    a = 0;

    repeat(10) @(posedge clk);

    $finish;
end

endmodule
