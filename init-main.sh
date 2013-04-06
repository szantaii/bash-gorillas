#!/bin/bash

# Initializes variables and creates buffer
init_main()
{
	# Create the 'screen buffer'
	create_buffer
	
	# Capture Ctrl+C key combination
	trap quit SIGINT
	
	# Clear the terminal screen
	clear >> ${buffer}
	refresh_screen
}

