module keypad_decoder(

input key0,
input key1,
input key2,
input key3,
input key4,
input key5,
input key6,
input key7,
input key8,
input key9,

input keyA,
input keyB,
input keyC,
input keyD,
input keyE,
input keyF,

output reg valid,
output reg [3:0] key_value

);

always @(*)
begin

valid = 1'b1;

case(1'b1)

key0: key_value = 4'h0;
key1: key_value = 4'h1;
key2: key_value = 4'h2;
key3: key_value = 4'h3;

key4: key_value = 4'h4;
key5: key_value = 4'h5;
key6: key_value = 4'h6;
key7: key_value = 4'h7;

key8: key_value = 4'h8;
key9: key_value = 4'h9;

keyA: key_value = 4'hA;
keyB: key_value = 4'hB;
keyC: key_value = 4'hC;
keyD: key_value = 4'hD;
keyE: key_value = 4'hE;
keyF: key_value = 4'hF;

default:
begin
    valid = 1'b0;
    key_value = 4'h0;
end

endcase

end

endmodule
