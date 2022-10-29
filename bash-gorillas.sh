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


IFS=''

term_width=''
term_height=''

min_term_width=80
min_term_height=22

buffer_name=''
buffer_directory=''
buffer=''

left_padding=''
left_padding_width=''
top_padding=''
top_padding_height=''

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
source "${script_directory}/quit.sh"
source "${script_directory}/read-player-data.sh"
source "${script_directory}/read-throw-data.sh"
source "${script_directory}/throw-banana.sh"


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

# Create a "screen buffer" file
create_buffer()
{
    local buffer_name_template='bash-gorillas-buffer-XXXXXXXXXX'
    local buffer_directory='/tmp'

    buffer="$(mktemp --tmpdir="${buffer_directory}" "${buffer_name_template}")"
}

# Generate buildings into $grid
generate_buildings()
{
    local current_building_height=''

    # Setsthe height of the buildings which players stand on
    player1_building_height="$((RANDOM % max_building_height))"
    player2_building_height="$((RANDOM % max_building_height))"

    if ((building_count <= 15))
    then
        # Create the bulding which player1 stands on (the second building from
        # the left edge of the screen)
        for ((i=building_width; i < (2 * building_width); i++))
        do
            for ((j=0; j < player1_building_height; j++))
            do
                grid["${i},${j}"]='X'
            done
        done

        # Create the bulding which player2 stands on (the second building from
        # the right edge of the screen)
        for ((i=(grid_width - (2 * building_width)); i < (grid_width - building_width); i++))
        do
            for ((j=0; j < player2_building_height; j++))
            do
                grid["${i},${j}"]='X'
            done
        done

        # Create all the other buildings
        for ((i=0; i < building_count; i++))
        do
            # Always set a random value for the actually generated building
            current_building_height="$((RANDOM % max_building_height))"

            if ((i != 1 && i != (building_count - 2)))
            then
                for ((j=0; j < building_width; j++))
                do
                    for ((k=0; k < current_building_height; k++))
                    do
                        grid["$(((i * building_width) + j)),${k}"]='X'
                    done
                done
            fi
        done
    else
        # Create the bulding which player1 stands on (the third building from
        # the left edge of the screen)
        for ((i=(2 * building_width); i < (3 * building_width); i++))
        do
            for ((j=0; j < player1_building_height; j++))
            do
                grid["${i},${j}"]='X'
            done
        done

        # Create the bulding which player2 stands on (the third building from
        # the right edge of the screen)
        for ((i=(grid_width - (3 * building_width)); i < (grid_width - (2 * building_width)); i++))
        do
            for ((j=0; j < player2_building_height; j++))
            do
                grid["${i},${j}"]='X'
            done
        done

        # Create all the other buildings
        for ((i=0; i < building_count; i++))
        do
            # Always set a random value for the actually generated building
            current_building_height="$((RANDOM % max_building_height))"

            if ((i != 2 && i != (building_count - 3)))
            then
                for ((j=0; j < building_width; j++))
                do
                    for ((k=0; k < current_building_height; k++))
                    do
                        grid["$(((i * building_width) + j)),${k}"]='X'
                    done
                done
            fi
        done
    fi
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

# Initialize variables for a new game or new round in the game
init_game()
{
    # Init player scores on new game
    if [[ "${player1_score}" == '' && "${player2_score}" == '' ]]
    then
        player1_score='0'
        player2_score='0'
    fi

    # Set first player randomly on new game
    if [[ "${next_player}" = '' ]]
    then
        next_player="$(((RANDOM % 2) + 1))"
    fi

    # Set maximum throw velocity
    if [[ "${max_speed}" = '' ]]
    then
        max_speed='100'
    fi

    # Set maximum wind speed
    if [[ "${max_wind_value}" == '' ]]
    then
        max_wind_value='6'
    fi

    # Set wind value
    wind_value="$((RANDOM % max_wind_value))"
    if ((wind_value != 0 && (RANDOM % 2) != 0))
    then
        wind_value="-${wind_value}"
    fi

    # Print message to the screen to inform the user what is happening
    tput cup 0 0 >> "${buffer}"
    if ((player1_score == 0 && player2_score == 0))
    then
        printf 'Starting new game...' >> "${buffer}"
    else
        printf 'Starting new round...' >> "${buffer}"
    fi

    # Refresh the screen
    refresh_screen

    # Set the width of a building (number of characters on the terminal screen)
    building_width='8'

    # Set the maxmum height of buildings to
    # three fourth of the height of the terminal
    max_building_height="$(((term_height * 3) / 4))"

    # Calculate $grid_width which will be the width of the playing field
    grid_width="$(((term_width / building_width) * building_width))"
    # Calculate $grid_height which will be the height of the playing field
    grid_height="$((term_height - 1))"

    # Calculate how many buildings can be placed into the playing field
    building_count="$((grid_width / building_width))"

    # Reset $left_padding and $top_padding
    left_padding=''
    top_padding=''

    # Set $left_padding_width for centering the playing field on the screen,
    # and set $top_padding_height to '0' since the game uses the whole
    # terminal in height
    left_padding_width="$(((term_width % building_width) / 2))"
    top_padding_height='0'

    # Initialize values of $grid
    for ((i=0; i < grid_width; i++))
    do
        for ((j=0; j < grid_height; j++))
        do
            grid["${i},${j}"]=''
        done
    done

    # Generate the buildings, and save the buildings into $grid
    generate_buildings

    # Initialize and place payers into $grid
    init_players
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

init_players()
{
    # Init player1 START -------------------------------------------------------
    local x=''
    local y=''

    # Remove elements of the $player1_coordinates array
    for ((i=0; i < ${#player1_coordinates[@]}; i++))
    do
        unset "player1_coordinates[${i}]"
    done

    # Remove elements of $player1_throw_animation_frame1
    for key in "${!player1_throw_animation_frame1[@]}"
    do
        unset "player1_throw_animation_frame1[${key}]"
    done

    # Remove elements of $player1_throw_animation_frame2
    for key in "${!player1_throw_animation_frame2[@]}"
    do
        unset "player1_throw_animation_frame2[${key}]"
    done

    # Remove elements of $player1_victory_animation_frame1
    for key in "${!player1_victory_animation_frame1[@]}"
    do
        unset "player1_victory_animation_frame1[${key}]"
    done

    # Remove elements of $player1_victory_animation_frame2
    for key in "${!player1_victory_animation_frame2[@]}"
    do
        unset "player1_victory_animation_frame2[${key}]"
    done

    # Set the initial horizontal coordinate of player1 depending
    # of the number of buildings on the playing field
    if ((building_count <= 15))
    then
        x="$((building_width + ((building_width - 3) / 2)))"
    else
        x="$(((building_width * 2) + ((building_width - 3) / 2)))"
    fi

    # Set the initial vertical coordinate of player1
    y="${player1_building_height}"

    # Left leg of player1
    grid["${x},${y}"]='/'

    # Add "${x},${y}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${x},${y}")

    # Right leg of player1
    x="$((x + 2))"
    grid["${x},${y}"]="\\"

    # Add "${x},${y}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${x},${y}")

    # Left arm of player1
    x="$((x - 2))"
    y="$((y + 1))"
    grid["${x},${y}"]='('

    # Set animation frames for player1 banana throw and victory dance
    player1_throw_animation_frame1["${x},${y}"]=' '
    player1_throw_animation_frame2["${x},${y}"]='('

    # Add "${x},${y}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${x},${y}")

    # Belly of player1
    x="$((x + 1))"
    grid["${x},${y}"]='G'

    # Add "${x},${y}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${x},${y}")

    # Right arm of player1
    x="$((x + 1))"
    grid["${x},${y}"]=')'

    # Set animation frames for player1 victory dance
    player1_victory_animation_frame1["${x},${y}"]=')'
    player1_victory_animation_frame2["${x},${y}"]=' '

    # Add "${x},${y}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${x},${y}")

    # Head of player1
    x="$((x - 1))"
    y="$((y + 1))"
    grid["${x},${y}"]='o'

    # Set animation frames for player1 banana throw and victory dance
    player1_throw_animation_frame1["$((x - 1)),${y}"]='('
    player1_throw_animation_frame2["$((x - 1)),${y}"]=' '
    player1_victory_animation_frame1["$((x + 1)),${y}"]=' '
    player1_victory_animation_frame2["$((x + 1)),${y}"]=')'

    # Add "${x},${y}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${x},${y}")

    # Set the banana throw position for player1
    player1_throw_start_coordinates="${x},$((y + 2))"
    # Init player1 END ---------------------------------------------------------

    # Init player2 START -------------------------------------------------------
    x=''
    y=''

    # Remove elements of the $player2_coordinates array
    for ((i=0; i < ${#player2_coordinates[@]}; i++))
    do
        unset "player2_coordinates[${i}]"
    done

    # Remove elements of $player2_throw_animation_frame1
    for key in "${!player2_throw_animation_frame1[@]}"
    do
        unset "player2_throw_animation_frame1[${key}]"
    done

    # Remove elements of $player2_throw_animation_frame2
    for key in "${!player2_throw_animation_frame2[@]}"
    do
        unset "player2_throw_animation_frame2[${key}]"
    done

    # Remove elements of $player2_victory_animation_frame1
    for key in "${!player2_victory_animation_frame1[@]}"
    do
        unset "player2_victory_animation_frame1[${key}]"
    done

    # Remove elements of $player2_victory_animation_frame2
    for key in "${!player2_victory_animation_frame2[@]}"
    do
        unset "player2_victory_animation_frame2[${key}]"
    done

    # Set the initial horizontal coordinate of player2 depending
    # of the number of buildings on the playing field
    if ((building_count <= 15))
    then
        x="$((grid_width - (2 * building_width)))"
        x="$((x + ((building_width - 3) / 2)))"
    else
        x="$((grid_width - (3 * building_width)))"
        x="$((x + ((building_width - 3) / 2)))"
    fi

    # Set the initial vertical coordinate of player2
    y="${player2_building_height}"

    # Left leg of player2
    grid["${x},${y}"]='/'

    # Add "${x},${y}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${x},${y}")

    # Right leg of player2
    x="$((x + 2))"
    grid["${x},${y}"]="\\"

    # Add "${x},${y}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${x},${y}")

    # Left arm of player2
    x="$((x - 2))"
    y="$((y + 1))"
    grid["${x},${y}"]='('

    # Set animation frames for player2 banana throw and victory dance
    player2_victory_animation_frame1["${x},${y}"]='('
    player2_victory_animation_frame2["${x},${y}"]=' '

    # Add "${x},${y}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${x},${y}")

    # Belly of player2
    x="$((x + 1))"
    grid["${x},${y}"]='G'

    # Add "${x},${y}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${x},${y}")

    # Right arm of player2
    x="$((x + 1))"
    grid["${x},${y}"]=')'
    player2_throw_animation_frame1["${x},${y}"]=' '
    player2_throw_animation_frame2["${x},${y}"]=')'

    # Add "${x},${y}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${x},${y}")

    # Head of player2
    x="$((x - 1))"
    y="$((y + 1))"
    grid["${x},${y}"]='o'

    # Set animation frames for player2 banana throw and victory dance
    player2_throw_animation_frame1["$((x + 1)),${y}"]=')'
    player2_throw_animation_frame2["$((x + 1)),${y}"]=' '
    player2_victory_animation_frame1["$((x - 1)),${y}"]=' '
    player2_victory_animation_frame2["$((x - 1)),${y}"]='('

    # Add "${x},${y}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${x},${y}")

    # Set the banana throw position for player2
    player2_throw_start_coordinates="${x},$((y + 2))"
    # Init player2 END ---------------------------------------------------------
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

print_frame_stage1()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf '*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    ' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 0))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf '    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 2))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage2()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf ' *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *   ' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 1))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf '   *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    * ' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 1))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage3()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf '  *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *  ' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 2))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf '  *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *  ' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 0))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage4()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf '   *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    * ' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 0))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf ' *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *   ' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 2))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage5()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf '    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 1))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf '*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    ' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 1))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
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

# Read a key from keyboard
read_intro_outro_continue_key()
{
    read -r -sn1 -t0.01

    return $?
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


check_required_programs

term_width="$(tput cols)"
term_height="$(tput lines)"

left_padding_width="$(((term_width - min_term_width) / 2))"
top_padding_height="$(((term_height - min_term_height) / 2))"

check_terminal_size

# Save terminal screen
tput smcup

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
