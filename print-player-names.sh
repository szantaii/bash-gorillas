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

# Prints the name of players to the top left and right corners of the screen
print_player_names()
{
	# Position the cursor to the top left corner of the playing field
	tput cup ${top_padding_height} ${left_padding_width} >> ${buffer}
	
	# Print player1's name ($player1_name)
	printf "${player1_name}" >> ${buffer}
	
	# Position the cursor to the top right corner ot the playing field
	tput cup ${top_padding_height} \
		$(($((left_padding_width + grid_width)) - ${#player2_name}))>> ${buffer}
	
	# Print player2's name ($player2_name)
	printf "${player2_name}" >> ${buffer}
	
	# Refresh the screen
	refresh_screen
}

