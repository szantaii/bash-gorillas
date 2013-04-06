#!/bin/bash

play_outro()
{
	top_padding=""
	left_padding=""
	
	left_padding_width=$(($((term_width - min_term_width)) / 2))
	top_padding_height=$(($((term_height - min_term_height)) / 2))
	
	for ((i=0; i < left_padding_width; i++))
	do
		left_padding="${left_padding} "
	done
	
	for ((i=0; i < top_padding_height; i++))
	do
		top_padding="${top_padding}\n"
	done
	
	local outro_text="\n\n\n\n\n\n${top_padding}${left_padding}         \
                          GAME OVER!\n\n${left_padding}        \
                             Score:\n${left_padding}          \
                     ${player1_name}"
	
	for ((i=${#player1_name}; i <= 10; i++))
	do
		outro_text="${outro_text} "
	done
	
	outro_text="${outro_text}     ${player1_score}\n${left_padding}\
                               ${player2_name}"
	
	for ((i=${#player2_name}; i <= 10; i++))
	do
		outro_text="${outro_text} "
	done
	
	outro_text="${outro_text}     ${player2_score}\n\n\n\n\n\n\n\n\n\n\
${left_padding}                            Press any key to continue"
	
	printf ${outro_text} >> ${buffer}
	
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
