extends Node2D

@onready var map = $"../../"

var coin_tile: Vector3i
var coin_tile_data: TileData

var fish_pos: Vector3i
var is_moving: bool

var starting_tile

signal call_pickup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("../../Fish").fish_pos.connect(fish_moved)
	get_node("../../Fish").fish_death.connect(on_fish_death)
	
	var y_offset = coin_tile.z * 48
	var move_pos = map.get_tile_center(coin_tile.x, coin_tile.y, coin_tile.z)
	move_pos.y -= y_offset
	
func set_starting_tile(_starting_tile: Vector3):
	starting_tile = _starting_tile
	reset()

func reset():
	if !visible:
		visible = true
	coin_tile = starting_tile
	position = map.get_tile_center(starting_tile.x, starting_tile.y, starting_tile.z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		if coin_tile == fish_pos and visible:
			emit_signal("call_pickup")
			visible = false
		is_moving = false
		
func fish_moved(pos: Vector3):
	fish_pos = pos
	is_moving = true
	
func on_fish_death():
	reset()
