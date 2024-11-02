extends Node2D

var current_map = 0

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

signal set_starting_values(starting_tile: Vector2i, starting_layer: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(instance0)
	instance0.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)

func enter_map1():
	add_child(instance1)
	instance1.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func enter_map2():
	add_child(instance2)
	instance2.get_node("Fish").finished_map.connect(finished)
	emit_signal("set_starting_values", Vector2i(-1, 0), 0)
	
func finished():
	print("finished map function")
	current_map += 1
	if current_map == 1:
		instance0.queue_free()
		enter_map1()
	elif current_map == 2:
		instance1.queue_free()
		enter_map2()
	
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

