module ArrayDivider #(parameter N=32)
(
	input [N-1:0] Dividend,
	input [N-1:0] Divisor,
	output [N-1:0] Quotient
);

genvar i, j;

wire Ground = 1'b0;
wire Vcc = 1'b1;
wire Carry[N][N-1];
wire Down[N][N-1];

generate

	for (i=0; i<N; i=i+1) begin : Grid
	
		if (i==0) begin
			PU FirstRow1(.A(Dividend[N-1]), .B(Divisor[0]), .Cin(Vcc), .Cout(Carry[0][0]), .Select(Quotient[N-1]), .Down(Down[0][0]));
		
			for (j=1; j<N-1; j=j+1) begin : First
				PU FirstRow2(.A(Ground), .B(Divisor[j]), .Cin(Carry[0][j-1]), .Cout(Carry[0][j]), .Select(Quotient[N-1]), .Down(Down[0][j]));
			end
			
			PU FirstRow3(.A(Ground), .B(Divisor[N-1]), .Cin(Carry[0][N-2]), .Cout(Quotient[N-1]), .Select(Quotient[N-1]));
		end
		
		
		
		else begin
		
			PU AllRow1(.A(Dividend[N-i-1]), .B(Divisor[0]), .Cin(Vcc), .Cout(Carry[i][0]), .Select(Quotient[N-i-1]), .Down(Down[i][0]));
		
			for (j=1; j<N-1; j=j+1) begin : First
				PU AllRow2(.A(Down[i-1][j-1]), .B(Divisor[j]), .Cin(Carry[i][j-1]), .Cout(Carry[i][j]), .Select(Quotient[N-i-1]), .Down(Down[i][j]));
			end
			
			PU AllRow3(.A(Down[i-1][j-1]), .B(Divisor[N-1]), .Cin(Carry[i][N-2]), .Cout(Quotient[N-i-1]), .Select(Quotient[N-i-1]));
		
		end
	end
endgenerate

endmodule
