extends Node2D

export (Color) var TERRAIN_COLOR = Color(0.2, 0.8, 0.2)
export (Color) var CLEAR_COLOR = Color(0, 0, 0, 0)
var windowsize
var image
var texture

func _ready():
	windowsize = get_viewport_rect().size
	print(windowsize)
	
	image = Image.new()
	image.create(windowsize.x, windowsize.y, false, Image.FORMAT_RGBA8)
	
	var fill_amount = rand_range(0.2, 0.8)
	
	image.lock()
	for x in range(0, windowsize.x):
		for y in range(0, windowsize.y):
			if rand_range(0, 1) <= fill_amount:
				image.set_pixel(x, y, TERRAIN_COLOR)
			else:
				image.set_pixel(x, y, CLEAR_COLOR)
	image.unlock()
#	print(len(terrain))
	
	texture = ImageTexture.new()
	texture.create_from_image(image, 0)

func terrain_fall():
	var fall_speed = 2
	image.lock()
	var changed = false
	for x in range(windowsize.x):
		
		var y = windowsize.y - 1
		while y >= fall_speed:
			# If the space empty
			if image.get_pixel(x, y) != TERRAIN_COLOR:
				
				# Search for non-empty pixel in the above 2 spaces
				var iy = y
				while image.get_pixel(x, iy) != TERRAIN_COLOR and y - iy < fall_speed:
					iy -= 1
					
				# If we found a non-empty pixel, drop it into the empty space
				if image.get_pixel(x, iy) == TERRAIN_COLOR:
					image.set_pixel(x, y, TERRAIN_COLOR)
					image.set_pixel(x, iy, CLEAR_COLOR)
					changed = true
					y = iy
			y -= 1

	image.unlock()
	return changed

func _draw():
	draw_texture(texture, Vector2(0, 0))

func _process(delta):
	if terrain_fall():
		texture.set_data(image)
		update()
#	print(Engine.get_frames_per_second())
	