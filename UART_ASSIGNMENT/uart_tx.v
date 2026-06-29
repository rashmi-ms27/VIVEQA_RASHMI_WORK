module uart_tx(

    input clk,
    input rst,

    input tx_start,
    input [7:0] tx_data,

    output reg tx,
    output reg tx_busy

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
        tx <= 1'b1;
        tx_busy <= 1'b0;
        state <= IDLE;
        clk_count <= 0;
        bit_index <= 0;
    end

    else
    begin

        case(state)

        IDLE:
        begin
            tx <= 1'b1;
            tx_busy <= 1'b0;

            if(tx_start)
            begin
                tx_busy <= 1'b1;
                state <= START;
                clk_count <= 0;
            end
        end

        START:
        begin
            tx <= 1'b0;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;
                bit_index <= 0;
                state <= DATA;
            end
        end

        DATA:
        begin

            tx <= tx_data[bit_index];

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                    state <= STOP;
            end

        end

        STOP:
        begin

            tx <= 1'b1;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                state <= IDLE;
                clk_count <= 0;
            end

        end

        endcase

    end

end

endmodule
