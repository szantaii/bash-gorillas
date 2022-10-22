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

# Prints wind indicator arrow to the bottom row of the screen
print_wind()
{
    # Center the cursor in the bottom row of the screen
    tput cup ${grid_height} \
        $((left_padding_width + $((grid_width / 2)))) >> ${buffer}

    printf "|" >> ${buffer}

    # Print wind indicator arrow if $wind_value is not zero
    if ((wind_value != 0))
    then
        if ((wind_value < 0))
        then
            # If the wind blows to the left ($wind_value is negative)
            tput cup ${grid_height} \
                $((left_padding_width + $(($(($((grid_width / 2)) \
                + wind_value)) - 1)))) >> ${buffer}

            # Print wind indicator arrowhead
            printf "<" >> ${buffer}

            # Print arrow with the length of $wind_value
            for ((i=wind_value; i < 0; i++))
            do
                printf "%s-" >> ${buffer}
            done
        else
            # If the wind blows to the right ($wind_value is positive)
            # then print the arrow with the length of $wind_value
            for ((i=0; i < wind_value; i++))
            do
                printf "%s-" >> ${buffer}
            done

            # Print wind indicator arrowhead
            printf ">" >> ${buffer}
        fi
    fi

    # Refresh the screen
    refresh_screen
}
