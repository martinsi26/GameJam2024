extends Node2D

@onready var screen_wipe = $CanvasLayer/Sprite2D
var screen_wipe_playing = false

var water_full = preload("res://Art/WaterDropFull.png")
var water_half = preload("res://Art/WaterDropHalf.png")
var water_empty = preload("res://Art/WaterDropEmpty.png")

@onready var water_bar = [$CanvasLayer/Control/Water_1, $CanvasLayer/Control/Water_2, $CanvasLayer/Control/Water_3, $CanvasLayer/Control/Water_4, $CanvasLayer/Control/Water_5]
var latest_water = 5

var current_map = 0

var total_coins = 0

var map0 = preload("res://Maps/Map0.tscn")
var map1 = preload("res://Maps/Map1.tscn")
var map2 = preload("res://Maps/Map2.tscn")
var map3 = preload("res://Maps/Map3.tscn")
var map4 = preload("res://Maps/Map4.tscn")
var map5 = preload("res://Maps/Map5.tscn")
var map6 = preload("res://Maps/Map6.tscn")
var map7 = preload("res://Maps/Map7.tscn")
var map8 = preload("res://Maps/Map8.tscn")

var enter_map_functions = [
	enter_map0, enter_map1, enter_map2, enter_map3, 
	enter_map4, enter_map5, enter_map6, enter_map7, enter_map8
]

var current_map_instance

var fox_scene: PackedScene = preload("res://Fox/Fox.tscn")
var shark_scene: PackedScene = preload("res://Shark/Shark.tscn")
var bear_scene: PackedScene = preload("res://Bear/Bear.tscn")
var coin_scene: PackedScene = preload("res://Coin/Coin.tscn")

signal set_starting_values(starting_tile: Vector2i, starting_layer: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_map = 0
	enter_map_functions[current_map].call()
	
func _process(delta):
	if screen_wipe_playing:
		screen_wipe.position.x += 3000 * delta
		
		if screen_wipe.position.x > 2200:
			screen_wipe_playing = false
			screen_wipe.visible = false
			
func play_screen_wipe():
	print("play")
	screen_wipe.position.x = -450
	screen_wipe.visible = true
	screen_wipe_playing = true
	
func on_fish_death():
	await get_tree().create_timer(0.75).timeout
	play_screen_wipe()
	get_tree().create_timer(0.25).timeout.connect(reset_map)
	
func reset_map():
	current_map_instance.queue_free()
	enter_map_functions[current_map].call()
	
func enter_map0():
	var instance0 = map0.instantiate()
	current_map_instance = instance0
	add_child(instance0)
	
	instance0.get_node("Fish").water_changed.connect(update_water_display)
	instance0.get_node("Fish").water_reset.connect(reset_water_bar)
	
	var coin = coin_scene.instantiate()
	instance0.get_node("Coins").add_child(coin)
	coin.set_starting_tile(Vector3(-6, -1, 1))
	
	instance0.get_node("Fish").fish_death.connect(on_fish_death)
	instance0.get_node("Fish").finished_map.connect(finished)
	coin.call_pickup.connect(instance0.get_node("Fish").pickup)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)

