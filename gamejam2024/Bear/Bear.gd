extends Node2D

@onready var map = $"../../"

var speed: int = 200

var on_slab: bool
var is_moving: bool

var fish_pos: Vector3i
var previous_fish_pos: Vector3i

var current_bear_tile: Vector3i
var current_bear_tile_data: TileData

var target_bear_tile: Vector3i
var target_bear_tile_data: TileData

var starting_tile: Vector3i

signal call_death

var path
var path_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("../../Fish").fish_pos.connect(move_to_fish)
	get_node("../../Fish").previous_fish_pos.connect(prev_fish_pos)
	get_node("../../Fish").fish_death.connect(on_fish_death)
	
func set_starting_tile(_starting_tile: Vector3i):
	starting_tile = _starting_tile
	reset()
	
func set_starting_path(path_input):
	path = path_input
	reset()
	
func reset():
	path_index = 1
	current_bear_tile = starting_tile
	target_bear_tile = path[path_index]
	target_bear_tile_data = current_bear_tile_data
	position = map.get_tile_center(starting_tile.x, starting_tile.y, starting_tile.z)
	position.y -= current_bear_tile.z * 48
	is_moving = false
			
func _process(delta):
	if is_moving:
		var y_offset = target_bear_tile.z * 48
		var move_pos = map.get_tile_center(target_bear_tile.x, target_bear_tile.y, target_bear_tile.z)
		move_pos.y -= y_offset
		
		position = position.move_toward(move_pos, speed * delta)  # Adjust speed as needed
		if position.distance_to(move_pos) < 1:  # Threshold for stopping
			position = move_pos
			
			if target_bear_tile == previous_fish_pos:
				if fish_pos == current_bear_tile:
					emit_signal("call_death")
			
			current_bear_tile = target_bear_tile
			current_bear_tile_data = target_bear_tile_data
			
			if current_bear_tile == fish_pos:
				emit_signal("call_death")
			
			move_to_next_path_tile()
			is_moving = false

func move_to_fish(pos: Vector3i):
	fish_pos = pos
	is_moving = true
	
func prev_fish_pos(pos: Vector3i):
	previous_fish_pos = pos

func move_to_next_path_tile():
	if path_index < path.size() - 1:
		path_index += 1
	else:
		path_index = 0
	
	target_bear_tile = path[path_index]
	target_bear_tile_data = map.get_tile(target_bear_tile.x, target_bear_tile.y, target_bear_tile.z)
	is_moving = true
		
func on_fish_death():
	reset()
