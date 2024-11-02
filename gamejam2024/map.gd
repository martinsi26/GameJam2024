extends Node2D


const NORTHWEST = Vector2i(-1, 0)
const NORTHEAST = Vector2i(0, -1)
const SOUTHWEST = Vector2i(0, 1)
const SOUTHEAST = Vector2i(1, 0)

const neighbor_directions: Array[Vector2i] = [NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST]

func get_neighbor_tiles(tile_coord: Vector2i, layer_index: int):
	var layer: TileMapLayer = $Layers.get_child(layer_index)
	var neighbors = []
	
	for dir in neighbor_directions:
		var pos = tile_coord + dir
		var neighbor = layer.get_cell_tile_data(pos)
		neighbors.append(neighbor)
	
	return neighbors
		
func _ready():
	print(get_neighbor_tiles(Vector2i(0, 0), 0))
