#!/bin/bash

print_player1_throw_frame1()
{
	local i=""
	local j=""
	
	for key in "${!player1_throw_animation_frame1[@]}"
	do
		i=${key%","*}
		j=${key#*","}
		
		tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
			$((left_padding_width + i)) >> ${buffer}
		
		printf "${player1_throw_animation_frame1["${key}"]}" >> ${buffer}
	done
	
	refresh_screen
	
	sleep 0.1
}

print_player1_throw_frame2()
{
	local i=""
	local j=""
	
	for key in "${!player1_throw_animation_frame2[@]}"
	do
		i=${key%","*}
		j=${key#*","}
		
		tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
			$((left_padding_width + i)) >> ${buffer}
		
		printf "${player1_throw_animation_frame2["${key}"]}" >> ${buffer}
	done
	
	refresh_screen
	
	sleep 0.1
}

print_player2_throw_frame1()
{
	local i=""
	local j=""
	
	for key in "${!player2_throw_animation_frame1[@]}"
	do
		i=${key%","*}
		j=${key#*","}
		
		tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
			$((left_padding_width + i)) >> ${buffer}
		
		printf "${player2_throw_animation_frame1["${key}"]}" >> ${buffer}
	done
	
	refresh_screen
	
	sleep 0.1
}

print_player2_throw_frame2()
{
	local i=""
	local j=""
	
	for key in "${!player2_throw_animation_frame2[@]}"
	do
		i=${key%","*}
		j=${key#*","}
		
		tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
			$((left_padding_width + i)) >> ${buffer}
		
		printf "${player2_throw_animation_frame2["${key}"]}" >> ${buffer}
	done
	
	refresh_screen
	
	sleep 0.1
}

