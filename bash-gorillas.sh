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

IFS=''

script_name='bash-gorillas'
copyright_text='Copyright (C) 2013, 2025 Istvan Szantai <szantaii@gmail.com>'

term_width=''
term_height=''

min_term_width=80
min_term_height=22

buffer=''

left_padding=''
left_padding_width=''
top_padding=''
top_padding_height=''

building_width=''
max_building_height=''
building_count=''

banana=''

player1_name=''
player2_name=''

player1_score=''
player2_score=''

declare -a player1_coordinates
declare -a player2_coordinates

player1_throw_start_coordinates=''
player2_throw_start_coordinates=''

declare -A player1_throw_animation_frame1
declare -A player1_throw_animation_frame2
declare -A player2_throw_animation_frame1
declare -A player2_throw_animation_frame2

declare -A player1_victory_animation_frame1
declare -A player1_victory_animation_frame2
declare -A player2_victory_animation_frame1
declare -A player2_victory_animation_frame2

player1_building_height=''
player2_building_height=''

player1_throw_angle=''
player2_throw_angle=''

player1_throw_speed=''
player2_throw_speed=''

next_player=''

total_points=''
gravity_value=''
menu_choice=''

max_speed=''
max_wind_value=''
wind_value=''

declare -A grid
grid_width=''
grid_height=''

sun_text=(
    '    |'
    "  \\ _ /"
    '-= (_) =-'
    "  /   \\"
    '    |'
)
sun_text_max_length=9
help_text='Quit: ^C'
angle_text='Angle [0-90]: '

check_required_commands()
{
    local _required_commands=(
        'bc'
        'cat'
        'clear'
        'mktemp'
        'printf'
        'rm'
        'sleep'
        'tput'
        'xargs'
    )

    for _required_command in "${_required_commands[@]}"
    do
        if ! which "${_required_command}" > /dev/null 2>&1
        then
            printf '%s\n' \
                "Your system is missing the program '${_required_command}' which is necessary for ${script_name} to run."

            exit 2
        fi
    done
}

check_terminal_size()
{
    if ((term_width < min_term_width || term_height < min_term_height))
    then
        printf '%s\n' \
            "${script_name} needs a terminal with size of at least ${min_term_width}x${min_term_height} (${min_term_width} columns, ${min_term_height} rows)."

        exit 3
    fi
}

# Create a 'screen buffer' file
create_buffer()
{
    local _buffer_directory='/tmp'
    local _buffer_name_template="${script_name}-buffer-XXXXXXXXXX"

    buffer="$(                              \
        mktemp                              \
            --tmpdir="${_buffer_directory}" \
            "${_buffer_name_template}"      \
        )"
}

# Print the buffer onto the screen then clear the buffer
refresh_screen()
{
    cat "${buffer}"

    printf '%s' '' > "${buffer}"
}

clear_screen()
{
    clear >> "${buffer}"
    refresh_screen
}

# Create screen buffer, install signal handler, clear screen
init_main()
{
    create_buffer

    # Capture Ctrl+C key combination to call the 'quit'
    # function when Ctrl+C key combination is pressed
    trap quit SIGINT

    clear_screen
}

print_frame_stage1()
{
    # Top rule
    {
        tput cup                    \
            "${top_padding_height}" \
            "${left_padding_width}"

        printf '%s' \
            '*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    '
    } >> "${buffer}"

    # Right rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                                         \
            $((top_padding_height + _i + 1))             \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if ((_i % 3 == 0))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    {
        tput cup                                          \
            $((top_padding_height + min_term_height - 5)) \
            "${left_padding_width}"

        printf '%s' \
            '    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *'
    } >> "${buffer}"

    # Left rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                             \
            $((top_padding_height + _i + 1)) \
            "${left_padding_width}"          \
            >> "${buffer}"

        if ((_i % 3 == 2))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    tput cup                 \
        $((term_height - 1)) \
        $((term_width - 1))  \
        >> "${buffer}"
}

print_frame_stage2()
{
    # Top rule
    {
        tput cup                    \
            "${top_padding_height}" \
            "${left_padding_width}"

        printf '%s' \
            ' *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *   '
    }  >> "${buffer}"

    # Right rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                                         \
            $((top_padding_height + _i + 1))             \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if ((_i % 3 == 1))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    {
        tput cup                                          \
            $((top_padding_height + min_term_height - 5)) \
            "${left_padding_width}"

        printf '%s' \
            '   *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    * '
    } >> "${buffer}"

    # Left rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                             \
            $((top_padding_height + _i + 1)) \
            "${left_padding_width}"          \
            >> "${buffer}"

        if ((_i % 3 == 1))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    tput cup                 \
        $((term_height - 1)) \
        $((term_width - 1))  \
        >> "${buffer}"
}

print_frame_stage3()
{
    # Top rule
    {
        tput cup                    \
            "${top_padding_height}" \
            "${left_padding_width}"

        printf '%s' \
            '  *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *  '
    } >> "${buffer}"

    # Right rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                                         \
            $((top_padding_height + _i + 1))             \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if ((_i % 3 == 2))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    {
        tput cup                                          \
            $((top_padding_height + min_term_height - 5)) \
            "${left_padding_width}"

        printf '%s' \
            '  *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *  '
    } >> "${buffer}"

    # Left rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                             \
            $((top_padding_height + _i + 1)) \
            "${left_padding_width}"          \
            >> "${buffer}"

        if ((_i % 3 == 0))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    tput cup                 \
        $((term_height - 1)) \
        $((term_width - 1))  \
        >> "${buffer}"
}

print_frame_stage4()
{
    # Top rule
    {
        tput cup                    \
            "${top_padding_height}" \
            "${left_padding_width}"

        printf '%s' \
            '   *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    * '
    } >> "${buffer}"

    # Right rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                                         \
            $((top_padding_height + _i + 1))             \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if ((_i % 3 == 0))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    {
        tput cup                                          \
            $((top_padding_height + min_term_height - 5)) \
            "${left_padding_width}"

        printf '%s' \
            ' *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *   '
    } >> "${buffer}"

    # Left rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                             \
            $((top_padding_height + _i + 1)) \
            "${left_padding_width}"          \
            >> "${buffer}"

        if ((_i % 3 == 2))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    tput cup                 \
        $((term_height - 1)) \
        $((term_width - 1))  \
        >> "${buffer}"
}

