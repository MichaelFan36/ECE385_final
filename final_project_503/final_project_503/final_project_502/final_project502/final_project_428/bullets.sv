module bullets1(input [1:0] is_tank_in,
					input Clk, 
					input frame_clk,
					input Reset, 
					input [31:0] keycode,
					input  [9:0] DrawX, DrawY,
					input [9:0]  Right_mid_X, Right_mid_Y, 
					input [9:0]  Up_mid_X, Up_mid_Y,
					input [9:0]  Left_mid_X, Left_mid_Y,
					input [9:0]  Down_mid_X, Down_mid_Y,
					input [1:0] mode,
					//input [3:0] stop_bullet,
					input draw_wall_o, draw_wall_b,
//					input stop_bullet_right, stop_bullet_up, stop_bullet_left, stop_bullet_down,
               input stop_bullet,
					output [19:0] Dist_X_boom, Dist_Y_boom,
					output [9:0] Bullet_X_Pos, Bullet_Y_Pos,
					output is_bullet, is_boom,
					output draw_bullet, draw_boom,
					output [1:0] is_bullet_out
					);
					
logic [9:0] Bullet_X_Start;  					  // Center position on the X axis
logic [9:0] Bullet_Y_Start;  					  // Center position on the Y axis
parameter [9:0] Bullet_X_Min = 10'd2;       // Leftmost point on the X axis
parameter [9:0] Bullet_X_Max = 10'd478;     // Rightmost point on the X axis
parameter [9:0] Bullet_Y_Min = 10'd20;      // Topmost point on the Y axis
parameter [9:0] Bullet_Y_Max = 10'd478;     // Bottommost point on the Y axis
parameter [9:0] Bullet_X_Step = 10'd6;      // Step size on the X axis
parameter [9:0] Bullet_Y_Step = 10'd6;      // Step size on the Y axis
parameter [9:0] Bullet_Size = 10'd3;        // Bullet size
parameter [9:0] Boom_Size = 10'd19;         // Boom size

logic [25:0] counter, counter_in, b_counter, b_counter_in;
logic [1:0] is_bullet_out_in;
logic [9:0] Bullet_X_Pos_in, Bullet_Y_Pos_in, Bullet_X_Motion_in, Bullet_Y_Motion_in;
//logic [9:0] Bullet_X_Pos, Bullet_Y_Pos, Bullet_X_Motion, Bullet_Y_Motion;
logic [9:0] Bullet_X_Motion, Bullet_Y_Motion;
logic bullet_load;
logic shoot;                                //shoot is when player press "space" for tank 1 

assign shoot_on = (keycode[31:24] == 8'h06 | keycode[23:16] == 8'h06 | keycode[15: 8] == 8'h06 | keycode[ 7: 0] == 8'h06);

always_ff @ (posedge Clk)
begin 
	if (Reset)
		begin
		counter <= 26'd0;
		b_counter <= 26'd0;
		is_bullet_out <= 2'b00; //00 Right, 01 up, 10 left, 11 down
		end
	else 
		begin
		counter <= counter_in;
		b_counter <= b_counter_in;
		is_bullet_out <= is_bullet_out_in;
		end
end

logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end

