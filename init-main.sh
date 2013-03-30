#!/bin/bash

# Initializes variables and creates buffer
init_main()
{
	# Create the 'screen buffer'
	create_buffer
	
	# Clear the terminal screen
	clear >> ${buffer}
	refresh_screen
}

