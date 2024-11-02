extends Resource  # or Node if you want to attach it to a scene

class_name Tile

# Declare the properties
var data: TileData
var pos: Vector3

# Optionally, you can create a constructor
func _init(data: TileData, pos: Vector3):
	self.data = data
	self.pos = pos
