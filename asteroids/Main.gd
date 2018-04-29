extends Node2D

export (PackedScene) var Bullet
export (PackedScene) var BigRock
export (PackedScene) var MediumRock
export (PackedScene) var SmallRock
export (int) var ROCK_SPEED = 25
export (int) var BULLET_SPEED = 150
export (int) var MAX_ROCKS = 5

var num_rocks
var windowsize


func _ready():
	randomize()
	windowsize = get_viewport_rect().size
	num_rocks = 0
	
	for i in range(10):
		spawn_big_rock()

func shoot_bullet():
	if $ShootTimer.is_stopped():
		var player = get_node("Player")
		var playersize = get_node("Player/Sprite").get_texture().get_size()
		var bullet = Bullet.instance()
		
		# Offset the bullet to be at the tip of the ship.
		# How do we get the size of the player?
		bullet.position = player.position
		bullet.position += Vector2(playersize.x / 2 + 2, 0).rotated(player.rotation)
		
		# bullet's velocity is the player's + the shoot velocity
		var velocity = player.linear_velocity
		velocity += Vector2(BULLET_SPEED, 0).rotated(player.rotation)
		bullet.set_linear_velocity(velocity)
		
		add_child(bullet)
		
		$ShootTimer.start()

func random_pos_in_donut(center, inner_radius, outer_radius):
	# Returns a random position on a donut.
	# This lets us spawn random objects without spawning on top of the player.
	#
	#     * <-+ Outer radius
	#     *   |
	#     * <-+ Inner radius
	#         |
	#         + Center
	#      
	#     * 
	#     *
	#     *
	var offset = rand_range(inner_radius, outer_radius)
	var negative = rand_range(-1, 1) < 0
	if negative:
		return center - offset
	return center + offset

func spawn_big_rock():
	if num_rocks >= MAX_ROCKS:
		return
		
	num_rocks += 1
	
	# Select the position to spawn the rock
	var player = get_node("Player")
	var playersize = get_node("Player/Sprite").get_texture().get_size()

	var rock = BigRock.instance()
	rock.position = Vector2(
		random_pos_in_donut(player.position.x, playersize.x, windowsize.x),
		random_pos_in_donut(player.position.y, playersize.y, windowsize.y)
	)
	var rotation = randf(0, 2 * PI)
	rock.set_linear_velocity(Vector2(ROCK_SPEED, 0).rotated(rotation))
	rock.connect("big_rock_destroyed", self, "destroy_big_rock")
	
	print("spawn_big_rock ", num_rocks, ", ", rock.position)
	add_child(rock)
	
func spawn_medium_rock(center, angle):
	var rock = MediumRock.instance()
	var offset = Vector2(rand_range(10, 30), 0).rotated(angle)
	rock.position = center + offset
	
	rock.set_linear_velocity(Vector2(2 * ROCK_SPEED, 0).rotated(angle))
	rock.connect("medium_rock_destroyed", self, "destroy_medium_rock")

	print("spawn_medium_rock: ", rock.position)
	add_child(rock)
	
func spawn_small_rock(center, angle):
	var rock = SmallRock.instance()
	var offset = Vector2(rand_range(10, 30), 0).rotated(angle)
	rock.position = center + offset
	
	rock.set_linear_velocity(Vector2(3 * ROCK_SPEED, 0).rotated(angle))
#	rock.connect("small_rock_destroyed", self, "destroy_small_rock")

	print("spawn_small_rock: ", rock.position)
	add_child(rock)

func destroy_big_rock(pos):
	num_rocks -= 1
	print("destroy_big_rock: ", num_rocks, ", ", pos)
	spawn_medium_rock(pos, rand_range(0, 2 * PI / 3))
	spawn_medium_rock(pos, rand_range(2 * PI / 3, 4 * PI / 3))
	spawn_medium_rock(pos, rand_range(4 * PI / 3, 2 * PI))

func destroy_medium_rock(pos):
	print("destroy_medium_rock")
	spawn_small_rock(pos, rand_range(0, 2 * PI / 3))
	spawn_small_rock(pos, rand_range(2 * PI / 3, 4 * PI / 3))
	spawn_small_rock(pos, rand_range(4 * PI / 3, 2 * PI))

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		shoot_bullet()