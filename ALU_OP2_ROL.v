module ALU_OP2_ROL (
    input wire [6:0] A,    // 7-bit input
    input wire [2:0] n,    // 3-bit rotation amount (0 to 6)
    output reg [6:0] R     // 7-bit rotated output
);

    always @(*) begin
        case(n)
            3'd0: R = A;
            3'd1: R = {A[5:0], A[6]}; // ROL 1
            3'd2: R = {A[4:0], A[6:5]}; // ROL 2
            3'd3: R = {A[3:0], A[6:4]}; // ROL 3
            3'd4: R = {A[2:0], A[6:3]}; // ROL 4
            3'd5: R = {A[1:0], A[6:2]}; // ROL 5
            3'd6: R = {A[0], A[6:1]}; // ROL 6
            default: R = A; // safety default
        endcase
    end

endmodule

