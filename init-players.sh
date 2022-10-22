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
