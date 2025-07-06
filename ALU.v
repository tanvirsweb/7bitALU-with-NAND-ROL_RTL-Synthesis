module ALU (
    input wire [6:0] A, B,
    input wire [1:0] OP,
    output reg [6:0] R
);

    wire [6:0] R_NAND, R_ROL;

    ALU_OP1_NAND NAND1 (.A(A), .B(B), .R(R_NAND));
    ALU_OP2_ROL ROL1 (.A(A), .n(B[2:0]), .R(R_ROL));

    always @(*) begin
        case (OP)
            2'b00: R = R_NAND;
            2'b01: R = R_ROL;
            default: R = 7'b0000000;
        endcase
    end

endmodule