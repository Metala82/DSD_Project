module TB;

reg clk = 0;
reg [31:0] number;
wire [31:0] out;
reg [2:0] ucode;
wire ready;
wire overflow;

ALU alu (clk, ucode, number, ready, out);

STACK_BASED_ALU #(.n(32)) sbalu (clk, number, out, ucode, overflow);

initial begin
    forever begin
        #10 clk = ~clk;
    end
end

initial begin // ( 2 * 3 + ( 10 + 4 + 3 ) * -20 + ( 6 + 5 ) ) =
    ucode = 3'b010; // (
    #20
    number = 2;
    ucode = 3'b100; // 2
    #20
    ucode = 3'b001; // *
    #20
    number = 3;
    ucode = 3'b100; // 3
    #20
    ucode = 3'b000; // +
    #20
    ucode = 3'b010; // (
    #20
    number = 10;
    ucode = 3'b100; // 10
    #20
    ucode = 3'b000; // +
    #20
    number = 4;
    ucode = 3'b100; // 4
    #20
    ucode = 3'b000; // +
    #20
    number = 3;
    ucode = 3'b100; // 3
    #20
    ucode = 3'b011; // )
    #80
    ucode = 3'b001; // *
    #20
    number = -20;
    ucode = 3'b100; // -20
    #20
    ucode = 3'b000; // +
    #20
    ucode = 3'b010; // (
    #20
    number = 6;
    ucode = 3'b100; // 6
    #20
    ucode = 3'b000; // +
    #20
    number = 5;
    ucode = 3'b100; // 5
    #20
    ucode = 3'b011; // )
    #60
    ucode = 3'b011; // )
    #80
    ucode = 3'b101; // =
    #30
    $stop; // answer should be -323 which is 11111111111111111111111010111101
end

initial begin
    $monitor("time: %t , clk=%b, output=%b", $time, clk, out);
end

endmodule
