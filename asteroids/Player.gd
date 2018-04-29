extends RigidBody2D

export (int) var ACCELERATION = 100
export (int) var MAX_SPEED = 250
export (int) var ROTATE_SPEED = 3
var windowsize

var thrust = Vector2(250, 0)

func _ready():
	windowsize = get_viewport_rect().size
	position.x = windowsize.x / 2
	position.y = windowsize.y / 2

func _integrate_forces(state):
	var t = state.get_transform()
	t.origin.x = wrapf(t.origin.x, 0, windowsize.x)
	t.origin.y = wrapf(t.origin.y, 0, windowsize.y)
	state.set_transform(t)
	
	var rot = 0
	if Input.is_action_pressed("ui_left"):
		rot -= 1
	if Input.is_action_pressed("ui_right"):
		rot += 1
	set_applied_torque(rot * 1500)
	
	if linear_velocity.length() < MAX_SPEED and Input.is_action_pressed("ui_up"):
		set_applied_force(thrust.rotated(rotation))
	else:
		set_applied_force(Vector2())