module wall( input[9:0] DrawX, DrawY,
				 input[9:0] Ball_X_Pos, Ball_Y_Pos,
				 input[9:0] Bullet_X_Pos, Bullet_Y_Pos,
				 input[9:0] enemy1_X_Pos, enemy1_Y_Pos,
				 input[9:0] enemy2_X_Pos, enemy2_Y_Pos,
				 input[9:0] bulletx2, bullety2, ballx2, bally2,
				 input      enable1, enable2, enable12,
				 output draw_wall, draw_wall_o, draw_wall_b, 
				 input draw_bullet, draw_boom,
				 output stop_tank_right, stop_tank_up, stop_tank_left, stop_tank_down, 
				 output stop_bullet, player_hit_en1, player_hit_en2,
				 output stop_bullet2, player2_hit
//				 output stop_tank_right2, stop_tank_up2, stop_tank_left2, stop_tank_down2,
				);
				
int func_up, func_down, x_func_up, x_func_down, y_func_up, y_func_down;
int by_func_up, by_func_down;
parameter [9:0] size = 10'd19;
parameter [9:0] b_size = 10'd5;
always_comb
begin 
	
	draw_wall = 1'b0;
	draw_wall_o = 1'b0; //draw illini orange
	draw_wall_b = 1'b0; //draw illini blue
	stop_tank_right = 1'd0;
	stop_tank_up = 1'd0;
	stop_tank_left = 1'd0;
	stop_tank_down = 1'd0;
	stop_bullet = 1'b0;
	stop_bullet2 = 1'b0;
	player_hit_en1 = 1'b0;
	player_hit_en2 = 1'b0;
	player2_hit = 1'b0;
	
	// Border
	if (DrawX >= 10'd478 && DrawX < 10'd497 || DrawY >= 10'd0 && DrawY < 10'd19
		|| DrawX >= 10'd621 && DrawX < 10'd640 || DrawY <= 10'd479 && DrawY >= 10'd460 && DrawX >= 10'd497 && DrawX <= 10'd621)
		draw_wall = 1'b1;
	// I  
	if (DrawX >= 10'd80 && DrawX < 10'd140 && DrawY >= 10'd80 && DrawY < 10'd100 || DrawX >= 10'd95 && DrawX < 10'd125 && DrawY >= 10'd100 && DrawY < 10'd200 || DrawX >= 10'd80 && DrawX < 10'd140 && DrawY >= 10'd200 && DrawY < 10'd220)
		begin
		draw_wall_o = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd100 || Bullet_X_Pos >= 10'd95 && Bullet_X_Pos < 10'd125 && Bullet_Y_Pos >= 10'd100 && Bullet_Y_Pos < 10'd200 || Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
		
	// L 
	if (DrawX >= 10'd170 && DrawX < 10'd230 && DrawY >= 10'd200 && DrawY < 10'd220 || DrawX >= 10'd170 && DrawX < 10'd190 && DrawY >= 10'd80 && DrawY < 10'd220)
		begin
		draw_wall_o = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd230 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220 || Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd190 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
	
	// L
	if (DrawX >= 10'd260 && DrawX < 10'd320 && DrawY >= 10'd200 && DrawY < 10'd220 || DrawX >= 10'd260 && DrawX < 10'd280 && DrawY >= 10'd80 && DrawY < 10'd220)
		begin
		draw_wall_o = 1'b1;
		end
	
	if (Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd200 && Bullet_Y_Pos < 10'd220 || Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd280 && Bullet_Y_Pos >= 10'd80 && Bullet_Y_Pos < 10'd220)
		begin
		stop_bullet = 1'b1;
		end
	
	// I  
	if (DrawX >= 10'd80 && DrawX < 10'd140 && DrawY >= 10'd250 && DrawY < 10'd270 || DrawX >= 10'd95 && DrawX < 10'd125 && DrawY >= 10'd270 && DrawY < 10'd370 || DrawX >= 10'd80 && DrawX < 10'd140 && DrawY >= 10'd370 && DrawY < 10'd390)
		begin
		draw_wall_b = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd270 || Bullet_X_Pos >= 10'd95 && Bullet_X_Pos < 10'd125 && Bullet_Y_Pos >= 10'd270 && Bullet_Y_Pos < 10'd370 || Bullet_X_Pos >= 10'd80 && Bullet_X_Pos < 10'd140 && Bullet_Y_Pos >= 10'd370 && Bullet_Y_Pos < 10'd390)
		begin
		stop_bullet = 1'b1;
		end
	
	if (enable1)
	begin
		if (Bullet_X_Pos >= enemy1_X_Pos && Bullet_X_Pos < enemy1_X_Pos + size && Bullet_Y_Pos >= enemy1_Y_Pos && Bullet_Y_Pos < enemy1_Y_Pos + size)
		begin
		stop_bullet = 1'b1;
		if (draw_boom == 1'b0 && draw_bullet == 1'b0)
			player_hit_en1 = 1'b1;
		end
		
		if (Ball_X_Pos + size >= enemy1_X_Pos - 4 && Ball_X_Pos + size <= enemy1_X_Pos + 4 && Ball_Y_Pos + size >= enemy1_Y_Pos && Ball_Y_Pos <= enemy1_Y_Pos + size)
		begin 
			stop_tank_right = 1'b1;
		end
		
		if (Ball_X_Pos + size >= enemy1_X_Pos && Ball_X_Pos <= enemy1_X_Pos + size && Ball_Y_Pos >= enemy1_Y_Pos + size - 4 && Ball_Y_Pos <= enemy1_Y_Pos + size + 4)
		begin
			stop_tank_up = 1'b1;
		end
		
		if (Ball_X_Pos >= enemy1_X_Pos + size - 4 && Ball_X_Pos <= enemy1_X_Pos + size + 4 && Ball_Y_Pos + size >= enemy1_Y_Pos && Ball_Y_Pos <= enemy1_Y_Pos + size )
		begin
			stop_tank_left = 1'b1;
		end
		
		if (Ball_X_Pos + size >= enemy1_X_Pos && Ball_X_Pos <= enemy1_X_Pos + size && Ball_Y_Pos + size >= enemy1_Y_Pos - 4 && Ball_Y_Pos + size <= enemy1_Y_Pos + 4)
		begin
			stop_tank_down = 1'b1;
		end
	end
	
	if(enable2)
	begin
		if (bulletx2 >= Ball_X_Pos && bulletx2 < Ball_X_Pos + size && bullety2 >= Ball_Y_Pos && bullety2 < Ball_Y_Pos + size )
			stop_bullet2 = 1'b1;
		
		if (Bullet_X_Pos >= ballx2 && Bullet_X_Pos < ballx2 + size && Bullet_Y_Pos >= bally2 
			&& Bullet_Y_Pos < bally2 + size && draw_boom == 1'b0 && draw_bullet == 1'b0)
			player2_hit = 1'b1;
			
		//ballx2, bally2
		if (Ball_X_Pos + size >= ballx2 - 4 && Ball_X_Pos + size <= ballx2 + 4 && Ball_Y_Pos + size >= bally2 && Ball_Y_Pos <= bally2 + size)
		begin 
			stop_tank_right = 1'b1;
		end
		
		if (Ball_X_Pos + size >= ballx2 && Ball_X_Pos <= ballx2 + size && Ball_Y_Pos >= bally2 + size - 4 && Ball_Y_Pos <= bally2 + size + 4)
		begin
			stop_tank_up = 1'b1;
		end
		
		if (Ball_X_Pos >= ballx2 + size - 4 && Ball_X_Pos <= ballx2 + size + 4 && Ball_Y_Pos + size >= bally2 && Ball_Y_Pos <= bally2 + size )
		begin
			stop_tank_left = 1'b1;
		end
		
		if (Ball_X_Pos + size >= ballx2 && Ball_X_Pos <= ballx2 + size && Ball_Y_Pos + size >= bally2 - 4 && Ball_Y_Pos + size <= bally2 + 4)
		begin
			stop_tank_down = 1'b1;
		end
	end 
	
	if (enable12)
	begin
		if (Bullet_X_Pos >= enemy2_X_Pos && Bullet_X_Pos < enemy2_X_Pos + size && Bullet_Y_Pos >= enemy2_Y_Pos && Bullet_Y_Pos < enemy2_Y_Pos + size)
		begin
		stop_bullet = 1'b1;
		if (draw_boom == 1'b0 && draw_bullet == 1'b0)
			player_hit_en2 = 1'b1;
		end
		
		if (Ball_X_Pos + size >= enemy2_X_Pos - 4 && Ball_X_Pos + size <= enemy2_X_Pos + 4 && Ball_Y_Pos + size >= enemy2_Y_Pos && Ball_Y_Pos <= enemy2_Y_Pos + size)
		begin 
			stop_tank_right = 1'b1;
		end
		
		if (Ball_X_Pos + size >= enemy2_X_Pos && Ball_X_Pos <= enemy2_X_Pos + size && Ball_Y_Pos >= enemy2_Y_Pos + size - 4 && Ball_Y_Pos <= enemy2_Y_Pos + size + 4)
		begin
			stop_tank_up = 1'b1;
		end
		
		if (Ball_X_Pos >= enemy2_X_Pos + size - 4 && Ball_X_Pos <= enemy2_X_Pos + size + 4 && Ball_Y_Pos + size >= enemy2_Y_Pos && Ball_Y_Pos <= enemy2_Y_Pos + size )
		begin
			stop_tank_left = 1'b1;
		end
		
		if (Ball_X_Pos + size >= enemy2_X_Pos && Ball_X_Pos <= enemy2_X_Pos + size && Ball_Y_Pos + size >= enemy2_Y_Pos - 4 && Ball_Y_Pos + size <= enemy2_Y_Pos + 4)
		begin
			stop_tank_down = 1'b1;
		end
	end
	

   
	
	func_up = DrawX * 4 - 480 - 10;
	func_down = DrawX * 4 - 480 + 10;
	by_func_up = Bullet_X_Pos * 4 - 480 - 10;
	by_func_down = Bullet_X_Pos * 4 - 480 + 10;
	// N 
	if (DrawX >= 10'd170 && DrawX < 10'd185 && DrawY >= 10'd250 && DrawY < 10'd390 || DrawX >= 10'd215 && DrawX < 10'd230 && DrawY >= 10'd250 && DrawY < 10'd390 || DrawX >= 10'd185 && DrawX < 10'd215 && DrawY >= func_up && DrawY < func_down)
		begin
		draw_wall_b = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd170 && Bullet_X_Pos < 10'd185 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd390 || Bullet_X_Pos >= 10'd215 && Bullet_X_Pos < 10'd230 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd390 || Bullet_X_Pos >= 10'd185 && Bullet_X_Pos < 10'd215 && Bullet_Y_Pos >= by_func_up && Bullet_Y_Pos < by_func_down)
		begin
		stop_bullet = 1'b1;
		end
		
	// I 
	if (DrawX >= 10'd260 && DrawX < 10'd320 && DrawY >= 10'd250 && DrawY < 10'd270 || DrawX >= 10'd275 && DrawX < 10'd305 && DrawY >= 10'd270 && DrawY < 10'd370 || DrawX >= 10'd260 && DrawX < 10'd320 && DrawY >= 10'd370 && DrawY < 10'd390)
		begin
		draw_wall_b = 1'b1;
		end
		
	if (Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd250 && Bullet_Y_Pos < 10'd270 || Bullet_X_Pos >= 10'd275 && Bullet_X_Pos < 10'd305 && Bullet_Y_Pos >= 10'd270 && Bullet_Y_Pos < 10'd370 || Bullet_X_Pos >= 10'd260 && Bullet_X_Pos < 10'd320 && Bullet_Y_Pos >= 10'd370 && Bullet_Y_Pos < 10'd390)
		begin
		stop_bullet = 1'b1;
		end
	
	// stop_tank[0] barrier on right.
	// stop_tank[1] barrier on top.
	// stop_tank[2] barrier on left.
	// stop_tank[3] barrier on down.
	x_func_down = (Ball_Y_Pos + 10'd470) >> 2;
	x_func_up = (Ball_Y_Pos + 10'd490) >> 2;
	y_func_down = (Ball_X_Pos + size) * 4 - 470;
	y_func_up = (Ball_X_Pos) * 4 - 490;
	
	
	// Rightcheck
	if ((Ball_X_Pos + size >= 10'd79 && Ball_X_Pos + size <= 10'd81 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd100 || Ball_X_Pos + size >= 10'd95 && Ball_X_Pos + size <= 10'd97 && Ball_Y_Pos + size >= 10'd100 && Ball_Y_Pos < 10'd200 || Ball_X_Pos + size >= 10'd79 && Ball_X_Pos + size <= 10'd81 && Ball_Y_Pos + size >= 10'd200 && Ball_Y_Pos < 10'd220) ||
		 (Ball_X_Pos + size >= 10'd169 && Ball_X_Pos + size <= 10'd171 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd220) ||
    	 (Ball_X_Pos + size >= 10'd259 && Ball_X_Pos + size <= 10'd261 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd220) ||
		 (Ball_X_Pos + size >= 10'd79 && Ball_X_Pos + size <= 10'd81 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd270 || Ball_X_Pos + size >= 10'd95 && Ball_X_Pos + size <= 10'd97 && Ball_Y_Pos + size >= 10'd270 && Ball_Y_Pos < 10'd370 || Ball_X_Pos + size >= 10'd79 && Ball_X_Pos + size <= 10'd81 && Ball_Y_Pos + size >= 10'd370 && Ball_Y_Pos < 10'd390) ||
		 (Ball_X_Pos + size >= 10'd169 && Ball_X_Pos + size <= 10'd171 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390 || Ball_X_Pos + size >= x_func_down - 1 && Ball_X_Pos + size <= x_func_down + 1 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390 || Ball_X_Pos + size >= 10'd213 && Ball_X_Pos + size <= 10'd217 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390) ||
		 (Ball_X_Pos + size >= 10'd259 && Ball_X_Pos + size <= 10'd261 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd270 || Ball_X_Pos + size >= 10'd275 && Ball_X_Pos + size <= 10'd305 && Ball_Y_Pos + size >= 10'd270 && Ball_Y_Pos < 10'd370 || Ball_X_Pos + size >= 10'd259 && Ball_X_Pos + size <= 10'd261 && Ball_Y_Pos + size >= 10'd370 && Ball_Y_Pos < 10'd390)
		)
		begin
		stop_tank_right = 1'b1;
		end
	
	// Upcheck
	if ((Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd140 && Ball_Y_Pos >= 10'd217 && Ball_Y_Pos <= 10'd223 || Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd95 && Ball_Y_Pos >=  10'd97 && Ball_Y_Pos <= 10'd103 || Ball_X_Pos + size >= 10'd125 && Ball_X_Pos < 10'd140 && Ball_Y_Pos >= 10'd97 && Ball_Y_Pos <= 10'd103) ||
		 (Ball_X_Pos + size >= 10'd170 && Ball_X_Pos < 10'd230 && Ball_Y_Pos >= 10'd217 && Ball_Y_Pos <= 10'd223)||
		 (Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd320 && Ball_Y_Pos >= 10'd217 && Ball_Y_Pos <= 10'd223) ||
		 (Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd140 && Ball_Y_Pos >= 10'd387 && Ball_Y_Pos <= 10'd393 || Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd95 && Ball_Y_Pos >=  10'd267 && Ball_Y_Pos <= 10'd273 || Ball_X_Pos + size >= 10'd125 && Ball_X_Pos < 10'd140 && Ball_Y_Pos >= 10'd267 && Ball_Y_Pos <= 10'd273) ||
    	 (Ball_X_Pos + size >= 10'd170 && Ball_X_Pos < 10'd185 && Ball_Y_Pos >= 10'd387 && Ball_Y_Pos <= 10'd393 || Ball_X_Pos + size >= 10'd215 && Ball_X_Pos < 10'd230 && Ball_Y_Pos >= 10'd387 && Ball_Y_Pos <= 10'd393 ) || 
		 (Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd320 && Ball_Y_Pos >= 10'd387 && Ball_Y_Pos <= 10'd393 || Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd275 && Ball_Y_Pos >=  10'd267 && Ball_Y_Pos <= 10'd273 || Ball_X_Pos + size >= 10'd305 && Ball_X_Pos < 10'd320 && Ball_Y_Pos >= 10'd267 && Ball_Y_Pos <= 10'd273)
	)
		begin
		stop_tank_up = 1'b1;
		end
	
	if (Ball_X_Pos >= 10'd185 && Ball_X_Pos <= 10'd195 && Ball_Y_Pos >= y_func_down - 3 && Ball_Y_Pos <= y_func_down+3)
		begin 
		stop_tank_up = 1'b1;
		end
		
	// Left Check.
	if ((Ball_X_Pos >= 10'd138 && Ball_X_Pos <= 10'd142 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd100 || Ball_X_Pos >= 10'd123 && Ball_X_Pos <= 10'd127 && Ball_Y_Pos + size >= 10'd100 && Ball_Y_Pos < 10'd200 || Ball_X_Pos >= 10'd138 && Ball_X_Pos <= 10'd142 && Ball_Y_Pos + size >= 10'd200 && Ball_Y_Pos < 10'd220) ||
		 (Ball_X_Pos >= 10'd188 && Ball_X_Pos <= 10'd192 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd200 || Ball_X_Pos >= 10'd228 && Ball_X_Pos <= 10'd232 && Ball_Y_Pos + size >= 10'd200 && Ball_Y_Pos < 10'd220) ||
		 (Ball_X_Pos >= 10'd278 && Ball_X_Pos <= 10'd282 && Ball_Y_Pos + size >= 10'd80 && Ball_Y_Pos < 10'd200 || Ball_X_Pos >= 10'd318 && Ball_X_Pos <= 10'd322 && Ball_Y_Pos + size >= 10'd200 && Ball_Y_Pos < 10'd220)
		)
		begin
		stop_tank_left = 1'b1;
		end
	
	if ((Ball_X_Pos >= 10'd138 && Ball_X_Pos <= 10'd142 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd270 || Ball_X_Pos >= 10'd123 && Ball_X_Pos <= 10'd127 && Ball_Y_Pos + size >= 10'd270 && Ball_Y_Pos <= 10'd370 || Ball_X_Pos >= 10'd138 && Ball_X_Pos <= 10'd142 && Ball_Y_Pos + size >= 10'd370 && Ball_Y_Pos < 10'd390)||
		 (Ball_X_Pos >= 10'd228 && Ball_X_Pos <= 10'd232 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390 || Ball_X_Pos >= x_func_up - 2 && Ball_X_Pos <= x_func_up + 2 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390 || Ball_X_Pos >= 10'd183 && Ball_X_Pos <= 10'd187 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd390) ||
		 (Ball_X_Pos >= 10'd318 && Ball_X_Pos <= 10'd322 && Ball_Y_Pos + size >= 10'd250 && Ball_Y_Pos < 10'd270 || Ball_X_Pos >= 10'd303 && Ball_X_Pos <= 10'd307 && Ball_Y_Pos + size >= 10'd270 && Ball_Y_Pos < 10'd370 || Ball_X_Pos >= 10'd318 && Ball_X_Pos <= 10'd322 && Ball_Y_Pos + size >= 10'd371 && Ball_Y_Pos < 10'd390)
		)
		begin
		stop_tank_left = 1'b1;
		end
		
	// Down Check.
	if ((Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd140 && Ball_Y_Pos + size >= 10'd79 && Ball_Y_Pos + size <= 10'd81 || Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd95 && Ball_Y_Pos + size >= 10'd199 && Ball_Y_Pos + size <= 10'd201 || Ball_X_Pos + size >= 10'd125 && Ball_X_Pos < 10'd140 && Ball_Y_Pos + size >= 10'd199 && Ball_Y_Pos + size <= 10'd201) ||
		 (Ball_X_Pos + size >= 10'd170 && Ball_X_Pos < 10'd190 && Ball_Y_Pos + size >= 10'd79 && Ball_Y_Pos + size <= 10'd81 || Ball_X_Pos + size >= 10'd190 && Ball_X_Pos < 10'd230 && Ball_Y_Pos + size >= 10'd199 && Ball_Y_Pos + size <= 10'd201) ||
		 (Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd280 && Ball_Y_Pos + size >= 10'd79 && Ball_Y_Pos + size <= 10'd81 || Ball_X_Pos + size >=  10'd280 && Ball_X_Pos < 10'd320 && Ball_Y_Pos + size >= 10'd199 && Ball_Y_Pos + size <= 10'd201)
		)
		begin
		stop_tank_down = 1'b1;
		end
	
	if ((Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd140 && Ball_Y_Pos + size >= 10'd249 && Ball_Y_Pos + size <= 10'd251 || Ball_X_Pos + size >= 10'd80 && Ball_X_Pos < 10'd95 && Ball_Y_Pos + size >= 10'd369 && Ball_Y_Pos + size <= 10'd371 || Ball_X_Pos + size >= 10'd125 && Ball_X_Pos < 10'd140 && Ball_Y_Pos + size >= 10'd369 && Ball_Y_Pos + size <= 10'd371) ||
		 (Ball_X_Pos + size >= 10'd170 && Ball_X_Pos < 10'd185 && Ball_Y_Pos + size >= 10'd249 && Ball_Y_Pos + size <= 10'd251 || Ball_X_Pos + size >= 10'd185 && Ball_X_Pos < 10'd215 && Ball_Y_Pos + size >= y_func_up - 1 && Ball_Y_Pos + size <= y_func_up + 1 || Ball_X_Pos + size >= 10'd215 && Ball_X_Pos + size < 10'd230 && Ball_Y_Pos + size >= 10'd249 && Ball_Y_Pos + size <= 10'd251) ||
		 (Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd320 && Ball_Y_Pos + size >= 10'd249 && Ball_Y_Pos + size <= 10'd251 || Ball_X_Pos + size >= 10'd260 && Ball_X_Pos < 10'd275 && Ball_Y_Pos + size >=  10'd369 && Ball_Y_Pos + size <= 10'd371 || Ball_X_Pos + size >= 10'd305 && Ball_X_Pos < 10'd320 && Ball_Y_Pos + size >= 10'd369 && Ball_Y_Pos + size <= 10'd371)
		)
		begin
		stop_tank_down = 1'b1;
		end
	
end
endmodule