#!/bin/bash

# Functions in this file print a frame to the buffer
# 
# Calling these funcions and refreshing the screen in order will
# result in an animation.

print_frame_stage1()
{
	# top rule
	tput cup ${top_padding_height} ${left_padding_width} >> ${buffer}
	printf "*    *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    " >> ${buffer}
	
	# right rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) \
			$(($((left_padding_width + min_term_width)) - 1)) >> ${buffer}
		if (( $((i % 3)) == 0))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	# bottom rule
	tput cup $((top_padding_height + min_term_height - 5)) \
		${left_padding_width} >> ${buffer}
	printf "    *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *" >> ${buffer}
	
	# left rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
			>> ${buffer}
		if (( $((i % 3)) == 2))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	tput cup $((term_height - 1)) $((term_width - 1)) >> ${buffer}
}


print_frame_stage2()
{
	# top rule
	tput cup ${top_padding_height} ${left_padding_width} >> ${buffer}
	printf " *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *   " >> ${buffer}
	
	# right rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) \
			$(($((left_padding_width + min_term_width)) - 1)) >> ${buffer}
		if (( $((i % 3)) == 1))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	# bottom rule
	tput cup $((top_padding_height + min_term_height - 5)) \
		${left_padding_width} >> ${buffer}
	printf "   *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    * " >> ${buffer}
	
	# left rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
			>> ${buffer}
		if (( $((i % 3)) == 1))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	tput cup $((term_height - 1)) $((term_width - 1)) >> ${buffer}
}

print_frame_stage3()
{
	# top rule
	tput cup ${top_padding_height} ${left_padding_width} >> ${buffer}
	printf "  *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *  " >> ${buffer}
	
	# right rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) \
			$(($((left_padding_width + min_term_width)) - 1)) >> ${buffer}
		if (( $((i % 3)) == 2))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	# bottom rule
	tput cup $((top_padding_height + min_term_height - 5)) \
		${left_padding_width} >> ${buffer}
	printf "  *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *  " >> ${buffer}
	
	# left rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
			>> ${buffer}
		if (( $((i % 3)) == 0))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	tput cup $((term_height - 1)) $((term_width - 1)) >> ${buffer}
}

print_frame_stage4()
{
	# top rule
	tput cup ${top_padding_height} ${left_padding_width} >> ${buffer}
	printf "   *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    * " >> ${buffer}
	
	# right rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) \
			$(($((left_padding_width + min_term_width)) - 1)) >> ${buffer}
		if (( $((i % 3)) == 0))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	# bottom rule
	tput cup $((top_padding_height + min_term_height - 5)) \
		${left_padding_width} >> ${buffer}
	printf " *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *   " >> ${buffer}
	
	# left rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
			>> ${buffer}
		if (( $((i % 3)) == 2))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	tput cup $((term_height - 1)) $((term_width - 1)) >> ${buffer}
}

print_frame_stage5()
{
	# top rule
	tput cup ${top_padding_height} ${left_padding_width} >> ${buffer}
	printf "    *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    *" >> ${buffer}
	
	# right rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) \
			$(($((left_padding_width + min_term_width)) - 1)) >> ${buffer}
		if (( $((i % 3)) == 1))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	# bottom rule
	tput cup $((top_padding_height + min_term_height - 5)) \
		${left_padding_width} >> ${buffer}
	printf "*    *    *    *    *    *    *    *    *    *    *    *    *    \
*    *    *    " >> ${buffer}
	
	# left rule
	for ((i=0; i < (min_term_height - 5); i++))
	do
		tput cup $(($((top_padding_height + i)) + 1)) ${left_padding_width} \
			>> ${buffer}
		if (( $((i % 3)) == 1))
		then
			printf "*" >> ${buffer}
		else
			printf " " >> ${buffer}
		fi
	done
	
	tput cup $((term_height - 1)) $((term_width - 1)) >> ${buffer}
}

