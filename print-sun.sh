#!/bin/bash

print_sun()
{
	local sun_text=()
	
	sun_text[0]="    |"
	sun_text[1]="  \\ _ /"
	sun_text[2]="-= (_) =-"
	sun_text[3]="  /   \\"
	sun_text[4]="    |"
	
	for ((i=0; i < ${#sun_text[@]}; i++))
	do
		tput cup $((top_padding_height + i)) \
			$((left_padding_width + $((grid_width / 2)) - $((9 / 2)))) \
			>> ${buffer}
		
		printf "%s${sun_text[${i}]}" >> ${buffer}
	done
	
	# refresh_screen
}

