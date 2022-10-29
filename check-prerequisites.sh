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

# Check the availability of necessary programs
check_required_programs()
{
    local required_programs=(
        'bc'
        'cat'
        'mktemp'
        'rm'
        'tput'
    )

    for required_program in "${required_programs[@]}"
    do
        if ! which "${required_program}" > /dev/null 2>&1
        then
            printf '%s\n' "Your system is missing the program '${required_program}' which is necessary for bash-gorillas to run."

            exit 2
        fi
    done
}

check_terminal_size()
{
    if ((term_width < min_term_width || term_height < min_term_height))
    then
        printf '%s\n' "bash-gorillas needs a terminal with size of at least ${min_term_width}x${min_term_height} (${min_term_width} columns, ${min_term_height} rows)."

        exit 3
    fi
}
