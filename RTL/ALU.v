module alu
(
    input [31:0] A,         //first input
    input [31:0] B,         //seconed input
    input [2:0] opcode,     //the peration code
    output reg [63:0] out,  //the output
    output Sign_Flag,       //MSB of out
    output Zero_Flag        //assert out == 64'b0
);
    always@(*)
        case(opcode)
            3'b000 : out = A + B;                    //Addition
            3'b001 : out = A - B;                    //Subtraction
            3'b010 : out = A * B;                    //Multiplication
            3'b011 : out = {32'b0 , &A};             //Reduction AND Gate on A
            3'b101 : out = {32'b0 , A ^ B};          //Bitwise XOR Gate
            3'b110 : out = A << B[4:0];              //Shift to left controled with the least significant 5 bits
            3'b111 : out = A >> B[4:0];              //Shift to right controled with the least significant 5 bits
            default: out = 64'b0;                    //Default to zero
        endcase
    assign Zero_Flag = (out == 64'b0);
    assign Sign_Flag = out[63];
endmodule