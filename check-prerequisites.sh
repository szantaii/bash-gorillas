#!/bin/bash

# Check availability of necessary programs and minimum terminal size
check_prerequisites()
{
	# Check if 'tput' is available
	which tput > /dev/null
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
	
	# Check if 'bc' is available
	which bc > /dev/null
	if (($? != 0))
	then
		printf "Your system is missing the program 'bc' which is necessary \
for bash-gorillas\nto run. 'bc' can be found in the 'bc' package on most Linux \
distributions.\n"
		exit 2
	fi
	
	# Check if terminal has at least $min_term_width columns and
	# $min_term_height lines
	if ((term_width < min_term_width || term_height < min_term_height))
	then
		printf "bash-gorillas needs a terminal with size of at least \
${min_term_width}x${min_term_height} (${min_term_width} columns, \
${min_term_height} lines).\n"
		exit 3
	fi
}

