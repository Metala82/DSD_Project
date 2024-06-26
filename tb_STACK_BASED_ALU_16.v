`timescale 1ns/1ps

module tb_STACK_BASED_ALU_16;

  parameter DATA_WIDTH = 16;
  parameter STACK_SIZE = 64;

  reg clk;
  reg [DATA_WIDTH-1:0] input_data;
  reg [2:0] opcode;
  wire [DATA_WIDTH-1:0] output_data;
  wire overflow;
  wire [DATA_WIDTH-1:0] debug_value;

  STACK_BASED_ALU #(DATA_WIDTH, STACK_SIZE) alu (
    .clk(clk),
    .input_data(input_data),
    .opcode(opcode),
    .output_data(output_data),
    .overflow(overflow),
    .debug_value(debug_value)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period clock
  end

  initial begin
    // Initialize inputs
    input_data = 0;
    opcode = 3'b000;

    // Wait for the clock to stabilize
    #10;

    // Test cases
    $monitor("Time = %0t, Opcode = %b, Input = %h, Output = %h, Overflow = %b, Stack Pointer = %d, Debug Value = %h",
             $time, opcode, input_data, output_data, overflow, alu.stack_pointer, debug_value);

    // Push 2 values
    input_data = 16'h0003;
    opcode = 3'b110; // Push
    #10;

    input_data = 16'h0002;
    opcode = 3'b110; // Push
    #10;

    // Multiply values
    opcode = 3'b101; // Multiply
    #10;

    // Pop result
    opcode = 3'b111; // Pop
    #10;

    // Finish the simulation
    $finish;
  end

endmodule
