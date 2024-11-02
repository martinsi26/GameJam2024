extends Resource  # or Node if you want to attach it to a scene

class_name Neighbor

# Declare the properties
var data: TileData
var pos: Vector2

# Optionally, you can create a constructor
func _init(data: TileData, pos: Vector2):
	self.data = data
	self.pos = pos
