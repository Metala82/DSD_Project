`timescale 1ns/1ps

module Calculator
(
    input clk,                   // Clock signal
    input [2:0] opcode,          // Microcode instruction
    input [15:0] operand          // Input operand
);

reg [2:0] alu_opcode;            // Operation code for ALU
wire [15:0] alu_result;           // Result from ALU
wire overflow;                   // Overflow flag from ALU

// Instantiate the STACK_BASED_ALU
STACK_BASED_ALU #(.DATA_WIDTH(16), .STACK_SIZE(64)) stack_alu (
    .clk(clk),
    .input_data(operand),
    .opcode(alu_opcode),
    .output_data(alu_result),
    .overflow(overflow)
);

integer pending_mult_stack [63:0]; // Stack to keep track of pending multiplications
integer pending_mult_index = 0;  // Index for the pending multiplication stack
integer pending_addition_stack [63:0]; // Stack to keep track of pending additions
integer pending_addition_index = 0;  // Index for the pending addition stack

// Always block to handle the operations
always @(negedge clk) begin
    // Handle multiplication
    if (pending_mult_stack[pending_mult_index] > 1) begin
        $display("multtttttttttttt");
        alu_opcode = 3'b101;    // Set opcode to multiplication
        #10
        pending_mult_stack[pending_mult_index] = 0;
    end
    // Handle addition
    else if (pending_addition_stack[pending_addition_index] > 1) begin
        $display("addddddddddd ");
        alu_opcode = 3'b100;    // Set opcode to addition
        pending_addition_stack[pending_addition_index] = 0;
    end
    // Handle input reading when no pending operations
    else begin
        $display("lets go");
        case (opcode)
            3'b000: begin // Addition
                $display("babababaababa");
                if (pending_addition_stack[pending_addition_index] == 1) begin
                    alu_opcode = 3'b100;    // Set opcode to addition
                    pending_addition_stack[pending_addition_index] = 1;
                end
                else begin
                    pending_addition_stack[pending_addition_index] = 1;
                    alu_opcode = 3'b000;
                end
            end
            3'b001: begin // Multiplication
                pending_mult_stack[pending_mult_index] = 1;
                alu_opcode = 3'b000;
            end
            3'b010: begin // Open parenthesis '('
                pending_mult_stack[pending_mult_index + 1] = 0; // Initialize next level multiplication state
                pending_addition_stack[pending_addition_index + 1] = 0; // Initialize next level addition state
                pending_mult_index = pending_mult_index + 1;
                pending_addition_index = pending_addition_index + 1;
                alu_opcode = 0;
            end
            3'b011: begin // Close parenthesis ')'
                if (pending_addition_stack[pending_addition_index] == 1) begin
                    alu_opcode = 3'b100;    // Set opcode to addition
                    pending_addition_stack[pending_addition_index] = 0;
                end
                else  begin
                    alu_opcode = 0;
                end
                pending_addition_index = pending_addition_index - 1;
                pending_mult_index = pending_mult_index - 1;
                if (pending_mult_stack[pending_mult_index] == 1) pending_mult_stack[pending_mult_index] = 2;
            end
            3'b100: begin // Operand
                alu_opcode = 3'b110;
                if (pending_mult_stack[pending_mult_index] == 1) pending_mult_stack[pending_mult_index] = 2;
            end
        endcase
    end
end

endmodule
