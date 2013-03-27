#!/bin/bash

# Generates buildings
generate_buildings()
{
	local current_building_height=""
	
	player1_building_height=$((RANDOM % $((term_height / 2))))
	
	player2_building_height=$((RANDOM % $((term_height / 2))))
	
	for ((i=0; i < building_width; i++))
	do
		for ((j=0; j < player1_building_height; j++))
		do
			grid["${i},${j}"]="X"
		done
	done
	
	for ((i=(grid_width - building_width); i < grid_width; i++))
	do
		for ((j=0; j < player2_building_height; j++))
		do
			grid["${i},${j}"]="X"
		done
	done
	
	for ((i=1; i <= building_count; i++))
	do
		current_building_height=$((RANDOM % building_max_height))
		
		for ((j=0; j < building_width; j++))
		do
			for ((k=0; k < current_building_height; k++))
			do
				grid["$(($((i * building_width)) + j)),${k}"]="X"
			done
		done
	done
}
