module ALU_tb;

    reg [6:0] A, B;
    reg [1:0] OP;
    wire [6:0] R;

    ALU uut (
        .A(A),
        .B(B),
        .OP(OP),
        .R(R)
    );

    initial begin
        $dumpfile("alu_test.vcd");
        $dumpvars(0, ALU_tb);

        A = 7'b1010101; B = 7'b0101010; OP = 2'b00; #10;
        A = 7'b1110000; B = 7'b0000011; OP = 2'b01; #10;
        A = 7'b0001111; B = 7'b0000100; OP = 2'b10; #10;
        A = 7'b1111111; B = 7'b0000001; OP = 2'b11; #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t A=%b B=%b OP=%b -> R=%b", $time, A, B, OP, R);
    end

endmodule