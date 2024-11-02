extends Node2D

@onready var map = $".."

var tile_size = Vector2(32, 16)  # Adjust based on your tile map dimensions
var current_layer = 0 # The layer that the player is currently at
var target_layer
var current_tile # The tile that the player is currently at
var current_tile_data
var target_tile  # The target tile the player will move to
var target_tile_data
var on_slab = false # Track whether the player is on a slab or not
var is_moving = false  # Track whether the player is currently moving
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_tile = Vector2i(-1, 0)
	target_tile = Vector2i(-1, 0)
	
func _process(delta):
	if is_moving:
		var move_pos = map.get_tile_center(target_tile, target_layer)
		if target_tile_data.terrain_set == 0:
			if target_layer == current_layer:
				move_pos.y += 16
			else:
				move_pos.y -= 16
		position = position.move_toward(move_pos, speed * delta)  # Adjust speed as needed
		if position.distance_to(move_pos) < 1:  # Threshold for stopping
			position = move_pos
			current_tile = target_tile
			current_tile_data = target_tile_data
			current_layer = target_layer
			is_moving = false
	
func _input(event):
	if not is_moving:
		var neighbors = map.get_neighbor_tiles(current_tile, current_layer)
		
		if Input.is_action_just_pressed("move_up"):	# W key (up-left)
			if !neighbors[0].data:
				return
			target_tile = neighbors[0].pos
			target_tile_data = neighbors[0].data
			target_layer = neighbors[0].layer
		elif Input.is_action_just_pressed("move_down"):	# S key (down-right)
			if !neighbors[3].data:
				return
			target_tile = neighbors[3].pos
			target_tile_data = neighbors[3].data
			target_layer = neighbors[3].layer
		elif Input.is_action_just_pressed("move_left"):	# A key (down-left)
			if !neighbors[2].data:
				return
			target_tile = neighbors[2].pos
			target_tile_data = neighbors[2].data
			target_layer = neighbors[2].layer
		elif Input.is_action_just_pressed("move_right"): # D key (up-right)
			if !neighbors[1].data:
				return
			target_tile = neighbors[1].pos
			target_tile_data = neighbors[1].data
			target_layer = neighbors[1].layer
		else:
			return

		is_moving = true
