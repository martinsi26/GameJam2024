extends Node2D

const NORTHWEST = Vector2i(-1, 0)
const NORTHEAST = Vector2i(0, -1)
const SOUTHWEST = Vector2i(0, 1)
const SOUTHEAST = Vector2i(1, 0)

const neighbor_directions: Array[Vector2i] = [NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST]

func get_tile(x, y, z) -> TileData:
	if z < 0 || z >= $Layers.get_child_count():
		return null
		
	return $Layers.get_child(z).get_cell_tile_data(Vector2i(x, y))

# returns the four neighbors of any given tile on a specified layer. The four neighbors may be
# on different layers; if they are, they're accessible from the given tile. If there's no accessible
# tile in that direction, that direction is null
func get_neighbor_tiles(x: int, y: int, z: int):	
	var neighbors = [null, null, null, null]
	
	for n in range(4):
		var dir = neighbor_directions[n]
		
		for z_dir in [1, 0, -1]:
			var neighbor_data = get_tile(x + dir.x, y + dir.y, z + z_dir)
	
			if neighbor_data and neighbor_data.terrain_set != 3:
				var neighbor = Tile.new(neighbor_data, Vector3(x + dir.x, y + dir.y, z + z_dir))
				neighbors[n] = neighbor
				break
	
	return neighbors
	
func set_outline_tiles(tiles):
	for l in $Layers.get_children():
		l.get_node("OutlineLayer").clear()
	
	for t in tiles:
		if !t:
			continue
		var layer = $Layers.get_child(t.pos.z).get_node("OutlineLayer")
		
		var source_id = 1
		
		if t.data.terrain_set == 0:
			source_id = 2
		
		layer.set_cell(Vector2(t.pos.x, t.pos.y), source_id, Vector2i(0, 0))
	
# Convert tile coordinates to world position centered on the tile
func get_tile_center(x: int, y: int, z: int) -> Vector2:
	return $Layers.get_child(z).map_to_local(Vector2i(x, y)) * 3

func set_target_tile(tiles, target, curr):
	for l in $Layers.get_children():
		l.get_node("OutlineLayer").clear()
		
	for t in tiles:
		if !t:
			continue
		var layer = $Layers.get_child(t.pos.z).get_node("OutlineLayer")
		
		var source_id = 1
		
		if t.data.terrain_set == 0:
			source_id = 2
		
		layer.set_cell(Vector2(t.pos.x, t.pos.y), source_id, Vector2i(0, 0))
	
	var value
	var x = curr.current_tile.x
	var y = curr.current_tile.y

	if target.x - x == 0:
		if target.y - y == -1:
			value = 1
		else:
			value = 2
	else:
		if target.x - x == -1:
			value = 0
		else:
			value = 3

	if !tiles[value]:
		return
	var t = tiles[value]
	#for t in tiles:

	var layer = $Layers.get_child(t.pos.z).get_node("OutlineLayer")

	var source_id = 8

	if t.data.terrain_set == 0:
		source_id = 10

	layer.set_cell(Vector2(t.pos.x, t.pos.y), source_id, Vector2i(0, 0))
	
