#!/bin/bash

print_player_names()
{
	tput cup ${top_padding_height} ${left_padding_width} >> ${buffer}
	printf "${player1_name}" >> ${buffer}
	
	tput cup ${top_padding_height} \
		$(($((left_padding_width + grid_width)) - ${#player2_name}))>> ${buffer}
	printf "${player2_name}" >> ${buffer}
	
	# refresh_screen
}

