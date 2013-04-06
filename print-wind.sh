#!/bin/bash

print_wind()
{
	tput cup ${grid_height} \
		$((left_padding_width + $((grid_width / 2)))) >> ${buffer}
	
	printf "|" >> ${buffer}
	
	if ((wind_value != 0))
	then
		if ((wind_value < 0))
		then
			tput cup ${grid_height} \
				$((left_padding_width + $(($(($((grid_width / 2)) \
				+ wind_value)) - 1)))) >> ${buffer}
			
			printf "<" >> ${buffer}
			
			for ((i=wind_value; i < 0; i++))
			do
				printf "%s-" >> ${buffer}
			done
		else
			for ((i=0; i < wind_value; i++))
			do
				printf "%s-" >> ${buffer}
			done
			
			printf ">" >> ${buffer}
		fi
	fi
	
	refresh_screen
}

