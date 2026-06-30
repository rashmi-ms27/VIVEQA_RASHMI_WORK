module delay #(parameter M=100)(
    input  a,
    input  clk,
    output a_delay
);

reg [M-1:0] a_reg;

always @(posedge clk)
begin
    a_reg <= {a,a_reg[M-1:1]};
end

assign a_delay = a_reg[0];

endmodule
