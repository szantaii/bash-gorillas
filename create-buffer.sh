#!/bin/bash

# Creates a 'screen buffer' file
create_buffer()
{
	# Try to use /dev/shm if available
	# else use /tmp
	if [ -d "/dev/shm" ]
	then
		local buffer_directory="/dev/shm"
	else
		local buffer_directory="/tmp"
	fi
	
	local buffer_name="bashgorillas-buffer"
	
	# Try to use mktemp before using the unsafe method
	if [ -x $(which mktemp) ]
	then
		buffer=$(mktemp --tmpdir=${buffer_directory} ${buffer_name}-XXXXXXXXXX)
	else
		buffer="${buffer_directory}/${buffer_name}-${RANDOM}"
		
		# TODO: check if buffer file already exists, if unsafe method is used
		
		# Create the buffer file
		printf "" > $buffer
	fi
}

