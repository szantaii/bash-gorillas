#!/bin/bash

# Initializes variables for a new game or new round in the game
init_game()
{
	tput cup 0 0 >> ${buffer}
	printf "Initializing game..." >> ${buffer}
	refresh_screen
	
	building_width=8
	building_max_height=$(($((term_height * 3)) / 4))
	
	grid_width=$(($((term_width / building_width)) * building_width))
	grid_height=$((term_height - 1))
	
	building_count=$((grid_width - $((2 * building_width))))
	building_count=$((building_count / building_width))
	
	left_padding=""
	top_padding=""
	
	left_padding_width=$(($((term_width % building_width)) / 2))
	top_padding_height="0"
	
	for ((i=0; i < grid_width; i++))
	do
		for ((j=0; j < grid_height; j++))
		do
			grid["${i},${j}"]=""
		done
	done
	
	# Generate the buildings, and save the buildings into 'grid'
	generate_buildings
	
	# Place payers into 'grid'
	place_player1
	place_player2
}

