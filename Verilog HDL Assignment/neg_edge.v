module neg_edge_detector(
    input clk,
    input a,
    output pulse
);

reg a_delay;

always @(posedge clk)
begin
    a_delay <= a;
end

assign pulse = a_delay & ~a;

endmodule
