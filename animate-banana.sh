#!/bin/bash

init_banana()
{
	if ((next_player == 1))
	then
		banana="<"
	else
		banana=">"
	fi
}

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

