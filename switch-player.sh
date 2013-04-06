#!/bin/bash

switch_player()
{
	if ((next_player == 1))
	then
		next_player=2
	else
		next_player=1
	fi
}

