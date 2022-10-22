#!/bin/bash

# bash-gorillas is a demake of QBasic GORILLAS completely rewritten in Bash.
# Copyright (C) 2013-2022 Istvan Szantai <szantaii@gmail.com>
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
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Plays outro: prints animated frames and outro text to the screen
play_outro()
{
    # Clear $top_padding and $left_padding
    top_padding=""
    left_padding=""

    # Calculate $left_padding_width and $top_padding_height
    left_padding_width=$(($((term_width - min_term_width)) / 2))
    top_padding_height=$(($((term_height - min_term_height)) / 2))

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

    # Set $outro_text which contains player scores, etc.
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

    # Print outro text into the screen buffer
    printf ${outro_text} >> ${buffer}

    # Play animation, exit from loop when a key was pressed
    while true
    do
        print_frame_stage1
        refresh_screen
        read_intro_outro_continue_key
        print_frame_stage2
        refresh_screen
        read_intro_outro_continue_key
        print_frame_stage3
        refresh_screen
        read_intro_outro_continue_key
        print_frame_stage4
        refresh_screen
        read_intro_outro_continue_key
        print_frame_stage5
        refresh_screen
        read_intro_outro_continue_key
    done

    # Clear and refresh screen
    clear >> ${buffer}
    refresh_screen
}
