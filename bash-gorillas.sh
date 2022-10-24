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
source "${script_directory}/print-intro-outro-frames.sh"
source "${script_directory}/read-intro-outro-continue-key.sh"
source "${script_directory}/play-intro.sh"
source "${script_directory}/quit.sh"
source "${script_directory}/read-player-data.sh"
source "${script_directory}/generate-buildings.sh"
source "${script_directory}/init-players.sh"
source "${script_directory}/init-game.sh"
source "${script_directory}/read-throw-data.sh"
source "${script_directory}/throw-banana.sh"
source "${script_directory}/play-outro.sh"


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

# Clear the player names from the top left and right corners of the screen
clear_player_names()
{
    # Position the cursor to the top left corner of the playing field
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"

    for ((i=0; i < ${#player1_name}; i++))
    do
        printf ' ' >> "${buffer}"
    done

    # Position the cursor to the top right corner of the playing field right
    # before player2's name
    tput cup                                                    \
        "${top_padding_height}"                                 \
        $((left_padding_width + grid_width - ${#player2_name})) \
        >> "${buffer}"

    for ((i=0; i < ${#player2_name}; i++))
    do
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

# Create screen buffer, install signal handler, clear screen
init_main()
{
    # Create the 'screen buffer'
    create_buffer

    # Capture Ctrl+C key combination to call the 'quit'
    # function when Ctrl+C key combination is pressed
    trap quit SIGINT

    # Clear the screen
    clear >> "${buffer}"

    refresh_screen
}

# Game main loop
main_loop()
{
    init_main

    play_intro

    read_player_data

    while [[ "${player1_score}" == '' && "${player2_score}" == '' ]] \
        || (((player1_score + player2_score) < total_points))
    do
        # Initialize necessary variables before every round,
        # generate buildings, place players on map, etc.
        init_game

        # Display game on screen
        print_scene
        print_wind
        print_help

        # Loop of players throwing bananas at each other
        while true
        do
            print_sun
            print_player_names
            print_score

            read_throw_data
            clear_player_names

            throw_banana
        done

        # On player hit update the score and make the winner dance
        print_score
        print_player_victory_dance
    done

    # Clear the screen
    clear >> "${buffer}"
    refresh_screen

    # Play outro and wait for keypress
    play_outro

    quit
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

# Print a small help how to quit the game into the right bottom part
# of the screen
print_help()
{
    local help_text='Quit: ^C'

    # Position the cursor to the bottom row of the screen,
    # and to the right side of the $grid
    tput cup                                                 \
        "${grid_height}"                                     \
        $((left_padding_width + grid_width - ${#help_text})) \
        >> "${buffer}"

    printf '%s' "${help_text}" >> "${buffer}"

    refresh_screen
}

# Print the name of the players to the top left and right corners of the screen
print_player_names()
{
    {
        # Position the cursor to the top left corner of the playing field
        tput cup "${top_padding_height}" "${left_padding_width}"

        printf '%s' "${player1_name}"

        # Position the cursor to the top right corner ot the playing field
        tput cup \
            "${top_padding_height}" \
            $((left_padding_width + grid_width - ${#player2_name}))

        printf '%s' "${player2_name}"

    } >> "${buffer}"

    refresh_screen
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

# Print the contents of 'grid' into the screen buffer, then refresh the screen
print_scene()
{
    # Clear screen
    clear >> "${buffer}"

    # Print the contents of $grid to the buffer
    for ((i=0; i < grid_width; i++))
    do
        for ((j=0; j < grid_height; j++))
        do
            tput cup                                          \
                $((top_padding_height + grid_height - j - 1)) \
                $((left_padding_width + i))                   \
                >> "${buffer}"

            printf '%s' "${grid["${i},${j}"]}" >> "${buffer}"
        done
    done

    refresh_screen
}

# Print the score of the players (overlaps buildings on the screen)
print_score()
{
    local score_text=" ${player1_score}>SCORE<${player2_score} "

    # Position the cursor into the third row from the bottom of the screen,
    # and center with length of $score_text taken into account
    tput cup                                                              \
        $((top_padding_height + grid_height - 2))                         \
        $((left_padding_width + (grid_width / 2) - (${#score_text} / 2))) \
        >> "${buffer}"

    printf '%s' "${score_text}" >> "${buffer}"

    refresh_screen
}

# Print the Sun to the top center of the screen
print_sun()
{
    local sun_text=()

    # Store the ASCII lines of the Sun
    sun_text[0]='    |'
    sun_text[1]='  \ _ /'
    sun_text[2]='-= (_) =-'
    sun_text[3]='  /   '\\
    sun_text[4]='    |'

    for ((i=0; i < ${#sun_text[@]}; i++))
    do
        # Position the cursor to the top of the screen + i lines
        # and horizontally center of the screen minus the width
        # of the ASCII Sun
        tput cup                                                 \
            $((top_padding_height + i))                          \
            $((left_padding_width + (grid_width / 2) - (9 / 2))) \
            >> "${buffer}"

        printf '%s' "${sun_text[${i}]}" >> "${buffer}"
    done

    refresh_screen
}

# Print the wind indicator arrow to the bottom row of the screen
print_wind()
{
    # Center the cursor in the bottom row of the screen
    tput cup                                       \
        "${grid_height}"                           \
        $((left_padding_width + (grid_width / 2))) \
        >> "${buffer}"

    printf '|' >> "${buffer}"

    # Print the wind indicator arrow if $wind_value is not zero
    if ((wind_value != 0))
    then
        if ((wind_value < 0))
        then
            # Wind blows to the left ($wind_value is negative)
            tput cup                                                        \
                "${grid_height}"                                            \
                $((left_padding_width + (grid_width / 2) + wind_value - 1)) \
                >> "${buffer}"

            # Print wind indicator arrowhead
            printf '<' >> "${buffer}"

            # Print arrow with the length of $wind_value
            for ((i=wind_value; i < 0; i++))
            do
                printf '%s' '-' >> "${buffer}"
            done
        else
            # Wind blows to the right ($wind_value is positive)

            # Print arrow with the length of $wind_value
            for ((i=0; i < wind_value; i++))
            do
                printf '%s' '-' >> "${buffer}"
            done

            # Print wind indicator arrowhead
            printf '>' >> "${buffer}"
        fi
    fi

    refresh_screen
}

# Print the buffer onto the screen then clear the buffer
refresh_screen()
{
    cat "${buffer}"

    printf '' > "${buffer}"
}

# Switch to the other player
switch_player()
{
    if ((next_player == 1))
    then
        next_player=2
    else
        next_player=1
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
