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
