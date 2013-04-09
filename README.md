# bash-gorillas

***

## Contents
 1. About
 2. License
 3. Prerequisites
 4. Exit status
 5. How to play
 6. Further development

***

## 1. About

This game is a demake of [QBasic GORILLAS](http://en.wikipedia.org/wiki/Gorillas_%28video_game%29) completely written in Bash.

*Your mission is to hit your opponent with the exploding banana by varying the angle and power of your throw, taking into account wind speed, gravity, and the city skyline. The wind speed is show by a directional arrow at the bottom of the playing field, its length relative to its strength.*

## 2. License

This project is licensed under GNU General Public License Version 3. For the full license, see `LICENSE`.

## 3. Prerequisites

 * Bash shell ≥ 4.2
 * `bc` basic calculator for floating point arithmetic. Can be found in the `bc` package on major Linux distributions.
 * `tput` for terminal handling. Can be found in different `ncurses` packages on Linux distributions (see the table below for major distros).

| Distrbution | Package name    |
| ----------- | --------------- |
| Arch Linux  | `ncurses`       |
| Fedora      | `ncurses`       |
| openSUSE    | `ncurses-utils` |
| Ubuntu      | `ncurses-bin`   |

## 4. Exit status
 * `0` bash-gorillas exited successfully.
 * `1` bash-gorillas was called with wrong or missing parameters. (not yet implemented)
 * `2` Missing necessary programs to run bash-gorillas.
 * `3` Too small terminal size (width×height).

## 5. How to play

`TODO`

## 6. Further development

 * Add extensive code comments. (high priority)
 * Let player correct entered throw angle and speed. (high priority)
 * Make `max_speed` and `wind_value` adjustable through command-line options (using `getopts`). (normal priority)

