module ALU_OP1_NAND (
    input wire [6:0] A, B,
    output wire [6:0] R
);

    assign R = ~(A & B);

endmodule