
`timescale 1ns / 1ps

module uart_button_led_top(

    input clk,
    input rst,

    input [15:0] buttons,

    input uart_rx,
    output uart_tx,

    output [7:0] leds

);

wire [7:0] ascii_char;
wire button_valid;

wire tx_busy;
reg  tx_start;
reg  [7:0] tx_data;

wire [7:0] rx_data;
wire rx_done;

reg [15:0] buttons_d;

reg [3:0] state;
reg [2:0] char_index;

localparam IDLE = 4'd0;
localparam SEND = 4'd1;
localparam WAIT = 4'd2;

button_decoder u_decoder(
    .buttons(buttons),
    .ascii_char(ascii_char),
    .valid(button_valid)
);

uart_tx u_tx(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(uart_tx),
    .tx_busy(tx_busy)
);

uart_rx u_rx(
    .clk(clk),
    .rst(rst),
    .rx(uart_rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

led_controller u_led(
    .clk(clk),
    .rst(rst),
    .rx_done(rx_done),
    .rx_data(rx_data),
    .leds(leds)
);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        buttons_d  <= 16'h0000;
        tx_start   <= 1'b0;
        tx_data    <= 8'h00;
        state      <= IDLE;
        char_index <= 3'd0;
    end

    else
    begin

        tx_start <= 1'b0;

        case(state)

        IDLE:
        begin

            if((buttons != 16'h0000) &&
               (buttons_d == 16'h0000))
            begin
                char_index <= 3'd0;
                state <= SEND;
            end

        end

        SEND:
        begin

            if(!tx_busy)
            begin

                case(char_index)
                    3'd0: tx_data <= "S";
                    3'd1: tx_data <= "i";
                    3'd2: tx_data <= "n";
                    3'd3: tx_data <= "c";
                    3'd4: tx_data <= "h";
                    3'd5: tx_data <= "a";
                    3'd6: tx_data <= "n";
                    3'd7: tx_data <= "a";
                endcase

                tx_start <= 1'b1;
                state <= WAIT;

            end

        end

        WAIT:
        begin

            if(tx_busy)
            begin

                if(char_index == 3'd7)
                    state <= IDLE;
                else
                begin
                    char_index <= char_index + 1'b1;
                    state <= SEND;
                end

            end

        end

        default:
            state <= IDLE;

        endcase

        buttons_d <= buttons;

    end

end

endmodule

