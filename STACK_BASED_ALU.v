`timescale 1ns/1ps

module STACK_BASED_ALU
#(parameter DATA_WIDTH = 8, parameter STACK_SIZE = 64)
(
    input clk,
    input [DATA_WIDTH-1:0] input_data,
    input [2:0] opcode,
    output reg [DATA_WIDTH-1:0] output_data,
    output reg overflow,
    output reg [DATA_WIDTH-1:0] debug_value
);

reg [DATA_WIDTH-1:0] stack [0:STACK_SIZE-1];
integer stack_pointer = 0;

always @(posedge clk) begin
    overflow <= 0;
    debug_value <= 0;
    case (opcode)
        3'b100: // addition
        begin
            if (stack_pointer >= 2) begin
                stack[stack_pointer - 2] <= stack[stack_pointer - 1] + stack[stack_pointer - 2];
                debug_value <= stack[stack_pointer - 2];
                if ((stack[stack_pointer - 2][DATA_WIDTH-1] == 1 && stack[stack_pointer - 1][DATA_WIDTH-1] == 0 && stack[stack_pointer - 2][DATA_WIDTH-1] == 0) ||
                    (stack[stack_pointer - 2][DATA_WIDTH-1] == 0 && stack[stack_pointer - 1][DATA_WIDTH-1] == 1 && stack[stack_pointer - 2][DATA_WIDTH-1] == 1))
                    overflow <= 1;
                stack_pointer <= stack_pointer - 1;
            end else begin
                overflow <= 1;
            end
            output_data <= {DATA_WIDTH{1'bz}};
        end

        3'b101: // multiplication
        begin
            if (stack_pointer >= 2) begin
                stack[stack_pointer - 2] <= stack[stack_pointer - 1] * stack[stack_pointer - 2];
                debug_value <= stack[stack_pointer - 2];
                if (|stack[stack_pointer - 2][2*DATA_WIDTH-1:DATA_WIDTH]) overflow <= 1;
                stack_pointer <= stack_pointer - 1;
            end else begin
                overflow <= 1;
            end
            output_data <= {DATA_WIDTH{1'bz}};
        end

        3'b110: // pushing
        begin
            if (stack_pointer < STACK_SIZE) begin
                stack[stack_pointer] <= input_data;
                stack_pointer <= stack_pointer + 1;
            end else begin
                overflow <= 1;
            end
            output_data <= {DATA_WIDTH{1'bz}};
        end

        3'b111: // popping
        begin
            if (stack_pointer > 0) begin
                stack_pointer <= stack_pointer - 1;
                output_data <= stack[stack_pointer];
            end else begin
                overflow <= 1;
                output_data <= {DATA_WIDTH{1'bz}};
            end
        end

        default: begin
            overflow <= 0;
            output_data <= {DATA_WIDTH{1'bz}};
        end
    endcase
end

endmodule
