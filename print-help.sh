#!/bin/bash

print_help()
{
	local help_text="Quit: ^C"
	
	tput cup ${grid_height} \
		$(($((left_padding_width + grid_width)) - ${#help_text})) >> ${buffer}
	
	printf "${help_text}" >> ${buffer}
	
	refresh_screen
}

