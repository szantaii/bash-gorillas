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
# regarding the angle and speed of throwing

prompt_player1_throw_angle()
{
    local angle_text="Angle [0-90]: "

    tput cup $((top_padding_height + 1)) ${left_padding_width} >> ${buffer}

    printf "${angle_text}" >> ${buffer}

    refresh_screen
}

prompt_player2_throw_angle()
{
    local angle_text="Angle [0-90]: "

    tput cup $((top_padding_height + 1)) \
        $(($((left_padding_width + grid_width)) - $((${#angle_text} + 2)))) \
        >> ${buffer}

    printf "${angle_text}" >> ${buffer}

    refresh_screen
}

prompt_player1_throw_speed()
{
    local speed_text="Velocity [0-${max_speed}]: "

    tput cup $((top_padding_height + 2)) ${left_padding_width} >> ${buffer}

    printf "${speed_text}" >> ${buffer}

    refresh_screen
}

prompt_player2_throw_speed()
{
    local speed_text="Velocity [0-${max_speed}]: "

    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + grid_width)) - \
        $((${#speed_text} + ${#max_speed})))) >> ${buffer}

    printf "${speed_text}" >> ${buffer}

    refresh_screen
}

print_player1_correct_throw_angle()
{
    tput cup $((top_padding_height + 1)) \
        $((left_padding_width + 14)) >> ${buffer}

    printf "  " >> ${buffer}

    tput cup $((top_padding_height + 1)) \
        $((left_padding_width + 14)) >> ${buffer}

    printf "${player1_throw_angle}" >> ${buffer}

    refresh_screen
}

print_player2_correct_throw_angle()
{
    tput cup $((top_padding_height + 1)) \
        $(($((left_padding_width + grid_width)) - 2)) >> ${buffer}

    printf "  " >> ${buffer}

    tput cup $((top_padding_height + 1)) \
        $(($((left_padding_width + grid_width)) - 2)) >> ${buffer}

    printf "${player2_throw_angle}" >> ${buffer}

    refresh_screen
}

print_player1_correct_throw_speed()
{
    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + 15)) + ${#max_speed})) >> ${buffer}

    for ((i=0; i < ${#max_speed}; i++))
    do
        printf " " >> ${buffer}
    done

    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + 15)) + ${#max_speed})) >> ${buffer}

    printf "${player1_throw_speed}" >> ${buffer}

    refresh_screen
}

print_player2_correct_throw_speed()
{
    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + grid_width)) - ${#max_speed})) >> ${buffer}

    for ((i=0; i < ${#max_speed}; i++))
    do
        printf " " >> ${buffer}
    done

    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + grid_width)) - ${#max_speed})) >> ${buffer}

    printf "${player2_throw_speed}" >> ${buffer}

    refresh_screen
}

read_player1_throw_angle()
{
    read -n2 player1_throw_angle

    case ${player1_throw_angle} in
        ''|*[!0-9]*)
            player1_throw_angle=0
            print_player1_correct_throw_angle
            ;;
        *)
            if ((player1_throw_angle > 90))
            then
                player1_throw_angle=90
                print_player1_correct_throw_angle
            fi
            ;;
    esac
}

read_player2_throw_angle()
{
    read -n2 player2_throw_angle

    case ${player2_throw_angle} in
        ''|*[!0-9]*)
            player2_throw_angle=0
            print_player2_correct_throw_angle
            ;;
        *)
            if ((player2_throw_angle > 90))
            then
                player2_throw_angle=90
                print_player2_correct_throw_angle
            fi
            ;;
    esac
}

read_player1_throw_speed()
{
    read -n3 player1_throw_speed

    case ${player1_throw_speed} in
        ''|*[!0-9]*)
            player1_throw_speed=0
            print_player1_correct_throw_speed
            ;;
        *)
            if ((player1_throw_speed > max_speed))
            then
                player1_throw_speed=${max_speed}
                print_player1_correct_throw_speed
            fi
            ;;
    esac
}

read_player2_throw_speed()
{
    read -n3 player2_throw_speed

    case ${player2_throw_speed} in
        ''|*[!0-9]*)
            player2_throw_speed=0
            print_player2_correct_throw_speed
            ;;
        *)
            if ((player2_throw_speed > max_speed))
            then
                player2_throw_speed=${max_speed}
                print_player2_correct_throw_speed
            fi
            ;;
    esac
}

clear_player1_throw_angle()
{
    tput cup $((top_padding_height + 1)) ${left_padding_width} >> ${buffer}

    printf "                " >> ${buffer}

    refresh_screen
}

clear_player2_throw_angle()
{
    tput cup $((top_padding_height + 1)) \
    $(($((left_padding_width + grid_width)) - 16)) >> ${buffer}

    printf "                " >> ${buffer}

    refresh_screen
}

clear_player1_throw_speed()
{
    tput cup $((top_padding_height + 2)) ${left_padding_width} >> ${buffer}

    printf "               " >> ${buffer}

    for ((i=0; i < (2 * ${#max_speed}); i++))
    do
        printf " " >> ${buffer}
    done

    refresh_screen
}

clear_player2_throw_speed()
{
    tput cup $((top_padding_height + 2)) \
        $(($(($((left_padding_width + grid_width)) - 15)) \
        - $((2 * ${#max_speed})))) >> ${buffer}

    printf "               " >> ${buffer}

    for ((i=0; i < (2 * ${#max_speed}); i++))
    do
        printf " " >> ${buffer}
    done

    refresh_screen
}

read_throw_data()
{
    if ((next_player == 1))
    then
        prompt_player1_throw_angle
        read_player1_throw_angle

        prompt_player1_throw_speed
        read_player1_throw_speed

        clear_player1_throw_angle
        clear_player1_throw_speed
    else
        prompt_player2_throw_angle
        read_player2_throw_angle

        prompt_player2_throw_speed
        read_player2_throw_speed

        clear_player2_throw_angle
        clear_player2_throw_speed
    fi
}
