/*
32 bit ALU
ucode can be:
+ 000
* 001
( 010
) 011
n 100
= 101
number can be a signed 32bit number

YOU SHOULD PUT THE HOLE EQUATION IN COUPLE OF
PARENTHESES AND PUT AN EQUAL SIGN IN THE END
for example:
2 * 3 + ( 10 + 4 + 3 ) * -20 + ( 6 + 5 )
should be written as:
( 2 * 3 + ( 10 + 4 + 3 ) * -20 + ( 6 + 5 ) )=
*/
module ALU (clk, ucode, number, ready, out);
input clk;
input ucode;
input number;
output ready;
output out;

wire [2:0] ucode;
wire [31:0] number;
reg ready = 1;
wire [31:0] out;
reg [2:0] opcode;
wire overflow;
reg [1:0] mustmult = 0;

STACK_BASED_ALU #(.n(32)) sbalu (clk, number, out, opcode, overflow);
integer stacksz = 0;
integer parstack [999:0];
integer parfreeid = 0;

always @(negedge clk)
if (mustmult > 1) // handle the multiplication
begin
    opcode = 3'b101;
    mustmult = 0;
    stacksz = stacksz - 1;
end
else if (ready == 1) // read from input
begin
    if (ucode == 3'b000) // read +
    begin
        opcode = 0;
    end
    else if (ucode == 3'b001)
    begin
        mustmult = 1; // read *
        opcode = 0;
    end
    else if (ucode == 3'b010) // read (
    begin
        parstack[parfreeid] = stacksz + 1;
        parfreeid = parfreeid + 1;
        opcode = 0;
   //     $display("parfreeid=%d, stacksz=%d", parfreeid, stacksz);
    end
    else if (ucode == 3'b011) // read )
    begin
        parfreeid = parfreeid - 1;
        ready = 0;
        opcode = 0;
    end
    else if (ucode == 3'b100) // read n
    begin
        opcode = 3'b110;
        if (mustmult == 1) mustmult = 2;
        stacksz = stacksz + 1;
    end
    else if (ucode == 3'b101) // read =  // end of process
    begin
        opcode = 3'b111;
    end
end
else // parentheses handling
begin
$display(">>>> parfreeid=%d, stacksz=%d should be %d", parfreeid, stacksz, parstack[parfreeid]);
if (stacksz > parstack[parfreeid])
begin
    stacksz = stacksz - 1;
    opcode = 3'b100;
end
else
begin
    ready = 1;
    opcode = 0;
end
end
endmodule

