module password_manager(
    input  [15:0] entered_password,
    output match
);

assign match = (entered_password == 16'h1234);

endmodule