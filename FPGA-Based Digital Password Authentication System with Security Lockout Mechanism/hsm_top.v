module hsm_top(

input clk,
input rst,

input key0, input key1, input key2, input key3,
input key4, input key5, input key6, input key7,
input key8, input key9,

input keyA, input keyB, input keyC, input keyD,
input keyE, input keyF,

output [7:0] led,

output seg_din,
output seg_clk,
output seg_load

);

wire valid;
wire [3:0] key_value;

wire [15:0] password;
wire verify;

wire match;
wire grant, deny, locked;

wire [1:0] display_state;

// Keypad
keypad_decoder KD(
.key0(key0), .key1(key1), .key2(key2), .key3(key3),
.key4(key4), .key5(key5), .key6(key6), .key7(key7),
.key8(key8), .key9(key9),
.keyA(keyA), .keyB(keyB), .keyC(keyC), .keyD(keyD),
.keyE(keyE), .keyF(keyF),
.valid(valid),
.key_value(key_value)
);

// Password entry
password_entry PE(
.clk(clk),
.rst(rst),
.valid(valid),
.key_value(key_value),
.password(password),
.verify(verify)
);

// Compare
password_manager PM(
.entered_password(password),
.match(match)
);

// FSM
security_fsm FSM(
.clk(clk),
.rst(rst),
.verify(verify),
.match(match),
.unlock_key(keyA),
.grant(grant),
.deny(deny),
.locked(locked),
.display_state(display_state)
);

// Display
// Display (Now using the correct module)
seg_display DISP(
    .clk_24mhz(clk),
    .display_state(display_state), // Connect the 24MHz clock
    .seg_din(seg_din),
    .seg_clk(seg_clk),
    .seg_cs(seg_load)
);

// LEDs
assign led[0] = rst;
assign led[1] = grant;
assign led[2] = deny;
assign led[4] = match;
assign led[7] = locked;

assign led[3] = 0;
assign led[5] = 0;
assign led[6] = 0;

endmodule
