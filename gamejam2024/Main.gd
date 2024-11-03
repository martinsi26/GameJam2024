extends Node2D

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

var instance0 = map0.instantiate()
var instance1 = map1.instantiate()
var instance2 = map2.instantiate()
var instance3 = map3.instantiate()
var instance4 = map4.instantiate()
var instance5 = map5.instantiate()
var instance6 = map6.instantiate()
var instance7 = map7.instantiate()

var fox_scene: PackedScene = preload("res://Fox/Fox.tscn")
var shark_scene: PackedScene = preload("res://Shark/Shark.tscn")
var bear_scene: PackedScene = preload("res://Bear/Bear.tscn")

var coin_scene: PackedScene = preload("res://Coin/Coin.tscn")


signal set_starting_values(starting_tile: Vector2i, starting_layer: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enter_map7()
	current_map = 7
	
func enter_map0():
	add_child(instance0)
	
	var coin = coin_scene.instantiate()
	instance0.get_node("Coins").add_child(coin)
	coin.set_starting_tile(Vector3(-6, -1, 1))
	
	instance0.get_node("Fish").finished_map.connect(finished)
	coin.call_pickup.connect(instance0.get_node("Fish").pickup)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)

func enter_map1():
	add_child(instance1)
	
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
	
	instance1.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map2():
	add_child(instance2)
	
	var shark = shark_scene.instantiate()
	instance2.get_node("Sharks").add_child(shark)
	shark.set_starting_tile(Vector3i(-4, -3, 1))
	shark.call_death.connect(instance2.get_node("Fish").death)
	
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
	
func enter_map7():
	add_child(instance7)

	
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

func enter_map3():
	add_child(instance3)
	
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
	
	instance3.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map4():
	add_child(instance4)
	
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
	
	instance4.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map5():
	add_child(instance5)

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
	
	instance5.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map6():
	add_child(instance6)
	
	var fox = fox_scene.instantiate()
	instance6.get_node("Foxes").add_child(fox)
	fox.set_starting_tile(Vector3i(-1, 4, 0))
	fox.call_death.connect(instance6.get_node("Fish").death)
	
	var coin = coin_scene.instantiate()
	instance6.get_node("Coins").add_child(coin)
	coin.set_starting_tile(Vector3(-1, -8, 0))
	coin.call_pickup.connect(instance6.get_node("Fish").pickup)
	
	var bear = bear_scene.instantiate()
	instance6.get_node("Bears").add_child(bear)
	var path = [
		Vector3i(0, -3, 0),
		Vector3i(-1, -3, 0),
	]
	bear.set_starting_path(path)
	bear.set_starting_tile(Vector3i(0, -3, 1))
	bear.call_death.connect(instance6.get_node("Fish").death)
	
	var bear2 = bear_scene.instantiate()
	instance6.get_node("Bears").add_child(bear2)
	var path2 = [
		Vector3i(-10, -8, 2),
		Vector3i(-11, -8, 2),
	]
	bear2.set_starting_path(path2)
	bear2.set_starting_tile(Vector3i(-10, -8, 2))
	bear2.call_death.connect(instance6.get_node("Fish").death)
	
	instance6.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func end_game():
	print("Game over")
	
func finished():
	current_map += 1
	if current_map == 1:
		total_coins += instance0.get_node("Fish").number_of_coins
		instance0.queue_free()
		enter_map1()
	elif current_map == 2:
		total_coins += instance1.get_node("Fish").number_of_coins
		instance1.queue_free()
		enter_map2()
	elif current_map == 3:
		total_coins += instance2.get_node("Fish").number_of_coins
		instance2.queue_free()
		enter_map3()
	elif current_map == 4:
		total_coins += instance3.get_node("Fish").number_of_coins
		instance3.queue_free()
		enter_map4()
	elif current_map == 5:
		total_coins += instance4.get_node("Fish").number_of_coins
		instance4.queue_free()
		enter_map5()
	elif current_map == 6:
		total_coins += instance5.get_node("Fish").number_of_coins
		instance5.queue_free()
		enter_map6()
