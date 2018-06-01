extends RigidBody2D

#export (float) var GRAVITY = 4.9
export (int) var MIN_BLOCK_SIZE = 2
var block_size setget set_block_size
var windowsize

func _ready():
	add_to_group("blocks")
	windowsize = get_viewport_rect().size
	
	$FallTimer.connect("timeout", self, "to_static_mode")

func set_block_size(size):
	# note: minus a sliver so objects slide down past each other smoothly
	block_size = size - 0.01
	var w = block_size / 2.0
	$Polygon2D.polygon = [Vector2(-w, -w), Vector2(w, -w), Vector2(w, w), Vector2(-w, w)]
	$CollisionShape2D.get_shape().set_extents(Vector2(w, w))
	
func better_duplicate():
	var block = duplicate()
	# for some reason the shape is not duplicated??
	block.get_node("CollisionShape2D").shape = block.get_node("CollisionShape2D").shape.duplicate()
	return block
	
func split():
	if block_size > MIN_BLOCK_SIZE:
		for i in range(0,2):
			for y_pos in [position.y - block_size / 4, position.y + block_size / 4]:
				var block = self.better_duplicate()
				block.set_block_size(block_size / 2)
				block.set_position(Vector2(position.x - block_size / 4 + i * (block_size / 2), y_pos))
				get_parent().add_child(block)
	queue_free()

func _integrate_forces(state):
	if position.y + block_size / 2 <= windowsize.y:
		my_move_and_collide(state, Vector2(0, 5))
		
func to_static_mode():
	mode = MODE_STATIC

# Only KinematicBody2D has `move_and_collide`
# This our own version for a RigidBody2D
func my_move_and_collide(state, motion):
	if not test_motion(motion, 0.0):
		var t = state.get_transform()
#		print(t.origin)
		t.origin += motion
		state.set_transform(t)
#		print(state.get_transform().origin)

#func _on_Block_body_entered(body):
#	print("_on_Block_body_entered")
