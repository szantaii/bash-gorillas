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
