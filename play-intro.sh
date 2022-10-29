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

# Print animated frames and intro text to the screen
play_intro()
{
    local intro_lines=()

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

    intro_lines=(
        ''
        ''
        "${top_padding}${left_padding}                           B a s h   G O R I L L A S"
        ''
        ''
        "${left_padding}         Copyright (C) 2013-2022 Istvan Szantai <szantaii@gmail.com>"
        ''
        ''
        "${left_padding}     This game is a demake of QBasic GORILLAS rewritten completely in Bash."
        ''
        ''
        "${left_padding}             Your mission is to hit your opponent with the exploding"
        "${left_padding}           banana by varying the angle and power of your throw, taking"
        "${left_padding}             into account wind speed, gravity, and the city skyline."
        "${left_padding}           The wind speed is show by a directional arrow at the bottom"
        "${left_padding}            of the playing field, its length relative to its strength."
        ''
        ''
        ''
        ''
        ''
        "${left_padding}                            Press any key to continue"
    )

    # Print intro into the screen buffer
    for intro_line in "${intro_lines[@]}"
    do
        printf '%s\n' "${intro_line}" >> "${buffer}"
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
