#!/bin/bash

# bash-gorillas is a demake of QBasic GORILLAS completely rewritten
# in Bash.
# Copyright (C) 2013 Istvan Szantai <szantaii at sidenote dot hu>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program (LICENSE).
# If not, see <http://www.gnu.org/licenses/>.

# Initializes variables for a new game or new round in the game
init_game()
{
	# Init player scores on new game
	if [[ "${player1_score}" == "" && "${player2_score}" == "" ]]
	then
		player1_score=0
		player2_score=0
	fi
	
	# Set first player randomly on new game
	if [[ "${next_player}" = "" ]]
	then
		next_player=$(($((RANDOM % 2)) + 1))
	fi
	
	# Set maximum throw velocity
	if [[ "${max_speed}" = "" ]]
	then
		max_speed=100
	fi
	
	# Set wind value
	wind_value=$((RANDOM % 6))
	if ((wind_value != 0 && (RANDOM % 2) != 0))
	then
		wind_value="-${wind_value}"
	fi
	
	# Print message to the screen to inform the user what is happening
	tput cup 0 0 >> ${buffer}
	if ((player1_score == 0 && player2_score == 0))
	then
		printf "Starting new game..." >> ${buffer}
	else
		printf "Starting new round..." >> ${buffer}
	fi
	
	# Refresh the screen
	refresh_screen
	
	# Set the width of a building (number of characters on the terminal screen)
	building_width=8
	
	# Set the maxmum height of buildings to
	# three fourth of the height of the terminal
	max_building_height=$(($((term_height * 3)) / 4))
	
	# Calculate $grid_width which will be the width of the playing field
	grid_width=$(($((term_width / building_width)) * building_width))
	# Calculate $grid_height which will be the height of the playing field
	grid_height=$((term_height - 1))
	
	# Calculate how many buildings can be placed into the playing field
	building_count=$((grid_width / building_width))
	
	# Reset $left_padding and $top_padding
	left_padding=""
	top_padding=""
	
	# Set $left_padding_width for centering the playing field on the screen,
	# and set $top_padding_height to '0' since the game uses the whole
	# terminal in height
	left_padding_width=$(($((term_width % building_width)) / 2))
	top_padding_height="0"
	
	# Initialize values of $grid
	for ((i=0; i < grid_width; i++))
	do
		for ((j=0; j < grid_height; j++))
		do
			grid["${i},${j}"]=""
		done
	done
	
	# Generate the buildings, and save the buildings into $grid
	generate_buildings
	
	# Initialize and place payers into $grid
	init_players
}

