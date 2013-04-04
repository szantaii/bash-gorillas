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
	
	tput cup $(($((top_padding_height + grid_height)) - y)) \
		$((left_padding_width + x)) >> ${buffer}
	printf "${banana}" >> ${buffer}
	refresh_screen
	
	if ((next_player == 1))
	then
		print_player1_throw_frame2
	else
		print_player2_throw_frame2
	fi
	
	for ((t=0; x >= 0 && x < grid_width && y >= 1 && y <= (grid_height * 5); ))
	do
		# sleep 0.1
		
		# Clear previous banana frame from screen
#		if [[ "${prev_x}" != "" && "${prev_y}" != "" ]] && \
#			((prev_x >= 0 && prev_x < grid_width && \
#			prev_y >= 0 && prev_y <= grid_height))
		if [[ "${prev_x}" != "" && "${prev_y}" != "" ]] && \
			((prev_x >= left_padding_width && \
			prev_x < (grid_width + left_padding_width) && \
			prev_y >= 0 && prev_y <= grid_height))
		then
			tput cup ${prev_y} ${prev_x} >> ${buffer}
			printf " " >> ${buffer}
			refresh_screen
		fi
		
		x=$(echo "scale=20; ${x_0} + (${throw_speed} * ${t} * c(${throw_angle}))" | bc -l | xargs printf "%1.0f\n")
		y=$(echo "scale=20; ${y_0} + (${throw_speed} * ${t} * s(${throw_angle}) - (2 * ${gravity_value} / 2) * ${t} * ${t})" | bc -l | xargs printf "%1.0f\n")
		
		# TODO: Add collision detection
		#
		# If a banana hits a player, than add a point to that
		# player's score who is not hit and set next_player
		# to the player who was hit, and execute a break to
		# start a new round
		
		# If the banana hits a building the building block
		# will be erased and then comes the next player
		if [[ "${grid["${x},$((y - 1))"]}" == "X" ]]
		then
			# Erase block from 'grid'
			grid["${x},$((y - 1))"]=""
			
			# Erase block from screen
			tput cup $(($((top_padding_height + grid_height)) - y)) \
				$((left_padding_width + x)) >> ${buffer}
			printf " " >> ${buffer}
			refresh_screen
			
			# Switch to the other player
			switch_player
			
			# Exit the loop
			break
		fi
		
		# Change banana character only if cursor is moved to another place
		if [[ "${prev_x}" != "" && "${prev_y}" != "" ]] && \
			((prev_x != x && prev_y != y))
		then
			next_banana_frame
		fi
		
		# Print banana to screen
		if ((x >= 0 && x < grid_width && y >= 1 && y <= grid_height))
		then
			tput cup $(($((top_padding_height + grid_height)) - y)) \
				$((left_padding_width + x)) >> ${buffer}
			printf "${banana}" >> ${buffer}
			refresh_screen
			sleep 0.1
		fi
		
		prev_x=$((left_padding_width + x))
		prev_y=$(($((top_padding_height + grid_height)) - y))
		
		t=$(echo "scale=20; ${t} + 0.01" | bc -l)
	done
	
	# If the thrown banana gets out of boundaries
	# then the next player can throw
	switch_player
}

