module STACK_BASED_ALU #(parameter N = 16) (
    input clk,
    input reset,
    input [N-1:0] input_data,
    input [2:0] opcode,
    output reg [N-1:0] output_data,
    output reg overflow
);

    wire [N-1:0] alu_result;
    wire alu_overflow;
    reg [N-1:0] operand_a, operand_b;
    wire [N-1:0] stack_top;
    wire [N-1:0] pop_data;
    reg push, pop;
    wire empty;
    wire full;
    reg [N-1:0] pop_value;

    ALU_Operations #(N) alu (
        .data_a(operand_a),
        .data_b(operand_b),
        .opcode(opcode),
        .result(alu_result),
        .overflow(alu_overflow)
    );

    Stack #(N) stack (
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .push_data(input_data),
        .pop_data(pop_data),
        .top(stack_top),
        .empty(empty),
        .full(full)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            operand_a <= 0;
            operand_b <= 0;
            output_data <= 0;
            overflow <= 0;
            push <= 0;
            pop <= 0;
            pop_value <= 0;
        end else begin
            push <= 0;
            pop <= 0;
            case (opcode)
                3'b100: begin // Addition
                    if (!empty && stack.sp > 1) begin
                        pop <= 1;
                        operand_a <= pop_data;
                        operand_b <= stack_top;
                        #1 output_data <= alu_result;
                        overflow <= alu_overflow;
                        #1 pop <= 0; // Ensure pop operation completes before next clock cycle
                    end else begin
                        output_data <= 0; // Not enough operands
                        overflow <= 0;
                    end
                end
                3'b101: begin // Multiplication
                    if (!empty && stack.sp > 1) begin
                        pop <= 1;
                        operand_a <= pop_data;
                        operand_b <= stack_top;
                        #1 output_data <= alu_result;
                        overflow <= alu_overflow;
                        #1 pop <= 0; // Ensure pop operation completes before next clock cycle
                    end else begin
                        output_data <= 0; // Not enough operands
                        overflow <= 0;
                    end
                end
                3'b110: begin // PUSH
                    push <= 1;
                    output_data <= 0;
                    overflow <= 0;
                    #1 push <= 0; // Ensure push operation completes before next clock cycle
                end
                3'b111: begin // POP
                    if (!empty) begin
                        pop <= 1;
                        #1 output_data <= pop_data;
                        pop_value <= pop_data;
                        #1 pop <= 0; // Ensure pop operation completes before next clock cycle
                    end else begin
                        output_data <= 0;
                    end
                    overflow <= 0;
                end
                default: begin
                    output_data <= 0;
                    overflow <= 0;
                end
            endcase
        end
    end

endmodule

