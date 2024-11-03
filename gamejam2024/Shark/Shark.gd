extends Node2D

@onready var map = $"../../"

var speed: int = 200

var on_slab: bool
var is_moving: bool

var fish_pos: Vector3i

var current_shark_tile: Vector3i
var current_shark_tile_data: TileData

var target_shark_tile: Vector3i
var target_shark_tile_data: TileData

var starting_tile: Vector3

signal call_death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("../../Fish").fish_pos.connect(move_to_fish)
	get_node("../../Fish").fish_death.connect(on_fish_death)
	
func set_starting_tile(_starting_tile: Vector3):
	starting_tile = _starting_tile
	reset()
	
func reset():
	current_shark_tile = starting_tile
	target_shark_tile = current_shark_tile
	target_shark_tile_data = current_shark_tile_data
	position = get_parent().get_parent().get_tile_center(starting_tile.x, starting_tile.y, starting_tile.z)
	position.y -= target_shark_tile.z * 48
	
func update_neighbors(current_neighbors, layer: int):
	var new_neighbors = [null, null, null, null]
	var i = -1
	for neighbor in current_neighbors:
		i += 1
		if !neighbor:
			continue
		if neighbor.data.terrain_set != 1: # neighbor is water
			continue
		if neighbor.pos.z == layer: # neighbor is on the same layer
			new_neighbors[i] = neighbor
	return new_neighbors
			
func _process(delta):
	if is_moving:
		var y_offset = target_shark_tile.z * 48
		var move_pos = map.get_tile_center(target_shark_tile.x, target_shark_tile.y, target_shark_tile.z)
		move_pos.y -= y_offset
		
		position = position.move_toward(move_pos, speed * delta)  # Adjust speed as needed
		if position.distance_to(move_pos) < 1:  # Threshold for stopping
			position = move_pos
			current_shark_tile = target_shark_tile
			current_shark_tile_data = target_shark_tile_data
			if current_shark_tile == fish_pos:
				emit_signal("call_death")
			is_moving = false

func move_to_fish(pos: Vector3i):
	fish_pos = pos
	
	var shark_neighbors = map.get_neighbor_tiles(current_shark_tile.x, current_shark_tile.y, current_shark_tile.z)
	shark_neighbors = update_neighbors(shark_neighbors, current_shark_tile.z)
	
	var best_distance = pos_compare(fish_pos, current_shark_tile)
	target_shark_tile = current_shark_tile
	target_shark_tile_data = current_shark_tile_data
	for neighbors in shark_neighbors:
		if !neighbors:
			continue
			
		var current_distance = pos_compare(fish_pos, neighbors.pos)
		if current_distance < best_distance:
			best_distance = current_distance
			target_shark_tile = neighbors.pos
			target_shark_tile_data = neighbors.data
	
	is_moving = true
	
func pos_compare(fish_pos: Vector3i, fox_pos: Vector3i):
	return abs(fox_pos.x - fish_pos.x) + abs(fox_pos.y - fish_pos.y)
		
func on_fish_death():
	reset()
