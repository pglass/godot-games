extends RigidBody2D

export (PackedScene) var Explosion

func _ready():
	add_to_group("bullets")

func _on_Bullet_body_entered(body):
	if body.is_in_group("blocks"):
#		print(body)
		body.split()
		var explosion = Explosion.instance()
		explosion.position = position
		get_parent().add_child(explosion)
		queue_free()
