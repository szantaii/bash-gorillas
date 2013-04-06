#!/bin/bash

clear_player_names()
{
	tput cup ${top_padding_height} ${left_padding_width} >> ${buffer}
	for ((i=0; i < ${#player1_name}; i++))
	do
		printf " " >> ${buffer}
	done
	
	tput cup ${top_padding_height} \
		$(($((left_padding_width + grid_width)) - ${#player2_name}))>> ${buffer}
	for ((i=0; i < ${#player2_name}; i++))
	do
		printf " " >> ${buffer}
	done
	
	refresh_screen
}
