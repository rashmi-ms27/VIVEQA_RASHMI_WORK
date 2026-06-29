`timescale 1ns/1ps

module tb_uart_button_led_top;

reg clk;
reg rst;

reg [15:0] buttons;

reg uart_rx;
wire uart_tx;

wire [7:0] leds;

integer i;

uart_button_led_top DUT(
    .clk(clk),
    .rst(rst),
    .buttons(buttons),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .leds(leds)
);

initial
begin
    clk = 0;
    forever #20 clk = ~clk;
end

initial
begin

    rst = 1;
    buttons = 16'h0000;
    uart_rx = 1'b1;

    #200;
    rst = 0;

    for(i = 0; i < 16; i = i + 1)
    begin
        buttons = (16'h0001 << i);
        #1000;

        buttons = 16'h0000;
        #500000;
    end

    #100000;

    $stop;

end

endmodule
