1. 1-bit Full Adder using Dataflow Modeling

full_adder.v

module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum  = a ^ b ^ cin;
assign cout = (a & b) | (b & cin) | (a & cin);

endmodule




tb_full_adder.v

module tb_full_adder;

reg a,b,cin;
wire sum,cout;

full_adder uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    $monitor("a=%b b=%b cin=%b sum=%b cout=%b",
              a,b,cin,sum,cout);

    a=0;b=0;cin=0;
    #10 a=0;b=0;cin=1;
    #10 a=0;b=1;cin=0;
    #10 a=0;b=1;cin=1;
    #10 a=1;b=0;cin=0;
    #10 a=1;b=0;cin=1;
    #10 a=1;b=1;cin=0;
    #10 a=1;b=1;cin=1;

    #10 $finish;
end

endmodule

2. 2×4 Decoder using Dataflow Modeling

decoder2x4.v

module decoder2x4(
    input a,
    input b,
    output [3:0] y
);

assign y[0] = ~a & ~b;
assign y[1] = ~a &  b;
assign y[2] =  a & ~b;
assign y[3] =  a &  b;

endmodule

tb_decoder2x4.v

module tb_decoder2x4;

reg a,b;
wire [3:0] y;

decoder2x4 uut(
    .a(a),
    .b(b),
    .y(y)
);

initial begin
    $monitor("a=%b b=%b y=%b",a,b,y);

    a=0;b=0;
    #10 a=0;b=1;
    #10 a=1;b=0;
    #10 a=1;b=1;

    #10 $finish;
end

endmodule

3. 8×3 Priority Encoder using Structural Modeling

priority_encoder8x3.v

module priority_encoder8x3(
    input [7:0] d,
    output [2:0] y
);

assign y[2] = d[4] | d[5] | d[6] | d[7];
assign y[1] = d[2] | d[3] | d[6] | d[7];
assign y[0] = d[1] | d[3] | d[5] | d[7];

endmodule

tb_priority_encoder8x3.v

module tb_priority_encoder8x3;

reg [7:0] d;
wire [2:0] y;

priority_encoder8x3 uut(
    .d(d),
    .y(y)
);

initial begin
    $monitor("d=%b y=%b",d,y);

    d=8'b00000001;
    #10 d=8'b00000010;
    #10 d=8'b00000100;
    #10 d=8'b00001000;
    #10 d=8'b00010000;
    #10 d=8'b00100000;
    #10 d=8'b01000000;
    #10 d=8'b10000000;

    #10 $finish;
end

endmodule

4. 4-bit Ripple Carry Adder using 1-bit Full Adder

full_adder.v

module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum  = a ^ b ^ cin;
assign cout = (a & b) | (b & cin) | (a & cin);

endmodule

ripple_carry_adder.v

