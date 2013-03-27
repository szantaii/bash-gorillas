#!/bin/bash

# Cleans up on quit, returns 0
quit()
{
	rm ${buffer}
	
	# Restore terminal screen
	tput rmcup
	
	exit 0
}

