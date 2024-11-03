extends Node2D

var current_map = 0

var total_coins = 0

var map0 = preload("res://Maps/Map0.tscn")
var map1 = preload("res://Maps/Map1.tscn")
var map2 = preload("res://Maps/Map2.tscn")
#var map3 = preload("res://Maps/Map3.tscn")
#var map4 = preload("res://Maps/Map4.tscn")
#var map5 = preload("res://Maps/Map5.tscn")
#var map6 = preload("res://Maps/Map6.tscn")

var instance0 = map0.instantiate()
var instance1 = map1.instantiate()
var instance2 = map2.instantiate()
#var instance3 = map3.instantiate()
#var instance4 = map4.instantiate()
#var instance5 = map5.instantiate()
#var instance6 = map6.instantiate()

var fox_scene: PackedScene = preload("res://Fox/Fox.tscn")
var shark_scene: PackedScene = preload("res://Shark/Shark.tscn")
var bear_scene: PackedScene = preload("res://Bear/Bear.tscn")

var coin_scene: PackedScene = preload("res://Coin/Coin.tscn")


signal set_starting_values(starting_tile: Vector2i, starting_layer: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enter_map0()
	current_map = 0
	
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
	bear.set_starting_path(path, Vector3i(-4, -4, 2), 1)
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
	#elif current_map == 3:
		#instance2.queue_free()
		#enter_map3()
	#elif current_map == 4:
		#instance3.queue_free()
		#enter_map4()
	#elif current_map == 5:
		#instance4.queue_free()
		#enter_map5()
	#elif current_map == 6:
		#instance5.queue_free()
		#enter_map6()
	
#func enter_map3():
	#var instance3 = map3.instantiate()
	#add_child(instance3)
	#instance3.connect("enter_map4")
	#emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	#
#func enter_map4():
	#var instance4 = map4.instantiate()
	#add_child(instance4)
	#instance4.connect("enter_map5")
	#emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	#
#func enter_map5():
	#var instance5 = map5.instantiate()
	#add_child(instance5)
	#instance5.connect("enter_map6")
	#emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	#
#func enter_map6():
	#var instance6 = map6.instantiate()
	#add_child(instance6)
	#instance6.connect("enter_end")
	#emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	#
#func enter_end():
	#print("Game over")
