`timescale 1ns/1ps

module tb_Calculator;

  reg clk;
  reg [2:0] opcode;
  reg [7:0] operand;
  wire [7:0] result;
  wire ready;

  // Instantiate the Calculator
  Calculator calculator (
    .clk(clk),
    .opcode(opcode),
    .operand(operand),
    .ready(ready),
    .result(result)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period clock
  end

  // Helper function to return operation name
  function [79:0] get_operation_name(input [2:0] opcode);
    case (opcode)
      3'b000: get_operation_name = "Addition";
      3'b001: get_operation_name = "Multiplication";
      3'b010: get_operation_name = "Open Parenthesis";
      3'b011: get_operation_name = "Close Parenthesis";
      3'b100: get_operation_name = "Push Operand";
      3'b101: get_operation_name = "Equal Sign";
      default: get_operation_name = "Unknown";
    endcase
  endfunction

  // Task to display the stack content
  task display_stack;
    integer i;
    begin
      $display("Stack content:");
      for (i = 0; i < calculator.stack_alu.stack_pointer; i = i + 1) begin
        $display("stack[%0d] = %h", i, calculator.stack_alu.stack[i]);
      end
    end
  endtask

  // Test procedure
  initial begin
    // Initialize inputs
    operand = 0;
    opcode = 3'b000;

    // Wait for the clock to stabilize
    #10;

    // Test cases
    $monitor("Time = %0t, Opcode = %b (%0s), Operand = %h, Result = %h, Ready = %b",
             $time, opcode, get_operation_name(opcode), operand, result, ready);

    // Step 1: Begin expression with '('
    opcode = 3'b010; // Open Parenthesis
    operand = 8'bz;
    #10;
    display_stack;

    // Step 2: Push operand 2
    operand = 8'd2;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;

    // Step 3: Push operand 3
    operand = 8'd3;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;

    // Step 4: Multiply 2 * 3
    opcode = 3'b001; // Multiplication
    operand = 8'bz;
    #10;
    display_stack;

    // Step 5: Open parenthesis '('
    opcode = 3'b010; // Open Parenthesis
    operand = 8'bz;
    #10;
    display_stack;

    // Step 6: Push operand 10
    operand = 8'd10;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;

    // Step 7: Push operand 4
    operand = 8'd4;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;

    // Step 8: Add 10 + 4
    opcode = 3'b000; // Addition
    operand = 8'bz;
    #10;
    display_stack;

    // Step 9: Push operand 3
    operand = 8'd3;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;

    // Step 10: Add 14 + 3
    opcode = 3'b000; // Addition
    operand = 8'bz;
    #10;
    display_stack;

    // Step 11: Close parenthesis ')'
    opcode = 3'b011; // Close Parenthesis
    operand = 8'bz;
    #10;
    display_stack;

    // Step 12: Push operand -20
    operand = -8'd20;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;

    // Step 13: Multiply (10 + 4 + 3) * -20
    opcode = 3'b001; // Multiplication
    operand = 8'bz;
    #10;
    display_stack;

    // Step 14: Add result to 2 * 3
    opcode = 3'b000; // Addition
    operand = 8'bz;
    #10;
    display_stack;

    // Step 15: Open parenthesis '('
    opcode = 3'b010; // Open Parenthesis
    operand = 8'bz;
    #10;
    display_stack;

    // Step 16: Push operand 6
    operand = 8'd6;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;

    // Step 17: Push operand 5
    operand = 8'd5;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;

    // Step 18: Add 6 + 5
    opcode = 3'b000; // Addition
    operand = 8'bz;
    #10;
    display_stack;

    // Step 19: Close parenthesis ')'
    opcode = 3'b011; // Close Parenthesis
    operand = 8'bz;
    #10;
    display_stack;

    // Step 20: Add final result
    opcode = 3'b000; // Addition
    operand = 8'bz;
    #10;
    display_stack;

    // Step 21: End expression with '='
    opcode = 3'b101; // Equal Sign
    operand = 8'bz;
    #10;
    display_stack;

    $finish;
  end

endmodule
