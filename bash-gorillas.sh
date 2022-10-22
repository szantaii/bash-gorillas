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


# Save terminal screen
tput smcup

IFS=''

term_width="$(tput cols)"
term_height="$(tput lines)"

min_term_width=80
min_term_height=22

buffer_name=''
buffer_directory=''
buffer=''

left_padding=''
left_padding_width="$(((term_width - min_term_width) / 2))"
top_padding=''
top_padding_height="$(((term_height - min_term_height) / 2))"

building_width=''
max_building_height=''
building_count=''

banana=''

player1_name=''
player2_name=''

player1_score=''
player2_score=''

declare -a player1_coordinates
declare -a player2_coordinates

player1_throw_start_coordinates=''
player2_throw_start_coordinates=''

declare -A player1_throw_animation_frame1
declare -A player1_throw_animation_frame2
declare -A player2_throw_animation_frame1
declare -A player2_throw_animation_frame2

declare -A player1_victory_animation_frame1
declare -A player1_victory_animation_frame2
declare -A player2_victory_animation_frame1
declare -A player2_victory_animation_frame2

player1_building_height=''
player2_building_height=''

player1_throw_angle=''
player2_throw_angle=''

player1_throw_speed=''
player2_throw_speed=''

next_player=''

total_points=''
gravity_value=''
menu_choice=''

max_speed=''
max_wind_value=''
wind_value=''

declare -A grid
grid_width=''
grid_height=''

script_directory="$(dirname "$(realpath "$0")")"

# Include necessary source files
source "${script_directory}/check-prerequisites.sh"
source "${script_directory}/create-buffer.sh"
source "${script_directory}/init-main.sh"
source "${script_directory}/refresh-screen.sh"
source "${script_directory}/print-intro-outro-frames.sh"
source "${script_directory}/read-intro-outro-continue-key.sh"
source "${script_directory}/play-intro.sh"
source "${script_directory}/quit.sh"
source "${script_directory}/read-player-data.sh"
source "${script_directory}/generate-buildings.sh"
source "${script_directory}/init-players.sh"
source "${script_directory}/init-game.sh"
source "${script_directory}/print-sun.sh"
source "${script_directory}/print-wind.sh"
source "${script_directory}/print-player-names.sh"
source "${script_directory}/clear-player-names.sh"
source "${script_directory}/print-score.sh"
source "${script_directory}/print-scene.sh"
source "${script_directory}/print-help.sh"
source "${script_directory}/read-throw-data.sh"
source "${script_directory}/switch-player.sh"
source "${script_directory}/throw-banana.sh"
source "${script_directory}/play-outro.sh"
source "${script_directory}/main-loop.sh"


clear_player1()
{
    local i=''
    local j=''
    local value=''

    for value in "${player1_coordinates[@]}"
    do
        i="${value%','*}"
        j="${value#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf ' ' >> "${buffer}"
    done

    refresh_screen
}

clear_player2()
{
    local i=''
    local j=''
    local value=''

    for value in "${player2_coordinates[@]}"
    do
        i="${value%','*}"
        j="${value#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf ' ' >> "${buffer}"
    done

    refresh_screen
}

# Set the first banana frame depending which player throws
init_banana()
{
    if ((next_player == 1))
    then
        banana='<'
    else
        banana='>'
    fi
}

# Set the next banana frame depending which player throws
next_banana_frame()
{
    if ((next_player == 1))
    then
        case "${banana}" in
            '<')
                banana='^'
                ;;
            '^')
                banana='>'
                ;;
            '>')
                banana='v'
                ;;
            'v')
                banana='<'
                ;;
        esac
    else
        case "${banana}" in
            '>')
                banana='^'
                ;;
            '^')
                banana='<'
                ;;
            '<')
                banana='v'
                ;;
            'v')
                banana='>'
                ;;
        esac
    fi
}

