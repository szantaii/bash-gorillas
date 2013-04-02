#!/bin/bash

bash_gorillas()
{
	# TODO: capture Ctrl+C key combination
	
	# Save terminal screen
	tput smcup
	
	IFS=""
	
	term_width=$(tput cols)
	term_height=$(tput lines)
	
	min_term_width=80
	min_term_height=22
	
	buffer_name=""
	buffer_directory=""
	buffer=""
	
	left_padding=""
	left_padding_width=$(($((term_width - min_term_width)) / 2))
	top_padding=""
	top_padding_height=$(($((term_height - min_term_height)) / 2))
	
	building_width=""
	max_building_height=""
	building_count=""
	
	player1_name=""
	player2_name=""
	
	player1_score=""
	player2_score=""
	
	declare -a player1_position
	declare -a player2_position
	
	player1_building_height=""
	player2_building_height=""
	
	max_score=""
	gravity_value=""
	menu_choice=""
	
	declare -A grid
	grid_width=""
	grid_height=""
	
	script_directory=$(dirname "$0")
	
	# Include necessary source files
	source "${script_directory}/check-prerequisites.sh"
	source "${script_directory}/create-buffer.sh"
	source "${script_directory}/init-main.sh"
	source "${script_directory}/refresh-screen.sh"
	source "${script_directory}/print-intro-frames.sh"
	source "${script_directory}/read-intro-continue-key.sh"
	source "${script_directory}/play-intro.sh"
	source "${script_directory}/quit.sh"
	source "${script_directory}/read-player-data.sh"
	source "${script_directory}/generate-buildings.sh"
	source "${script_directory}/place-players.sh"
	source "${script_directory}/init-game.sh"
	source "${script_directory}/init-game.sh"
	source "${script_directory}/print-sun.sh"
	source "${script_directory}/print-player-names.sh"
	source "${script_directory}/clear-player-names.sh"
	source "${script_directory}/print-score.sh"
	source "${script_directory}/print-scene.sh"
	source "${script_directory}/main-loop.sh"
	
	check_prerequisites ${term_width} ${term_height}
	
	main_loop
}

bash_gorillas

