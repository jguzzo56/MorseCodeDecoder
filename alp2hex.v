module alp2hex(input [4:0]letter,output [6:0]hex_out);

	reg [6:0]hex=0;
	assign hex_out=~hex;
	
	always@(*)begin
		case(letter)
			0:hex <=7'h00;//all off
			1:hex <=7'h77;//A
			2:hex <=7'h7c;//B
			3:hex <=7'h39;//C
			4:hex <=7'h5E;//D
			5:hex <=7'h79;//E
			6:hex <=7'h71;//F
			7:hex <=7'h3D;//G
			8:hex <=7'h76;//H
			9:hex <=7'h30;//I
			10:hex <=7'h1E;//J
			11:hex <=7'h00;//K
			12:hex <=7'h38;//L
			13:hex <=7'h0;//M
			14:hex <=7'h54;//N
			15:hex <=7'h3F;//O
			16:hex <=7'h73;//P
			17:hex <=7'h67;//Q
			18:hex <=7'h50;//R
			19:hex <=7'h6D;//S
			20:hex <=7'h78;//T
			21:hex <=7'h3E;//U
			22:hex <=7'h1C;//V
			23:hex <=7'h0;//W
			24:hex <=7'h0;//X
			25:hex <=7'h6E;//Y
			26:hex <=7'h0;//Z
			default:	hex<=0;
		endcase
	end

endmodule
