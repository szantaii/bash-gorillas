#!/bin/bash

# bash-gorillas is a demake of QBasic GORILLAS completely rewritten
# in Bash.
# Copyright (C) 2013 Istvan Szantai <szantaii at sidenote dot hu>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program (LICENSE).
# If not, see <http://www.gnu.org/licenses/>.

# Plays intro: prints animated frames and intro text to the screen
play_intro()
{
	# Set $left_padding from $left_padding_width
	# $left_padding will contain a number of
	# $left_padding_width space characters
	for ((i=0; i < left_padding_width; i++))
	do
		left_padding="${left_padding} "
	done
	
	# Set $top_padding from $top_padding_height
	# $top_padding will contain a number of
	# $top_padding_height newline characters
	for ((i=0; i < top_padding_height; i++))
	do
		top_padding="${top_padding}\n"
	done
	
	# Intro text
	local intro_text="\n\n${top_padding}${left_padding}                       \
    B a s h   G O R I L L A S\n\n\n${left_padding}            Copyright (C) \
Istvan Szantai \x3c\x73\x7a\x61\x6e\x74\x61\x69\x69\x40\x73\x69\x64\x65\x6e\
\x6f\x74\x65\x2e\x68\x75\x3e 2013\n\n${left_padding}     This game \
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
	
	# Clear and refresh screen
	clear >> ${buffer}
	refresh_screen
}

