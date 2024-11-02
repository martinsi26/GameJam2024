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
		var neighbor_data = layer.get_cell_tile_data(pos)
		var neighbor_pos = pos
		var neighbors_object = Neighbor.new(neighbor_data, neighbor_pos)
		neighbors.append(neighbors_object)
	
	return neighbors
	
# Convert tile coordinates to world position centered on the tile
func get_tile_center(tile_coords: Vector2, layer_index: int) -> Vector2:
	var layer: TileMapLayer = $Layers.get_child(layer_index)
	# Convert tile coords to local position and add half tile size to center
	return layer.map_to_local(tile_coords) * 3
		
func _ready():
	print(get_neighbor_tiles(Vector2i(0, 0), 0))
