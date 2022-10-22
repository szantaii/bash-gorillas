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

# Prints a small help how to quit the game
# into the right bottom part of the screen
print_help()
{
    local help_text="Quit: ^C"

    # Position the cursor to the bottom row of the screen,
    # and to the right side of the $grid
    tput cup ${grid_height} \
        $(($((left_padding_width + grid_width)) - ${#help_text})) >> ${buffer}

    # Print help
    printf "${help_text}" >> ${buffer}

    # Refresh the screen
    refresh_screen
}
