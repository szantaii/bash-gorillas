#!/bin/bash

# Reads a key from keyboard
#
# If a key was read before read's timeout expires
# then breaks out of outer construcions.
read_intro_outro_continue_key()
{
    read -sn1 -t0.01

    if (($? == 0))
    then
        break
    fi
}
