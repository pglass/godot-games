extends RigidBody2D

export (Color) var EXPLOSION_COLOR = Color(0.8, 0.2, 0.3)
export (int) var MIN_SIZE = 1
export (int) var MAX_SIZE = 20
export (int) var GROWTH_RATE = 15

func _ready():
	_set_radius(MIN_SIZE)
	
func _get_radius():
	return $CollisionShape2D.shape.radius

func _set_radius(radius):
	$CollisionShape2D.shape.radius = radius

func _draw():
	# drawing is relative to the current node
	# note: `+ 2` is a margin to cover up some empty space
	draw_circle(Vector2(0, 0), _get_radius() + 2, EXPLOSION_COLOR)

func _physics_process(delta):
	_set_radius(clamp(_get_radius() + GROWTH_RATE * delta, MIN_SIZE, MAX_SIZE))
	# need update() so that _draw() is called again
	update()
	
	if _get_radius() >= MAX_SIZE:
		queue_free()

func _on_Explosion_body_entered(body):
	if body.is_in_group("blocks"):
		body.split()