print_frame_stage5()
{
    # Top rule
    {
        tput cup                    \
            "${top_padding_height}" \
            "${left_padding_width}"

        printf '%s' \
            '    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *'
    } >> "${buffer}"

    # Right rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                                         \
            $((top_padding_height + _i + 1))             \
            $((left_padding_width + min_term_width - 1)) \
            >> "${buffer}"

        if ((_i % 3 == 1))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    # Bottom rule
    {
        tput cup                                          \
            $((top_padding_height + min_term_height - 5)) \
            "${left_padding_width}"

        printf '%s' \
            '*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    '
    } >> "${buffer}"

    # Left rule
    for ((_i=0; _i < min_term_height - 5; _i++))
    do
        tput cup                             \
            $((top_padding_height + _i + 1)) \
            "${left_padding_width}"          \
            >> "${buffer}"

        if ((_i % 3 == 1))
        then
            printf '%s' '*' >> "${buffer}"
        else
            printf '%s' ' ' >> "${buffer}"
        fi
    done

    tput cup                 \
        $((term_height - 1)) \
        $((term_width - 1))  \
        >> "${buffer}"
}

# Read a key from keyboard
read_intro_outro_continue_key()
{
    read -r -sn1 -t0.01

    return $?
}

# Print animated frames and intro text to the screen
play_intro()
{
    local _intro_lines=()

    for ((i=0; i < left_padding_width; i++))
    do
        left_padding="${left_padding} "
    done

    for ((i=0; i < top_padding_height; i++))
    do
        top_padding="${top_padding}\n"
    done

    _intro_lines=(
        ''
        ''
        "${top_padding}${left_padding}                           B a s h   G O R I L L A S"
        ''
        ''
        "${left_padding}         ${copyright_text}"
        ''
        ''
        "${left_padding}     This game is a demake of QBasic GORILLAS rewritten completely in Bash."
        ''
        ''
        "${left_padding}             Your mission is to hit your opponent with the exploding"
        "${left_padding}           banana by varying the angle and power of your throw, taking"
        "${left_padding}             into account wind speed, gravity, and the city skyline."
        "${left_padding}           The wind speed is show by a directional arrow at the bottom"
        "${left_padding}            of the playing field, its length relative to its strength."
        ''
        ''
        ''
        ''
        ''
        "${left_padding}                            Press any key to continue"
    )

    # Print intro into the screen buffer
    for _intro_line in "${_intro_lines[@]}"
    do
        printf '%b\n' "${_intro_line}" >> "${buffer}"
    done

    # Play animation, exit from loop when a key was pressed
    for ((;;))
    do
        print_frame_stage1
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage2
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage3
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage4
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage5
        refresh_screen
        read_intro_outro_continue_key && break
    done

    clear_screen
}

# Cleanup and exit
quit()
{
    rm -f "${buffer}"

    # Restore terminal screen
    tput rmcup

    exit 0
}

prompt_player1_name()
{
    {
        tput cup                        \
            $((top_padding_height + 4)) \
            $((left_padding_width + 15))

        printf '%s' \
            'Name of Player 1 (Default = '"'"'Player 1'"'"'): '
    } >> "${buffer}"
}

prompt_player2_name()
{
    {
        tput cup                        \
            $((top_padding_height + 6)) \
            $((left_padding_width + 15))

        printf '%s' \
            'Name of Player 2 (Default = '"'"'Player 2'"'"'): '
    } >> "${buffer}"
}

prompt_max_points_num()
{
    {
    tput cup                        \
        $((top_padding_height + 8)) \
        $((left_padding_width + 17))

    printf '%s' \
        'Play to how many total points (Default = 3)? '
    } >> "${buffer}"
}

prompt_gravity_value()
{
    {
        tput cup                         \
            $((top_padding_height + 10)) \
            $((left_padding_width + 20))

        printf '%s' \
            'Gravity in Meters/Sec^2 (Earth = ~10)? '
    } >> "${buffer}"
}

prompt_menu_choice()
{
    {
        tput cup                         \
            $((top_padding_height + 12)) \
            $((left_padding_width + 34))

        printf '%s' '-------------'

        tput cup                         \
            $((top_padding_height + 14)) \
            $((left_padding_width + 34))

        printf '%s' 'P = Play Game'

        tput cup                         \
            $((top_padding_height + 15)) \
            $((left_padding_width + 37))

        printf '%s' 'Q = Quit'

        tput cup                         \
            $((top_padding_height + 17)) \
            $((left_padding_width + 35))

        printf '%s' 'Your Choice?'
    } >> "${buffer}"
}

read_player1_name()
{
    local _player1_tmp_name=''

    read -r -n10 player1_name

    _player1_tmp_name="${player1_name/ /}"

    if [[ "${_player1_tmp_name}" == '' ]]
    then
        player1_name='Player 1'
    fi
}

read_player2_name()
{
    local _player2_tmp_name

    read -r -n10 player2_name

    _player2_tmp_name="${player2_name/ /}"

    if [[ "${_player2_tmp_name}" == '' ]]
    then
        player2_name='Player 2'
    fi
}

read_total_points()
{
    read -r -n2 total_points

    case ${total_points} in
        ''|*[!0-9]*)
            total_points=3
            ;;
    esac
}

read_gravity_value()
{
    read -r -n3 gravity_value

    case ${gravity_value} in
        ''|*[!0-9]*)
            gravity_value=10
            ;;
    esac
}

