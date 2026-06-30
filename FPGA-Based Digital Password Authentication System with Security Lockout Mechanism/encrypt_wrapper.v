module encrypt_wrapper #(
    parameter KEY = 16'hA5C3
)(
    input  [15:0] password,
    output [15:0] cipher
);

assign cipher = password ^ KEY;

endmodule

