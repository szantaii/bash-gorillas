#!/bin/bash

# Initializes variables and creates buffer
init_main()
{
	# Set player points to zero
	player1_points_num=0
	player2_points_num=0
	
	# Create the 'screen buffer'
	create_buffer
	
	# Clear the terminal screen
	clear >> ${buffer}
	refresh_screen
}

