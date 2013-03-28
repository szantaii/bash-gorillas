#!/bin/bash

#
place_player1()
{
	local i=""
	local j=""
	
	j=${#player1_position[@]}
	
	for ((i=0; i < j; i++))
	do
		unset player1_position[${i}]
	done
	
	i=$(($((building_width - 3)) / 2))
	j=${player1_building_height}
	grid["${i},${j}"]="/"
	
	player1_position=("${player1_position[@]}" "${i},${j}")
	
	i=$((i + 2))
	grid["${i},${j}"]="\\"
	
	player1_position=("${player1_position[@]}" "${i},${j}")
	
	i=$((i - 2))
	j=$((j + 1))
	grid["${i},${j}"]="("
	
	player1_position=("${player1_position[@]}" "${i},${j}")
	
	i=$((i + 1))
	grid["${i},${j}"]="G"
	
	player1_position=("${player1_position[@]}" "${i},${j}")
	
	i=$((i + 1))
	grid["${i},${j}"]=")"
	
	player1_position=("${player1_position[@]}" "${i},${j}")
	
	i=$((i - 1))
	j=$((j + 1))
	grid["${i},${j}"]="o"
	
	player1_position=("${player1_position[@]}" "${i},${j}")
}

place_player2()
{
	local i=""
	local j=""
	
	j=${#player2_position[@]}
	
	for ((i=0; i < j; i++))
	do
		unset player2_position[${i}]
	done
	
	i=$(($((grid_width - building_width)) + $(($((building_width - 3)) / 2))))
	j=${player2_building_height}
	grid["${i},${j}"]="/"
	
	player2_position=("${player2_position[@]}" "${i},${j}")
	
	i=$((i + 2))
	grid["${i},${j}"]="\\"
	
	player2_position=("${player2_position[@]}" "${i},${j}")
	
	i=$((i - 2))
	j=$((j + 1))
	grid["${i},${j}"]="("
	
	player2_position=("${player2_position[@]}" "${i},${j}")
	
	i=$((i + 1))
	grid["${i},${j}"]="G"
	
	player2_position=("${player2_position[@]}" "${i},${j}")
	
	i=$((i + 1))
	grid["${i},${j}"]=")"
	
	player2_position=("${player2_position[@]}" "${i},${j}")
	
	i=$((i - 1))
	j=$((j + 1))
	grid["${i},${j}"]="o"
	
	player2_position=("${player2_position[@]}" "${i},${j}")
}

