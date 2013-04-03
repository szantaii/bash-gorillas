#!/bin/bash

throw_banana()
{
	local pi=$(echo "scale=20; 4 * a(1)" | bc -l)
	local x=""
	local y=""
	local x_0=""
	local y_0=""
	local prev_x=""
	local prev_y=""
	local throw_angle=""
	local throw_speed=""
	
	init_banana
	
	if ((next_player == 1))
	then
		throw_angle=$(echo "scale=20; ${player1_throw_angle} * ${pi} / 180" | \
			bc -l)
		
		throw_speed=${player1_throw_speed}
		
		
		x=${player1_throw_start_coordinates%","*}
		y=${player1_throw_start_coordinates#*","}
		x_0=${x}
		y_0=${y}
		
		print_player1_throw_frame1
	else
		throw_angle=$((180 - player2_throw_angle))
		throw_angle=$(echo "scale=20; ${throw_angle} * ${pi} / 180" | \
			bc -l)
			
		throw_speed=${player2_throw_speed}
		
		x=${player2_throw_start_coordinates%","*}
		y=${player2_throw_start_coordinates#*","}
		x_0=${x}
		y_0=${y}
		
		print_player2_throw_frame1
	fi
	
	tput cup $(($((top_padding_height + grid_height)) - y)) ${x} >> ${buffer}
	printf "${banana}" >> ${buffer}
	refresh_screen
	next_banana_frame
	
	if ((next_player == 1))
	then
		print_player1_throw_frame0
	else
		print_player2_throw_frame0
	fi
	
	for ((t=0; x >= 0 && x < grid_width && y >= 1 && y < (grid_height * 5); ))
	do
		# sleep 0.1
		
		# Clear previous banana frame from screen
		if [[ "${prev_x}" != "" && "${prev_y}" != "" ]]
		then
			tput cup ${prev_y} ${prev_x} >> ${buffer}
			printf " " >> ${buffer}
			refresh_screen
		fi
		
		x=$(echo "scale=20; ${x_0} + (${throw_speed} * ${t} * c(${throw_angle}))" | bc -l | xargs printf "%1.0f\n")
		y=$(echo "scale=20; ${y_0} + (${throw_speed} * ${t} * s(${throw_angle}) - (${gravity_value} / 2) * ${t} * ${t})" | bc -l | xargs printf "%1.0f\n")
		
		# TODO: Add collision detection
		
		# Print banana to screen
		tput cup $(($((top_padding_height + grid_height)) - y)) ${x} >> ${buffer}
		printf "${banana}" >> ${buffer}
		refresh_screen
		next_banana_frame
		
		prev_x=${x}
		prev_y=$(($((top_padding_height + grid_height)) - y))
		
		t=$(echo "scale=20; ${t} + 0.01" | bc -l)
	done
}

