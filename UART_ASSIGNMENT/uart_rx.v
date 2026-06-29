module uart_rx(

    input clk,
    input rst,
    input rx,

    output reg [7:0] rx_data,
    output reg rx_done

);

parameter CLKS_PER_BIT = 2500;

reg [12:0] clk_count;
reg [3:0] bit_index;
reg [2:0] state;

localparam IDLE  = 0;
localparam START = 1;
localparam DATA  = 2;
localparam STOP  = 3;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        state <= IDLE;
        rx_done <= 0;
        clk_count <= 0;
        bit_index <= 0;
    end

    else
    begin

        rx_done <= 0;

        case(state)

        IDLE:
        begin
            if(rx == 0)
            begin
                state <= START;
                clk_count <= 0;
            end
        end

        START:
        begin
            if(clk_count == (CLKS_PER_BIT/2))
            begin
                clk_count <= 0;
                bit_index <= 0;
                state <= DATA;
            end
            else
                clk_count <= clk_count + 1;
        end

        DATA:
        begin

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin

                clk_count <= 0;
                rx_data[bit_index] <= rx;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                    state <= STOP;

            end

        end

        STOP:
        begin

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                rx_done <= 1;
                state <= IDLE;
                clk_count <= 0;
            end

        end

        endcase

    end

end

endmodule
