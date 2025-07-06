module CONTROLLER_tb;

    reg clk, rst;
    wire [6:0] A, B;
    wire [1:0] OP;

    CONTROLLER uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .OP(OP)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("controller_test.vcd");
        $dumpvars(0, CONTROLLER_tb);

        clk = 0; rst = 1; #10;
        rst = 0; #50;

        $finish;
    end

    initial begin
        $monitor("Time=%0t A=%b B=%b OP=%b", $time, A, B, OP);
    end

endmodule