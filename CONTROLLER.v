module CONTROLLER (
    input wire clk,
    input wire rst,
    output reg [6:0] A, B,
    output reg [1:0] OP,
    output reg flag,
    output reg done
);

    // Define states as parameters (no typedef enum)
    parameter START  = 3'd0;
    parameter ONE    = 3'd1;
    parameter TWO    = 3'd2;
    parameter THREE  = 3'd3;
    parameter FINISH = 3'd4;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= START;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            START:  next_state = ONE;
            ONE:    next_state = TWO;
            TWO:    next_state = THREE;
            THREE:  next_state = FINISH;
            FINISH: next_state = FINISH;
            default: next_state = START;
        endcase
    end

    // Output logic and registers (combined flag logic here)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 7'b0;
            B <= 7'b0;
            OP <= 2'b00;
            flag <= 1'b0;
            done <= 1'b0;
        end else begin
            // Default assignments to avoid inferred latches
            A <= 7'b0;
            B <= 7'b0;
            OP <= 2'b00;
            flag <= 1'b0;
            done <= 1'b0;

            case (state)
                ONE: begin
                    A <= 7'b1010101;
                    B <= 7'b0101010;
                    OP <= 2'b00; // NAND
                end
                TWO: begin
                    A <= 7'b1110000;
                    B <= 7'b0000011;
                    OP <= 2'b01; // ROL
                end
                THREE: begin
                    A <= 7'b0000000;
                    B <= 7'b0000001;
                    OP <= 2'b00; // NAND, expect R=7'b1111111
                end
                FINISH: begin
                    done <= 1'b1;
                    flag <= (A | B) != 0;
                    // Outputs A, B, OP remain zero from defaults
                end
                default: begin
                    // Defaults already assigned above
                end
            endcase
        end
    end

endmodule