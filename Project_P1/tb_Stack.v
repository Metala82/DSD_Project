module tb_Stack();

    parameter N = 16;
    parameter STACK_SIZE = 16;

    reg clk;
    reg reset;
    reg push;
    reg pop;
    reg [N-1:0] push_data;
    wire [N-1:0] pop_data;
    wire [N-1:0] top;
    wire empty;
    wire full;

    Stack #(N, STACK_SIZE) uut (
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .push_data(push_data),
        .pop_data(pop_data),
        .top(top),
        .empty(empty),
        .full(full)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Monitor the stack status
        $monitor("At time %t, push = %b, pop = %b, push_data = %0d, pop_data = %0d, top = %0d, empty = %b, full = %b",
                 $time, push, pop, push_data, pop_data, top, empty, full);

        // Test reset
        reset = 1;
        push = 0;
        pop = 0;
        push_data = 0;
        #10 reset = 0;
        uut.print_stack();

        // Test push
        push_data = 10;
        push = 1;
        #10 push = 0;
        uut.print_stack();

        push_data = 20;
        push = 1;
        #10 push = 0;
        uut.print_stack();

        // Test pop
        pop = 1;
        #10 pop = 0;
        uut.print_stack();

        // Test push and pop together
        push_data = 30;
        push = 1;
        #10 push = 0;
        uut.print_stack();

        pop = 1;
        #10 pop = 0;
        uut.print_stack();

        $finish;
    end

endmodule