func enter_map1():
	var instance1 = map1.instantiate()
	current_map_instance = instance1
	add_child(instance1)
	
	instance1.get_node("Fish").water_changed.connect(update_water_display)
	instance1.get_node("Fish").water_reset.connect(reset_water_bar)
	
	var fox = fox_scene.instantiate()
	instance1.get_node("Foxes").add_child(fox)
	fox.set_starting_tile(Vector3i(-2, -2, 0))
	fox.call_death.connect(instance1.get_node("Fish").death)
	
	var bear = bear_scene.instantiate()
	instance1.get_node("Bears").add_child(bear)
	var path = [
		Vector3i(-4, -5, 2),
		Vector3i(-4, -4, 2),
		Vector3i(-3, -4, 2),
		Vector3i(-2, -4, 2),
		Vector3i(-2, -5, 2),
		Vector3i(-2, -4, 2),
		Vector3i(-3, -4, 2),
		Vector3i(-4, -4, 2),
	]
	bear.set_starting_path(path)
	bear.set_starting_tile(Vector3i(-4, -5, 2))
	bear.call_death.connect(instance1.get_node("Fish").death)
	
	instance1.get_node("Fish").fish_death.connect(on_fish_death)
	instance1.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map4():
	var instance2 = map2.instantiate()
	current_map_instance = instance2
	add_child(instance2)
	
	instance2.get_node("Fish").water_changed.connect(update_water_display)
	instance2.get_node("Fish").water_reset.connect(reset_water_bar)
	
	var shark = shark_scene.instantiate()
	instance2.get_node("Sharks").add_child(shark)
	shark.set_starting_tile(Vector3i(-4, -3, 1))
	shark.call_death.connect(instance2.get_node("Fish").death)
	
	instance2.get_node("Fish").fish_death.connect(on_fish_death)
	instance2.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
	var coin1 = coin_scene.instantiate()
	instance2.get_node("Coins").add_child(coin1)
	coin1.set_starting_tile(Vector3(-9, -6, 2))
	
	var coin2 = coin_scene.instantiate()
	instance2.get_node("Coins").add_child(coin2)
	coin2.set_starting_tile(Vector3(-9, -8, 2))
	
	var coin3 = coin_scene.instantiate()
	instance2.get_node("Coins").add_child(coin3)
	coin3.set_starting_tile(Vector3(-7, -6, 2))
	
	var coin4 = coin_scene.instantiate()
	instance2.get_node("Coins").add_child(coin4)
	coin4.set_starting_tile(Vector3(-7, -8, 2))
	
	coin1.call_pickup.connect(instance2.get_node("Fish").pickup)
	coin2.call_pickup.connect(instance2.get_node("Fish").pickup)
	coin3.call_pickup.connect(instance2.get_node("Fish").pickup)
	coin4.call_pickup.connect(instance2.get_node("Fish").pickup)
	
