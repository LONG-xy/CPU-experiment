module branch_equal (
    input[31:0] input1,
    input[31:0] input2,
    output reg  branch_equal
);
initial begin
    branch_equal <= 0;
end
always @(*) begin
    branch_equal <= (input1 == input2);
end
endmodule

