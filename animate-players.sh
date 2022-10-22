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

# Functions in this file animates players
# during banana throwing and victory dance

print_player1_throw_frame1()
{
    local i=""
    local j=""

    for key in "${!player1_throw_animation_frame1[@]}"
    do
        i=${key%","*}
        j=${key#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}

        printf "${player1_throw_animation_frame1["${key}"]}" >> ${buffer}
    done

    refresh_screen

    sleep 0.1
}

print_player1_throw_frame2()
{
    local i=""
    local j=""

    for key in "${!player1_throw_animation_frame2[@]}"
    do
        i=${key%","*}
        j=${key#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}

        printf "${player1_throw_animation_frame2["${key}"]}" >> ${buffer}
    done

    refresh_screen

    sleep 0.1
}

print_player2_throw_frame1()
{
    local i=""
    local j=""

    for key in "${!player2_throw_animation_frame1[@]}"
    do
        i=${key%","*}
        j=${key#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}

        printf "${player2_throw_animation_frame1["${key}"]}" >> ${buffer}
    done

    refresh_screen

    sleep 0.1
}

print_player2_throw_frame2()
{
    local i=""
    local j=""

    for key in "${!player2_throw_animation_frame2[@]}"
    do
        i=${key%","*}
        j=${key#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}

        printf "${player2_throw_animation_frame2["${key}"]}" >> ${buffer}
    done

    refresh_screen

    sleep 0.1
}

print_player1_victory_frame1()
{
    local i=""
    local j=""

    for key in "${!player1_victory_animation_frame1[@]}"
    do
        i=${key%","*}
        j=${key#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}

        printf "${player1_victory_animation_frame1["${key}"]}" >> ${buffer}
    done

    refresh_screen

    sleep 0.1
}

print_player1_victory_frame2()
{
    local i=""
    local j=""

    for key in "${!player1_victory_animation_frame2[@]}"
    do
        i=${key%","*}
        j=${key#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}

        printf "${player1_victory_animation_frame2["${key}"]}" >> ${buffer}
    done

    refresh_screen

    sleep 0.1
}

print_player2_victory_frame1()
{
    local i=""
    local j=""

    for key in "${!player2_victory_animation_frame1[@]}"
    do
        i=${key%","*}
        j=${key#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}

        printf "${player2_victory_animation_frame1["${key}"]}" >> ${buffer}
    done

    refresh_screen

    sleep 0.1
}

print_player2_victory_frame2()
{
    local i=""
    local j=""

    for key in "${!player2_victory_animation_frame2[@]}"
    do
        i=${key%","*}
        j=${key#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}

        printf "${player2_victory_animation_frame2["${key}"]}" >> ${buffer}
    done

    refresh_screen

    sleep 0.1
}

print_player_victory_dance()
{
    if ((next_player == 1))
    then
        for ((k=0; k < 5; k++))
        do
            print_player2_throw_frame2
            sleep 0.3
            print_player2_throw_frame1
            print_player2_victory_frame1
            sleep 0.3
            print_player2_victory_frame2
        done
    else
        for ((k=0; k < 5; k++))
        do
            print_player1_throw_frame2
            sleep 0.3
            print_player1_throw_frame1
            print_player1_victory_frame1
            sleep 0.3
            print_player1_victory_frame2
        done
    fi
}

clear_player1()
{
    local i=""
    local j=""
    local value=""

    for value in "${player1_coordinates[@]}"
    do
        i=${value%","*}
        j=${value#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}
        printf " " >> ${buffer}
    done

    refresh_screen
}

clear_player2()
{
    local i=""
    local j=""
    local value=""

    for value in "${player2_coordinates[@]}"
    do
        i=${value%","*}
        j=${value#*","}

        tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
            $((left_padding_width + i)) >> ${buffer}
        printf " " >> ${buffer}
    done

    refresh_screen
}
