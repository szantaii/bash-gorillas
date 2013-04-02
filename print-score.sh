#!/bin/bash

print_score()
{
	local score_text=" ${player1_score}>SCORE<${player2_score} "
	
	tput cup $(($((top_padding_height + grid_height)) - 2)) \
		$((left_padding_width + $((grid_width / 2)) - $((${#score_text} / 2)))) >> ${buffer}
	
	printf "${score_text}" >> ${buffer}
}

