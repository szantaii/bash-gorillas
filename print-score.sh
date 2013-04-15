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

# Prints the score of the players (overlaps buildings on the screen)
print_score()
{
	local score_text=" ${player1_score}>SCORE<${player2_score} "
	
	# Position the cursor into the third row from the bottom of the screen,
	# and center with length of $score_text taken into account
	tput cup $(($((top_padding_height + grid_height)) - 2)) \
		$((left_padding_width + $((grid_width / 2)) - $((${#score_text} / 2)))) >> ${buffer}
	
	# Print the score
	printf "${score_text}" >> ${buffer}
	
	# Refresh the screen
	refresh_screen
}

