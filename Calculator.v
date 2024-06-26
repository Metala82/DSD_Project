`timescale 1ns/1ps

module Calculator
(
    input clk,                   // Clock signal
    input [2:0] opcode,          // Microcode instruction
    input [7:0] operand,         // Input operand
    output reg ready,            // Ready signal
    output [7:0] result          // Output result
);

reg [2:0] alu_opcode;            // Operation code for ALU
wire [7:0] alu_result;           // Result from ALU
wire overflow;                   // Overflow flag from ALU
reg [1:0] pending_multiplication = 0; // Multiplier flag

// Instantiate the STACK_BASED_ALU
STACK_BASED_ALU #(.DATA_WIDTH(8), .STACK_SIZE(64)) stack_alu (
    .clk(clk),
    .input_data(operand),
    .opcode(alu_opcode),
    .output_data(alu_result),
    .overflow(overflow)
);

assign result = alu_result;

integer stack_size = 0;          // Stack size counter
integer parenthesis_stack [63:0]; // Parentheses stack
integer par_stack_index = 0;     // Free index in parentheses stack

// Initial block to set the ready signal
initial begin
    ready = 1;
end

// Always block to handle the operations
always @(negedge clk) begin
    // Handle multiplication
    if (pending_multiplication > 1) begin
        alu_opcode = 3'b101;    // Set opcode to multiplication
        pending_multiplication = 0;
        stack_size = stack_size - 1; // Decrease stack size
    end
    // Handle input reading when ready
    else if (ready == 1) begin
        case (opcode)
            3'b000: begin // Addition
                alu_opcode = 3'b100;
            end
            3'b001: begin // Multiplication
                pending_multiplication = 1;
                alu_opcode = 0;
            end
            3'b010: begin // Open parenthesis '('
                parenthesis_stack[par_stack_index] = stack_size;
                par_stack_index = par_stack_index + 1;
                alu_opcode = 0;
            end
            3'b011: begin // Close parenthesis ')'
                par_stack_index = par_stack_index - 1;
                ready = 0;
                alu_opcode = 0;
            end
            3'b100: begin // Operand
                alu_opcode = 3'b110;
                if (pending_multiplication == 1) pending_multiplication = 2;
                stack_size = stack_size + 1;
            end
            3'b101: begin // Equal '='
                alu_opcode = 3'b111;
            end
        endcase
    end
    // Handle parentheses closing
    else begin
        if (stack_size > parenthesis_stack[par_stack_index]) begin
            stack_size = stack_size - 1;
            alu_opcode = 3'b100;
        end else begin
            ready = 1;
            alu_opcode = 0;
        end
    end
end

endmodule
