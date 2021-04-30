module morse(

	input CLK,
	output [1:0] LEDG,
	input button,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7
);

//input clock:50mhz
	reg [25:0] clk_counter = 0;

	always@(posedge CLK)begin
		clk_counter <= clk_counter + 1;
	end	
	
	assign clock_millisec = clk_counter[22];
	
	reg [10:0] counter = 0;
	reg [3:0] pattern = 0;			//pattern=0000 -> 4 short  , pattern=1111 -> 4 long
	reg [3:0] pattern_buffer = 0; //holds prev letter pattern
	reg [2:0] morse_count = 0;		// how many letters in the pattern, eg:E:1, H4
	reg [2:0] morse_count_buffer = 0; //holds prev button press count
	reg [1:0] btn_state = 0;
	reg [4:0] letter_decoded = 0; // 1->A 26->Z
	reg  new_letter_present = 0;
	reg [4:0] letters_decoded[0:7];	//holds prev input, is used to shift letters over 
	
	localparam WAIT_NEW_LETTER = 0; //assign for state machine
	localparam BTN_PRESSED = 1;
	localparam BTN_CHECK_FURTHER = 2;

	reg short_pulse = 0; //debugging, first green is on for short, second green is on for long
	reg long_pulse = 0;
	assign LEDG[0] = short_pulse; //debugging, first green is on for short, second green is on for long
	assign LEDG[1] = long_pulse;
	
	always@(posedge clock_millisec) begin
		case(btn_state)
			WAIT_NEW_LETTER:begin
				if(button == 0) begin 		//button pressed
					btn_state <= BTN_PRESSED;
				end
				pattern <= 0;
				morse_count <= 0;
				counter <= 0;
				new_letter_present <= 0;				
			end
			BTN_PRESSED:begin
				if(button == 0)begin       //still pressed
					counter <= counter + 1;	
				end
				else begin				    //now released
					if(counter > 4) begin 				// its a long press
						pattern[morse_count] <= 1;
						morse_count<=morse_count + 1;
						btn_state <= BTN_CHECK_FURTHER;
						short_pulse <= 0;
						long_pulse <= 1;
					end
					else begin 								// its a short press
						pattern[morse_count] <= 0;
						morse_count <= morse_count + 1;
						btn_state <= BTN_CHECK_FURTHER;
						short_pulse <= 1;
						long_pulse <= 0;						
					end
					counter <= 0;
				end
			end
			BTN_CHECK_FURTHER:begin
				if(button == 1)begin					
					
					if(counter > 4)begin					//released for long time:new letter
						btn_state <= WAIT_NEW_LETTER; 
						new_letter_present <= 1;
						letters_decoded[0] <= letter_decoded;
						letters_decoded[1] <= letters_decoded[0];
						letters_decoded[2] <= letters_decoded[1];
						letters_decoded[3] <= letters_decoded[2];
						letters_decoded[4] <= letters_decoded[3];
						letters_decoded[5] <= letters_decoded[4];
						letters_decoded[6] <= letters_decoded[5];
						letters_decoded[7] <= letters_decoded[6];
						pattern_buffer <= pattern;		
						morse_count_buffer <= morse_count;						
					end
					else
					  counter <= counter + 1;				
						
				end
				else begin
  						//same letter continuation
						btn_state <= BTN_PRESSED;
						counter <= 0;
				end
			end
			
		endcase
	end
	
	always@(*)begin
		if(new_letter_present)begin
			if(morse_count_buffer == 1)begin /// letters with single morse signals
				if(pattern_buffer[0] == 1)
					letter_decoded = 20;//T=20
				else
					letter_decoded = 5;//E=5
			end
			else if(morse_count_buffer == 2)begin // letters with two morse signals
				if(pattern_buffer[1:0] == 2'b10)begin
					letter_decoded = 1;//A
				end
				else if(pattern_buffer[1:0] == 2'b00)begin
					letter_decoded = 9;//I
				end
				else if(pattern_buffer[1:0] == 2'b11)begin
					letter_decoded = 13;//M
				end
				else if(pattern_buffer[1:0] == 2'b01)begin
					letter_decoded = 14;//N
				end			
			end
			else if(morse_count_buffer == 3)begin // letters with three morse signals
				if(pattern_buffer[2:0] == 3'b000)begin
					letter_decoded = 19;//S
				end
				else if(pattern_buffer[2:0] == 3'b100)begin
					letter_decoded = 21;//U
				end
				else if(pattern_buffer[2:0] == 3'b001)begin
					letter_decoded = 4;//D
				end	
				else if(pattern_buffer[2:0] == 3'b011)begin
					letter_decoded = 7; //G
				end	
				else if(pattern_buffer[2:0] == 3'b101)begin
					letter_decoded = 11;//K
				end	
				else if(pattern_buffer[2:0] == 3'b111)begin
					letter_decoded = 15;//O
				end
				else if(pattern_buffer[2:0] == 3'b010)begin
					letter_decoded = 18;//R
				end
				else if(pattern_buffer[2:0] == 3'b110)begin
					letter_decoded = 23;//W
				end			
			end
			else if(morse_count_buffer == 4)begin // letters with four morse signals
				if(pattern_buffer[3:0] == 4'b0000)begin
					letter_decoded = 8;//H
				end
				else if(pattern_buffer[3:0] == 4'b0001)begin
					letter_decoded = 2;//B
				end
				else if(pattern_buffer[3:0] == 4'b0101)begin
					letter_decoded = 3;//C
				end				
				else if(pattern_buffer[3:0] == 4'b0100)begin
					letter_decoded = 6;//F
				end
				else if(pattern_buffer[3:0] == 4'b1110)begin
					letter_decoded = 10;//J
				end
				else if(pattern_buffer[3:0] == 4'b0010)begin
					letter_decoded = 12;//L
				end
				else if(pattern_buffer[3:0] == 4'b0110)begin
					letter_decoded = 16;//P 
				end
				else if(pattern_buffer[3:0] == 4'b1011)begin
					letter_decoded = 17;//Q
				end
				else if(pattern_buffer[3:0] == 4'b1000)begin
					letter_decoded = 22;//V
				end
				else if(pattern_buffer[3:0] == 4'b1001)begin
					letter_decoded = 24;//X
				end	
				else if(pattern_buffer[3:0] == 4'b1101)begin
					letter_decoded = 25;//Y
				end				
				else if(pattern_buffer[3:0] == 4'b0011)begin
					letter_decoded = 26;//Z
				end					
			end			
		end	
	end 

	alp2hex h0(letter_decoded,HEX0);
	alp2hex h1(letters_decoded[0],HEX1);
	alp2hex h2(letters_decoded[1],HEX2);
	alp2hex h3(letters_decoded[2],HEX3);
	alp2hex h4(letters_decoded[3],HEX4);
	alp2hex h5(letters_decoded[4],HEX5);
	alp2hex h6(letters_decoded[5],HEX6);
	alp2hex h7(letters_decoded[6],HEX7);
	
endmodule