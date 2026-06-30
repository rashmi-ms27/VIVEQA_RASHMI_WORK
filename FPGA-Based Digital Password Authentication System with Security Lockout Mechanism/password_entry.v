module password_entry(

input clk,
input rst,

input valid,
input [3:0] key_value,

output reg [15:0] password,
output reg verify

);

reg [1:0] digit_count;
reg valid_d;

always @(posedge clk)
begin

if(rst)
begin

    digit_count <= 0;

    password <= 16'h0000;

    verify <= 0;

end

else
begin

    verify <= 0;

valid_d <= valid;

if(valid && !valid_d)
begin

        case(digit_count)

        2'd0:
        begin
            password[15:12] <= key_value;
            digit_count <= 1;
        end

        2'd1:
        begin
            password[11:8] <= key_value;
            digit_count <= 2;
        end

        2'd2:
        begin
            password[7:4] <= key_value;
            digit_count <= 3;
        end

        2'd3:
        begin

            password[3:0] <= key_value;

            verify <= 1'b1;

            digit_count <= 0;

        end

        endcase

    end

end

end

endmodule
