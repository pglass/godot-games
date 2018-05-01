extends Node2D

export (PackedScene) var LightShape
export (int) var SIZE = 5

# Can we grab the size from the LightShape directly?
var SHAPE_SIZE = 20
var MARGIN = 5
# These spaces are highlighted initially
var SCENARIO = [
	[0, 2], [2, 2], [4, 2]
]
var shapes
signal victory

func _ready():
	self.connect("victory", self, "on_victory")
	create_scene()
	setup_scenario()

func create_scene():
	self.shapes = []
	for i in range(5):
		self.shapes.append([])
		for j in range(5):
			var shape = create_light_shape(i, j)
			self.shapes[i].append(shape)
			assert self.shapes[i][j] == shape

func setup_scenario():
	for index in SCENARIO:
		var shape = self.shapes[index[0]][index[1]]
		shape.toggle_color()

func create_light_shape(i, j):
	# note: Using i + 1 to offset shape centered at origin
	# into the viewport
	var x = (i + 1) * (SHAPE_SIZE + MARGIN)
	var y = (j + 1) * (SHAPE_SIZE + MARGIN)
	var shape = LightShape.instance()
	shape.position.x = x
	shape.position.y = y
	shape.index = [i, j]
	shape.connect("space_pressed", self, "press_space")
	add_child(shape)
	return shape

func press_space(i, j):
	# Called when a space is toggled.
	# We will toggle each adjacent space as well.
	toggle_shape(i, j)
	toggle_shape(i + 1, j)
	toggle_shape(i - 1, j)
	toggle_shape(i, j + 1)
	toggle_shape(i, j - 1)
	check_victory_condition()

func toggle_shape(i, j):
	# Toggle one space, or do nothing if index out of bounds
	if (0 <= i and i < len(self.shapes)
		and 0 <= j and j < len(self.shapes[i])):
		self.shapes[i][j].toggle_color()

func check_victory_condition():
	for col in self.shapes:
		for shape in col:
			if not shape.is_off():
				return
	emit_signal("victory")

func on_victory():
	$Label.text = "You win!"