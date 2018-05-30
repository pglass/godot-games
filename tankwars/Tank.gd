extends Area2D

export (PackedScene) var Bullet
export (int) var MIN_POWER = 1
export (int) var MAX_POWER = 1000
export (int) var ROTATE_SPEED = 0.2
export (int) var POWER_DELTA = 1
var is_active_tank = true
var power = 100

func _ready():
	var windowsize = get_viewport_rect().size
	self.position.x = windowsize.x / 2
	self.position.y = windowsize.y / 2

	# The gun/turret is a Line2D. It points along the +x axis
	# so that the Line2D.rotation can be used as the angle to
	# at which bullets are fired.
	#
	# But we want the to point upwards initially, so we apply
	# this initial rotation.
	self.rotate_gun(-PI / 2)

func _process(delta):
	# If shift is pressed, move things more quickly
	var action_quickness = 1
	if Input.is_action_pressed("ui_shift_modifier"):
		action_quickness = 4

	# Rotate the turret
	var rot = 0
	if Input.is_action_pressed("ui_left"):
		rot -= 1
	if Input.is_action_pressed("ui_right"):
		rot += 1
	self.rotate_gun(rot * action_quickness * ROTATE_SPEED * delta)

	# Increase/decrease power
	if Input.is_action_pressed("ui_up"):
		self.power = clamp(self.power + POWER_DELTA * action_quickness, MIN_POWER, MAX_POWER)
	if Input.is_action_pressed("ui_down"):
		self.power = clamp(self.power - POWER_DELTA * action_quickness, MIN_POWER, MAX_POWER)

	# Fire a bullet
	if Input.is_action_just_pressed("ui_accept"):
		var bullet = Bullet.instance()
		bullet.position = $Line2D.points[1].rotated($Line2D.rotation)
		var impulse = Vector2(self.power, 0).rotated($Line2D.rotation)
		bullet.apply_impulse(Vector2(), impulse)
		add_child(bullet)

func rotate_gun(d_angle):
	$Line2D.rotate(d_angle)