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

# Sets the first banana frame
# depending which player throws
init_banana()
{
    if ((next_player == 1))
    then
        banana="<"
    else
        banana=">"
    fi
}

# Sets the next banana frame
# depending which player throws
next_banana_frame()
{
    if ((next_player == 1))
    then
        case ${banana} in
            "<")
                banana="^"
                ;;
            "^")
                banana=">"
                ;;
            ">")
                banana="v"
                ;;
            "v")
                banana="<"
                ;;
        esac
    else
        case ${banana} in
            ">")
                banana="^"
                ;;
            "^")
                banana="<"
                ;;
            "<")
                banana="v"
                ;;
            "v")
                banana=">"
                ;;
        esac
    fi
}
