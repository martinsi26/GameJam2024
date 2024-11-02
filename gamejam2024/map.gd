extends Node2D


const NORTHWEST = Vector2i(-1, 0)
const NORTHEAST = Vector2i(0, -1)
const SOUTHWEST = Vector2i(0, 1)
const SOUTHEAST = Vector2i(1, 0)

const neighbor_directions: Array[Vector2i] = [NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST]

# returns the four neighbors of any given tile on a specified layer. The four neighbors may be
# on different layers; if they are, they're accessible from the given tile. If there's no accessible
# tile in that direction, that direction is null
func get_neighbor_tiles(tile_coord: Vector2i, layer_index: int):	
	var layer_middle: TileMapLayer = $Layers.get_child(layer_index)
	var layer_above: TileMapLayer = null
	var layer_below: TileMapLayer = null
	
	var is_slab = layer_middle.get_cell_tile_data(tile_coord).terrain_set == 0
	print("slab: ", is_slab)
	#return is_slab
	
	if layer_index + 1 < $Layers.get_child_count():
		layer_above = $Layers.get_child(layer_index + 1)
		
	if layer_index - 1 >= 0:
		layer_below = $Layers.get_child(layer_index - 1)
		
	var layers_to_check = [layer_above, layer_middle, layer_below]
	
	var neighbors = []
			
	for dir in neighbor_directions:
		var pos = tile_coord + dir
		
		for layer in layers_to_check:
			if !layer:
				continue
			
			var neighbor_data = layer.get_cell_tile_data(pos)
			
			if !neighbor_data:
				continue
			
			var neighbor_pos = pos
			var neighbors_object = Neighbor.new(neighbor_data, neighbor_pos)
			neighbors.append(neighbors_object)
			break
	
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
	print(neighbors)
	#set_outline_tiles(neighbors)
