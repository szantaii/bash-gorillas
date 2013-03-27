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
	
	# Initialize necessary variables before every round,
	# generate buildings, place players on map, etc.
	# (not everything implemented yet)
	init_game
	
	# Display game on screen
	print_scene
	
	# Clean up and exit with 0
	quit
}

