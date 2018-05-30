extends Area2D

var SCALE_DELTA = 0.1
var size = 64
var min_size = 2

func _ready():
	if size == 64:
		var windowsize = get_viewport_rect().size
		position.x = windowsize.x / 2
		position.y = windowsize.y / 2

func split():
	if size <= min_size:
		return
	var count = 0
	for i in range(0,2):
		for y_pos in [position.y - size / 4, position.y + size / 4]:
			# The top row
			var block = duplicate()
			block.size = size / 2
			block.set_scale(get_scale() / 2)
			block.set_position(Vector2(position.x - size / 4 + i * (size / 2), y_pos))
			block.get_node("Polygon2D").color = Color(count % 4 / 4.0, 1 - count % 4 / 4.0, 0)
			get_parent().add_child(block)
			count += 1

func _process(delta):
	var scale_amt = 1
	if Input.is_action_just_pressed("ui_accept"):
		print(position, " ", size)
	if Input.is_action_just_pressed("ui_up"):
		split()
		queue_free()
	if Input.is_action_just_pressed("ui_down"):
		scale_amt -= SCALE_DELTA

#	print(scale_amt)
	apply_scale(Vector2(scale_amt, scale_amt))