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

# Print animated frames and outro text to the screen
play_outro()
{
    local outro_lines=()

    # Clear $top_padding and $left_padding
    top_padding=''
    left_padding=''

    # Calculate $left_padding_width and $top_padding_height
    left_padding_width=$(((term_width - min_term_width) / 2))
    top_padding_height=$(((term_height - min_term_height) / 2))

    # Set $left_padding from $left_padding_width ($left_padding will contain
    # a number of $left_padding_width space characters)
    for ((i=0; i < left_padding_width; i++))
    do
        left_padding="${left_padding} "
    done

    # Set $top_padding from $top_padding_height ($top_padding will contain
    # a number of $top_padding_height newline characters)
    for ((i=0; i < top_padding_height; i++))
    do
        top_padding="${top_padding}\n"
    done

    outro_lines=(
        ''
        ''
        ''
        ''
        ''
        ''
        "${top_padding}${left_padding}                                   GAME OVER!"
        ''
        "${left_padding}                                     Score:"
        "${left_padding}                               $(printf '%-10s' "${player1_name}")${player1_score}"
        "${left_padding}                               $(printf '%-10s' "${player2_name}")${player2_score}"
        ''
        ''
        ''
        ''
        ''
        ''
        ''
        ''
        ''
        "${left_padding}                            Press any key to continue"
    )

    # Print outro text into the screen buffer
    for outro_line in "${outro_lines[@]}"
    do
        printf '%s\n' "${outro_line}" >> "${buffer}"
    done

    # Play animation, exit from loop when a key was pressed
    while true
    do
        print_frame_stage1
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage2
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage3
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage4
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage5
        refresh_screen
        read_intro_outro_continue_key && break
    done

    clear >> "${buffer}"
    refresh_screen
}