print_player1_throw_frame1()
{
    local i=''
    local j=''

    for key in "${!player1_throw_animation_frame1[@]}"
    do
        i="${key%','*}"
        j="${key#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i)) \
            >> "${buffer}"

        printf '%s' "${player1_throw_animation_frame1["${key}"]}" >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player1_throw_frame2()
{
    local i=''
    local j=''

    for key in "${!player1_throw_animation_frame2[@]}"
    do
        i="${key%','*}"
        j="${key#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf '%s' "${player1_throw_animation_frame2["${key}"]}" >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player2_throw_frame1()
{
    local i=''
    local j=''

    for key in "${!player2_throw_animation_frame1[@]}"
    do
        i="${key%','*}"
        j="${key#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf '%s' "${player2_throw_animation_frame1["${key}"]}" >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player2_throw_frame2()
{
    local i=''
    local j=''

    for key in "${!player2_throw_animation_frame2[@]}"
    do
        i="${key%','*}"
        j="${key#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf '%s' "${player2_throw_animation_frame2["${key}"]}" >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player1_victory_frame1()
{
    local i=''
    local j=''

    for key in "${!player1_victory_animation_frame1[@]}"
    do
        i="${key%','*}"
        j="${key#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf '%s' "${player1_victory_animation_frame1["${key}"]}" \
            >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player1_victory_frame2()
{
    local i=''
    local j=''

    for key in "${!player1_victory_animation_frame2[@]}"
    do
        i="${key%','*}"
        j="${key#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf '%s' "${player1_victory_animation_frame2["${key}"]}" \
            >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player2_victory_frame1()
{
    local i=''
    local j=''

    for key in "${!player2_victory_animation_frame1[@]}"
    do
        i="${key%','*}"
        j="${key#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf '%s' "${player2_victory_animation_frame1["${key}"]}" \
            >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player2_victory_frame2()
{
    local i=''
    local j=''

    for key in "${!player2_victory_animation_frame2[@]}"
    do
        i="${key%','*}"
        j="${key#*','}"

        tput cup                                          \
            $((top_padding_height + grid_height - j - 1)) \
            $((left_padding_width + i))                   \
            >> "${buffer}"

        printf '%s' "${player2_victory_animation_frame2["${key}"]}" \
            >> "${buffer}"
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


check_prerequisites "${term_width}" "${term_height}"

# Parse option flags and their arguments
while getopts ":w:s:h" option
do
    case "${option}" in
        'h')
            tput rmcup

            printf '%s\n' \
                "bash-gorillas Copyright (C) 2013-2022 \
Istvan Szantai <szantaii@gmail.com>" \
                '' \
                "For more detailed help please see the file 'README.md'."

            exit 0
            ;;
        'w')
            case "${OPTARG}" in
                *[0-9]*)
                    max_wind_value="${OPTARG}"
                    ;;
                *)
                    tput rmcup

                    printf '%s\n' \
                        "Invalid argument for option: -w. \
Specify a number between 0 and 10."

                    exit 1
                    ;;
            esac

            if ((max_wind_value < 0 || max_wind_value > 10))
            then
                tput rmcup

                printf '%s\n' \
                    "Invalid argument for option: -w. \
Specify a number between 0 and 10."

                exit 1
            fi

            max_wind_value="$((max_wind_value + 1))"
            ;;
        's')
            case "${OPTARG}" in
                *[0-9]*)
                    max_speed="${OPTARG}"
                    ;;
                *)
                    tput rmcup

                    printf '%s\n' \
                        "Invalid argument for option: -s. \
Specify a number between 100 and 200."

                    exit 1
                    ;;
            esac

            if ((max_speed < 100 || max_speed > 200))
            then
                tput rmcup

                printf '%s\n' \
                    "Invalid argument for option: -s. \
Specify a number between 100 and 200."

                exit 1
            fi
            ;;
        :)
            tput rmcup

            if [[ "${OPTARG}" == 'w' ]]
            then
                printf '%s\n' \
                    "Missing argument for option: -${OPTARG}. \
Specify a number between 0 and 10."

            elif [[ "${OPTARG}" == 's' ]]
            then
                printf '%s\n' \
                    "Missing argument for option: -${OPTARG}. \
Specify a number between 100 and 200."
            fi

            exit 1
            ;;
        \?)
            tput rmcup

            printf '%s\n' "Invalid option: -${OPTARG}.\n"

            exit 1
            ;;
    esac
done

main_loop
