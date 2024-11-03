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

# Define a specific path for the fox to follow
var path = [
	Vector3i(-1, -1, 0),  # Start tile
	Vector3i(-2, -1, 0),  # Move up
	Vector3i(-1, -1, 0),  # Move right
	Vector3i(-1, -2, 0),  # Move down
	Vector3i(-2, -2, 0)   # Return to start or other end tile
]
var current_path_index = 0  # Index to track the current position in the path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_slab = false
	current_fox_tile = path[current_path_index]  # Start at the first tile in the path
	target_fox_tile = current_fox_tile
	target_fox_tile_data = map.get_tile(target_fox_tile.x, target_fox_tile.y, target_fox_tile.z)  # Initialize target tile data
	get_parent().get_node("Fish").fish_pos.connect(move_to_fish)

func update_neighbors(current_neighbors, layer):
	var new_neighbors = [null, null, null, null]
	var i = -1
	for neighbor in current_neighbors:
		i += 1
		if !neighbor:
			continue
		if neighbor.data.terrain_set == 1:  # neighbor is water
			continue
		if on_slab:  # on slab
			if neighbor.pos.z > layer:  # neighbor is on a layer above
				continue
			elif neighbor.pos.z == layer:  # neighbor is on the same layer
				new_neighbors[i] = neighbor
			elif neighbor.pos.z < layer:  # neighbor is on a lower layer
				if neighbor.data.terrain_set != 0:  # lower neighbor is not a slab
					new_neighbors[i] = neighbor
		else:
			if neighbor.pos.z > layer:  # neighbor is on a layer above
				if neighbor.data.terrain_set == 0:  # neighbor is a slab
					new_neighbors[i] = neighbor
			elif neighbor.pos.z == layer:  # neighbor is on the same layer
				new_neighbors[i] = neighbor
			elif neighbor.pos.z < layer:  # neighbor is on a layer below
				if neighbor.data.terrain_set == 0:  # neighbor is a slab
					new_neighbors[i] = neighbor
	return new_neighbors

func _process(delta):
	if is_moving:
		# Ensure we have valid tile data before checking
		if target_fox_tile_data == null:
			target_fox_tile_data = map.get_tile(target_fox_tile.x, target_fox_tile.y, target_fox_tile.z)
			if target_fox_tile_data == null:
				return  # Exit if we still don't have valid data

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
			
			if current_fox_tile == Vector3i(fish_pos.x, fish_pos.y, fish_pos.z):
				emit_signal("call_death")

			is_moving = false
			move_to_next_path_tile()  # Move to the next tile in the path

func move_to_fish(pos: Vector3):
	fish_pos = pos
	is_moving = true  # Set moving state to true to trigger movement

func move_to_next_path_tile():
	# Move to the next tile in the predefined path
	if current_path_index < path.size() - 1:
		current_path_index += 1  # Move to the next tile in the path
	else:
		current_path_index = 0  # Reset to the start of the path if finished

	target_fox_tile = path[current_path_index]
	target_fox_tile_data = map.get_tile(target_fox_tile.x, target_fox_tile.y, target_fox_tile.z)  # Update tile data

func pos_compare(fish_pos: Vector3i, fox_pos: Vector3i):
	return abs(fox_pos.x - fish_pos.x) + abs(fox_pos.y - fish_pos.y)