read_menu_choice()
{
    while [[ "${menu_choice}" != 'p' \
        && "${menu_choice}" != 'P' \
        && "${menu_choice}" != 'q' \
        && "${menu_choice}" != 'Q' ]]
    do
        read -r -sn1 menu_choice

        case "${menu_choice}" in
            'p'|'P')
                ;;
            'q'|'Q')
                quit
                ;;
        esac
    done
}

read_player_data()
{
    prompt_player1_name
    refresh_screen
    read_player1_name

    prompt_player2_name
    refresh_screen
    read_player2_name

    prompt_max_points_num
    refresh_screen
    read_total_points

    prompt_gravity_value
    refresh_screen
    read_gravity_value

    prompt_menu_choice
    refresh_screen
    read_menu_choice

    clear_screen
}

# Generate buildings into $grid
generate_buildings()
{
    local _current_building_height

    # Set the height of the buildings which players stand on
    player1_building_height=$((RANDOM % max_building_height))
    player2_building_height=$((RANDOM % max_building_height))

    if ((building_count < 16))
    then
        # Create the bulding which player1 stands on (the second building from
        # the left edge of the screen)
        for ((_i=building_width; _i < 2 * building_width; _i++))
        do
            for ((_j=0; _j < player1_building_height; _j++))
            do
                grid["${_i},${_j}"]='X'
            done
        done

        # Create the bulding which player2 stands on (the second building from
        # the right edge of the screen)
        for ((_i=grid_width - (2 * building_width); _i < grid_width - building_width; _i++))
        do
            for ((_j=0; _j < player2_building_height; _j++))
            do
                grid["${_i},${_j}"]='X'
            done
        done

        # Create all the other buildings
        for ((_i=0; _i < building_count; _i++))
        do
            _current_building_height=$((RANDOM % max_building_height))

            if ((_i != 1 && _i != building_count - 2))
            then
                for ((_j=0; _j < building_width; _j++))
                do
                    for ((_k=0; _k < _current_building_height; _k++))
                    do
                        grid["$(((_i * building_width) + _j)),${_k}"]='X'
                    done
                done
            fi
        done
    else
        # Create the bulding which player1 stands on (the third building from
        # the left edge of the screen)
        for ((_i=building_width * 2; _i < building_width * 3; _i++))
        do
            for ((_j=0; _j < player1_building_height; _j++))
            do
                grid["${_i},${_j}"]='X'
            done
        done

        # Create the bulding which player2 stands on
        # (the third building from the right edge of the screen)
        for ((_i=grid_width - (3 * building_width); _i < grid_width - (2 * building_width); _i++))
        do
            for ((_j=0; _j < player2_building_height; _j++))
            do
                grid["${_i},${_j}"]='X'
            done
        done

        # Create all the other buildings
        for ((_i=0; _i < building_count; _i++))
        do
            # Always set a random value for the actually generated building
            _current_building_height=$((RANDOM % max_building_height))

            if ((_i != 2 && _i != building_count - 3))
            then
                for ((_j=0; _j < building_width; _j++))
                do
                    for ((_k=0; _k < _current_building_height; _k++))
                    do
                        grid["$(((_i * building_width) + _j)),${_k}"]='X'
                    done
                done
            fi
        done
    fi
}