module ripple_carry_adder(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

wire c1,c2,c3;

full_adder FA0(a[0],b[0],cin,sum[0],c1);
full_adder FA1(a[1],b[1],c1,sum[1],c2);
full_adder FA2(a[2],b[2],c2,sum[2],c3);
full_adder FA3(a[3],b[3],c3,sum[3],cout);

endmodule

tb_ripple_carry_adder.v

module tb_ripple_carry_adder;

reg [3:0] a,b;
reg cin;
wire [3:0] sum;
wire cout;

ripple_carry_adder uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    $monitor("a=%b b=%b cin=%b sum=%b cout=%b",
              a,b,cin,sum,cout);

    a=4'b0011; b=4'b0101; cin=0;
    #10 a=4'b1111; b=4'b0001;
    #10 a=4'b1010; b=4'b0110;

    #10 $finish;
end

endmodule

5. 4:1 MUX using 2:1 MUXes

mux2x1.v

module mux2x1(
    input a,
    input b,
    input s,
    output y
);

assign y = s ? b : a;

endmodule

mux4x1.v

module mux4x1(
    input i0,
    input i1,
    input i2,
    input i3,
    input [1:0] s,
    output y
);

wire w1,w2;

mux2x1 M1(i0,i1,s[0],w1);
mux2x1 M2(i2,i3,s[0],w2);
mux2x1 M3(w1,w2,s[1],y);

endmodule

tb_mux4x1.v

module tb_mux4x1;

reg i0,i1,i2,i3;
reg [1:0] s;
wire y;

mux4x1 uut(
    .i0(i0),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .s(s),
    .y(y)
);

initial begin
    i0=0; i1=1; i2=0; i3=1;

    $monitor("s=%b y=%b",s,y);

    s=2'b00;
    #10 s=2'b01;
    #10 s=2'b10;
    #10 s=2'b11;

    #10 $finish;
end

endmodule
6. 3×8 Decoder
decoder3x8.v
module decoder3x8(
    input [2:0] a,
    output [7:0] y
);

assign y = 8'b00000001 << a;

endmodule
tb_decoder3x8.v
module tb_decoder3x8;

reg [2:0] a;
wire [7:0] y;

decoder3x8 uut(
    .a(a),
    .y(y)
);

initial begin
    $monitor("a=%b y=%b",a,y);

    a=3'b000;
    #10 a=3'b001;
    #10 a=3'b010;
    #10 a=3'b011;
    #10 a=3'b100;
    #10 a=3'b101;
    #10 a=3'b110;
    #10 a=3'b111;

    #10 $finish;
end

endmodule
7. 8×3 Priority Encoder
priority_encoder.v
module priority_encoder(
    input [7:0] d,
    output reg [2:0] y
);

always @(*) begin
    casex(d)
        8'b1xxxxxxx : y = 3'b111;
        8'b01xxxxxx : y = 3'b110;
        8'b001xxxxx : y = 3'b101;
        8'b0001xxxx : y = 3'b100;
        8'b00001xxx : y = 3'b011;
        8'b000001xx : y = 3'b010;
        8'b0000001x : y = 3'b001;
        8'b00000001 : y = 3'b000;
        default     : y = 3'b000;
    endcase
end

endmodule
tb_priority_encoder.v
module tb_priority_encoder;

reg [7:0] d;
wire [2:0] y;

priority_encoder uut(
    .d(d),
    .y(y)
);

initial begin
    $monitor("d=%b y=%b",d,y);

    d=8'b00000001;
    #10 d=8'b00000010;
    #10 d=8'b00000100;
    #10 d=8'b00001000;
    #10 d=8'b00010000;
    #10 d=8'b00100000;
    #10 d=8'b01000000;
    #10 d=8'b10000000;

    #10 $finish;
end

endmodule




1. SR Latch using Gate Level Modelling
RTL
module sr_latch (
    input S,
    input R,
    output Q,
    output Qbar
);

nand(Q, S, Qbar);
nand(Qbar, R, Q);

endmodule
Testbench
module tb_sr_latch;

reg S, R;
wire Q, Qbar;

sr_latch U0 (
    .S(S),
    .R(R),
    .Q(Q),
    .Qbar(Qbar)
);

initial begin
    $monitor("Time=%0t S=%b R=%b Q=%b Qbar=%b",
              $time,S,R,Q,Qbar);

    S=1; R=1;   // Hold
    #10;

    S=0; R=1;   // Set
    #10;

    S=1; R=1;   // Hold
    #10;

    S=1; R=0;   // Reset
    #10;

    S=1; R=1;   // Hold
    #10;

    S=0; R=0;   // Invalid
    #10;

    $finish;
end

endmodule
2. JK Flip-Flop using Parameter Declaration
RTL
module jk_ff (
    input J,
    input K,
    input clk,
    output reg Q
);

parameter HOLD   = 2'b00;
parameter RESET  = 2'b01;
parameter SET    = 2'b10;
parameter TOGGLE = 2'b11;

always @(posedge clk)
begin
    case ({J,K})

        HOLD   : Q <= Q;

        RESET  : Q <= 1'b0;

        SET    : Q <= 1'b1;

        TOGGLE : Q <= ~Q;

    endcase
end

endmodule
Testbench
module tb_jk_ff;

reg J,K,clk;
wire Q;

jk_ff U0 (
    .J(J),
    .K(K),
    .clk(clk),
    .Q(Q)
);

always #5 clk = ~clk;

initial
begin
    clk=0;

    J=0; K=0;   // Hold
    #10;

    J=1; K=0;   // Set
    #10;

    J=0; K=1;   // Reset
    #10;

    J=1; K=1;   // Toggle
    #20;

    $finish;
end

initial
$monitor("Time=%0t J=%b K=%b Q=%b",
          $time,J,K,Q);

endmodule
3. T Flip-Flop using D Flip-Flop
D Flip-Flop
module d_ff (
    input D,
    input clk,
    output reg Q
);

always @(posedge clk)
    Q <= D;

endmodule
T Flip-Flop
module t_ff (
    input T,
    input clk,
    output Q
);

wire q_int;
wire D;

assign D = T ^ q_int;

d_ff U0 (
    .D(D),
    .clk(clk),
    .Q(q_int)
);

assign Q = q_int;

endmodule
Testbench
module tb_t_ff;

reg T,clk;
wire Q;

t_ff U0 (
    .T(T),
    .clk(clk),
    .Q(Q)
);

always #5 clk = ~clk;

initial
begin
    clk=0;

    T=0;
    #20;

    T=1;
    #40;

    T=0;
    #20;

    $finish;
end

initial
$monitor("Time=%0t T=%b Q=%b",
          $time,T,Q);

endmodule
4. 4-bit Synchronous Loadable Binary Up Counter
RTL
module up_counter_load (
    input clk,
    input rst,
    input load,
    input [3:0] D,
    output reg [3:0] Q
);

always @(posedge clk)
begin
    if(rst)
        Q <= 4'b0000;

    else if(load)
        Q <= D;

    else
        Q <= Q + 1'b1;
end

endmodule
Testbench
module tb_up_counter_load;

reg clk,rst,load;
reg [3:0] D;
wire [3:0] Q;

up_counter_load U0 (
    .clk(clk),
    .rst(rst),
    .load(load),
    .D(D),
    .Q(Q)
);

always #5 clk=~clk;

initial
begin
    clk=0;
    rst=1;
    load=0;
    D=4'b0000;

    #10 rst=0;

    #20 load=1;
    D=4'b1010;

    #10 load=0;

    #50 $finish;
end

initial
$monitor("Time=%0t Q=%b",$time,Q);

endmodule
5. 4-bit MOD-12 Loadable Binary Synchronous Up Counter
RTL
module mod12_counter (
    input clk,
    input rst,
    input load,
    input [3:0] D,
    output reg [3:0] Q
);

always @(posedge clk)
begin
    if(rst)
        Q <= 4'd0;

    else if(load)
        Q <= D;

    else if(Q == 4'd11)
        Q <= 4'd0;

    else
        Q <= Q + 1'b1;
end

endmodule
Testbench
module tb_mod12;

reg clk,rst,load;
reg [3:0] D;
wire [3:0] Q;

mod12_counter U0 (
    .clk(clk),
    .rst(rst),
    .load(load),
    .D(D),
    .Q(Q)
);

always #5 clk=~clk;

initial
begin
    clk=0;
    rst=1;
    load=0;

    #10 rst=0;

    #30 load=1;
    D=4'd8;

    #10 load=0;

    #100 $finish;
end

initial
$monitor("Time=%0t Count=%d",$time,Q);

endmodule
6. 4-bit Loadable Binary Synchronous Up-Down Counter
RTL
module up_down_counter (
    input clk,
    input rst,
    input load,
    input up_down,
    input [3:0] D,
    output reg [3:0] Q
);

always @(posedge clk)
begin
    if(rst)
        Q <= 4'b0000;

    else if(load)
        Q <= D;

    else if(up_down)
        Q <= Q + 1'b1;

    else
        Q <= Q - 1'b1;
end

endmodule
Testbench
module tb_up_down;

reg clk,rst,load,up_down;
reg [3:0] D;
wire [3:0] Q;

up_down_counter U0 (
    .clk(clk),
    .rst(rst),
    .load(load),
    .up_down(up_down),
    .D(D),
    .Q(Q)
);

always #5 clk=~clk;

initial
begin
    clk=0;
    rst=1;
    load=0;
    up_down=1;

    #10 rst=0;

    #30;

    load=1;
    D=4'd10;

    #10 load=0;

    #30 up_down=0;

    #50 $finish;
end

initial
$monitor("Time=%0t Count=%d",$time,Q);

endmodule