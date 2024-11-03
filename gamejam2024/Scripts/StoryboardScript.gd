extends Control

var count = 0

var Story_Texture = ["res://Assets/Art/Storyboard/second_scene.png", "res://Assets/Art/Storyboard/third_scene.png"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if count < 2:
		var new_texture = load(Story_Texture[count])
		$TextureRect.texture = new_texture
		
	elif count == 2:
		$VBoxContainer.visible = false
		$VBoxContainer2.visible = true
	count += 1


func _on_dialogue_button_pressed() -> void:
	if count == 3:
		$VBoxContainer2/ColorRect/Label2.text = "Rules"
		$VBoxContainer2/MarginContainer/Label.text = "
		
		1. Use WASD to move between tiles or SPACE to jump in place
		
		2. You can only move so many times before you run out of water
		
		3. Reach streams to reach the next level"
	else:
		get_tree().change_scene_to_file("res://Scenes/MiscScenes/StartMenu.tscn")
	count += 1
