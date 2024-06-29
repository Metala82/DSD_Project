module Stack #(parameter N = 16, parameter STACK_SIZE = 16) (
    input clk,
    input reset,
    input push,
    input pop,
    input [N-1:0] push_data,
    output [N-1:0] pop_data,
    output reg [N-1:0] top,
    output reg empty,
    output reg full
);

    reg [N-1:0] stack_mem [0:STACK_SIZE-1];
    reg [4:0] sp; // Stack pointer
    reg [N-1:0] pop_data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp <= 0;
            empty <= 1;
            full <= 0;
            pop_data_reg <= 0;
        end else begin
            if (push && !full) begin
                stack_mem[sp] <= push_data;
                sp <= sp + 1;
                empty <= 0;
                if (sp == STACK_SIZE-1) full <= 1;
            end else if (pop && !empty) begin
                sp <= sp - 1;
                pop_data_reg <= stack_mem[sp];
                full <= 0;
                if (sp == 1) empty <= 1;
            end
            if (sp > 0)
                top <= stack_mem[sp-1];
        end
    end

    assign pop_data = pop_data_reg;

    // Task to print stack contents
    task print_stack;
        integer i;
        begin
            $display("Stack contents at time %0t:", $time);
            for (i = 0; i < sp; i = i + 1) begin
                $display("stack_mem[%0d] = %0d", i, stack_mem[i]);
            end
        end
    endtask

endmodule

