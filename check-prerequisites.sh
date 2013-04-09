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

# Check availability of necessary programs and minimum terminal size
check_prerequisites()
{
	# Check if 'tput' command is available
	which tput > /dev/null
	
	# If 'tput' is not available, then print
	# error message and exit with status code '2'
	if (($? != 0))
	then
		printf "Your system is missing the program 'tput' which is necessary \
for bash-gorillas\nto run. 'tput' can be found in the following packages on \
the following distributions:\n    distribution        package\n\
    ---------------------------------\n    Arch Linux          ncurses\n    \
Fedora              ncurses\n    openSUSE            ncurses-utils\n    Ubuntu\
              ncurses-bin\n"
		exit 2
	fi
	
	# Check if 'bc' command is available
	which bc > /dev/null
	
	# If 'bc' is not available, then print
	# error message and exit with status code '2'
	if (($? != 0))
	then
		printf "Your system is missing the program 'bc' which is necessary \
for bash-gorillas\nto run. 'bc' can be found in the 'bc' package on most Linux \
distributions.\n"
		exit 2
	fi
	
	# Check if terminal has at least $min_term_width columns and
	# $min_term_height lines
	#
	# If either terminal width or height is less than
	# $min_term_width and $min_term_height print error message
	# and exit with status code '3'
	if ((term_width < min_term_width || term_height < min_term_height))
	then
		printf "bash-gorillas needs a terminal with size of at least \
${min_term_width}x${min_term_height} (${min_term_width} columns, \
${min_term_height} lines).\n"
		exit 3
	fi
}

