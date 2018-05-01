extends Area2D

var OFF_COLOR = Color(0.6, 0.6, 0.6)
var ON_COLOR = Color(0.8, 0.1, 0.1)
var index = [-1, -1]

signal space_pressed

func _ready():
	set_color(OFF_COLOR)

func _input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton
		and event.button_index == BUTTON_LEFT
		and event.is_pressed()):
			emit_signal("space_pressed", self.index[0], self.index[1])

func get_color():
	return $Polygon2D.color

func set_color(color):
	$Polygon2D.color = color

func is_off():
	return get_color() == OFF_COLOR

func toggle_color():
	if is_off():
		set_color(ON_COLOR)
	else:
		set_color(OFF_COLOR)