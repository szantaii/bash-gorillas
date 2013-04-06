#!/bin/bash

# Prints the buffer onto the screen then empties the buffer
refresh_screen()
{
	cat "${buffer}"
	printf "" > $buffer
}

