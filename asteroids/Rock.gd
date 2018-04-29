extends RigidBody2D

var signal_name
var windowsize

func _ready():
	windowsize = get_viewport_rect().size

func _integrate_forces(state):
	# The rock will wrap around when it moves off the edge of the window
	var t = state.get_transform()
	t.origin.x = wrapf(t.origin.x, 0, windowsize.x)
	t.origin.y = wrapf(t.origin.y, 0, windowsize.y)
	state.set_transform(t)

func _on_Rock_body_entered(body):
	if body.is_in_group("bullets"):
		var pos = position
		body.queue_free()
		queue_free()
		emit_signal(signal_name, position)