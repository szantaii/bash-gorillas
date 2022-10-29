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

print_frame_stage1()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf '*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    ' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 0))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf '    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 2))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage2()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf ' *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *   ' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 1))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf '   *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    * ' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 1))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage3()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf '  *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *  ' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 2))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf '  *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *  ' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 0))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage4()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf '   *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    * ' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 0))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf ' *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *   ' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 2))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}

print_frame_stage5()
{
    # Top rule
    tput cup "${top_padding_height}" "${left_padding_width}" >> "${buffer}"
    printf '    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *' >> "${buffer}"

    # Right rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                                         \
            $((top_padding_height + i + 1))              \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if (((i % 3) == 1))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    tput cup                                          \
        $((top_padding_height + min_term_height - 5)) \
        "${left_padding_width}"                       \
        >> "${buffer}"

    printf '*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    ' >> "${buffer}"

    # Left rule
    for ((i=0; i < (min_term_height - 5); i++))
    do
        tput cup                            \
            $((top_padding_height + i + 1)) \
            "${left_padding_width}"         \
            >> "${buffer}"

        if (((i % 3) == 1))
        then
            printf '*' >> "${buffer}"
        else
            printf ' ' >> "${buffer}"
        fi
    done

    tput cup $((term_height - 1)) $((term_width - 1)) >> "${buffer}"
}
