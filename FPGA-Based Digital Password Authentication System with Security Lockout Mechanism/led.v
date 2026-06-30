

`timescale 1ns / 1ps

module seg_display(
    input  wire       clk_24mhz,
    input  wire [1:0] display_state,

    output reg seg_cs  = 1'b1,
    output reg seg_clk = 1'b0,
    output reg seg_din = 1'b0
);

//=========================================================
// Character definitions (Common Cathode MAX7219)
// Bit order = DP G F E D C B A
//=========================================================

localparam [7:0]
CHAR_0 = 8'h7E,
CHAR_1 = 8'h30,
CHAR_2 = 8'h6D,
CHAR_3 = 8'h79,
CHAR_4 = 8'h33,
CHAR_5 = 8'h5B,
CHAR_6 = 8'h5F,
CHAR_7 = 8'h70,
CHAR_8 = 8'h7F,
CHAR_9 = 8'h7B,

CHAR_A = 8'h77,
CHAR_B = 8'h1F,
CHAR_C = 8'h4E,
CHAR_D = 8'h3D,
CHAR_E = 8'h4F,
CHAR_F = 8'h47,
CHAR_H = 8'h37,
CHAR_I = 8'h30,
CHAR_K = 8'h37,
CHAR_L = 8'h0E,
CHAR_O = 8'h7E,
CHAR_P = 8'h67,
CHAR_S = 8'h5B,
CHAR_U = 8'h3E,

CHAR_DASH  = 8'h01,
CHAR_BLANK = 8'h00;

//=========================================================
// Four display bytes
//=========================================================

reg [7:0] d3;
reg [7:0] d2;
reg [7:0] d1;
reg [7:0] d0;

//=========================================================
// Display selection
//=========================================================

always @(*) begin

    case(display_state)

        // PASS
        2'b01:
        begin
            d3 = CHAR_P;
            d2 = CHAR_A;
            d1 = CHAR_S;
            d0 = CHAR_S;
        end

        // FAIL
        2'b10:
        begin
            d3 = CHAR_F;
            d2 = CHAR_A;
            d1 = CHAR_I;
            d0 = CHAR_L;
        end

        // LOCK
        2'b11:
        begin
            d3 = CHAR_L;
            d2 = CHAR_O;
            d1 = CHAR_C;
            d0 = CHAR_K;
        end

        default:
        begin
            d3 = CHAR_BLANK;
            d2 = CHAR_BLANK;
            d1 = CHAR_BLANK;
            d0 = CHAR_BLANK;
        end

    endcase

end

//=========================================================
// 24 MHz -> 1 MHz Tick
//=========================================================

reg [4:0] tick_div = 0;

wire tick = (tick_div == 23);

always @(posedge clk_24mhz)
begin

    if(tick)
        tick_div <= 0;
    else
        tick_div <= tick_div + 1;

end

//=========================================================
// SPI Registers
//=========================================================

reg [15:0] shift_reg = 16'd0;

reg [5:0] spi_state = 0;

reg [3:0] command = 0;

//=========================================================
// SPI State Machine
//=========================================================

always @(posedge clk_24mhz)
begin

    if(tick)
    begin

        if(spi_state == 0)
        begin

            seg_cs  <= 0;
            seg_clk <= 0;

            case(command)

                // Exit Shutdown
                4'd0:
                    shift_reg <= 16'h0C01;

                // Decode OFF
                4'd1:
                    shift_reg <= 16'h0900;

                // Intensity
                4'd2:
                    shift_reg <= 16'h0A08;

                // Scan limit = 4 digits
                4'd3:
                    shift_reg <= 16'h0B03;

                // Display Test OFF
                4'd4:
                    shift_reg <= 16'h0F00;

                // Digit 1
                4'd5:
                    shift_reg <= {8'h01,d3};

                // Digit 2
                4'd6:
                    shift_reg <= {8'h02,d2};

                // Digit 3
                4'd7:
                    shift_reg <= {8'h03,d1};

                // Digit 4
                4'd8:
                    shift_reg <= {8'h04,d0};

            endcase

            spi_state <= 1;

        end
        else if (spi_state <= 32)
        begin

            // Odd states: output data while clock is LOW
            if (spi_state[0])
            begin
                seg_clk <= 1'b0;
                seg_din <= shift_reg[15];
            end
            // Even states: clock HIGH and shift next bit
            else
            begin
                seg_clk   <= 1'b1;
                shift_reg <= {shift_reg[14:0],1'b0};
            end

            spi_state <= spi_state + 1;

        end
        else
        begin

            // End of one 16-bit SPI transfer
            seg_cs  <= 1'b1;
            seg_clk <= 1'b0;

            // Send initialization commands once,
            // then continuously refresh digits
            if(command < 8)
                command <= command + 1;
            else
                command <= 4'd5;

            spi_state <= 0;

        end

    end

end
endmodule