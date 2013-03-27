#!/bin/bash

play_intro()
{
	
	for ((i=0; i < left_padding_width; i++))
	do
		left_padding="${left_padding} "
	done
	
	for ((i=0; i < top_padding_height; i++))
	do
		top_padding="${top_padding}\n"
	done
	
	local intro_text="\n\n${top_padding}${left_padding}                       \
    B a s h   G O R I L L A S\n\n\n${left_padding}            Copyright (C) \
Istvan Szantai <szantaii@sidenote.hu> 2013\n\n${left_padding}     This game \
is a demake of QBasic GORILLAS rewritten completely in Bash.\n\n\n${left_padding}\
             Your mission is to hit your opponent with the exploding\n\
${left_padding}           banana by varying the angle and power of your \
throw, taking\n${left_padding}             into account wind speed, gravity, \
and the city skyline.\n${left_padding}*          The wind speed is show by a \
directional arrow at the bottom\n${left_padding}            of the playing \
field, its length relative to its strength.\n\n\n\n\n\n${left_padding}    \
                        Press any key to continue"
	
	# Print intro text into the screen buffer
	printf ${intro_text} >> ${buffer}
	
	# Play animation, exit from loop when a key was pressed
	while true
	do
		print_frame_stage1
		refresh_screen
		read_intro_continue_key
		print_frame_stage2
		refresh_screen
		read_intro_continue_key
		print_frame_stage3
		refresh_screen
		read_intro_continue_key
		print_frame_stage4
		refresh_screen
		read_intro_continue_key
		print_frame_stage5
		refresh_screen
		read_intro_continue_key
	done
	
	# Clear screen
	clear >> ${buffer}
	refresh_screen
}

