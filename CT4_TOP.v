module CT4_TOP (
    input wire clk,
    input wire rst,
    output wire [6:0] R,
    output wire flag
);

    wire [6:0] A, B;
    wire [1:0] OP;
    wire controller_flag;
    wire done;

    CONTROLLER controller (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .OP(OP),
        .flag(controller_flag),
        .done(done)
    );

    ALU alu (
        .A(A),
        .B(B),
        .OP(OP),
        .R(R)
    );

    assign flag = controller_flag;

endmodule
