module tb_STACK_BASED_ALU();

    parameter N = 16; // Number of bits, which can be varied as needed

    reg clk;
    reg reset;
    reg [N-1:0] input_data;
    reg [2:0] opcode;
    wire [N-1:0] output_data;
    wire overflow;

    STACK_BASED_ALU #(N) uut (
        .clk(clk),
        .reset(reset),
        .input_data(input_data),
        .opcode(opcode),
        .output_data(output_data),
        .overflow(overflow)
    );

    reg [8*20:1] operation_name; // to hold the operation name, allowing up to 20 characters

    always begin
        clk = 1;
        #10 clk = ~clk;
    end

    initial begin
	clk = 1;
        reset = 1;
        #10 reset = 0;

        // Monitor outputs
        $monitor("At time %t, opcode = %b (%0s), input_data = %0d, output_data = %0d, overflow = %b", 
                 $time, opcode, operation_name, input_data, output_data, overflow);

        // Test No Operation
        opcode = 3'b000;
        operation_name = "No Operation";
        #20 uut.stack.print_stack();

        // Test PUSH
        input_data = 8;
        opcode = 3'b110;
        operation_name = "PUSH";
        #20 uut.stack.print_stack();

        input_data = 12;
        opcode = 3'b110;
        operation_name = "PUSH";
        #20 uut.stack.print_stack();

        // Test POP
        opcode = 3'b111;
        operation_name = "POP";
        #20 uut.stack.print_stack();

        // Test ADDITION (8 + 12)
        opcode = 3'b100;
        operation_name = "ADDITION";
        #20 uut.stack.print_stack();

        // Test PUSH (result of addition)
        input_data = output_data;
        opcode = 3'b110;
        operation_name = "PUSH";
        #20 uut.stack.print_stack();

        // Test PUSH
        input_data = 3;
        opcode = 3'b110;
        operation_name = "PUSH";
        #20 uut.stack.print_stack();

        // Test MULTIPLICATION (20 * 3)
        opcode = 3'b101;
        operation_name = "MULTIPLICATION";
        #20 uut.stack.print_stack();

        // Test PUSH (result of multiplication)
        input_data = output_data;
        opcode = 3'b110;
        operation_name = "PUSH";
        #20 uut.stack.print_stack();

        // Test ADDITION (60 + 8)
        opcode = 3'b100;
        operation_name = "ADDITION";
        #20 uut.stack.print_stack();

        // Reset for further tests
        reset = 1;
        #20 reset = 0;

        // Push values for overflow test
        input_data = {N{1'b1}}; // Max negative value
        opcode = 3'b110;
        operation_name = "PUSH";
        #20 uut.stack.print_stack();

        input_data = 1;
        opcode = 3'b110;
        operation_name = "PUSH";
        #20 uut.stack.print_stack();

        // Test ADDITION (Max negative value + 1, should overflow)
        opcode = 3'b100;
        operation_name = "ADDITION";
        #20 uut.stack.print_stack();

        $finish;
    end

endmodule

