extends TextureRect

@onready var bg = $"."

var start_x
var start_y

func _ready() -> void:
	start_x = bg.position.x
	start_y = bg.position.y
	
func move_tiles():
	bg.position.x -= 0.5
	bg.position.y -= 0.5
	
	if bg.position.x == start_x - 32:
		bg.position.x = start_x
		bg.position.y = start_y
	
func _process(delta: float) -> void:
	move_tiles()
