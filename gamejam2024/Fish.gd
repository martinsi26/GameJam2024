extends Node2D

@onready var tile_map = get_parent().get_node("TileMapLayer")

const NORTHWEST = Vector2i(-1, 0)
const NORTHEAST = Vector2i(0, -1)
const SOUTHWEST = Vector2i(0, 1)
const SOUTHEAST = Vector2i(1, 0)

var tile_size = Vector2(32, 16)  # Adjust based on your tile map dimensions
var target_tile = Vector2.ZERO  # The target tile the player will move to
var is_moving = false  # Track whether the player is currently moving
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_tile_center(target_tile)  # Set to center of starting tile
	
func _process(delta):
	if is_moving:
		$"../TileMapLayer"
		position = position.move_toward(get_tile_center(target_tile), speed * delta)  # Adjust speed as needed
		print("position ", position)
		if position.distance_to(get_tile_center(target_tile)) < 1:  # Threshold for stopping
			position = get_tile_center(target_tile)
			is_moving = false
	
func _input(event):
	if not is_moving:
		# Convert current position to tile coordinates
		var current_tile = tile_map.local_to_map(position)
		print("current_tile ", current_tile)
		
		if Input.is_action_just_pressed("move_up"):	# W key (up-left)
			print("up")
			target_tile = NORTHWEST
			print("target tile ", get_tile_center(target_tile))
		elif Input.is_action_just_pressed("move_down"):	# S key (down-right)
			print("down")
			target_tile = SOUTHEAST
		elif Input.is_action_just_pressed("move_left"):	# A key (down-left)
			print("left")
			target_tile = NORTHEAST
		elif Input.is_action_just_pressed("move_right"): # D key (up-right)
			print("right")
			target_tile = SOUTHWEST

		is_moving = true

# Convert tile coordinates to world position centered on the tile
func get_tile_center(tile_coords: Vector2) -> Vector2:
	# Convert tile coords to local position and add half tile size to center
	return tile_map.map_to_local(tile_coords / scale)
