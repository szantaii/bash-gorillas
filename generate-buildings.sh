#!/bin/bash

# Generates buildings
generate_buildings()
{
	local current_building_height=""
	
	player1_building_height=$((RANDOM % max_building_height))
	
	player2_building_height=$((RANDOM % max_building_height))
	
	if ((building_count <= 15))
	then
		for ((i=building_width; i < (2 * building_width); i++))
		do
			for ((j=0; j < player1_building_height; j++))
			do
				grid["${i},${j}"]="X"
			done
		done
		
		for ((i=(grid_width - (2 * building_width)); i < (grid_width - building_width); i++))
		do
			for ((j=0; j < player2_building_height; j++))
			do
				grid["${i},${j}"]="X"
			done
		done
		
		for ((i=0; i < building_count; i++))
		do
			current_building_height=$((RANDOM % max_building_height))
			
			if ((i != 1 && i != (building_count - 2)))
			then
				for ((j=0; j < building_width; j++))
				do
					for ((k=0; k < current_building_height; k++))
					do
						grid["$(($((i * building_width)) + j)),${k}"]="X"
					done
				done
			fi
		done
	else
		for ((i=(2 * building_width); i < (3 * building_width); i++))
		do
			for ((j=0; j < player1_building_height; j++))
			do
				grid["${i},${j}"]="X"
			done
		done
		
		for ((i=(grid_width - (3 * building_width)); i < (grid_width - (2 * building_width)); i++))
		do
			for ((j=0; j < player2_building_height; j++))
			do
				grid["${i},${j}"]="X"
			done
		done
		
		for ((i=0; i < building_count; i++))
		do
			current_building_height=$((RANDOM % max_building_height))
			
			if ((i != 2 && i != (building_count - 3)))
			then
				for ((j=0; j < building_width; j++))
				do
					for ((k=0; k < current_building_height; k++))
					do
						grid["$(($((i * building_width)) + j)),${k}"]="X"
					done
				done
			fi
		done
	fi
}

