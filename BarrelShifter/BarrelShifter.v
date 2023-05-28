module BarrelShifter #(parameter N=32)
(
	input [N-1:0] Input,
	input [$clog2(N)-1:0] Shift_Val,
	output [N-1:0] Result
);

genvar i, j, k;
generate

wire MUX_Out[$clog2(N)][N];

for (i=N/2; 0<i; i=i/2) begin : Main

	if (i == N/2) begin
		for (j=0; j<N; j=j+1) begin : First
			if (j < N-i)
				MUX A(.I0(Input[j]), .I1(Input[j+i]), .Select(Shift_Val[$clog2(i)]), .Out(MUX_Out[$clog2(i)][j]));

			else
				MUX A(.I0(Input[j]), .I1(1'b0), .Select(Shift_Val[$clog2(i)]), .Out(MUX_Out[$clog2(i)][j]));
		end
	end
	
	
	
	else begin
		for (j=0; j<N; j=j+1) begin : Rest
			if (j < N-i)
				MUX A(.I0(MUX_Out[$clog2(i)+1][j]), .I1(MUX_Out[$clog2(i)+1][j+i]), .Select(Shift_Val[$clog2(i)]), .Out(MUX_Out[$clog2(i)][j]));

			else
				MUX A(.I0(MUX_Out[$clog2(i)+1][j]), .I1(1'b0), .Select(Shift_Val[$clog2(i)]), .Out(MUX_Out[$clog2(i)][j]));
		end
	end
	
end


for (i=0; i<N; i=i+1) begin : Output_Vars
	assign Result[i] = MUX_Out[0][i];
end

endgenerate
endmodule
