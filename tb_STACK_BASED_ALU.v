`timescale 1ns/1ps

module tb_STACK_BASED_ALU;

  parameter DATA_WIDTH = 8;
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

  // Helper function to return operation name
  function [79:0] get_operation_name(input [2:0] opcode);
    case (opcode)
      3'b100: get_operation_name = "Addition";
      3'b101: get_operation_name = "Multiplication";
      3'b110: get_operation_name = "Push";
      3'b111: get_operation_name = "Pop";
      default: get_operation_name = "Unknown";
    endcase
  endfunction

  // Task to display the stack content
  task display_stack;
    integer i;
    begin
      $display("Stack content:");
      for (i = 0; i < alu.stack_pointer; i = i + 1) begin
        $display("stack[%0d] = %h", i, alu.stack[i]);
      end
    end
  endtask

  // Test procedure
  initial begin
    // Initialize inputs
    input_data = 0;
    opcode = 3'b000;

    // Wait for the clock to stabilize
    #10;

    // Test cases
    $monitor("Time = %0t, Opcode = %b (%0s), Input = %h, Output = %h, Overflow = %b, Stack Pointer = %d, Debug Value = %h",
             $time, opcode, get_operation_name(opcode), input_data, output_data, overflow, alu.stack_pointer, debug_value);

    // Push some values onto the stack
    input_data = 8'h05;
    opcode = 3'b110; // Push
    #10;
    display_stack;

    input_data = 8'h03;
    opcode = 3'b110; // Push
    #10;
    display_stack;

    // Perform addition
    opcode = 3'b100; // Add
    #10;
    display_stack;

    // Push more values
    input_data = 8'h02;
    opcode = 3'b110; // Push
    #10;
    display_stack;

    input_data = 8'h03;
    opcode = 3'b110; // Push
    #10;
    display_stack;

    // Perform addition again
    opcode = 3'b100; // Add
    #10;
    display_stack;

    input_data = 8'h04;
    opcode = 3'b110; // Push
    #10;
    display_stack;

    // Perform multiplication
    opcode = 3'b101; // Multiply
    #10;
    display_stack;

    // Push more values
    input_data = 8'h06;
    opcode = 3'b110; // Push
    #10;
    display_stack;

    input_data = 8'h02;
    opcode = 3'b110; // Push
    #10;
    display_stack;

    // Perform addition
    opcode = 3'b100; // Add
    #10;
    display_stack;

    // Perform multiplication again
    opcode = 3'b101; // Multiply
    #10;
    display_stack;

    // Pop a value from the stack
    opcode = 3'b111; // Pop
    #10;
    display_stack;

    // Test stack underflow
    opcode = 3'b111; // Pop
    #10;
    display_stack;

    opcode = 3'b111; // Pop
    #10;
    display_stack;

    // Push to stack overflow
    repeat (STACK_SIZE - 1) begin
      input_data = 8'h01;
      opcode = 3'b110; // Push
      #10;
      display_stack;
    end

    // Final push to cause overflow
    input_data = 8'h01;
    opcode = 3'b110; // Push
    #10;
    display_stack;

    // Finish the simulation
    $finish;
  end

endmodule