always_comb
begin
//	Bullet_X_Start = 10'd320;
//	Bullet_Y_Start = 10'd240;
//	Bullet_X_Motion_in = Bullet_X_Motion;
//	Bullet_Y_Motion_in = Bullet_X_Motion;
//	if (bullet_load)
//	begin
		unique case (is_bullet_out)
			2'b00: begin
						Bullet_X_Start = Right_mid_X;
						Bullet_Y_Start = Right_mid_Y;
						Bullet_X_Motion_in = Bullet_X_Step;
						Bullet_Y_Motion_in = 10'b0;
					 end
			2'b01: begin
						Bullet_X_Start = Up_mid_X;
						Bullet_Y_Start = Up_mid_Y;
						Bullet_X_Motion_in = 10'b0;
						Bullet_Y_Motion_in = ((~Bullet_Y_Step)+1'b1); // 2's complement.
			       end
			2'b10: begin
						Bullet_X_Start = Left_mid_X; 
						Bullet_Y_Start = Left_mid_Y;
						Bullet_X_Motion_in = ((~Bullet_X_Step)+1'b1);
						Bullet_Y_Motion_in = 10'b0;
					 end
			2'b11: begin
						Bullet_X_Start = Down_mid_X;
						Bullet_Y_Start = Down_mid_Y;
						Bullet_X_Motion_in = 10'b0;
						Bullet_Y_Motion_in = Bullet_Y_Step;
					 end
			default:begin
						Bullet_X_Start = 10'd320;
						Bullet_Y_Start = 10'd240;
						Bullet_X_Motion_in = Bullet_X_Motion;
						Bullet_Y_Motion_in = Bullet_X_Motion;
					  end
		endcase
//	end
end
// Update registers
always_ff @ (posedge Clk)
begin
if (Reset || bullet_load == 1'b1)
   begin
	Bullet_X_Pos <= Bullet_X_Start;
   Bullet_Y_Pos <= Bullet_Y_Start;
   Bullet_X_Motion <= Bullet_X_Motion_in;
   Bullet_Y_Motion <= Bullet_Y_Motion_in;
   end
	else
   begin
      Bullet_X_Pos <= Bullet_X_Pos_in;
      Bullet_Y_Pos <= Bullet_Y_Pos_in;
      Bullet_X_Motion <= Bullet_X_Motion;
      Bullet_Y_Motion <= Bullet_Y_Motion;
   end
end


enum logic [2:0] {NOBULLET, NOBULLET_WAIT, BULLET_LOAD, BULLET, BULLET_WAIT, BULLET_BOOM, BOOM_WAIT} State, Next_State;

always_ff @ (posedge Clk) 
begin
	if (Reset) 
		State <= NOBULLET;
	else
		State <= Next_State;
end


always_comb
begin 
	is_bullet_out_in = is_bullet_out;
	bullet_load = 1'b1;
	counter_in = counter;
	b_counter_in = b_counter;
	draw_bullet = 1'b0;
	draw_boom = 1'b0;
	unique case (State)
	NOBULLET:
		begin
		if (shoot_on) 
			Next_State = NOBULLET_WAIT;
		else 
			Next_State = NOBULLET;
		end
	NOBULLET_WAIT:
		begin
//		if (keycode[7:0] == 8'h00 || keycode[15:8] == 8'h00) 
			Next_State = BULLET;
//		else
//			Next_State = NOBULLET_WAIT;
		end
	BULLET_LOAD:
		Next_State = BULLET;
	BULLET:
		begin
		if (counter == 26'b01100000000000000000000000)
			Next_State = BULLET_WAIT;
		else if (interrupt == 1'b1)
			Next_State = BULLET_BOOM;
		else
			Next_State = BULLET;
		end
	BULLET_WAIT:
		begin
//		if (keycode[7:0] == 8'h00)
			Next_State = NOBULLET;
//		else 
//			Next_State = BULLET_WAIT;
		end
	BULLET_BOOM:
		begin
		if (b_counter == 26'b00001111000000000000000000)
			Next_State = BOOM_WAIT;
		else
			Next_State = BULLET_BOOM;
		end
	BOOM_WAIT:
//		begin 
//		if (keycode[7:0] == 8'h00)
			Next_State = NOBULLET;
//		else 
//			Next_State = BOOM_WAIT;
//		end
	endcase
	
	case (State) 
	NOBULLET:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		is_bullet_out_in = is_tank_in;
		end
	NOBULLET_WAIT:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		is_bullet_out_in = is_tank_in;
		end
	BULLET_LOAD:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		end
	BULLET:
		begin
		counter_in = counter_in + 26'd1;
		b_counter_in = 26'd0;
		draw_bullet = 1'b1;
		bullet_load = 1'b0;
		end
	BULLET_WAIT:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		end
	BULLET_BOOM:
		begin
		counter_in = 26'd0;
		draw_boom = 1'b1;
		bullet_load = 1'b0;
		b_counter_in = b_counter + 26'd1;
		end
	BOOM_WAIT:
		begin
		counter_in = 26'd0;
		b_counter_in = 26'd0;
		end
	endcase
end

logic interrupt;
always_comb
    begin
        // By default, keep motion and position unchanged
        Bullet_X_Pos_in = Bullet_X_Pos;
        Bullet_Y_Pos_in = Bullet_Y_Pos;
		  interrupt = 1'b0;
//        Bullet_X_Motion_in = Bullet_X_Motion;
//        Bullet_Y_Motion_in = Bullet_Y_Motion;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Bullet_Y_Pos - Bullet_Size <= Bullet_Y_Min 
            // If Bullet_Y_Pos is 0, then Bullet_Y_Pos - Bullet_Size will not be -4, but rather a large positive number.
				if (draw_bullet == 1'b1)
				begin
            // Update the Bullet's position with its motion
					if (Bullet_X_Pos + Bullet_Size < Bullet_X_Max && Bullet_X_Pos > Bullet_X_Min 
						&& Bullet_Y_Pos + Bullet_Size < Bullet_Y_Max && Bullet_Y_Pos > Bullet_Y_Min && ~stop_bullet)
					begin
						Bullet_X_Pos_in = Bullet_X_Pos + Bullet_X_Motion;
						Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;
					end
					else 
						begin
						interrupt = 1'b1;
						end
				end
        end
	 end
	 
int DistX, DistY, Size, b_size;
always_comb 
begin
	DistX = DrawX - Bullet_X_Pos;
	DistY = DrawY - Bullet_Y_Pos;
	Dist_X_boom[19:10] = {10{1'b0}};
	Dist_X_boom[9:0] = DistX[9:0];
	Dist_Y_boom[19:10] = {10{1'b0}};
	Dist_Y_boom[9:0] = DistY[9:0];
	Size = Bullet_Size;
	b_size = Boom_Size >> 1;
end
always_comb
begin
	is_bullet = 1'b0;
	is_boom = 1'b0;
	if (mode == 2'b10)
	begin
		if (draw_bullet == 1'b1)
		begin 
			if ((DistX*DistX + DistY*DistY) <= (Size*Size))
				is_bullet = 1'b1;
		end
		else if (draw_boom == 1'b1)
		begin
			if (DistX >= -1 * b_size && DistX < b_size && DistY >= -1 * b_size && DistY < b_size)
				is_boom = 1'b1;
		end
	end
end		  
endmodule 