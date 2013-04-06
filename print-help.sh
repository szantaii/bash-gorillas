#!/bin/bash

print_help()
{
	local help_text="Quit: ^C"
	
	tput cup ${grid_height} \
		$((term_width - ${#help_text})) >> ${buffer}
	
	printf "${help_text}" >> ${buffer}
	
	refresh_screen
}

