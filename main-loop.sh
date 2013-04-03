#!/bin/bash

# Main loop of the game
# 
# Not sure if this is necessary
main_loop()
{
	# Initialize variables, create screen buffer for bash-gorillas
	init_main
	
	# Play intro and wait for keypress
	play_intro
	
	# Read players' names, max points, gravity
	read_player_data
	
	while [[ "${player1_score}" == "" && "${player2_score}" == "" ]] \
		|| (((player1_score + player2_score) <= total_points))
	do
		# Initialize necessary variables before every round,
		# generate buildings, place players on map, etc.
		# (not everything implemented yet)
		init_game
	
		# Display game on screen
		print_scene
	
		while true
		do
			print_sun
			print_player_names
			print_score
			print_wind
			
			read_throw_data
			clear_player_names
			
			throw_banana
		done
	done
	
	# TODO: Add end game animation
	
	# Clean up and exit with 0
	quit
}

