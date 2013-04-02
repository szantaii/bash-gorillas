#!/bin/bash

# Functions in this file prompt questions and read answers from player

prompt_player1_name()
{
	tput cup $((top_padding_height + 4)) \
		$((left_padding_width + 15)) >> ${buffer}
	
	printf "Name of Player 1 (Default = 'Player 1'): " >> ${buffer}
}

prompt_player2_name()
{
	tput cup $((top_padding_height + 6)) \
		$((left_padding_width + 15)) >> ${buffer}
	
	printf "Name of Player 2 (Default = 'Player 2'): " >> ${buffer}
}

prompt_max_points_num()
{
	tput cup $((top_padding_height + 8)) \
		$((left_padding_width + 17)) >> ${buffer}
	
	printf "Play to how many total points (Default = 3)? " >> ${buffer}
}

prompt_gravity_value()
{
	tput cup $((top_padding_height + 10)) \
		$((left_padding_width + 20)) >> ${buffer}
	
	printf "Gravity in Meters/Sec^2 (Earth = ~10)? " >> ${buffer}
}

prompt_menu_choice()
{
	tput cup $((top_padding_height + 12)) \
		$((left_padding_width + 34)) >> ${buffer}
	
	printf "%s-------------" >> ${buffer}
	
	tput cup $((top_padding_height + 14)) \
		$((left_padding_width + 34)) >> ${buffer}
	
	printf "P = Play Game" >> ${buffer}
	
	tput cup $((top_padding_height + 15)) \
		$((left_padding_width + 37)) >> ${buffer}
	
	printf "Q = Quit" >> ${buffer}
	
	tput cup $((top_padding_height + 17)) \
		$((left_padding_width + 35)) >> ${buffer}
	
	printf "Your Choice?" >> ${buffer}
}

read_player1_name()
{
	local player1_tmp_name=""
	
	read -n10 player1_name
	
	player1_tmp_name=${player1_name/ /}
	
	if [[ "${player1_tmp_name}" == "" ]]
	then
		player1_name="Player 1"
	fi
}

read_player2_name()
{
	local player2_tmp_name
	
	read -n10 player2_name
	
	player2_tmp_name=${player2_name/ /}
	
	if [[ "${player2_tmp_name}" == "" ]]
	then
		player2_name="Player 2"
	fi
}

read_max_points_num()
{
	read -n2 max_points_num
	
	case ${max_points_num} in
		''|*[!0-9]*)
			max_points_num="3"
			;;
	esac
}

read_gravity_value()
{
	read -n3 gravity_value
	
	case ${gravity_value} in
		''|*[!0-9]*)
			gravity_value=10
			;;
	esac
}

read_menu_choice()
{
	while [[ "${menu_choice}" != "p" && "${menu_choice}" != "P" && \
		"${menu_choice}" != "q" && "${menu_choice}" != "Q" ]]
	do
		read -sn1 menu_choice
		
		case ${menu_choice} in
			'p'|'P')
				;;
			'q'|'Q')
				quit
				;;
		esac
	done
}

read_player_data()
{
	prompt_player1_name
	refresh_screen
	read_player1_name
	
	prompt_player2_name
	refresh_screen
	read_player2_name
	
	prompt_max_points_num
	refresh_screen
	read_max_points_num
	
	prompt_gravity_value
	refresh_screen
	read_gravity_value
	
	prompt_menu_choice
	refresh_screen
	read_menu_choice
	
	clear >> ${buffer}
	refresh_screen
}

