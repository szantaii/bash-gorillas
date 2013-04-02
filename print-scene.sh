#!/bin/bash

# Prints the contents of 'grid' into the screen buffer,
# then refreshes the screen
print_scene()
{
	# Clear screen
	clear >> ${buffer}
	
	for((i=0; i < grid_width; i++))
	do
		for ((j=0; j < grid_height; j++))
		do
			tput cup $(($(($((top_padding_height + grid_height)) - j)) -1)) \
				$((left_padding_width + i)) >> ${buffer}
			printf "${grid["${i},${j}"]}" >> ${buffer}
		done
	done
	
	print_sun
	print_player_names
	print_score
	
	tput cup $((term_height - 1)) $((term_width - 1)) >> ${buffer}
	refresh_screen
	
	sleep 5
}

