extends Node

@onready var audio : AudioStreamPlayer2D = $BeatsPerMinute
@onready var timer : Timer = $Timer
@export var level = 1 # change to per level/map
@export var control: Vector2
var times = 2.0 / (level * 2)

#Put this in each map
#beats.level = 1
#beats._ready() #idk if you rlly need this one though

func _ready() -> void:
	timer.wait_time = times
	

func _process(delta: float) -> void:
	var time = audio.get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	time -= AudioServer.get_output_latency()
	print("Time is: ", time)
	#print("Control is: ", control)
		


func _on_timer_timeout() -> void:
	audio.play()
