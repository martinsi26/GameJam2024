extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var Exit_Button_Node = get_node("HowToPlay/MarginContainer/VBoxContainer/VBoxContainer/Exit")
	Exit_Button_Node.pressed.connect(display_screen)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_how_to_play_pressed() -> void:
	$HowToPlay.visible = true
	$MarginContainer/VBoxContainer.visible = false


func display_screen() -> void:
	$HowToPlay.visible = false
	$MarginContainer/VBoxContainer.visible = true
	
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MiscScenes/StoryboardScenes/first_scene.tscn")
