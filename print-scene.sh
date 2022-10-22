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

# Print the contents of 'grid' into the screen buffer, then refresh the screen
print_scene()
{
    # Clear screen
    clear >> "${buffer}"

    # Print the contents of $grid to the buffer
    for((i=0; i < grid_width; i++))
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
