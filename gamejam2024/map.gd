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
	

func set_outline_tiles(tiles):
	var outline_layer: TileMapLayer = $Layers.get_node("OutlineLayer")
	outline_layer.clear()

	for tile in tiles:
		if tile.data:
			#if tile.data.terrain_set == 0:
			outline_layer.set_cell(tile.pos, 1, Vector2i(0, 0))
			#else:
				#outline_layer.set_cell(tile.pos, 2, Vector2i(0, 0))
		#print(tile.data)
	
# Convert tile coordinates to world position centered on the tile
func get_tile_center(tile_coords: Vector2, layer_index: int) -> Vector2:
	var layer: TileMapLayer = $Layers.get_child(layer_index)
	# Convert tile coords to local position and add half tile size to center
	return layer.map_to_local(tile_coords) * 3
		
func _ready():
	pass
	#print(get_neighbor_tiles(Vector2i(0, 0), 0))
	
func _process(delta: float):
	var fish_pos = $Layers.get_child(0).local_to_map($Fish.position / 3)
	var neighbors = get_neighbor_tiles(fish_pos, 0)
	set_outline_tiles(neighbors)
