extends Node2D

@onready var map = $".."

var tile_size = Vector2(32, 16)  # Adjust based on your tile map dimensions
var current_layer # The layer that the player is currently at
var target_layer
var current_tile # The tile that the player is currently at
var current_tile_data
var target_tile  # The target tile the player will move to
var target_tile_data
var on_slab = false # Track whether the player is on a slab or not
var is_moving = false  # Track whether the player is currently moving
var speed = 200
var current_neighbors

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var starting_tile = Vector2i(-1, 0)
	var starting_layer = 0
	
	current_tile = starting_tile
	current_layer = starting_layer
	
	current_neighbors = map.get_neighbor_tiles(starting_tile.x, starting_tile.y, starting_layer)
	#map.set_outline_tiles(current_neighbors)
	
func _process(delta):
	
	
	if is_moving:
		var slab_offset = 0
		if target_tile_data.terrain_set == 0:
			print("slab")
			slab_offset = 32 * 3
		$Sprite2D.offset.y = target_layer * -68 * 3 + slab_offset
		var move_pos = map.get_tile_center(target_tile.x, target_tile.y, target_layer)
			
		
		position = position.move_toward(move_pos, speed * delta)  # Adjust speed as needed
		if position.distance_to(move_pos) < 1:  # Threshold for stopping
			position = move_pos
			current_tile = target_tile
			current_tile_data = target_tile_data
			current_layer = target_layer
			
			#print(current_layer)
			
			current_neighbors = map.get_neighbor_tiles(current_tile.x, current_tile.y, current_layer)
			#map.set_outline_tiles(current_neighbors)
			
			is_moving = false
	
func _input(event):
	if not is_moving:
		var neighbors = map.get_neighbor_tiles(current_tile.x, current_tile.y, current_layer)
		
		if Input.is_action_just_pressed("move_up"):	# W key (up-left)
			if !neighbors[0]:
				return
			target_tile = neighbors[0].pos
			target_tile_data = neighbors[0].data
			target_layer = neighbors[0].pos.z
			
			#target_layer = neighbors[0].layer
		elif Input.is_action_just_pressed("move_down"):	# S key (down-right)
			if !neighbors[3]:
				return
			target_tile = neighbors[3].pos
			target_tile_data = neighbors[3].data
			target_layer = neighbors[3].pos.z
			#target_layer = neighbors[3].layer
		elif Input.is_action_just_pressed("move_left"):	# A key (down-left)
			if !neighbors[2]:
				return
			target_tile = neighbors[2].pos
			target_tile_data = neighbors[2].data
			target_layer = neighbors[2].pos.z
			#target_layer = neighbors[2].layer
		elif Input.is_action_just_pressed("move_right"): # D key (up-right)
			if !neighbors[1]:
				return
			target_tile = neighbors[1].pos
			target_tile_data = neighbors[1].data
			target_layer = neighbors[1].pos.z
			#target_layer = neighbors[1].layer
		else:
			return

		is_moving = true