func enter_map5():
	var instance3 = map3.instantiate()
	current_map_instance = instance3
	add_child(instance3)
	
	instance3.get_node("Fish").water_changed.connect(update_water_display)
	instance3.get_node("Fish").water_reset.connect(reset_water_bar)
	
	var shark = shark_scene.instantiate()
	instance3.get_node("Sharks").add_child(shark)
	shark.set_starting_tile(Vector3i(-5, -7, 1))
	shark.call_death.connect(instance3.get_node("Fish").death)
	
	var fox = fox_scene.instantiate()
	instance3.get_node("Foxes").add_child(fox)
	fox.set_starting_tile(Vector3i(-3, -6, 1))
	fox.call_death.connect(instance3.get_node("Fish").death)
	
	var coin = coin_scene.instantiate()
	instance3.get_node("Coins").add_child(coin)
	coin.set_starting_tile(Vector3(-6, -8, 1))
	coin.call_pickup.connect(instance3.get_node("Fish").pickup)
	
	instance3.get_node("Fish").fish_death.connect(on_fish_death)
	instance3.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map3():
	var instance4 = map4.instantiate()
	current_map_instance = instance4
	add_child(instance4)
	
	instance4.get_node("Fish").water_changed.connect(update_water_display)
	instance4.get_node("Fish").water_reset.connect(reset_water_bar)
	
	var bear = bear_scene.instantiate()
	instance4.get_node("Bears").add_child(bear)
	var path = [
		Vector3i(-5, -4, 0),
		Vector3i(-5, -5, 0),
		Vector3i(-5, -6, 0),
		Vector3i(-5, -7, 0),
		Vector3i(-5, -8, 0),
		Vector3i(-5, -9, 0),
		Vector3i(-5, -8, 0),
		Vector3i(-5, -7, 0),
		Vector3i(-5, -6, 0),
		Vector3i(-5, -5, 0),
	]
	bear.set_starting_path(path)
	bear.set_starting_tile(Vector3i(-5, -4, 0))
	bear.call_death.connect(instance4.get_node("Fish").death)
	
	var bear2 = bear_scene.instantiate()
	instance4.get_node("Bears").add_child(bear2)
	var path2 = [
		Vector3i(-8, -10, 1),
		Vector3i(-8, -11, 1),
		Vector3i(-8, -12, 1),
		Vector3i(-8, -11, 1),
	]
	bear2.set_starting_path(path2)
	bear2.set_starting_tile(Vector3i(-8, -10, 1))
	bear2.call_death.connect(instance4.get_node("Fish").death)
	
	var coin = coin_scene.instantiate()
	instance4.get_node("Coins").add_child(coin)
	coin.set_starting_tile(Vector3(2, -10, 0))
	coin.call_pickup.connect(instance4.get_node("Fish").pickup)
	
	instance4.get_node("Fish").fish_death.connect(on_fish_death)
	instance4.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map2():
	var instance5 = map5.instantiate()
	current_map_instance = instance5
	add_child(instance5)
	
	instance5.get_node("Fish").water_changed.connect(update_water_display)
	instance5.get_node("Fish").water_reset.connect(reset_water_bar)

	var bear = bear_scene.instantiate()
	instance5.get_node("Bears").add_child(bear)
	var path = [
		Vector3i(-5, -4, 1),
		Vector3i(-5, -5, 1),
		Vector3i(-5, -6, 1),
		Vector3i(-5, -5, 1),
	]
	bear.set_starting_path(path)
	bear.set_starting_tile(Vector3i(-5, -4, 1))
	bear.call_death.connect(instance5.get_node("Fish").death)
	
	var bear2 = bear_scene.instantiate()
	instance5.get_node("Bears").add_child(bear2)
	var path2 = [
		Vector3i(-10, -8, 2),
		Vector3i(-11, -8, 2),
	]
	bear2.set_starting_path(path2)
	bear2.set_starting_tile(Vector3i(-10, -8, 2))
	bear2.call_death.connect(instance5.get_node("Fish").death)
	
	instance5.get_node("Fish").fish_death.connect(on_fish_death)
	instance5.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map6():
	var instance6 = map6.instantiate()
	current_map_instance = instance6
	add_child(instance6)
	
	instance6.get_node("Fish").water_changed.connect(update_water_display)
	instance6.get_node("Fish").water_reset.connect(reset_water_bar)
	
	var fox = fox_scene.instantiate()
	instance6.get_node("Foxes").add_child(fox)
	fox.set_starting_tile(Vector3i(-1, 7, 0))
	fox.call_death.connect(instance6.get_node("Fish").death)
	
	var coin = coin_scene.instantiate()
	instance6.get_node("Coins").add_child(coin)
	coin.set_starting_tile(Vector3(-2, -6, 0))
	coin.call_pickup.connect(instance6.get_node("Fish").pickup)
	
	var bear = bear_scene.instantiate()
	instance6.get_node("Bears").add_child(bear)
	var path = [
		Vector3i(-1, -2, 0),
		Vector3i(-2, -2, 0),
	]
	bear.set_starting_path(path)
	bear.set_starting_tile(Vector3i(-1, -2, 0))
	bear.call_death.connect(instance6.get_node("Fish").death)
	
	var bear2 = bear_scene.instantiate()
	instance6.get_node("Bears").add_child(bear2)
	var path2 = [
		Vector3i(-2, -4, 0),
		Vector3i(-1, -4, 0),
	]
	bear2.set_starting_path(path2)
	bear2.set_starting_tile(Vector3i(-2, -4, 0))
	bear2.call_death.connect(instance6.get_node("Fish").death)
	
	instance6.get_node("Fish").fish_death.connect(on_fish_death)
	var bear3 = bear_scene.instantiate()
	instance6.get_node("Bears").add_child(bear3)
	var path3 = [
		Vector3i(-2, -7, 0),
		Vector3i(-1, -7, 0),
	]
	bear3.set_starting_path(path3)
	bear3.set_starting_tile(Vector3i(-2, -7, 0))
	bear3.call_death.connect(instance6.get_node("Fish").death)
	
	var bear4 = bear_scene.instantiate()
	instance6.get_node("Bears").add_child(bear4)
	var path4 = [
		Vector3i(-2, -9, 0),
		Vector3i(-1, -9, 0),
	]
	bear4.set_starting_path(path4)
	bear4.set_starting_tile(Vector3i(-2, -9, 0))
	bear4.call_death.connect(instance6.get_node("Fish").death)
	
	var bear5 = bear_scene.instantiate()
	instance6.get_node("Bears").add_child(bear5)
	var path5 = [
		Vector3i(-1, -8, 0),
		Vector3i(0, -8, 0),
	]
	bear5.set_starting_path(path5)
	bear5.set_starting_tile(Vector3i(-1, -8, 0))
	bear5.call_death.connect(instance6.get_node("Fish").death)
	
	instance6.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)

