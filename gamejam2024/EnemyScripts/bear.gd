extends Node2D

@onready var map = $".."

var tile_size = Vector2(32, 16)
var current_layer
var target_layer
var current_tile
var current_tile_data
var target_tile
var target_tile_data
var is_moving = false
var speed = 200
var current_neighbors
var direction_index = 0  # Tracks current direction in the cycle (0=up, 1=right, 2=down, 3=left)
var directions = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]
var is_first_move = true  # Track if this is the first move attempt

func _ready() -> void:
	var starting_tile = Vector2i(2, 4)
	var starting_layer = 0
	
	current_tile = starting_tile
	current_layer = starting_layer
	
	current_neighbors = map.get_neighbor_tiles(starting_tile.x, starting_tile.y, starting_layer)
	map.set_outline_tiles(current_neighbors)
	
func _process(delta):
	# Check for any player movement input and move the bear if detected
	if not is_moving and (Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down")
		or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		
		print("Player moved - bear will attempt to move")
		
		if is_first_move:
			# Instead of skipping, we update the direction index to point to the next move
			is_first_move = false
			direction_index = (direction_index + 1) % directions.size()  # Advance the direction for the bear
			print("Skipping first move; moving to next direction")
		
		move_to_next_tile()  # Move based on the updated direction index
	
	if is_moving:
		var slab_offset = 0
		if target_tile_data.terrain_set == 0:  # Check if the target tile is a slab
			print("Bear stepping onto slab")
			slab_offset = 32 * 3  # Apply slab offset
		
		$Sprite2D.offset.y = target_layer * -68 * 3 + slab_offset  # Apply layer and slab offset
		
		var move_pos = map.get_tile_center(target_tile.x, target_tile.y, target_layer)
		position = position.move_toward(move_pos, speed * delta)
		
		if position.distance_to(move_pos) < 1:  # Threshold for stopping
			position = move_pos
			current_tile = target_tile
			current_tile_data = target_tile_data
			current_layer = target_layer
			
			current_neighbors = map.get_neighbor_tiles(current_tile.x, current_tile.y, current_layer)
			is_moving = false
			print("Bear movement completed, ready for next move")

# Move the bear to the next tile in the path (up, right, down, left)
func move_to_next_tile():
	var direction = directions[direction_index]
	var next_tile = Vector3(current_tile.x + direction.x, current_tile.y + direction.y, current_layer)
	
	current_neighbors = map.get_neighbor_tiles(current_tile.x, current_tile.y, current_layer)
	
	for neighbor in current_neighbors:
		if neighbor.pos == next_tile and neighbor.data:
			target_tile = neighbor.pos
			target_tile_data = neighbor.data
			target_layer = neighbor.pos.z
			is_moving = true
			print("Bear is moving to tile:", target_tile)
			break
	
	# If no valid neighbor was found, print a message
	if not is_moving:
		print("No valid move found for bear in direction", direction)
	
	direction_index = (direction_index + 1) % directions.size()
