`timescale 1ns/1ps

module tb_Calculator;

  reg clk;
  reg [2:0] opcode;
  reg [15:0] operand;
  wire [15:0] alu_result;

  // Instantiate the Calculator
  Calculator calculator (
    .clk(clk),
    .opcode(opcode),
    .operand(operand)
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

  // Task to display the current pending multiplication and addition states
  task display_pending_states;
    begin
      $display("Pending multiplication state: %0d", calculator.pending_mult_stack[calculator.pending_mult_index]);
      $display("Pending addition state: %0d", calculator.pending_addition_stack[calculator.pending_addition_index]);
    end
  endtask

  // Task to display the progress of the expression calculation
  task display_progress(input [8*80:1] expression, input integer current_step);
    begin
      $display("Progress at step %0d: %0s", current_step, expression);
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
    $monitor("Time = %0t, Opcode = %b (%0s), Operand = %h, Alu_Result = %h, Pending Mult = %0d, Pending Add = %0d",
             $time, opcode, get_operation_name(opcode), operand, calculator.alu_result,
             calculator.pending_mult_stack[calculator.pending_mult_index],
             calculator.pending_addition_stack[calculator.pending_addition_index]);

    // Expression: (2 * 3 + (10 + 4 + 3) * -20 + (6 + 5))=

    // Step 1: Begin expression with '('
    opcode = 3'b010; // Open Parenthesis
    operand = 16'bz;
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 1);

    // Step 2: Push operand 2
    operand = 16'd2;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 2);

    // Step 3: Multiply 2 *
    operand = 16'bz;
    opcode = 3'b001; // Multiplication
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 3);

    // Step 4: Push operand 3
    operand = 16'd3;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 4);
	#10
    // Step 5: Addition operation after 2 * 3
    operand = 16'bz;
    opcode = 3'b000; // Addition
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 5);

    // Step 6: Open parenthesis '('
    operand = 16'bz;
    opcode = 3'b010; // Open Parenthesis
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 6);

    // Step 7: Push operand 10
    operand = 16'd10;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 7);

    // Step 8: Addition 10 +
    operand = 16'bz;
    opcode = 3'b000; // Addition
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 8);

    // Step 9: Push operand 4
    operand = 16'd4;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 9);

    // Step 10: Addition 10 + 4 + 
    operand = 16'bz;
    opcode = 3'b000; // Addition
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 10);

    // Step 11: Push operand 3
    operand = 16'd3;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 11);


    // Step 13: Close parenthesis ')'
    operand = 16'bz;
    opcode = 3'b011; // Close Parenthesis
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 13);

    // Step 14: Multiply (10 + 4 + 3) *
    operand = 16'bz;
    opcode = 3'b001; // Multiplication
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 14);

    // Step 15: Push operand -20
    operand = -16'd20;
    opcode = 3'b100; // Push Operand
    #20;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 15);

    // Step 16: Addition after first block
    operand = 16'bz;
    opcode = 3'b000; // Addition
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 16);

    // Step 17: Open parenthesis '('
    operand = 16'bz;
    opcode = 3'b010; // Open Parenthesis
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 17);

    // Step 18: Push operand 6
    operand = 16'd6;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 18);

    // Step 19: Addition 6 +
    operand = 16'bz;
    opcode = 3'b000; // Addition
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 19);

    // Step 20: Push operand 5
    operand = 16'd5;
    opcode = 3'b100; // Push Operand
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 20);

    // Step 21: Close parenthesis ')'
    operand = 16'bz;
    opcode = 3'b011; // Close Parenthesis
    #10;
    display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 21);
    #10;
     display_stack;
    display_pending_states;
    display_progress("(2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) =", 21);


    $finish;
  end

endmodule