func enter_map7():
	var instance7 = map7.instantiate()
	current_map_instance = instance7
	add_child(instance7)
	
	instance7.get_node("Fish").water_changed.connect(update_water_display)
	instance7.get_node("Fish").water_reset.connect(reset_water_bar)

	var shark1 = shark_scene.instantiate()
	instance7.get_node("Shark1").add_child(shark1)
	shark1.set_starting_tile(Vector3i(-7, -2, 0))
	shark1.call_death.connect(instance7.get_node("Fish").death)
	
	var shark2 = shark_scene.instantiate()
	instance7.get_node("Shark2").add_child(shark2)
	shark2.set_starting_tile(Vector3i(-4, -6, 0))
	shark2.call_death.connect(instance7.get_node("Fish").death)
	
	var shark3 = shark_scene.instantiate()
	instance7.get_node("Shark3").add_child(shark3)
	shark3.set_starting_tile(Vector3i(-15, -11, 1))
	shark3.call_death.connect(instance7.get_node("Fish").death)
	
	var fox = fox_scene.instantiate()
	instance7.get_node("Fox").add_child(fox)
	fox.set_starting_tile(Vector3i(-12, -3, 1))
	fox.call_death.connect(instance7.get_node("Fish").death)
	
	var bear = bear_scene.instantiate()
	instance7.get_node("Bear1").add_child(bear)
	var path = [
		Vector3i(-10, -8, 1),
		Vector3i(-9, -8, 1),
	]
	bear.set_starting_path(path) #, Vector3i(-9, -8, 1), 1)
	bear.set_starting_tile(Vector3i(-10, -8, 1))
	bear.call_death.connect(instance7.get_node("Fish").death)
	
	instance7.get_node("Fish").fish_death.connect(on_fish_death)
	instance7.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)

	
	var coin1 = coin_scene.instantiate()
	instance7.get_node("Coin1").add_child(coin1)
	coin1.set_starting_tile(Vector3(-5, -3, 0))
	
	var coin2 = coin_scene.instantiate()
	instance7.get_node("Coin2").add_child(coin2)
	coin2.set_starting_tile(Vector3(-7, -9, 1))
	
	var coin3 = coin_scene.instantiate()
	instance7.get_node("Coin3").add_child(coin3)
	coin3.set_starting_tile(Vector3(-10, -7, 1))
	
	var coin4 = coin_scene.instantiate()
	instance7.get_node("Coin4").add_child(coin4)
	coin4.set_starting_tile(Vector3(-16, -15, 1))
	
	coin1.call_pickup.connect(instance7.get_node("Fish").pickup)
	coin2.call_pickup.connect(instance7.get_node("Fish").pickup)
	coin3.call_pickup.connect(instance7.get_node("Fish").pickup)
	coin4.call_pickup.connect(instance7.get_node("Fish").pickup)

