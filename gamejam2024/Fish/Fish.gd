extends Node2D

@onready var map = $".."
@onready var water_label = $Camera2D/Control/WaterLabel
@onready var coin_label = $Camera2D/Control/CoinLabel

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

var max_water = 10
var current_water

var number_of_coins = 0

var starting_tile
var starting_layer

var sent_signal = false
signal finished_map
signal fish_pos(pos: Vector3i)
signal previous_fish_pos(pos: Vector3i)
signal fish_death()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sent_signal = false
	get_parent().get_parent().connect("set_starting_values", set_starting_values)
	
func set_starting_values(_starting_tile, _starting_layer):
	set_water()
	water_label.text = str(current_water)
	coin_label.text = str(number_of_coins)
	
	on_slab = false
	starting_tile = _starting_tile
	starting_layer = _starting_layer
	current_tile = _starting_tile
	current_layer = _starting_layer
	
	current_neighbors = map.get_neighbor_tiles(_starting_tile.x, _starting_tile.y, _starting_layer)
	current_neighbors = update_neighbors(current_neighbors, _starting_layer)
	map.set_outline_tiles(current_neighbors)
	
func respawn():
	position = map.get_tile_center(starting_tile.x, starting_tile.y, starting_layer)
	
	current_neighbors = map.get_neighbor_tiles(starting_tile.x, starting_tile.y, starting_layer)
	current_neighbors = update_neighbors(current_neighbors, starting_layer)
	map.set_outline_tiles(current_neighbors)
	
	target_tile = null
	target_tile_data = null
	target_layer = null
	
	is_moving = false

func set_water():
	current_water = max_water
	water_label.text = str(current_water)
	
func use_water(water: int):
	current_water -= water
	water_label.text = str(current_water)

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
	
func death():
	set_water()
	
	number_of_coins = 0
	coin_label.text = str(number_of_coins)
	
	respawn()
	fish_death.emit()
	
func pickup():
	number_of_coins += 1
	coin_label.text = str(number_of_coins)
					
func _process(delta):
	if is_moving:
		var slab_offset = 0
		if target_tile_data.terrain_set == 2 and !sent_signal: # Player has made it to the final block
			emit_signal("finished_map")
			sent_signal = true
			
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
			
			previous_fish_pos.emit(current_tile)
			fish_pos.emit(target_tile)
			
			current_tile = target_tile
			current_tile_data = target_tile_data
			current_layer = target_layer
			
			current_neighbors = map.get_neighbor_tiles(current_tile.x, current_tile.y, current_layer)
			current_neighbors = update_neighbors(current_neighbors, current_layer)
			map.set_outline_tiles(current_neighbors)
			is_moving = false
			
	if current_water == 0:
		death()
	
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
		#elif Input.is_action_just_pressed("hop_in_place"):
			#pass
		else:
			return
		
		use_water(1)
		if target_tile_data.terrain_set == 1:
			set_water()
		#water_label.text = str(current_water)
		
		is_moving = true
