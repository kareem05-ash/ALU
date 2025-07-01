module alu_tb();
    reg [31:0] A;         //first input
    reg [31:0] B;         //seconed input
    reg [2:0] opcode;     //the peration code
    wire [63:0] out;      //the output
    wire Sign_Flag;       //MSB of out
    wire Zero_Flag;       //assert out == 64'b0

    alu DUT(.A(A),        //module instantiation
            .B(B), 
            .opcode(opcode), 
            .out(out), 
            .Sign_Flag(Sign_Flag), 
            .Zero_Flag(Zero_Flag));

    initial
        begin
            repeat(30) //Checking 30 random case
                begin
                    A = $random; B = $random; opcode = $urandom_range(0 , 7);  //randomization
                    #10; //release 10 ns to track changes
                    if(out[63] == Sign_Flag) 
                        $display("Pass : Sign_Flag");
                    else
                        $display("Error : Sign_Flag");
                    if((out == 64'b0) && Zero_Flag)
                        $display("Pass : Zero_Flag");
                    else if(out != 64'b0 && !Zero_Flag)
                        $display("Pass : Zero_Flag");
                    else
                        $display("Error : Zero_Flag");
                    case(opcode)
                        3'b000 :if(out == A + B)
                                    $display("Pass : Addition");
                                else
                                    $display("Error : Addition, at time = %t, A = %d , B = %b" , $time, A, B);
                        3'b001 :if(out == A - B)
                                    $display("Pass : Subtraction");
                                else
                                    $display("Error : Subtraction, at time = %t, A = %d , B = %b" , $time, A, B);
                        3'b010 :if(out == A * B)   
                                    $display("Pass : Multiplication");
                                else
                                    $display("Error : Multiplication, at time = %t, A = %d , B = %b" , $time, A, B); 
                        3'b011 :if(out[31:0] == &A)
                                    $display("Pass : Bitwise AND Gate");
                                else
                                    $display("Error : Reduction AND Gate on A, at time = %t, A = %b , B = %b" , $time, A, B);  
                        3'b101 :if(out[31:0] == A ^ B)     
                                    $display("Pass : Bitwise XOR Gate");
                                else
                                    $display("Error : Bitwise XOR Gate, at time = %t, A = %b , B = %b" , $time, A, B);
                        3'b110 :if(out == A << B[4:0])   
                                    $display("Pass : Shift to left");
                                else
                                    $display("Error : Shift to left, at time = %t, A = %b , B = %d" , $time, A, B);
                        3'b111 :if(out == A >> B[4:0])    
                                    $display("Pass : Shift to right");
                                else
                                    $display("Error : Shift to right, at time = %t, A = %b , B = %d" , $time, A, B);
                        default:if(out == 64'b0)      
                                    $display("Pass : Default to zero");
                                else
                                    $display("Error : Default to zero, at time = %t" , $time);
                    endcase
                end
            #100; $stop;
        end
endmodule