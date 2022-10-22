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

IFS=""

term_width=$(tput cols)
term_height=$(tput lines)

min_term_width=80
min_term_height=22

buffer_name=""
buffer_directory=""
buffer=""

left_padding=""
left_padding_width=$(($((term_width - min_term_width)) / 2))
top_padding=""
top_padding_height=$(($((term_height - min_term_height)) / 2))

building_width=""
max_building_height=""
building_count=""

banana=""

player1_name=""
player2_name=""

player1_score=""
player2_score=""

declare -a player1_coordinates
declare -a player2_coordinates

player1_throw_start_coordinates=""
player2_throw_start_coordinates=""

declare -A player1_throw_animation_frame1
declare -A player1_throw_animation_frame2
declare -A player2_throw_animation_frame1
declare -A player2_throw_animation_frame2

declare -A player1_victory_animation_frame1
declare -A player1_victory_animation_frame2
declare -A player2_victory_animation_frame1
declare -A player2_victory_animation_frame2

player1_building_height=""
player2_building_height=""

player1_throw_angle=""
player2_throw_angle=""

player1_throw_speed=""
player2_throw_speed=""

next_player=""

total_points=""
gravity_value=""
menu_choice=""

max_speed=""
max_wind_value=""
wind_value=""

declare -A grid
grid_width=""
grid_height=""

script_directory=$(dirname "$0")

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
source "${script_directory}/animate-players.sh"
source "${script_directory}/animate-banana.sh"
source "${script_directory}/switch-player.sh"
source "${script_directory}/throw-banana.sh"
source "${script_directory}/play-outro.sh"
source "${script_directory}/main-loop.sh"

check_prerequisites ${term_width} ${term_height}

# Parse option flags and their arguments
while getopts ":w:s:h" option
do
    case ${option} in
        h)
            tput rmcup
            printf "bash-gorillas Copyright (C) Istvan Szantai \
\x3c\x73\x7a\x61\x6e\x74\x61\x69\x69\x40\x73\x69\x64\x65\x6e\x6f\
\x74\x65\x2e\x68\x75\x3e 2013\n\
For more detailed help please see the file 'README.md'.\n"
            exit 0
            ;;
        w)
            case ${OPTARG} in
                *[0-9]*)
                    max_wind_value=${OPTARG}
                    ;;
                *)
                    tput rmcup
                    printf "Invalid argument for option: -w. \
Specify a number between 0 and 10.\n"
                    exit 1
                    ;;
            esac

            if ((max_wind_value < 0 || max_wind_value > 10))
            then
                tput rmcup
                printf "Invalid argument for option: -w. \
Specify a number between 0 and 10.\n"
                exit 1
            fi

            max_wind_value=$((max_wind_value + 1))
            ;;
        s)

            case ${OPTARG} in
                *[0-9]*)
                    max_speed=${OPTARG}
                    ;;
                *)
                    tput rmcup
                    printf "Invalid argument for option: -s. \
Specify a number between 100 and 200.\n"
                    exit 1
                    ;;
            esac

            if ((max_speed < 100 || max_speed > 200))
            then
                tput rmcup
                printf "Invalid argument for option: -s. \
Specify a number between 100 and 200.\n"
                exit 1
            fi
            ;;
        :)
            tput rmcup

            if [[ "${OPTARG}" == "w" ]]
            then
                printf "Missing argument for option: -${OPTARG}. \
Specify a number between 0 and 10.\n"
            elif [[ "${OPTARG}" == "s" ]]
            then
                printf "Missing argument for option: -${OPTARG}. \
Specify a number between 100 and 200.\n"
            fi

            exit 1
            ;;
        \?)
            tput rmcup
            printf "Invalid option: -${OPTARG}.\n"
            exit 1
            ;;
    esac
done

main_loop
