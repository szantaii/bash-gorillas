#!/bin/bash

place_player1()
{
	local i=""
	local j=""
	
	j=${#player1_coordinates[@]}
	
	for ((i=0; i < j; i++))
	do
		unset player1_coordinates[${i}]
	done
	
	for key in "${!player1_throw_animation_frame0}"
	do
		unset player1_throw_animation_frame0["${key}"]
	done
	
	for key in "${!player1_throw_animation_frame1}"
	do
		unset player1_throw_animation_frame1["${key}"]
	done
	
	if ((building_count <= 15))
	then
		i=$((building_width + $(($((building_width - 3)) / 2))))
	else
		i=$(($((building_width * 2)) + $(($((building_width - 3)) / 2))))
	fi
	j=${player1_building_height}
	grid["${i},${j}"]="/"
	
	player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")
	
	i=$((i + 2))
	grid["${i},${j}"]="\\"
	
	player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")
	
	i=$((i - 2))
	j=$((j + 1))
	grid["${i},${j}"]="("
	player1_throw_animation_frame0["${i},${j}"]="("
	player1_throw_animation_frame1["${i},${j}"]=" "
	
	player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")
	
	i=$((i + 1))
	grid["${i},${j}"]="G"
	
	player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")
	
	i=$((i + 1))
	grid["${i},${j}"]=")"
	
	player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")
	
	i=$((i - 1))
	j=$((j + 1))
	grid["${i},${j}"]="o"
	player1_throw_animation_frame0["$((i - 1)),${j}"]=" "
	player1_throw_animation_frame1["$((i - 1)),${j}"]="("
	
	player1_coordinates=("${player1_coordinates[@]}" "${i},${j}")
	player1_throw_start_coordinates="${i},$((j + 1))"
}

place_player2()
{
	local i=""
	local j=""
	
	j=${#player2_coordinates[@]}
	
	for ((i=0; i < j; i++))
	do
		unset player2_coordinates[${i}]
	done
	
	for key in "${!player2_throw_animation_frame0}"
	do
		unset player2_throw_animation_frame0["${key}"]
	done
	
	for key in "${!player2_throw_animation_frame1}"
	do
		unset player2_throw_animation_frame1["${key}"]
	done
	
	if ((building_count <= 15))
	then
		i=$((grid_width - $((2 * building_width))))
		i=$((i + $(($((building_width - 3)) / 2))))
	else
		i=$((grid_width - $((3 * building_width))))
		i=$((i + $(($((building_width - 3)) / 2))))
	fi
	j=${player2_building_height}
	grid["${i},${j}"]="/"
	
	player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")
	
	i=$((i + 2))
	grid["${i},${j}"]="\\"
	
	player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")
	
	i=$((i - 2))
	j=$((j + 1))
	grid["${i},${j}"]="("
	
	player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")
	
	i=$((i + 1))
	grid["${i},${j}"]="G"
	
	player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")
	
	i=$((i + 1))
	grid["${i},${j}"]=")"
	player2_throw_animation_frame0["${i},${j}"]=")"
	player2_throw_animation_frame1["${i},${j}"]=" "
	
	player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")
	
	i=$((i - 1))
	j=$((j + 1))
	grid["${i},${j}"]="o"
	player2_throw_animation_frame0["$((i + 1)),${j}"]=" "
	player2_throw_animation_frame1["$((i + 1)),${j}"]=" "
	
	player2_coordinates=("${player2_coordinates[@]}" "${i},${j}")
	player2_throw_start_coordinates="${i},$((j + 1))"
}

