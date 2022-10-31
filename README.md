# bash-gorillas

## Contents
 * [About](#about)
 * [License](#license)
 * [Prerequisites](#prerequisites)
 * [Exit status](#exit-status)
 * [How to play](#how-to-play)
   * [Get bash-gorillas](#get-bash-gorillas)
   * [Start bash-gorillas](#start-bash-gorillas)
     * [Command-line options](#command-line-options)
       * [Examples](#examples)
   * [Gameplay](#gameplay)
 * [Known problems](#known-problems)

## About

This game is a demake of [QBasic GORILLAS](https://en.wikipedia.org/wiki/Gorillas_%28video_game%29) completely written in Bash.

*Your mission is to hit your opponent with the exploding banana by varying the angle and power of your throw, taking into account wind speed, gravity, and the city skyline. The wind speed is show by a directional arrow at the bottom of the playing field, its length relative to its strength.*

## License

This project is licensed under GNU General Public License Version 3+. For the full license, see [`LICENSE`](LICENSE).

## Prerequisites

 * Bash shell ≥ 5.

 * You will also need the following commands from the [GNU coreutils][gnu-coreutils-link], [GNU findutils][gnu-findutils-link] and [ncurses][ncurses-link] software packages to be able to play bash-gorillas.

   | Command      | Software package                    |
   |--------------|-------------------------------------|
   | __`bc`__     | [GNU bc][gnu-bc-link]               |
   | __`cat`__    | [GNU coreutils][gnu-coreutils-link] |
   | __`clear`__  | [ncurses][ncurses-link]             |
   | __`mktemp`__ | [GNU coreutils][gnu-coreutils-link] |
   | __`printf`__ | [GNU coreutils][gnu-coreutils-link] |
   | __`rm`__     | [GNU coreutils][gnu-coreutils-link] |
   | __`sleep`__  | [GNU coreutils][gnu-coreutils-link] |
   | __`tput`__   | [ncurses][ncurses-link]             |
   | __`true`__   | [GNU coreutils][gnu-coreutils-link] |
   | __`xargs`__  | [GNU findutils][gnu-findutils-link] |

[gnu-bc-link]:        https://www.gnu.org/software/bc/
[gnu-coreutils-link]: https://www.gnu.org/software/coreutils/
[gnu-findutils-link]: https://www.gnu.org/software/findutils/
[ncurses-link]:       https://invisible-island.net/ncurses/

## Exit status

 * __`0`__ bash-gorillas exited successfully.
 * __`1`__ bash-gorillas was called with wrong or missing parameters.
 * __`2`__ Missing necessary programs to run bash-gorillas.
 * __`3`__ Too small terminal size (width×height).

## How to play

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

You can either use the Bash interpreter to start the game or invoke the script directly:

```bash
bash bash-gorillas.sh
```

```bash
./bash-gorillas.sh
```

#### Command-line options

bash-gorillas can be started with the following command line options:

 * __`-h`__ Prints a simple help to the screen, and exits.
 * __`-s max_throw_speed`__ Sets the maximum throw speed (default value: 100) that players can use, valid values: 100–200.
 * __`-w max_wind_value`__ Sets the maximum power of the wind (default value: 5), valid values: 0–10.

##### Examples

Set maximum throw speed to 150:

```bash
bash bash-gorillas.sh -s 150
```

Set maximum wind power to 3:

```bash
bash bash-gorillas.sh -w 3
```

Set maximum throw speed to 200 and maximum wind power to 10:

```bash
bash bash-gorillas.sh -s 200 -w 10
```

### Gameplay

Upon starting the game a welcome screen will appear, press any key to get past the welcome screen.

On the second screen you can specify the names of players (maximum 10 characters each), total points to play until, and the value of gravity in the game. If you don't want to specify either of these you can simply press Enter to use the indicated default values. At this point you can choose to play (press 'p') or to quit (press 'q').

Once the playing field loaded players can start throwing bananas at each other. Throw angle and speed prompt will appear under the name (top left and right corner of the screen) of the current player. Minimum and maximum throw angles and throw speeds are indicated in the prompt. Your aim is simply the following:

>[...] to hit your opponent with the exploding banana by varying the angle and power of your throw, taking into account wind speed, gravity, and the city skyline. The wind speed is show by a directional arrow at the bottom of the playing field, its length relative to its strength.

## Known problems

 * Players cannot correct data entered during the game (e.g. names, throw angle and speed).
 * Sometimes players cannot hit each other due to the random generated maps and wind. (In such a case one of the players has to sacrifice themselves so the game can advance.)
 * Collision detection does not always detect hits properly at high throw speeds.
 * Sometimes parts of the buildings are cleared after a player was hit. (This does not affect the gameplay at all.)

These mentioned issues will most likely never be fixed.
