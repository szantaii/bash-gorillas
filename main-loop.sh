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
    clear >> ${buffer}
    refresh_screen

    # Play outro and wait for keypress
    play_outro

    # Clean up and exit with 0
    quit
}
