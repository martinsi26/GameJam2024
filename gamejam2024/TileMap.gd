extends TileMapLayer

const blue_block_atlas_pos = Vector2i(0, 0)
const main_source = 0

func _ready():
	for y in range(3):
		for x in range(3):
			set_cell(Vector2i(10 + x, 0 + y), main_source, blue_block_atlas_pos)

#func _process(delta):
	#var moused_over_tile = local_to_map(get_global_mouse_position() / scale)
	#set_cell(moused_over_tile, main_source, blue_block_atlas_pos)