func enter_map8():
	var instance8 = map8.instantiate()
	current_map_instance = instance8
	add_child(instance8)
	
	instance8.get_node("Fish").water_changed.connect(update_water_display)
	instance8.get_node("Fish").water_reset.connect(reset_water_bar)
	
	var bear1 = bear_scene.instantiate()
	instance8.get_node("Bear1").add_child(bear1)
	var path1 = [
		Vector3i(-6, -12, 1),
		Vector3i(-7, -12, 1),
		Vector3i(-8, -12, 1),
		Vector3i(-9, -12, 1),
		Vector3i(-10, -12, 1),
		Vector3i(-11, -12, 1),
		Vector3i(-12, -12, 1),
		Vector3i(-11, -12, 1),
		Vector3i(-10, -12, 1),		
		Vector3i(-9, -12, 1),	
		Vector3i(-8, -12, 1),		
		Vector3i(-7, -12, 1),			
	]
	bear1.set_starting_path(path1)
	bear1.set_starting_tile(Vector3i(-6, -12, 1))
	bear1.call_death.connect(instance8.get_node("Fish").death)
	
	
	var bear2 = bear_scene.instantiate()
	instance8.get_node("Bear2").add_child(bear2)
	var path2 = [
		Vector3i(-13, -7, 1),
		Vector3i(-13, -8, 1),
		Vector3i(-13, -9, 1),
		Vector3i(-13, -10, 1),
		Vector3i(-13, -9, 1),
		Vector3i(-13, -8, 1),	
	]
	bear2.set_starting_path(path2)
	bear2.set_starting_tile(Vector3i(-13, -7, 1))
	bear2.call_death.connect(instance8.get_node("Fish").death)
	
	var bear3 = bear_scene.instantiate()
	instance8.get_node("Bear3").add_child(bear3)
	var path3 = [
		Vector3i(-12, -10, 1),
		Vector3i(-12, -9, 1),
		Vector3i(-12, -8, 1),
		Vector3i(-12, -7, 1),
		Vector3i(-12, -8, 1),
		Vector3i(-12, -9, 1),	
	]
	bear3.set_starting_path(path3)
	bear3.set_starting_tile(Vector3i(-13, -7, 1))
	bear3.call_death.connect(instance8.get_node("Fish").death)
	
	var bear4 = bear_scene.instantiate()
	instance8.get_node("Bear4").add_child(bear4)
	var path4 = [
		Vector3i(-10, -17, 2),
		Vector3i(-10, -16, 2),
		Vector3i(-10, -15, 2),
		Vector3i(-9, -15, 2),
		Vector3i(-9, -16, 2),
		Vector3i(-9, -17, 2),	
		Vector3i(-8, -17, 2),
		Vector3i(-8, -16, 2),
		Vector3i(-8, -15, 2),
		Vector3i(-7, -15, 2),
		Vector3i(-7, -16, 2),
		Vector3i(-7, -17, 2),
		Vector3i(-7, -16, 2),
		Vector3i(-7, -15, 2),		
		Vector3i(-8, -15, 2),		
		Vector3i(-8, -16, 2),		
		Vector3i(-8, -17, 2),
		Vector3i(-9, -17, 2),	
		Vector3i(-9, -16, 2),
		Vector3i(-9, -15, 2),
		Vector3i(-10, -15, 2),
		Vector3i(-10, -16, 2),		
		
	]
	bear4.set_starting_path(path4)
	bear4.set_starting_tile(Vector3i(-10, -17, 2))
	bear4.call_death.connect(instance8.get_node("Fish").death)
	
	instance8.get_node("Fish").fish_death.connect(on_fish_death)
	instance8.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)

	var coin1 = coin_scene.instantiate()
	instance8.get_node("Coin1").add_child(coin1)
	coin1.set_starting_tile(Vector3(-7, -17, 2))
	
	var coin2 = coin_scene.instantiate()
	instance8.get_node("Coin2").add_child(coin2)
	coin2.set_starting_tile(Vector3(-13, -8, 1))

	coin1.call_pickup.connect(instance8.get_node("Fish").pickup)
	coin2.call_pickup.connect(instance8.get_node("Fish").pickup)

func end_game():
	print("Game over")
	
func finished():
	play_screen_wipe()
	await get_tree().create_timer(0.25).timeout
	total_coins += current_map_instance.get_node("Fish").number_of_coins
	current_map_instance.queue_free()
	current_map += 1
	print(current_map)
	print(enter_map_functions[current_map])
	enter_map_functions[current_map].call()
	
func update_water_display(current_water):
	if latest_water >= 0:
		if water_bar[latest_water-1].texture == water_full:
			water_bar[latest_water-1].texture = water_half
		else:
			water_bar[latest_water-1].texture = water_empty
			latest_water -= 1
			
func reset_water_bar():
	for i in water_bar:
		i.texture = water_full
	latest_water = 5
