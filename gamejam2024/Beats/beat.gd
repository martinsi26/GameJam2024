extends Node

@onready var audio : AudioStreamPlayer = $BeatsPerMinute
@export var level = 1 # change to per level/map
@export var active = true
@export var control: Vector2

#beats.level = 1
#beats._ready()

func _ready() -> void:
	while(active):
		#control = true
		audio.play()
		await get_tree().create_timer(2.0 / (level * 2)).timeout
		

func _process(delta: float) -> void:
	var time = audio.get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	time -= AudioServer.get_output_latency()
	print("Time is: ", time)
	print("Control is: ", control)
	
	
	if time >= (2.0 / (level * 2)) && !control:
		pass
