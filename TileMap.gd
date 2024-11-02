extends TileMapLayer

enum layers {
	level0 = 0,
	level1 = 1,
	level2 = 2
}

const blue_block_atlas_pos = Vector2i(0, 0)
const main_source = 0

func _ready():
	for y in range(3):
		for x in range(3):
			set_cell(Vector2i(10 + x, 0 + y), main_source, blue_block_atlas_pos)
