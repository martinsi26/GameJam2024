extends Node2D

@onready var map = $".."
@onready var layers = $"../Layers"

var tile_size = Vector2(32, 16)  # Adjust based on your tile map dimensions
var current_layer # The layer that the player is currently at
var target_layer
var current_tile # The tile that the player is currently at
var current_tile_data
var target_tile  # The target tile the player will move to
var target_tile_data
var on_slab # Track whether the player is on a slab or not
var is_moving = false  # Track whether the player is currently moving
var speed = 200
var current_neighbors

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var starting_tile = Vector2i(-1, 0)
	var starting_layer = 0
	on_slab = false
	
	current_tile = starting_tile
	current_layer = starting_layer
	
	current_neighbors = map.get_neighbor_tiles(starting_tile.x, starting_tile.y, starting_layer)
	current_neighbors = update_neighbors(current_neighbors, starting_layer)
	#map.set_outline_tiles(current_neighbors)
	print("new neighbors ", current_neighbors)
	
func update_neighbors(current_neighbors, layer):
	var new_neighbors = [null, null, null, null]
	var i = -1
	for neighbor in current_neighbors:
		i += 1
		if !neighbor:
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
		if target_tile_data.terrain_set == 0:
			on_slab = true
			slab_offset = 22
		else:
			on_slab = false
		var y_offset = target_layer * 48 - slab_offset
		var move_pos = map.get_tile_center(target_tile.x, target_tile.y, target_layer)
		move_pos.y -= y_offset
		
		position = position.move_toward(move_pos, speed * delta)  # Adjust speed as needed
		if position.distance_to(move_pos) < 1:  # Threshold for stopping
			position = move_pos
			current_tile = target_tile
			current_tile_data = target_tile_data
			current_layer = target_layer
			
			#print(current_layer)
			
			current_neighbors = map.get_neighbor_tiles(current_tile.x, current_tile.y, current_layer)
			current_neighbors = update_neighbors(current_neighbors, current_layer)
			map.set_outline_tiles(current_neighbors)
			
			is_moving = false
	
func _input(event):
	if not is_moving:
		if Input.is_action_just_pressed("move_up"):	# W key (up-left)
			if !current_neighbors[0]:
				return
			target_tile = current_neighbors[0].pos
			target_tile_data = current_neighbors[0].data
			target_layer = current_neighbors[0].pos.z
		elif Input.is_action_just_pressed("move_down"):	# S key (down-right)
			if !current_neighbors[3]:
				return
			target_tile = current_neighbors[3].pos
			target_tile_data = current_neighbors[3].data
			target_layer = current_neighbors[3].pos.z
		elif Input.is_action_just_pressed("move_left"):	# A key (down-left)
			if !current_neighbors[2]:
				return
			target_tile = current_neighbors[2].pos
			target_tile_data = current_neighbors[2].data
			target_layer = current_neighbors[2].pos.z
		elif Input.is_action_just_pressed("move_right"): # D key (up-right)
			if !current_neighbors[1]:
				return
			target_tile = current_neighbors[1].pos
			target_tile_data = current_neighbors[1].data
			target_layer = current_neighbors[1].pos.z
		else:
			return

		is_moving = true
