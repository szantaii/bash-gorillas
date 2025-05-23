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

# Check availability of necessary programs and minimum terminal size
check_prerequisites()
{
    # Check if 'tput' command is available
    which tput > /dev/null

    # If 'tput' is not available, then print
    # error message and exit with status code '2'
    if (($? != 0))
    then
        # Restore terminal screen
        tput rmcup

        printf "Your system is missing the program 'tput' which is necessary \
for bash-gorillas\nto run. 'tput' can be found in the following packages on \
the following distributions:\n    Distribution        Package name\n\
    ---------------------------------\n    Arch Linux          ncurses\n    \
Debian              ncurses-bin\n    Fedora              ncurses\n    \
openSUSE            ncurses-utils\n    Ubuntu              ncurses-bin\n"

        exit 2
    fi

    # Check if 'bc' command is available
    which bc > /dev/null

    # If 'bc' is not available, then print
    # error message and exit with status code '2'
    if (($? != 0))
    then
        # Restore terminal screen
        tput rmcup

        printf "Your system is missing the program 'bc' which is necessary \
for bash-gorillas\nto run. 'bc' can be found in the 'bc' package on most Linux \
distributions.\n"

        exit 2
    fi

    # Check if terminal has at least $min_term_width columns and
    # $min_term_height lines
    #
    # If either terminal width or height is less than
    # $min_term_width and $min_term_height print error message
    # and exit with status code '3'
    if ((term_width < min_term_width || term_height < min_term_height))
    then
        # Restore terminal screen
        tput rmcup

        printf "bash-gorillas needs a terminal with size of at least \
${min_term_width}x${min_term_height} (${min_term_width} columns, \
${min_term_height} lines).\n"

        exit 3
    fi
}

# Creates a 'screen buffer' file
create_buffer()
{
    local buffer_name="bashgorillas-buffer"

    # Try to use /dev/shm if available
    # else use /tmp as the location of
    # the screen buffer file
    if [ -d "/dev/shm" ]
    then
        local buffer_directory="/dev/shm"
    else
        local buffer_directory="/tmp"
    fi

    # Try to use mktemp before using the unsafe method
    if [ -x $(which mktemp) ]
    then
        # If 'mktemp' is available for use,
        # then create the buffer file using it
        buffer=$(mktemp --tmpdir=${buffer_directory} ${buffer_name}-XXXXXXXXXX)
    else
        # If 'mktemp' was not available for use,
        # then create the buffer file using $RANDOM
        #
        # Note this is an unsafe method to create the
        # screen buffer file!
        # TODO: check if buffer file already exists, if unsafe method is used
        buffer="${buffer_directory}/${buffer_name}-${RANDOM}"

        # Create the buffer file
        printf "" > $buffer
    fi
}

# Initializes variables and creates buffer
init_main()
{
    # Create the 'screen buffer'
    create_buffer

    # Capture Ctrl+C key combination to call the 'quit'
    # function when Ctrl+C key combination is pressed
    trap quit SIGINT

    # Clear the terminal screen
    clear >> "${buffer}"
    refresh_screen
}

# Function that prints the buffer onto
# the screen then empties the buffer
refresh_screen()
{
    cat "${buffer}"
    printf "" > "${buffer}"
}

