extends Node2D

@onready var map = $".."

var speed = 200

var on_slab
var is_moving

var fish_pos

var current_fox_tile
var current_fox_tile_data

var target_fox_tile
var target_fox_tile_data

signal call_death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_slab = false
	current_fox_tile = Vector3i(-2, -2, 0)
	get_parent().get_node("Fish").fish_pos.connect(move_to_fish)

func update_neighbors(current_neighbors, layer):
	var new_neighbors = [null, null, null, null]
	var i = -1
	for neighbor in current_neighbors:
		i += 1
		if !neighbor:
			continue
		if neighbor.data.terrain_set == 1: # neighbor is water
			continue
		if on_slab: # on slab
			if neighbor.pos.z > layer: # neighbor is on a layer above
				continue
			elif neighbor.pos.z == layer: # neighbor is on the same layer
				new_neighbors[i] = neighbor
			elif neighbor.pos.z < layer: # neighbor is on a lower layer
				if neighbor.data.terrain_set != 0: # lower neighbor is not a slab
					new_neighbors[i] = neighbor
		else:
			if neighbor.pos.z > layer: # nieghbor is on a layer above
				if neighbor.data.terrain_set == 0: # neighbor is a slab
					new_neighbors[i] = neighbor
			elif neighbor.pos.z == layer: # neighbor is on the same layer
				new_neighbors[i] = neighbor
			elif neighbor.pos.z < layer: # neighbor is on a layer below
				if neighbor.data.terrain_set == 0: # neighbor is a slab
					new_neighbors[i] = neighbor
	return new_neighbors
			
func _process(delta):
	if is_moving:
		var slab_offset = 0
		if target_fox_tile_data.terrain_set == 0:
			on_slab = true
			slab_offset = 22
		else:
			on_slab = false
		var y_offset = target_fox_tile.z * 48 - slab_offset
		var move_pos = map.get_tile_center(target_fox_tile.x, target_fox_tile.y, target_fox_tile.z)
		move_pos.y -= y_offset
		
		position = position.move_toward(move_pos, speed * delta)  # Adjust speed as needed
		if position.distance_to(move_pos) < 1:  # Threshold for stopping
			position = move_pos
			current_fox_tile = target_fox_tile
			current_fox_tile_data = target_fox_tile_data
			
			var fox_neighbors = map.get_neighbor_tiles(current_fox_tile.x, current_fox_tile.y, current_fox_tile.z)
			fox_neighbors = update_neighbors(fox_neighbors, current_fox_tile.z)
			
			if current_fox_tile == fish_pos:
				emit_signal("call_death")
			is_moving = false

func move_to_fish(pos: Vector3):
	fish_pos = pos
	
	var fox_neighbors = map.get_neighbor_tiles(current_fox_tile.x, current_fox_tile.y, current_fox_tile.z)
	fox_neighbors = update_neighbors(fox_neighbors, current_fox_tile.z)
	
	var best_distance = pos_compare(fish_pos, current_fox_tile)
	target_fox_tile = current_fox_tile
	target_fox_tile_data = current_fox_tile_data
	for neighbors in fox_neighbors:
		if !neighbors:
			continue
			
		var current_distance = pos_compare(fish_pos, neighbors.pos)
		if current_distance < best_distance:
			best_distance = current_distance
			target_fox_tile = neighbors.pos
			target_fox_tile_data = neighbors.data
	
	is_moving = true
	
func pos_compare(fish_pos: Vector3i, fox_pos: Vector3i):
	return abs(fox_pos.x - fish_pos.x) + abs(fox_pos.y - fish_pos.y)
		
		
