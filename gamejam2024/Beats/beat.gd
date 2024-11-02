extends Node

@onready var audio : AudioStreamPlayer = $BeatsPerMinute
@export var level = 0

#beats.level = 1
#beats._ready()

func _ready() -> void:
	while(1):
		audio.play()
		await get_tree().create_timer(2.0 / (level * 2)).timeout
