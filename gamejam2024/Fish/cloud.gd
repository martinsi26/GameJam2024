extends TextureRect

@onready var bg = $"."

var start_x
var start_y

func _ready() -> void:
	start_x = bg.position.x
	start_y = bg.position.y
	
func move_tiles():
	bg.position.x -= 1
	
	if bg.position.x == start_x - 2048:
		bg.position.x = start_x
	
func _process(delta: float) -> void:
	move_tiles()
