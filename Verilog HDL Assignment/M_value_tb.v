module tb;

reg clk;
reg a;
wire a_delay;

delay #(.M(100)) U0 (
    .a(a),
    .clk(clk),
    .a_delay(a_delay)
);

// Clock generation
always #10 clk = ~clk;
    

// Stimulus
initial begin
    clk=0;
    a = 0;

    #20 a = 1;
    #20  a=0;
    #2500 $finish;
    
    
end

endmodule
