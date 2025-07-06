module TOP_tb;

    reg clk, rst;
    wire [6:0] R;
    wire flag;

    CT4_TOP uut (
        .clk(clk),
        .rst(rst),
        .R(R),
        .flag(flag)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("top_test.vcd");
        $dumpvars(0, TOP_tb);

        clk = 0;
        rst = 1; #10;
        rst = 0; #100;

        $finish;
    end

    initial begin
        $monitor("Time=%0t R=%b, flag=%b", $time, R, flag);
    end

endmodule
