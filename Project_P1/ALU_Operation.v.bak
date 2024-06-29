module ALU_Operations #(parameter N = 16) (
    input [N-1:0] data_a,
    input [N-1:0] data_b,
    input [2:0] opcode,
    output reg [N-1:0] result,
    output reg overflow
);

    always @(*) begin
        overflow = 0;
        case (opcode)
            3'b100: begin // Addition
                {overflow, result} = data_a + data_b;
            end
            3'b101: begin // Multiplication
                result = data_a * data_b; // Assuming no overflow for multiplication in this simplified example
            end
            default: result = 0;
        endcase
    end

endmodule

