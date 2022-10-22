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

# Functions in this file prompt questions and read answers from player

prompt_player1_name()
{
    tput cup $((top_padding_height + 4)) \
        $((left_padding_width + 15)) >> ${buffer}

    printf "Name of Player 1 (Default = 'Player 1'): " >> ${buffer}
}

prompt_player2_name()
{
    tput cup $((top_padding_height + 6)) \
        $((left_padding_width + 15)) >> ${buffer}

    printf "Name of Player 2 (Default = 'Player 2'): " >> ${buffer}
}

prompt_max_points_num()
{
    tput cup $((top_padding_height + 8)) \
        $((left_padding_width + 17)) >> ${buffer}

    printf "Play to how many total points (Default = 3)? " >> ${buffer}
}

prompt_gravity_value()
{
    tput cup $((top_padding_height + 10)) \
        $((left_padding_width + 20)) >> ${buffer}

    printf "Gravity in Meters/Sec^2 (Earth = ~10)? " >> ${buffer}
}

prompt_menu_choice()
{
    tput cup $((top_padding_height + 12)) \
        $((left_padding_width + 34)) >> ${buffer}

    printf "%s-------------" >> ${buffer}

    tput cup $((top_padding_height + 14)) \
        $((left_padding_width + 34)) >> ${buffer}

    printf "P = Play Game" >> ${buffer}

    tput cup $((top_padding_height + 15)) \
        $((left_padding_width + 37)) >> ${buffer}

    printf "Q = Quit" >> ${buffer}

    tput cup $((top_padding_height + 17)) \
        $((left_padding_width + 35)) >> ${buffer}

    printf "Your Choice?" >> ${buffer}
}

read_player1_name()
{
    local player1_tmp_name=""

    read -n10 player1_name

    player1_tmp_name=${player1_name/ /}

    if [[ "${player1_tmp_name}" == "" ]]
    then
        player1_name="Player 1"
    fi
}

read_player2_name()
{
    local player2_tmp_name

    read -n10 player2_name

    player2_tmp_name=${player2_name/ /}

    if [[ "${player2_tmp_name}" == "" ]]
    then
        player2_name="Player 2"
    fi
}

read_total_points()
{
    read -n2 total_points

    case ${total_points} in
        ''|*[!0-9]*)
            total_points="3"
            ;;
    esac
}

read_gravity_value()
{
    read -n3 gravity_value

    case ${gravity_value} in
        ''|*[!0-9]*)
            gravity_value=10
            ;;
    esac
}

read_menu_choice()
{
    while [[ "${menu_choice}" != "p" && "${menu_choice}" != "P" && \
        "${menu_choice}" != "q" && "${menu_choice}" != "Q" ]]
    do
        read -sn1 menu_choice

        case ${menu_choice} in
            'p'|'P')
                ;;
            'q'|'Q')
                quit
                ;;
        esac
    done
}

read_player_data()
{
    prompt_player1_name
    refresh_screen
    read_player1_name

    prompt_player2_name
    refresh_screen
    read_player2_name

    prompt_max_points_num
    refresh_screen
    read_total_points

    prompt_gravity_value
    refresh_screen
    read_gravity_value

    prompt_menu_choice
    refresh_screen
    read_menu_choice

    clear >> ${buffer}
    refresh_screen
}
