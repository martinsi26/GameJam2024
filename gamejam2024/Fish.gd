extends Node2D

@onready var map = $".."

var tile_size = Vector2(32, 16)  # Adjust based on your tile map dimensions
var current_layer = 0 # The layer that the player is currently at
var current_tile = Vector2.ZERO # The tile that the player is currently at
var target_tile = Vector2.ZERO  # The target tile the player will move to
var is_moving = false  # Track whether the player is currently moving
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta):
	if is_moving:
		position = position.move_toward(map.get_tile_center(target_tile, current_layer), speed * delta)  # Adjust speed as needed
		if position.distance_to(map.get_tile_center(target_tile, current_layer)) < 1:  # Threshold for stopping
			position = map.get_tile_center(target_tile, current_layer)
			current_tile = target_tile
			is_moving = false
	
func _input(event):
	if not is_moving:
		var neighbors = map.get_neighbor_tiles(current_tile, current_layer)
		
		if Input.is_action_just_pressed("move_up"):	# W key (up-left)
			print("up")
			target_tile = neighbors[0].pos
		elif Input.is_action_just_pressed("move_down"):	# S key (down-right)
			print("down")
			target_tile = neighbors[3].pos
		elif Input.is_action_just_pressed("move_left"):	# A key (down-left)
			print("left")
			target_tile = neighbors[2].pos
		elif Input.is_action_just_pressed("move_right"): # D key (up-right)
			print("right")
			target_tile = neighbors[1].pos

		is_moving = true
