extends RigidBody2D

var windowsize

func _ready():
	add_to_group("bullets")
	windowsize = get_viewport_rect().size
	
	# Bullet's only life for a short duration
	$LifeTimer.start()
	$LifeTimer.connect("timeout", self, "_timeout")
	
func _timeout():
	self.queue_free()

func _integrate_forces(state):
	# note: use of _integrate_forces allows us to safely change
	# physics state.
	var t = state.get_transform()
	t.origin.x = wrapf(t.origin.x, 0, windowsize.x)
	t.origin.y = wrapf(t.origin.y, 0, windowsize.y)
	state.set_transform(t)