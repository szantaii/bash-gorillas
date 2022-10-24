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
