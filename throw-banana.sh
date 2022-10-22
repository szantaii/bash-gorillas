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
        $((left_padding_width + x)) >> ${buffer}
    printf "${banana}" >> ${buffer}
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
                $((left_padding_width + x)) >> ${buffer}
            printf " " >> ${buffer}
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
                $((left_padding_width + x)) >> ${buffer}
            printf " " >> ${buffer}
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
                $((left_padding_width + x)) >> ${buffer}
            printf "${banana}" >> ${buffer}
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
