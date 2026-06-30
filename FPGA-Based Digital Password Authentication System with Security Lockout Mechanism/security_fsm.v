module security_fsm(
    input clk,
    input rst,
    input verify,
    input match,
    input unlock_key,
    output reg grant,
    output reg deny,
    output reg locked,
    output reg [1:0] display_state
);

localparam IDLE    = 2'b00;
localparam SUCCESS = 2'b01;
localparam FAIL    = 2'b10;
localparam LOCK    = 2'b11;

reg [1:0] state;
reg [2:0] fail_count;
reg [24:0] fail_timer = 0; // Timer declared here, at the module level

// verify pulse
reg verify_d;
wire verify_pulse = verify & ~verify_d;

always @(posedge clk) begin
    if(rst) verify_d <= 0;
    else    verify_d <= verify;
end

always @(posedge clk) begin
    if(rst) begin
        state <= IDLE;
        fail_count <= 0;
        fail_timer <= 0;
    end else begin
        case(state)
            IDLE: begin
                fail_timer <= 0; // Reset timer when in IDLE
                if(verify_pulse) begin
                    if(match) begin
                        state <= SUCCESS;
                        fail_count <= 0;
                    end else begin
                        if(fail_count == 2) begin
                            state <= LOCK;
                            fail_count <= 3;
                        end else begin
                            fail_count <= fail_count + 1;
                            state <= FAIL;
                        end
                    end
                end
            end

            SUCCESS: if(unlock_key) state <= IDLE;

            FAIL: begin
                if (fail_timer < 24_000_000) begin // 1 second @ 24MHz
                    fail_timer <= fail_timer + 1;
                    state <= FAIL;
                end else begin
                    fail_timer <= 0;
                    state <= IDLE;
                end
            end

            LOCK: if(unlock_key) begin
                state <= IDLE;
                fail_count <= 0;
            end
        endcase
    end
end

// Registered Outputs
always @(posedge clk) begin
    case(state)
        SUCCESS: display_state <= 2'b01;
        FAIL:    display_state <= 2'b10;
        LOCK:    display_state <= 2'b11;
        default: display_state <= 2'b00;
    endcase
end

always @(*) begin
    grant  = (state == SUCCESS);
    deny   = (state == FAIL);
    locked = (state == LOCK);
end

endmodule



