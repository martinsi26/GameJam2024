extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") * 10
	
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom *= 1.2
		
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom *= 1 / 1.2