init_players()
{
    local _i
    local _j

    # Init player1 START -------------------------------------------------------
    _j="${#player1_coordinates[@]}"
    for ((_i=0; _i < _j; _i++))
    do
        unset 'player1_coordinates[${_i}]'
    done

    for _key in "${!player1_throw_animation_frame1[@]}"
    do
        unset 'player1_throw_animation_frame1["${_key}"]'
    done

    for _key in "${!player1_throw_animation_frame2[@]}"
    do
        unset 'player1_throw_animation_frame2["${_key}"]'
    done

    for _key in "${!player1_victory_animation_frame1[@]}"
    do
        unset 'player1_victory_animation_frame1["${_key}"]'
    done

    for _key in "${!player1_victory_animation_frame2[@]}"
    do
        unset 'player1_victory_animation_frame2["${_key}"]'
    done

    # Set the initial horizontal coordinate of player1 depending
    # of the number of buildings on the playing field
    if ((building_count < 16))
    then
        _i=$((building_width + ((building_width - 3) / 2)))
    else
        _i=$(((building_width * 2) + ((building_width - 3) / 2)))
    fi
    # Set the initial vertical coordinate of player1
    _j="${player1_building_height}"
    # Left leg of player1
    grid["${_i},${_j}"]='/'

    player1_coordinates=("${player1_coordinates[@]}" "${_i},${_j}")

    # Right leg of player1
    _i=$((_i + 2))
    grid["${_i},${_j}"]="\\"

    player1_coordinates=("${player1_coordinates[@]}" "${_i},${_j}")

    # Left arm of player1
    _i=$((_i - 2))
    _j=$((_j + 1))
    grid["${_i},${_j}"]='('

    # Set animation frames for player1 banana throw and victory dance
    player1_throw_animation_frame1["${_i},${_j}"]=' '
    player1_throw_animation_frame2["${_i},${_j}"]='('

    player1_coordinates=("${player1_coordinates[@]}" "${_i},${_j}")

    # Belly of player1
    _i=$((_i + 1))
    grid["${_i},${_j}"]='G'

    player1_coordinates=("${player1_coordinates[@]}" "${_i},${_j}")

    # Right arm of player1
    _i=$((_i + 1))
    grid["${_i},${_j}"]=')'

    # Set animation frames for player1 victory dance
    player1_victory_animation_frame1["${_i},${_j}"]=')'
    player1_victory_animation_frame2["${_i},${_j}"]=' '

    player1_coordinates=("${player1_coordinates[@]}" "${_i},${_j}")

    # Head of player1
    _i=$((_i - 1))
    _j=$((_j + 1))
    grid["${_i},${_j}"]='o'

    # Set animation frames for player1 banana throw and victory dance
    player1_throw_animation_frame1["$((_i - 1)),${_j}"]='('
    player1_throw_animation_frame2["$((_i - 1)),${_j}"]=' '
    player1_victory_animation_frame1["$((_i + 1)),${_j}"]=' '
    player1_victory_animation_frame2["$((_i + 1)),${_j}"]=')'

    player1_coordinates=("${player1_coordinates[@]}" "${_i},${_j}")

    # Set the banana throw position for player1
    player1_throw_start_coordinates="${_i},$((_j + 2))"
    # Init player1 END ---------------------------------------------------------

    # Init player2 START -------------------------------------------------------
    _j="${#player2_coordinates[@]}"
    for ((_i=0; _i < _j; _i++))
    do
        unset 'player2_coordinates[${_i}]'
    done

    for _key in "${!player2_throw_animation_frame1[@]}"
    do
        unset 'player2_throw_animation_frame1["${_key}"]'
    done

    for _key in "${!player2_throw_animation_frame2[@]}"
    do
        unset 'player2_throw_animation_frame2["${_key}"]'
    done

    for _key in "${!player2_victory_animation_frame1[@]}"
    do
        unset 'player2_victory_animation_frame1["${_key}"]'
    done

    for _key in "${!player2_victory_animation_frame2[@]}"
    do
        unset 'player2_victory_animation_frame2["${_key}"]'
    done

    # Set the initial horizontal coordinate of player2 depending
    # of the number of buildings on the playing field
    if ((building_count < 16))
    then
        _i=$((grid_width - (2 * building_width)))
        _i=$((_i + ((building_width - 3) / 2)))
    else
        _i=$((grid_width - (3 * building_width)))
        _i=$((_i + ((building_width - 3) / 2)))
    fi

    # Set the initial vertical coordinate of player1
    _j="${player2_building_height}"

    # Left leg of player2
    grid["${_i},${_j}"]='/'

    player2_coordinates=("${player2_coordinates[@]}" "${_i},${_j}")

    # Right leg of player2
    _i=$((_i + 2))
    grid["${_i},${_j}"]="\\"

    player2_coordinates=("${player2_coordinates[@]}" "${_i},${_j}")

    # Left arm of player2
    _i=$((_i - 2))
    _j=$((_j + 1))
    grid["${_i},${_j}"]='('

    # Set animation frames for player2 banana throw and victory dance
    player2_victory_animation_frame1["${_i},${_j}"]='('
    player2_victory_animation_frame2["${_i},${_j}"]=' '

    player2_coordinates=("${player2_coordinates[@]}" "${_i},${_j}")

    # Belly of player2
    _i=$((_i + 1))
    grid["${_i},${_j}"]='G'

    player2_coordinates=("${player2_coordinates[@]}" "${_i},${_j}")

    # Right arm of player2
    _i=$((_i + 1))
    grid["${_i},${_j}"]=')'
    player2_throw_animation_frame1["${_i},${_j}"]=' '
    player2_throw_animation_frame2["${_i},${_j}"]=')'

    player2_coordinates=("${player2_coordinates[@]}" "${_i},${_j}")

    # Head of player2
    _i=$((_i - 1))
    _j=$((_j + 1))
    grid["${_i},${_j}"]='o'

    # Set animation frames for player2 banana throw and victory dance
    player2_throw_animation_frame1["$((_i + 1)),${_j}"]=')'
    player2_throw_animation_frame2["$((_i + 1)),${_j}"]=' '
    player2_victory_animation_frame1["$((_i - 1)),${_j}"]=' '
    player2_victory_animation_frame2["$((_i - 1)),${_j}"]='('

    player2_coordinates=("${player2_coordinates[@]}" "${_i},${_j}")

    # Set the banana throw position for player2
    player2_throw_start_coordinates="${_i},$((_j + 2))"
    # Init player2 END ---------------------------------------------------------
}

# Initialize variables for a new game/round
init_game()
{
    # Init player scores on new game
    if [[ "${player1_score}" == '' && "${player2_score}" == '' ]]
    then
        player1_score=0
        player2_score=0
    fi

    # Set first player randomly on new game
    if [[ "${next_player}" == '' ]]
    then
        next_player=$(((RANDOM % 2) + 1))
    fi

    if [[ "${max_speed}" == '' ]]
    then
        max_speed=100
    fi

    if [[ "${max_wind_value}" == '' ]]
    then
        max_wind_value=6
    fi

    wind_value=$((RANDOM % max_wind_value))
    if ((wind_value != 0 && (RANDOM % 2) != 0))
    then
        wind_value="-${wind_value}"
    fi

    tput cup 0 0 >> "${buffer}"

    if ((player1_score == 0 && player2_score == 0))
    then
        printf '%s' 'Starting new game...' >> "${buffer}"
    else
        printf '%s' 'Starting new round...' >> "${buffer}"
    fi

    refresh_screen

    building_width=8

    # Set the maxmum height of buildings to three fourth of the height
    # of the terminal
    max_building_height=$(((term_height * 3) / 4))

    grid_width=$(((term_width / building_width) * building_width))
    grid_height=$((term_height - 1))

    building_count=$((grid_width / building_width))

    left_padding=''
    top_padding=''

    # Set $left_padding_width for centering the playing field on the screen,
    # and set $top_padding_height to '0' since the game uses the whole
    # terminal in height
    left_padding_width=$(((term_width % building_width) / 2))
    top_padding_height=0

    # Initialize $grid
    for ((i=0; i < grid_width; i++))
    do
        for ((j=0; j < grid_height; j++))
        do
            grid["${i},${j}"]=''
        done
    done

    generate_buildings

    init_players
}

