extends Node2D

export (PackedScene) var Block
export (int) var BLOCK_SIZE = 16
var windowsize

func _ready():
	randomize()
	windowsize = get_viewport_rect().size
	
	var max_blocks_in_column = windowsize.y / BLOCK_SIZE
	
	for x in range(BLOCK_SIZE / 2, windowsize.x + BLOCK_SIZE / 2, BLOCK_SIZE):
		var n_blocks_in_column = int(rand_range(1, max_blocks_in_column - 1))
		for y in range(0, BLOCK_SIZE * n_blocks_in_column, BLOCK_SIZE):
			spawn_block(x, y)
				
func spawn_block(x, y):
	var block = Block.instance()
	block.set_block_size(BLOCK_SIZE)
	block.position.x = x
	block.position.y = y
	add_child(block)