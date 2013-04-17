# bash-gorillas

***

## Contents
 1. About
 2. License
 3. Prerequisites
 4. Exit status
 5. How to play
  * Get bash-gorillas
  * Start bash-gorillas
     * Command-line options
         * Examples
  * Gameplay
 6. Further development

***

## 1. About

This game is a demake of [QBasic GORILLAS](http://en.wikipedia.org/wiki/Gorillas_%28video_game%29) completely written in Bash.

*Your mission is to hit your opponent with the exploding banana by varying the angle and power of your throw, taking into account wind speed, gravity, and the city skyline. The wind speed is show by a directional arrow at the bottom of the playing field, its length relative to its strength.*

## 2. License

This project is licensed under GNU General Public License Version 3+. For the full license, see `LICENSE`.

## 3. Prerequisites

 * Bash shell ≥ 4.2.
 * `bc` basic calculator for floating point arithmetic. Can be found in the `bc` package on major Linux distributions.
 * `tput` for terminal handling. Can be found in different `ncurses` packages on Linux distributions (see the table below for major distros).

| Distrbution | Package name    |
| ----------- | --------------- |
| Arch Linux  | `ncurses`       |
| Debian      | `ncurses-bin`   |
| Fedora      | `ncurses`       |
| openSUSE    | `ncurses-utils` |
| Ubuntu      | `ncurses-bin`   |

## 4. Exit status
 * `0` bash-gorillas exited successfully.
 * `1` bash-gorillas was called with wrong or missing parameters.
 * `2` Missing necessary programs to run bash-gorillas.
 * `3` Too small terminal size (width×height).

## 5. How to play

### Get bash-gorillas

First you have to acquire bash-gorillas:

```bash
git clone https://github.com/szantaii/bash-gorillas.git
```

Enter bash-gorillas' directory:

```bash
cd bash-gorillas
```

### Start bash-gorillas

Use the Bash interpreter to start the game:

```bash
bash bash-gorillas
```

#### Command-line options

bash-gorillas can be started with the following command line options:

 * `-h` Prints a simple help to the screen, and exits.
 * `-s max_throw_speed` Sets the maximum throw speed (default value: 100) that players can use, valid values: 100–200.
 * `-w max_wind_value` Sets the maximum power of the wind (default value: 5), valid values: 0–10.

##### Examples

Set maximum throw speed to 150:

```bash
bash bash-gorillas -s 150
```

Set maximum wind power to 3:

```bash
bash bash-gorillas -w 3
```

Set maxmimum throw speed to 200 and maxmimum wind power to 10:

```bash
bash bash-gorillas -s 200 -w 10
```

### Gameplay

Upon starting the game a welcome screen will appear, press any key to get past the welcome screen.

On the second screen you can specify the names of players (maxmimum 10 characters each), total points to play until, and the value of garvity in the game. If you don't want to specify either of these you can simply press Enter to use the indicated default values. At this point you can choose to play (press 'p') or to quit (press 'q').

Once the playing field loaded players can start throwing bananas at each other. Throw angle and speed prompt will appear under the name (top left and right corner of the screen) of the current player. Minimum and maxmimum throw angles and throw speeds are indicated in the prompt. Your aim is simply the following:

>[...] to hit your opponent with the exploding banana by varying the angle and power of your throw, taking into account wind speed, gravity, and the city skyline. The wind speed is show by a directional arrow at the bottom of the playing field, its length relative to its strength.

## 6. Further development

 * Let player to correct entered throw angle and speed. (high priority)