# Print the Sun to the top center of the screen
print_sun()
{
    for ((_i=0; _i < ${#sun_text[@]}; _i++))
    do
        {
            # Position the cursor to the top of the screen + i lines
            # and horizontally center of the screen minus the width
            # of the ASCII Sun
            tput cup                         \
                $((top_padding_height + _i)) \
                $((left_padding_width + (grid_width / 2) - (sun_text_max_length / 2)))

            printf '%s' "${sun_text[${_i}]}"
        } >> "${buffer}"
    done

    refresh_screen
}

# Print the wind indicator arrow to the bottom row of the screen
print_wind()
{
    {
        # Center the cursor in the bottom row of the screen
        tput cup             \
            "${grid_height}" \
            $((left_padding_width + (grid_width / 2)))

        printf '%s' '|'
    } >> "${buffer}"

    # Print wind indicator arrow if $wind_value is not zero
    if ((wind_value != 0))
    then
        if ((wind_value < 0))
        then
            # Wind blows to the left ($wind_value is negative)
            {
                tput cup             \
                    "${grid_height}" \
                    $((left_padding_width + (grid_width / 2) + wind_value - 1))

                printf '%s' '<'
            } >> "${buffer}"

            # Print arrow with the length of $wind_value
            for ((_i=wind_value; _i < 0; _i++))
            do
                printf '%s' '-' >> "${buffer}"
            done
        else
            # Wind blows to the right ($wind_value is positive)
            for ((_i=0; _i < wind_value; _i++))
            do
                printf '%s' '-' >> "${buffer}"
            done

            printf '%s' '>' >> "${buffer}"
        fi
    fi

    refresh_screen
}

# Print the name of the players to the top left and right corners of the screen
print_player_names()
{
    {
        # Position the cursor to the top left corner of the playing field
        tput cup                    \
            "${top_padding_height}" \
            "${left_padding_width}"

        printf '%s' "${player1_name}"

        # Position the cursor to the top right corner of the playing field
        tput cup                    \
            "${top_padding_height}" \
            $((left_padding_width + grid_width - ${#player2_name}))

        printf '%s' "${player2_name}"
    } >> "${buffer}"

    refresh_screen
}

# Clear the player names from the top left and right corners of the screen
clear_player_names()
{
    # Position the cursor to the top left corner of the playing field
    tput cup                    \
        "${top_padding_height}" \
        "${left_padding_width}" \
        >> "${buffer}"

    for ((i=0; i < ${#player1_name}; i++))
    do
        printf '%s' ' ' >> "${buffer}"
    done

    # Position the cursor to the top right corner of the playing field right
    # before player2's name
    tput cup                                                    \
        "${top_padding_height}"                                 \
        $((left_padding_width + grid_width - ${#player2_name})) \
        >> "${buffer}"

    for ((i=0; i < ${#player2_name}; i++))
    do
        printf '%s' ' ' >> "${buffer}"
    done

    refresh_screen
}

# Print the score of the players (overlaps buildings on the screen)
print_score()
{
    local _score_text=" ${player1_score}>SCORE<${player2_score} "

    {
        # Position the cursor into the third row from the bottom of the screen,
        # and center with length of $_score_text taken into account
        tput cup                                      \
            $((top_padding_height + grid_height - 2)) \
            $((left_padding_width + (grid_width / 2) - (${#_score_text} / 2)))

        printf '%s' "${_score_text}"
    } >> "${buffer}"

    refresh_screen
}

# Print the contents of 'grid' into the screen buffer, then refresh the screen
print_scene()
{
    clear >> "${buffer}"

    for((_i=0; _i < grid_width; _i++))
    do
        for ((_j=0; _j < grid_height; _j++))
        do
            {
                tput cup                                           \
                    $((top_padding_height + grid_height - _j - 1)) \
                    $((left_padding_width + _i))

                printf '%s' "${grid["${_i},${_j}"]}"
            } >> "${buffer}"
        done
    done

    refresh_screen
}

# Print a small help how to quit the game into the right bottom part
# of the screen
print_help()
{
    {
        # Position the cursor to the bottom row of the screen,
        # and to the right side of the $grid
        tput cup             \
            "${grid_height}" \
            $((left_padding_width + grid_width - ${#help_text}))

        printf '%s' "${help_text}"
    } >> "${buffer}"

    refresh_screen
}

prompt_player1_throw_angle()
{
    {
        tput cup                        \
            $((top_padding_height + 1)) \
            "${left_padding_width}"

        printf '%s' "${angle_text}"
    } >> "${buffer}"

    refresh_screen
}

prompt_player2_throw_angle()
{
    {
        tput cup                        \
            $((top_padding_height + 1)) \
            $((left_padding_width + grid_width - (${#angle_text} + 2)))

        printf '%s' "${angle_text}"
    } >> "${buffer}"

    refresh_screen
}

prompt_player1_throw_speed()
{
    local _speed_text="Velocity [0-${max_speed}]: "

    {
        tput cup                        \
            $((top_padding_height + 2)) \
            "${left_padding_width}"

        printf '%s' "${_speed_text}"
    } >> "${buffer}"

    refresh_screen
}

prompt_player2_throw_speed()
{
    local _speed_text="Velocity [0-${max_speed}]: "

    {
        tput cup                        \
            $((top_padding_height + 2)) \
            $((left_padding_width + grid_width - (${#_speed_text} + ${#max_speed})))

        printf '%s' "${_speed_text}"
    } >> "${buffer}"

    refresh_screen
}

print_player1_correct_throw_angle()
{
    {
        tput cup                        \
            $((top_padding_height + 1)) \
            $((left_padding_width + 14))

        printf '%s' '  '

        tput cup                        \
            $((top_padding_height + 1)) \
            $((left_padding_width + 14))

        printf '%s' "${player1_throw_angle}"
    } >> "${buffer}"

    refresh_screen
}

print_player2_correct_throw_angle()
{
    {
        tput cup                        \
            $((top_padding_height + 1)) \
            $((left_padding_width + grid_width - 2))

        printf '%s' '  '

        tput cup                        \
            $((top_padding_height + 1)) \
            $((left_padding_width + grid_width - 2))

        printf '%s' "${player2_throw_angle}"
    } >> "${buffer}"

    refresh_screen
}

print_player1_correct_throw_speed()
{
    tput cup                                         \
        $((top_padding_height + 2))                  \
        $((left_padding_width + 15 + ${#max_speed})) \
        >> "${buffer}"

    for ((i=0; i < ${#max_speed}; i++))
    do
        printf '%s' ' ' >> "${buffer}"
    done

    {
        tput cup                        \
            $((top_padding_height + 2)) \
            $((left_padding_width + 15 + ${#max_speed}))

        printf '%s' "${player1_throw_speed}"
    } >> "${buffer}"

    refresh_screen
}

print_player2_correct_throw_speed()
{
    tput cup                                                 \
        $((top_padding_height + 2))                          \
        $((left_padding_width + grid_width - ${#max_speed})) \
        >> "${buffer}"

    for ((i=0; i < ${#max_speed}; i++))
    do
        printf '%s' ' ' >> "${buffer}"
    done
    {
        tput cup                        \
            $((top_padding_height + 2)) \
            $((left_padding_width + grid_width - ${#max_speed}))

        printf '%s' "${player2_throw_speed}"
    } >> "${buffer}"

    refresh_screen
}

read_player1_throw_angle()
{
    read -r -n2 player1_throw_angle

    case ${player1_throw_angle} in
        ''|*[!0-9]*)
            player1_throw_angle=0
            print_player1_correct_throw_angle
            ;;
        *)
            if ((player1_throw_angle > 90))
            then
                player1_throw_angle=90
                print_player1_correct_throw_angle
            fi
            ;;
    esac
}

read_player2_throw_angle()
{
    read -r -n2 player2_throw_angle

    case ${player2_throw_angle} in
        ''|*[!0-9]*)
            player2_throw_angle=0
            print_player2_correct_throw_angle
            ;;
        *)
            if ((player2_throw_angle > 90))
            then
                player2_throw_angle=90
                print_player2_correct_throw_angle
            fi
            ;;
    esac
}

read_player1_throw_speed()
{
    read -r -n3 player1_throw_speed

    case ${player1_throw_speed} in
        ''|*[!0-9]*)
            player1_throw_speed=0
            print_player1_correct_throw_speed
            ;;
        *)
            if ((player1_throw_speed > max_speed))
            then
                player1_throw_speed="${max_speed}"
                print_player1_correct_throw_speed
            fi
            ;;
    esac
}

read_player2_throw_speed()
{
    read -r -n3 player2_throw_speed

    case ${player2_throw_speed} in
        ''|*[!0-9]*)
            player2_throw_speed=0
            print_player2_correct_throw_speed
            ;;
        *)
            if ((player2_throw_speed > max_speed))
            then
                player2_throw_speed="${max_speed}"
                print_player2_correct_throw_speed
            fi
            ;;
    esac
}

clear_player1_throw_angle()
{
    {
        tput cup                        \
            $((top_padding_height + 1)) \
            "${left_padding_width}"

        printf '%s' '                '
    } >> "${buffer}"

    refresh_screen
}

clear_player2_throw_angle()
{
    {
        tput cup                        \
            $((top_padding_height + 1)) \
            $((left_padding_width + grid_width - 16))

        printf '%s' '                '
    } >> "${buffer}"

    refresh_screen
}

clear_player1_throw_speed()
{
    {
        tput cup                        \
            $((top_padding_height + 2)) \
            "${left_padding_width}"

        printf '%s' '               '
    } >> "${buffer}"

    for ((i=0; i < 2 * ${#max_speed}; i++))
    do
        printf '%s' ' ' >> "${buffer}"
    done

    refresh_screen
}

clear_player2_throw_speed()
{
    {
        tput cup                        \
            $((top_padding_height + 2)) \
            $((left_padding_width + grid_width - 15 - (2 * ${#max_speed})))

        printf '%s' '               '
    } >> "${buffer}"

    for ((i=0; i < 2 * ${#max_speed}; i++))
    do
        printf '%s' ' ' >> "${buffer}"
    done

    refresh_screen
}

read_throw_data()
{
    if ((next_player == 1))
    then
        prompt_player1_throw_angle
        read_player1_throw_angle

        prompt_player1_throw_speed
        read_player1_throw_speed

        clear_player1_throw_angle
        clear_player1_throw_speed
    else
        prompt_player2_throw_angle
        read_player2_throw_angle

        prompt_player2_throw_speed
        read_player2_throw_speed

        clear_player2_throw_angle
        clear_player2_throw_speed
    fi
}

print_player1_throw_frame1()
{
    local _i
    local _j

    for _key in "${!player1_throw_animation_frame1[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' "${player1_throw_animation_frame1["${_key}"]}"
        } >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player1_throw_frame2()
{
    local _i
    local _j

    for _key in "${!player1_throw_animation_frame2[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' "${player1_throw_animation_frame2["${_key}"]}"
        } >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player2_throw_frame1()
{
    local _i
    local _j

    for _key in "${!player2_throw_animation_frame1[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' "${player2_throw_animation_frame1["${_key}"]}"
        } >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player2_throw_frame2()
{
    local _i
    local _j

    for _key in "${!player2_throw_animation_frame2[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' "${player2_throw_animation_frame2["${_key}"]}"
        } >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player1_victory_frame1()
{
    local _i
    local _j

    for _key in "${!player1_victory_animation_frame1[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' "${player1_victory_animation_frame1["${_key}"]}"
        } >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player1_victory_frame2()
{
    local _i
    local _j

    for _key in "${!player1_victory_animation_frame2[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' "${player1_victory_animation_frame2["${_key}"]}"
        } >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player2_victory_frame1()
{
    local _i
    local _j

    for _key in "${!player2_victory_animation_frame1[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' "${player2_victory_animation_frame1["${_key}"]}"
        } >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player2_victory_frame2()
{
    local _i
    local _j

    for _key in "${!player2_victory_animation_frame2[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' "${player2_victory_animation_frame2["${_key}"]}"
        } >> "${buffer}"
    done

    refresh_screen

    sleep 0.1
}

print_player_victory_dance()
{
    if ((next_player == 1))
    then
        for ((k=0; k < 5; k++))
        do
            print_player2_throw_frame2
            sleep 0.3
            print_player2_throw_frame1
            print_player2_victory_frame1
            sleep 0.3
            print_player2_victory_frame2
        done
    else
        for ((k=0; k < 5; k++))
        do
            print_player1_throw_frame2
            sleep 0.3
            print_player1_throw_frame1
            print_player1_victory_frame1
            sleep 0.3
            print_player1_victory_frame2
        done
    fi
}

clear_player1()
{
    local _i
    local _j

    for _key in "${player1_coordinates[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' ' '
        } >> "${buffer}"
    done

    refresh_screen
}

clear_player2()
{
    local _i
    local _j

    for _key in "${player2_coordinates[@]}"
    do
        _i="${_key%","*}"
        _j="${_key#*","}"

        {
            tput cup                                           \
                $((top_padding_height + grid_height - _j - 1)) \
                $((left_padding_width + _i))

            printf '%s' ' '
        } >> "${buffer}"
    done

    refresh_screen
}

# Set the first banana frame
init_banana_frame()
{
    if ((next_player == 1))
    then
        banana='<'
    else
        banana='>'
    fi
}

# Set the next banana frame
next_banana_frame()
{
    if ((next_player == 1))
    then
        case "${banana}" in
            '<')
                banana='^'
                ;;
            '^')
                banana='>'
                ;;
            '>')
                banana='v'
                ;;
            'v')
                banana='<'
                ;;
        esac
    else
        case "${banana}" in
            '>')
                banana='^'
                ;;
            '^')
                banana='<'
                ;;
            '<')
                banana='v'
                ;;
            'v')
                banana='>'
                ;;
        esac
    fi
}

# Switch to the other player
switch_player()
{
    if ((next_player == 1))
    then
        next_player=2
    else
        next_player=1
    fi
}

# This fuction is responsible for banana throwing, including physics,
# animation, etc.
throw_banana()
{
    local _pi
    local _x
    local _y
    local _x_0
    local _y_0
    local _prev_x
    local _prev_y
    local _throw_angle
    local _throw_speed

    _pi="$(                                \
        printf '%s\n' 'scale=20; 4 * a(1)' \
        | bc -l                            \
    )"

    init_banana_frame

    # Set $_throw_angle, $_throw_speed, banana throw start positions, etc.
    # based on read values and current player
    if ((next_player == 1))
    then
        # Convert degrees to radians
        _throw_angle="$(                                                    \
            printf '%s\n' "scale=20; ${player1_throw_angle} * ${_pi} / 180" \
            | bc -l                                                         \
        )"

        # Set $_throw_speed of player1
        _throw_speed="${player1_throw_speed}"

        # Set throw start coordinates of player1
        _x="${player1_throw_start_coordinates%","*}"
        _y="${player1_throw_start_coordinates#*","}"
        _x_0="${_x}"
        _y_0="${_y}"

        # Start player1 throw animation
        print_player1_throw_frame1
    else
        # Set correct angle for player2, and convert degrees to radians
        _throw_angle=$((180 - player2_throw_angle))
        _throw_angle="$(                                             \
            printf '%s\n' "scale=20; ${_throw_angle} * ${_pi} / 180" \
            | bc -l                                                  \
        )"

        # Set $_throw_speed of player2
        _throw_speed="${player2_throw_speed}"

        # Set throw start coordinates of player2
        _x="${player2_throw_start_coordinates%","*}"
        _y="${player2_throw_start_coordinates#*","}"
        _x_0="${_x}"
        _y_0="${_y}"

        # Start player2 throw animation
        print_player2_throw_frame1
    fi

    # Print first banana frame to the screen
    {
        tput cup                                       \
            $((top_padding_height + grid_height - _y)) \
            $((left_padding_width + _x))

        printf '%s' "${banana}"
    } >> "${buffer}"

    refresh_screen

    # Print player throw animation ending to the screen depending who is the
    # current throwing player
    if ((next_player == 1))
    then
        print_player1_throw_frame2
    else
        print_player2_throw_frame2
    fi

    # Banana throw loop
    for ((_t=0; _x >= 0 && _x < grid_width && _y >= 1 && _y <= grid_height * 5; ))
    do
        # Clear previous banana frame from screen, if there was a banana
        # printed to the screen in the previous iteration
        if [[ "${_prev_x}" != '' && "${_prev_y}" != '' ]] \
            && ((_x >= 0 && _x < grid_width && _y >= 1 && _y <= grid_height))
        then
            {
                tput cup                                       \
                    $((top_padding_height + grid_height - _y)) \
                    $((left_padding_width + _x))

                printf '%s' ' '
            } >> "${buffer}"

            refresh_screen
        fi

        # Calculate next horizontal ($_x) and vertical ($_y) position
        # of the banana
        _x="$(                                                                                                             \
            printf '%s\n'                                                                                                  \
                    "scale=20; ${_x_0} + (${_throw_speed} * ${_t} * c(${_throw_angle}) + (${wind_value} * ${_t} * ${_t}))" \
                | bc -l                                                                                                    \
                | xargs printf '%1.0f\n'                                                                                   \
        )"
        _y="$(                                                                                                                        \
            printf '%s\n'                                                                                                             \
                    "scale=20; ${_y_0} + (${_throw_speed} * ${_t} * s(${_throw_angle}) - (2 * ${gravity_value} / 2) * ${_t} * ${_t})" \
                | bc -l                                                                                                               \
                | xargs printf '%1.0f\n'                                                                                              \
        )"

        # Collision detection START --------------------------------------------
        # If the banana hits a building the building block will be erased
        # and then comes the next player
        if [[ "${grid["${_x},$((_y - 1))"]}" == 'X' ]]
        then
            # Erase block from 'grid'
            grid["${_x},$((_y - 1))"]=''

            # Erase block from screen
            {
                tput cup                                       \
                    $((top_padding_height + grid_height - _y)) \
                    $((left_padding_width + _x))

                printf '%s' ' '
            } >> "${buffer}"

            refresh_screen

            break
        fi

        # Banana hits player: check the current player, and increase score
        # of the player who was not hit, clear the player who was hit from
        # the screen, and set $next_player to the player who was hit
        for ((_i=0; _i < ${#player1_coordinates[@]}; _i++))
        do
            if [[ "${player1_coordinates[${_i}]}" == "${_x},$((_y - 1))" ]]
            then
                clear_player1
                player2_score=$((player2_score + 1))

                if ((next_player == 2))
                then
                    switch_player
                fi

                return 1

            elif [[ "${player2_coordinates[${_i}]}" == "${_x},$((_y - 1))" ]]
            then
                clear_player2
                player1_score=$((player1_score + 1))

                if ((next_player == 1))
                then
                    switch_player
                fi

                return 1
            fi
        done

        # Change banana character only if cursor is moved to another place
        if ((_prev_x != _x || _prev_y != _y))
        then
            next_banana_frame
        fi
        # Collision detection END ----------------------------------------------

        # Print banana to screen
        if ((_x >= 0 && _x < grid_width && _y >= 1 && _y <= grid_height))
        then
            {
                tput cup                                       \
                    $((top_padding_height + grid_height - _y)) \
                    $((left_padding_width + _x))

                printf '%s' "${banana}"
            }>> "${buffer}"

            refresh_screen

            sleep 0.05
        fi

        # Set previous horizontal ($_prev_x) and vertical ($_prev_y) coordinates
        _prev_x="${_x}"
        _prev_y="${_y}"

        # Step time
        _t="$(                                      \
            printf '%s\n' "scale=20; ${_t} + 0.005" \
            | bc -l                                 \
        )"
    done

    # If the thrown banana gets out of boundaries or the banana hits a building
    # then the next player can throw
    switch_player

    return 0
}

# Print animated frames and outro text to the screen
play_outro()
{
    local _outro_lines

    top_padding=''
    left_padding=''

    left_padding_width=$(((term_width - min_term_width) / 2))
    top_padding_height=$(((term_height - min_term_height) / 2))

    for ((_i=0; _i < left_padding_width; _i++))
    do
        left_padding="${left_padding} "
    done

    for ((_i=0; _i < top_padding_height; _i++))
    do
        top_padding="${top_padding}\n"
    done

    _outro_lines=(
        ''
        ''
        ''
        ''
        ''
        ''
        "${top_padding}${left_padding}                                   GAME OVER!"
        ''
        "${left_padding}                                     Score:"
        "${left_padding}                               $(printf '%-10s' "${player1_name}")${player1_score}"
        "${left_padding}                               $(printf '%-10s' "${player2_name}")${player2_score}"
        ''
        ''
        ''
        ''
        ''
        ''
        ''
        ''
        ''
        "${left_padding}                            Press any key to continue"
    )

    # Print outro text into the screen buffer
    for _outro_line in "${_outro_lines[@]}"
    do
        printf '%b\n' "${_outro_line}" >> "${buffer}"
    done

    # Play animation, exit from loop when a key was pressed
    for ((;;))
    do
        print_frame_stage1
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage2
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage3
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage4
        refresh_screen
        read_intro_outro_continue_key && break
        print_frame_stage5
        refresh_screen
        read_intro_outro_continue_key && break
    done

    clear_screen
}

# Game main loop
main_loop()
{
    # Save terminal screen
    tput smcup

    init_main

    play_intro

    read_player_data

    while [[ "${player1_score}" == '' && "${player2_score}" == '' ]] \
        || (((player1_score + player2_score) < total_points))
    do
        init_game

        print_scene
        print_wind
        print_help

        for ((;;))
        do
            print_sun
            print_player_names
            print_score

            read_throw_data
            clear_player_names

            throw_banana || break
        done

        # On player hit update the score and make the winner dance
        print_score
        print_player_victory_dance
    done

    clear_screen

    # Play outro and wait for keypress
    play_outro

    quit
}

check_required_commands

term_width="$(tput cols)"
term_height="$(tput lines)"

left_padding_width=$(((term_width - min_term_width) / 2))
top_padding_height=$(((term_height - min_term_height) / 2))

check_terminal_size

# Parse option flags and their arguments
while getopts ":w:s:h" _option
do
    case "${_option}" in
        h)
            printf '%s\n'                          \
                "${script_name} ${copyright_text}" \
                "For more detailed help, see 'README.md'."

            exit 0

            ;;
        w)
            case ${OPTARG} in
                *[0-9]*)
                    max_wind_value=${OPTARG}
                    ;;
                *)
                    printf '%s\n' \
                        'Invalid argument for option: -w. Specify a number between 0 and 10.'

                    exit 1
            esac

            if ((max_wind_value < 0 || max_wind_value > 10))
            then
                printf '%s\n' \
                    'Invalid argument for option: -w. Specify a number between 0 and 10.'

                exit 1
            fi

            max_wind_value=$((max_wind_value + 1))

            ;;
        s)
            case ${OPTARG} in
                *[0-9]*)
                    max_speed=${OPTARG}

                    ;;
                *)
                    printf '%s\n' \
                        'Invalid argument for option: -s. Specify a number between 100 and 200.'

                    exit 1

                    ;;
            esac

            if ((max_speed < 100 || max_speed > 200))
            then
                printf '%s\n' \
                    'Invalid argument for option: -s. Specify a number between 100 and 200.'

                exit 1
            fi

            ;;
        :)
            if [[ "${OPTARG}" == 'w' ]]
            then
                printf '%s\n' \
                    "Missing argument for option: -${OPTARG}. Specify a number between 0 and 10."
            elif [[ "${OPTARG}" == 's' ]]
            then
                printf '%s\n' \
                    "Missing argument for option: -${OPTARG}. Specify a number between 100 and 200."
            fi

            exit 1

            ;;
        \?)
            printf '%s\n' "Invalid option: -${OPTARG}."

            exit 1

            ;;
    esac
done

main_loop