# Functions in this file each print a frame to the buffer
#
# Calling these funcions and refreshing the screen in order will
# result in an animation
print_frame_stage1()
{
    # top rule
    tput cup ${top_padding_height} ${left_padding_width} >> "${buffer}"
    printf "*    *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    " >> "${buffer}"

    # right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) \
            $(($((left_padding_width + min_term_width)) - 1)) >> "${buffer}"
        if (( $((i % 3)) == 0))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    # bottom rule
    tput cup $((top_padding_height + min_term_height - 5)) \
        ${left_padding_width} >> "${buffer}"
    printf "    *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *" >> "${buffer}"

    # left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
            >> "${buffer}"
        if (( $((i % 3)) == 2))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage2()
{
    # top rule
    tput cup ${top_padding_height} ${left_padding_width} >> "${buffer}"
    printf " *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *   " >> "${buffer}"

    # right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) \
            $(($((left_padding_width + min_term_width)) - 1)) >> "${buffer}"
        if (( $((i % 3)) == 1))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    # bottom rule
    tput cup $((top_padding_height + min_term_height - 5)) \
        ${left_padding_width} >> "${buffer}"
    printf "   *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    * " >> "${buffer}"

    # left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
            >> "${buffer}"
        if (( $((i % 3)) == 1))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage3()
{
    # top rule
    tput cup ${top_padding_height} ${left_padding_width} >> "${buffer}"
    printf "  *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *  " >> "${buffer}"

    # right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) \
            $(($((left_padding_width + min_term_width)) - 1)) >> "${buffer}"
        if (( $((i % 3)) == 2))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    # bottom rule
    tput cup $((top_padding_height + min_term_height - 5)) \
        ${left_padding_width} >> "${buffer}"
    printf "  *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *  " >> "${buffer}"

    # left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
            >> "${buffer}"
        if (( $((i % 3)) == 0))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage4()
{
    # top rule
    tput cup ${top_padding_height} ${left_padding_width} >> "${buffer}"
    printf "   *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    * " >> "${buffer}"

    # right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) \
            $(($((left_padding_width + min_term_width)) - 1)) >> "${buffer}"
        if (( $((i % 3)) == 0))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    # bottom rule
    tput cup $((top_padding_height + min_term_height - 5)) \
        ${left_padding_width} >> "${buffer}"
    printf " *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *   " >> "${buffer}"

    # left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
            >> "${buffer}"
        if (( $((i % 3)) == 2))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage5()
{
    # top rule
    tput cup ${top_padding_height} ${left_padding_width} >> "${buffer}"
    printf "    *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *" >> "${buffer}"

    # right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) \
            $(($((left_padding_width + min_term_width)) - 1)) >> "${buffer}"
        if (( $((i % 3)) == 1))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    # bottom rule
    tput cup $((top_padding_height + min_term_height - 5)) \
        ${left_padding_width} >> "${buffer}"
    printf "*    *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    " >> "${buffer}"

    # left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
            >> "${buffer}"
        if (( $((i % 3)) == 1))
        then
            printf "*" >> "${buffer}"
        else
            printf " " >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

#!/bin/bash

# Reads a key from keyboard
#
# If a key was read before read's timeout expires
# then breaks out of outer construcions.
read_intro_outro_continue_key()
{
    read -sn1 -t0.01

    if (($? == 0))
    then
        break
    fi
}

# Plays intro: prints animated frames and intro text to the screen
play_intro()
{
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

    # Intro text
    local intro_text="\n\n${top_padding}${left_padding}                       \
    B a s h   G O R I L L A S\n\n\n${left_padding}            Copyright (C) \
Istvan Szantai \x3c\x73\x7a\x61\x6e\x74\x61\x69\x69\x40\x73\x69\x64\x65\x6e\
\x6f\x74\x65\x2e\x68\x75\x3e 2013\n\n${left_padding}     This game \
is a demake of QBasic GORILLAS rewritten completely in Bash.\n\n\n${left_padding}\
             Your mission is to hit your opponent with the exploding\n\
${left_padding}           banana by varying the angle and power of your \
throw, taking\n${left_padding}             into account wind speed, gravity, \
and the city skyline.\n${left_padding}*          The wind speed is show by a \
directional arrow at the bottom\n${left_padding}            of the playing \
field, its length relative to its strength.\n\n\n\n\n\n${left_padding}    \
                        Press any key to continue"

    # Print intro text into the screen buffer
    printf "${intro_text}" >> "${buffer}"

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
    clear >> "${buffer}"
    refresh_screen
}

# Cleans up on quit, returns '0'
quit()
{
    # Delete screen buffer file
    rm "${buffer}"

    # Restore terminal screen
    tput rmcup

    # Exit with status '0'
    exit 0
}

# Functions in this file prompt questions and read answers from player

prompt_player1_name()
{
    tput cup $((top_padding_height + 4)) \
        $((left_padding_width + 15)) >> "${buffer}"

    printf "Name of Player 1 (Default = 'Player 1'): " >> "${buffer}"
}

prompt_player2_name()
{
    tput cup $((top_padding_height + 6)) \
        $((left_padding_width + 15)) >> "${buffer}"

    printf "Name of Player 2 (Default = 'Player 2'): " >> "${buffer}"
}

prompt_max_points_num()
{
    tput cup $((top_padding_height + 8)) \
        $((left_padding_width + 17)) >> "${buffer}"

    printf "Play to how many total points (Default = 3)? " >> "${buffer}"
}

prompt_gravity_value()
{
    tput cup $((top_padding_height + 10)) \
        $((left_padding_width + 20)) >> "${buffer}"

    printf "Gravity in Meters/Sec^2 (Earth = ~10)? " >> "${buffer}"
}

prompt_menu_choice()
{
    tput cup $((top_padding_height + 12)) \
        $((left_padding_width + 34)) >> "${buffer}"

    printf "%s-------------" >> "${buffer}"

    tput cup $((top_padding_height + 14)) \
        $((left_padding_width + 34)) >> "${buffer}"

    printf "P = Play Game" >> "${buffer}"

    tput cup $((top_padding_height + 15)) \
        $((left_padding_width + 37)) >> "${buffer}"

    printf "Q = Quit" >> "${buffer}"

    tput cup $((top_padding_height + 17)) \
        $((left_padding_width + 35)) >> "${buffer}"

    printf "Your Choice?" >> "${buffer}"
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

    clear >> "${buffer}"
    refresh_screen
}

# Generates buildings into $grid
generate_buildings()
{
    local current_building_height=""

    # Sets the height of the buildings which players stand on
    player1_building_height=$((RANDOM % max_building_height))
    player2_building_height=$((RANDOM % max_building_height))

    # If there are less than 16 buildings on the map
    if ((building_count <= 15))
    then
        # Create the bulding which player1 stands on
        # (the second building from the left edge of the screen)
        for ((i=building_width; i < (2 * building_width); i++))
        do
            for ((j=0; j < player1_building_height; j++))
            do
                grid["${i},${j}"]="X"
            done
        done

        # Create the bulding which player2 stands on
        # (the second building from the right edge of the screen)
        for ((i=(grid_width - (2 * building_width)); i < (grid_width - building_width); i++))
        do
            for ((j=0; j < player2_building_height; j++))
            do
                grid["${i},${j}"]="X"
            done
        done

        # Create all the other buildings
        for ((i=0; i < building_count; i++))
        do
            # Always set a random value for the actually generated building
            current_building_height=$((RANDOM % max_building_height))

            if ((i != 1 && i != (building_count - 2)))
            then
                for ((j=0; j < building_width; j++))
                do
                    for ((k=0; k < current_building_height; k++))
                    do
                        grid["$(($((i * building_width)) + j)),${k}"]="X"
                    done
                done
            fi
        done
    else # If there are more than 15 buildings on the map then

        # Create the bulding which player1 stands on
        # (the third building from the left edge of the screen)
        for ((i=(2 * building_width); i < (3 * building_width); i++))
        do
            for ((j=0; j < player1_building_height; j++))
            do
                grid["${i},${j}"]="X"
            done
        done

        # Create the bulding which player2 stands on
        # (the third building from the right edge of the screen)
        for ((i=(grid_width - (3 * building_width)); i < (grid_width - (2 * building_width)); i++))
        do
            for ((j=0; j < player2_building_height; j++))
            do
                grid["${i},${j}"]="X"
            done
        done

        # Create all the other buildings
        for ((i=0; i < building_count; i++))
        do
            # Always set a random value for the actually generated building
            current_building_height=$((RANDOM % max_building_height))

            if ((i != 2 && i != (building_count - 3)))
            then
                for ((j=0; j < building_width; j++))
                do
                    for ((k=0; k < current_building_height; k++))
                    do
                        grid["$(($((i * building_width)) + j)),${k}"]="X"
                    done
                done
            fi
        done
    fi
}

init_players()
{
    # Init player1 START -------------------------------------------------------
    local i=""
    local j=""

    # Remove elements of the $player1_coordinates array
    j=${#player1_coordinates[@]}
    for ((i=0; i < j; i++))
    do
        unset player1_coordinates[${i}]
    done

    # Remove elements of $player1_throw_animation_frame1
    for key in "${!player1_throw_animation_frame1[@]}"
    do
        unset player1_throw_animation_frame1["${key}"]
    done

    # Remove elements of $player1_throw_animation_frame2
    for key in "${!player1_throw_animation_frame2[@]}"
    do
        unset player1_throw_animation_frame2["${key}"]
    done

    # Remove elements of $player1_victory_animation_frame1
    for key in "${!player1_victory_animation_frame1[@]}"
    do
        unset player1_victory_animation_frame1["${key}"]
    done

    # Remove elements of $player1_victory_animation_frame2
    for key in "${!player1_victory_animation_frame2[@]}"
    do
        unset player1_victory_animation_frame2["${key}"]
    done

    # Set the initial horizontal coordinate of player1 depending
    # of the number of buildings on the playing field
    if ((building_count <= 15))
    then
        i=$((building_width + $(($((building_width - 3)) / 2))))
    else
        i=$(($((building_width * 2)) + $(($((building_width - 3)) / 2))))
    fi
    # Set the initial vertical coordinate of player1
    j=${player1_building_height}
    # Left leg of player1
    grid["${i},${j}"]="/"

    # Add "${i},${j}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")

    # Right leg of player1
    i=$((i + 2))
    grid["${i},${j}"]="\\"

    # Add "${i},${j}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")

    # Left arm of player1
    i=$((i - 2))
    j=$((j + 1))
    grid["${i},${j}"]="("

    # Set animation frames for player1 banana throw and victory dance
    player1_throw_animation_frame1["${i},${j}"]=" "
    player1_throw_animation_frame2["${i},${j}"]="("

    # Add "${i},${j}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")

    # Belly of player1
    i=$((i + 1))
    grid["${i},${j}"]="G"

    # Add "${i},${j}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")

    # Right arm of player1
    i=$((i + 1))
    grid["${i},${j}"]=")"

    # Set animation frames for player1 victory dance
    player1_victory_animation_frame1["${i},${j}"]=")"
    player1_victory_animation_frame2["${i},${j}"]=" "

    # Add "${i},${j}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")

    # Head of player1
    i=$((i - 1))
    j=$((j + 1))
    grid["${i},${j}"]="o"

    # Set animation frames for player1 banana throw and victory dance
    player1_throw_animation_frame1["$((i - 1)),${j}"]="("
    player1_throw_animation_frame2["$((i - 1)),${j}"]=" "
    player1_victory_animation_frame1["$((i + 1)),${j}"]=" "
    player1_victory_animation_frame2["$((i + 1)),${j}"]=")"

    # Add "${i},${j}" to the $player1_coordinates array
    player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")

    # Set the banana throw position for player1
    player1_throw_start_coordinates="${i},$((j + 2))"
    # Init player1 END ---------------------------------------------------------

    # Init player2 START -------------------------------------------------------
    i=""
    j=""

    # Remove elements of the $player1_coordinates array
    j=${#player2_coordinates[@]}
    for ((i=0; i < j; i++))
    do
        unset player2_coordinates[${i}]
    done

    # Remove elements of $player2_throw_animation_frame1
    for key in "${!player2_throw_animation_frame1[@]}"
    do
        unset player2_throw_animation_frame1["${key}"]
    done

    # Remove elements of $player2_throw_animation_frame2
    for key in "${!player2_throw_animation_frame2[@]}"
    do
        unset player2_throw_animation_frame2["${key}"]
    done

    # Remove elements of $player2_victory_animation_frame1
    for key in "${!player2_victory_animation_frame1[@]}"
    do
        unset player2_victory_animation_frame1["${key}"]
    done

    # Remove elements of $player2_victory_animation_frame2
    for key in "${!player2_victory_animation_frame2[@]}"
    do
        unset player2_victory_animation_frame2["${key}"]
    done

    # Set the initial horizontal coordinate of player2 depending
    # of the number of buildings on the playing field
    if ((building_count <= 15))
    then
        i=$((grid_width - $((2 * building_width))))
        i=$((i + $(($((building_width - 3)) / 2))))
    else
        i=$((grid_width - $((3 * building_width))))
        i=$((i + $(($((building_width - 3)) / 2))))
    fi
    # Set the initial vertical coordinate of player1
    j=${player2_building_height}

    # Left leg of player2
    grid["${i},${j}"]="/"

    # Add "${i},${j}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")

    # Right leg of player2
    i=$((i + 2))
    grid["${i},${j}"]="\\"

    # Add "${i},${j}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")

    # Left arm of player2
    i=$((i - 2))
    j=$((j + 1))
    grid["${i},${j}"]="("

    # Set animation frames for player2 banana throw and victory dance
    player2_victory_animation_frame1["${i},${j}"]="("
    player2_victory_animation_frame2["${i},${j}"]=" "

    # Add "${i},${j}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")

    # Belly of player2
    i=$((i + 1))
    grid["${i},${j}"]="G"

    # Add "${i},${j}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")

    # Right arm of player2
    i=$((i + 1))
    grid["${i},${j}"]=")"
    player2_throw_animation_frame1["${i},${j}"]=" "
    player2_throw_animation_frame2["${i},${j}"]=")"

    # Add "${i},${j}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")

    # Head of player2
    i=$((i - 1))
    j=$((j + 1))
    grid["${i},${j}"]="o"

    # Set animation frames for player2 banana throw and victory dance
    player2_throw_animation_frame1["$((i + 1)),${j}"]=")"
    player2_throw_animation_frame2["$((i + 1)),${j}"]=" "
    player2_victory_animation_frame1["$((i - 1)),${j}"]=" "
    player2_victory_animation_frame2["$((i - 1)),${j}"]="("

    # Add "${i},${j}" to the $player2_coordinates array
    player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")

    # Set the banana throw position for player2
    player2_throw_start_coordinates="${i},$((j + 2))"
    # Init player2 END ---------------------------------------------------------
}

# Initializes variables for a new game or new round in the game
init_game()
{
    # Init player scores on new game
    if [[ "${player1_score}" == "" && "${player2_score}" == "" ]]
    then
        player1_score=0
        player2_score=0
    fi

    # Set first player randomly on new game
    if [[ "${next_player}" = "" ]]
    then
        next_player=$(($((RANDOM % 2)) + 1))
    fi

    # Set maximum throw velocity
    if [[ "${max_speed}" = "" ]]
    then
        max_speed=100
    fi

    # Set maximum wind speed
    if [[ "${max_wind_value}" == "" ]]
    then
        max_wind_value=6
    fi

    # Set wind value
    wind_value=$((RANDOM % max_wind_value))
    if ((wind_value != 0 && (RANDOM % 2) != 0))
    then
        wind_value="-${wind_value}"
    fi

    # Print message to the screen to inform the user what is happening
    tput cup 0 0 >> "${buffer}"
    if ((player1_score == 0 && player2_score == 0))
    then
        printf "Starting new game..." >> "${buffer}"
    else
        printf "Starting new round..." >> "${buffer}"
    fi

    # Refresh the screen
    refresh_screen

    # Set the width of a building (number of characters on the terminal screen)
    building_width=8

    # Set the maxmum height of buildings to
    # three fourth of the height of the terminal
    max_building_height=$(($((term_height * 3)) / 4))

    # Calculate $grid_width which will be the width of the playing field
    grid_width=$(($((term_width / building_width)) * building_width))
    # Calculate $grid_height which will be the height of the playing field
    grid_height=$((term_height - 1))

    # Calculate how many buildings can be placed into the playing field
    building_count=$((grid_width / building_width))

    # Reset $left_padding and $top_padding
    left_padding=""
    top_padding=""

    # Set $left_padding_width for centering the playing field on the screen,
    # and set $top_padding_height to '0' since the game uses the whole
    # terminal in height
    left_padding_width=$(($((term_width % building_width)) / 2))
    top_padding_height="0"

    # Initialize values of $grid
    for ((i=0; i < grid_width; i++))
    do
        for ((j=0; j < grid_height; j++))
        do
            grid["${i},${j}"]=""
        done
    done

    # Generate the buildings, and save the buildings into $grid
    generate_buildings

    # Initialize and place payers into $grid
    init_players
}

# Prints the Sun to the top center of the screen
print_sun()
{
    # Create a local array variable
    local sun_text=()

    # Store the ASCII lines of the Sun
    sun_text[0]="    |"
    sun_text[1]="  \\ _ /"
    sun_text[2]="-= (_) =-"
    sun_text[3]="  /   \\"
    sun_text[4]="    |"

    # Iterate through the local array $sun_text
    # and print its contents to the screen
    for ((i=0; i < ${#sun_text[@]}; i++))
    do
        # Position the cursor to the top of the screen + i lines
        # and horizontally center of the screen minus the width
        # of the ASCII Sun
        tput cup $((top_padding_height + i)) \
            $((left_padding_width + $((grid_width / 2)) - $((9 / 2)))) \
            >> "${buffer}"

        # Print the actual line to the screen buffer
        printf "%s${sun_text[${i}]}" >> "${buffer}"
    done

    # Refresh the screen
    refresh_screen
}

# Prints wind indicator arrow to the bottom row of the screen
print_wind()
{
    # Center the cursor in the bottom row of the screen
    tput cup ${grid_height} \
        $((left_padding_width + $((grid_width / 2)))) >> "${buffer}"

    printf "|" >> "${buffer}"

    # Print wind indicator arrow if $wind_value is not zero
    if ((wind_value != 0))
    then
        if ((wind_value < 0))
        then
            # If the wind blows to the left ($wind_value is negative)
            tput cup ${grid_height} \
                $((left_padding_width + $(($(($((grid_width / 2)) \
                + wind_value)) - 1)))) >> "${buffer}"

            # Print wind indicator arrowhead
            printf "<" >> "${buffer}"

            # Print arrow with the length of $wind_value
            for ((i=wind_value; i < 0; i++))
            do
                printf "%s-" >> "${buffer}"
            done
        else
            # If the wind blows to the right ($wind_value is positive)
            # then print the arrow with the length of $wind_value
            for ((i=0; i < wind_value; i++))
            do
                printf "%s-" >> "${buffer}"
            done

            # Print wind indicator arrowhead
            printf ">" >> "${buffer}"
        fi
    fi

    # Refresh the screen
    refresh_screen
}

# Prints the name of players to the top left and right corners of the screen
print_player_names()
{
    # Position the cursor to the top left corner of the playing field
    tput cup ${top_padding_height} ${left_padding_width} >> "${buffer}"

    # Print player1's name ($player1_name)
    printf "${player1_name}" >> "${buffer}"

    # Position the cursor to the top right corner ot the playing field
    tput cup ${top_padding_height} \
        $(($((left_padding_width + grid_width)) - ${#player2_name}))>> "${buffer}"

    # Print player2's name ($player2_name)
    printf "${player2_name}" >> "${buffer}"

    # Refresh the screen
    refresh_screen
}

# Clears the player names from the top left and right corners of the screen
clear_player_names()
{
    # Position the cursor to the top left corner of the playing field
    tput cup ${top_padding_height} ${left_padding_width} >> "${buffer}"

    # Clear the name of player1 from the top left corner of the playing field
    for ((i=0; i < ${#player1_name}; i++))
    do
        printf " " >> "${buffer}"
    done

    # Position the cursor to the top right corner of the playing field
    tput cup ${top_padding_height} \
        $(($((left_padding_width + grid_width)) - ${#player2_name}))>> "${buffer}"

    # Clear the name of player2 from the top right corner of the playing field
    for ((i=0; i < ${#player2_name}; i++))
    do
        printf " " >> "${buffer}"
    done

    # Refresh the screen
    refresh_screen
}

# Prints the score of the players (overlaps buildings on the screen)
print_score()
{
    local score_text=" ${player1_score}>SCORE<${player2_score} "

    # Position the cursor into the third row from the bottom of the screen,
    # and center with length of $score_text taken into account
    tput cup $(($((top_padding_height + grid_height)) - 2)) \
        $((left_padding_width + $((grid_width / 2)) - $((${#score_text} / 2)))) >> "${buffer}"

    # Print the score
    printf "${score_text}" >> "${buffer}"

    # Refresh the screen
    refresh_screen
}

# Prints the contents of 'grid' into the screen buffer,
# then refreshes the screen
print_scene()
{
    # Clear screen
    clear >> "${buffer}"

    # Print the contents of $grid to the buffer
    for((i=0; i < grid_width; i++))
    do
        for ((j=0; j < grid_height; j++))
        do
            tput cup $(($(($((top_padding_height + grid_height)) - j)) - 1)) \
                $((left_padding_width + i)) >> "${buffer}"

            printf "${grid["${i},${j}"]}" >> "${buffer}"
        done
    done

    # Refresh screen
    refresh_screen
}

# Prints a small help how to quit the game
# into the right bottom part of the screen
print_help()
{
    local help_text="Quit: ^C"

    # Position the cursor to the bottom row of the screen,
    # and to the right side of the $grid
    tput cup ${grid_height} \
        $(($((left_padding_width + grid_width)) - ${#help_text})) >> "${buffer}"

    # Print help
    printf "${help_text}" >> "${buffer}"

    # Refresh the screen
    refresh_screen
}

# Functions in this file prompt questions and read answers from player
# regarding the angle and speed of throwing

prompt_player1_throw_angle()
{
    local angle_text="Angle [0-90]: "

    tput cup $((top_padding_height + 1)) ${left_padding_width} >> "${buffer}"

    printf "${angle_text}" >> "${buffer}"

    refresh_screen
}

prompt_player2_throw_angle()
{
    local angle_text="Angle [0-90]: "

    tput cup $((top_padding_height + 1)) \
        $(($((left_padding_width + grid_width)) - $((${#angle_text} + 2)))) \
        >> "${buffer}"

    printf "${angle_text}" >> "${buffer}"

    refresh_screen
}

prompt_player1_throw_speed()
{
    local speed_text="Velocity [0-${max_speed}]: "

    tput cup $((top_padding_height + 2)) ${left_padding_width} >> "${buffer}"

    printf "${speed_text}" >> "${buffer}"

    refresh_screen
}

prompt_player2_throw_speed()
{
    local speed_text="Velocity [0-${max_speed}]: "

    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + grid_width)) - \
        $((${#speed_text} + ${#max_speed})))) >> "${buffer}"

    printf "${speed_text}" >> "${buffer}"

    refresh_screen
}

print_player1_correct_throw_angle()
{
    tput cup $((top_padding_height + 1)) \
        $((left_padding_width + 14)) >> "${buffer}"

    printf "  " >> "${buffer}"

    tput cup $((top_padding_height + 1)) \
        $((left_padding_width + 14)) >> "${buffer}"

    printf "${player1_throw_angle}" >> "${buffer}"

    refresh_screen
}

print_player2_correct_throw_angle()
{
    tput cup $((top_padding_height + 1)) \
        $(($((left_padding_width + grid_width)) - 2)) >> "${buffer}"

    printf "  " >> "${buffer}"

    tput cup $((top_padding_height + 1)) \
        $(($((left_padding_width + grid_width)) - 2)) >> "${buffer}"

    printf "${player2_throw_angle}" >> "${buffer}"

    refresh_screen
}

print_player1_correct_throw_speed()
{
    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + 15)) + ${#max_speed})) >> "${buffer}"

    for ((i=0; i < ${#max_speed}; i++))
    do
        printf " " >> "${buffer}"
    done

    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + 15)) + ${#max_speed})) >> "${buffer}"

    printf "${player1_throw_speed}" >> "${buffer}"

    refresh_screen
}

print_player2_correct_throw_speed()
{
    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + grid_width)) - ${#max_speed})) >> "${buffer}"

    for ((i=0; i < ${#max_speed}; i++))
    do
        printf " " >> "${buffer}"
    done

    tput cup $((top_padding_height + 2)) \
        $(($((left_padding_width + grid_width)) - ${#max_speed})) >> "${buffer}"

    printf "${player2_throw_speed}" >> "${buffer}"

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
    tput cup $((top_padding_height + 1)) ${left_padding_width} >> "${buffer}"

    printf "                " >> "${buffer}"

    refresh_screen
}

clear_player2_throw_angle()
{
    tput cup $((top_padding_height + 1)) \
    $(($((left_padding_width + grid_width)) - 16)) >> "${buffer}"

    printf "                " >> "${buffer}"

    refresh_screen
}

clear_player1_throw_speed()
{
    tput cup $((top_padding_height + 2)) ${left_padding_width} >> "${buffer}"

    printf "               " >> "${buffer}"

    for ((i=0; i < (2 * ${#max_speed}); i++))
    do
        printf " " >> "${buffer}"
    done

    refresh_screen
}

clear_player2_throw_speed()
{
    tput cup $((top_padding_height + 2)) \
        $(($(($((left_padding_width + grid_width)) - 15)) \
        - $((2 * ${#max_speed})))) >> "${buffer}"

    printf "               " >> "${buffer}"

    for ((i=0; i < (2 * ${#max_speed}); i++))
    do
        printf " " >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"

        printf "${player1_throw_animation_frame1["${key}"]}" >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"

        printf "${player1_throw_animation_frame2["${key}"]}" >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"

        printf "${player2_throw_animation_frame1["${key}"]}" >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"

        printf "${player2_throw_animation_frame2["${key}"]}" >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"

        printf "${player1_victory_animation_frame1["${key}"]}" >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"

        printf "${player1_victory_animation_frame2["${key}"]}" >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"

        printf "${player2_victory_animation_frame1["${key}"]}" >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"

        printf "${player2_victory_animation_frame2["${key}"]}" >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"
        printf " " >> "${buffer}"
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
            $((left_padding_width + i)) >> "${buffer}"
        printf " " >> "${buffer}"
    done

    refresh_screen
}

# Sets the first banana frame
# depending which player throws
init_banana()
{
    if ((next_player == 1))
    then
        banana="<"
    else
        banana=">"
    fi
}

# Sets the next banana frame
# depending which player throws
next_banana_frame()
{
    if ((next_player == 1))
    then
        case ${banana} in
            "<")
                banana="^"
                ;;
            "^")
                banana=">"
                ;;
            ">")
                banana="v"
                ;;
            "v")
                banana="<"
                ;;
        esac
    else
        case ${banana} in
            ">")
                banana="^"
                ;;
            "^")
                banana="<"
                ;;
            "<")
                banana="v"
                ;;
            "v")
                banana=">"
                ;;
        esac
    fi
}

# Swithes to the other player
switch_player()
{
    if ((next_player == 1))
    then
        next_player=2
    else
        next_player=1
    fi
}

# This fuction is responsible for banana throwing,
# including physics, animation, etc.
throw_banana()
{
    # Necessary local variables
    local pi=$(echo "scale=20; 4 * a(1)" | bc -l)
    local x=""
    local y=""
    local x_0=""
    local y_0=""
    local prev_x=""
    local prev_y=""
    local throw_angle=""
    local throw_speed=""

    # Initialize banana animation frame
    init_banana

    # Set $throw_angle, $throw_speed, banana throw
    # start positions, etc. based on read values and
    # current player
    if ((next_player == 1))
    then
        # Convert degrees to radians
        throw_angle=$(echo "scale=20; ${player1_throw_angle} * ${pi} / 180" | \
            bc -l)

        # Set $throw_speed of player1
        throw_speed=${player1_throw_speed}

        # Set throw start coordinates of player1
        x=${player1_throw_start_coordinates%","*}
        y=${player1_throw_start_coordinates#*","}
        x_0=${x}
        y_0=${y}

        # Start player1 throw animation
        print_player1_throw_frame1
    else
        # Set correct angle for player2, and
        # convert degrees to radians
        throw_angle=$((180 - player2_throw_angle))
        throw_angle=$(echo "scale=20; ${throw_angle} * ${pi} / 180" | \
            bc -l)

        # Set $throw_speed of player2
        throw_speed=${player2_throw_speed}

        # Set throw start coordinates of player2
        x=${player2_throw_start_coordinates%","*}
        y=${player2_throw_start_coordinates#*","}
        x_0=${x}
        y_0=${y}

        # Start player2 throw animation
        print_player2_throw_frame1
    fi

    # Print first banana frame to the screen
    tput cup $(($((top_padding_height + grid_height)) - y)) \
        $((left_padding_width + x)) >> "${buffer}"
    printf "${banana}" >> "${buffer}"
    refresh_screen

    # Print player throw animation ending to the screen
    # depending who is the current throwing player
    if ((next_player == 1))
    then
        print_player1_throw_frame2
    else
        print_player2_throw_frame2
    fi

    # Banana throw loop:
    #
    for ((t=0; x >= 0 && x < grid_width && y >= 1 && y <= (grid_height * 5); ))
    do
        # Clear previous banana frame from screen,
        # if there was a banana printed to the
        # screen in the previous iteration
        if [[ "${prev_x}" != "" && "${prev_y}" != "" ]] && \
            ((x >= 0 && x < grid_width && y >= 1 && y <= grid_height))
        then
            tput cup $(($((top_padding_height + grid_height)) - y)) \
                $((left_padding_width + x)) >> "${buffer}"
            printf " " >> "${buffer}"
            refresh_screen
        fi

        # Calculate next horizontal ($x) and
        # vertical ($y) position of the banana
        x=$(echo "scale=20; ${x_0} + \
            (${throw_speed} * ${t} * c(${throw_angle}) + \
            (${wind_value} * ${t} * ${t}))" | bc -l | xargs printf "%1.0f\n")
        y=$(echo "scale=20; ${y_0} + \
            (${throw_speed} * ${t} * s(${throw_angle}) - \
            (2 * ${gravity_value} / 2) * ${t} * ${t})" | \
            bc -l | xargs printf "%1.0f\n")

        # Collision detection START --------------------------------------------
        # If the banana hits a building the building block
        # will be erased and then comes the next player
        if [[ "${grid["${x},$((y - 1))"]}" == "X" ]]
        then
            # Erase block from 'grid'
            grid["${x},$((y - 1))"]=""

            # Erase block from screen
            tput cup $(($((top_padding_height + grid_height)) - y)) \
                $((left_padding_width + x)) >> "${buffer}"
            printf " " >> "${buffer}"
            refresh_screen

            # Exit the loop
            break
        fi

        # Banana hits player: check the current player,
        # and increase score of the player who was not hit,
        # clear the player who was hit from the screen,
        # and set $next_player to the player who was hit
        for ((i=0; i < ${#player1_coordinates[@]}; i++))
        do
            if [[ "${player1_coordinates[${i}]}" == "${x},$((y - 1))" ]]
            then
                clear_player1
                player2_score=$((player2_score + 1))

                if ((next_player == 2))
                then
                    switch_player
                fi

                break 3

            elif [[ "${player2_coordinates[${i}]}" == "${x},$((y - 1))" ]]
            then
                clear_player2
                player1_score=$((player1_score + 1))

                if ((next_player == 1))
                then
                    switch_player
                fi

                break 3
            fi
        done

        # Change banana character only if cursor is moved to another place
        if ((prev_x != x || prev_y != y))
        then
            next_banana_frame
        fi
        # Collision detection END ----------------------------------------------

        # Print banana to screen
        if ((x >= 0 && x < grid_width && y >= 1 && y <= grid_height))
        then
            tput cup $(($((top_padding_height + grid_height)) - y)) \
                $((left_padding_width + x)) >> "${buffer}"
            printf "${banana}" >> "${buffer}"
            refresh_screen
            sleep 0.05
        fi

        # Set previous horizontal ($prev_x) and vertical ($prev_y) coordinates
        prev_x=${x}
        prev_y=${y}

        # Step time
        t=$(echo "scale=20; ${t} + 0.005" | bc -l)
    done

    # If the thrown banana gets out of boundaries
    # or the banana hits a building then the next
    # player can throw
    switch_player
}

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
    printf "${outro_text}" >> "${buffer}"

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
    clear >> "${buffer}"
    refresh_screen
}

# Main loop of the game
main_loop()
{
    # Initialize variables, create screen buffer for bash-gorillas
    init_main

    # Play intro and wait for keypress
    play_intro

    # Read players' names, max points, gravity
    read_player_data

    while [[ "${player1_score}" == "" && "${player2_score}" == "" ]] \
        || (((player1_score + player2_score) < total_points))
    do
        # Initialize necessary variables before every round,
        # generate buildings, place players on map, etc.
        # (not everything implemented yet)
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

        # On player hit update the score
        # and make the winner dance
        print_score
        print_player_victory_dance
    done

    # Clear the screen
    clear >> "${buffer}"
    refresh_screen

    # Play outro and wait for keypress
    play_outro

    # Clean up and exit with 0
    quit
}

check_prerequisites "${term_width}" "${term_height}"

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
