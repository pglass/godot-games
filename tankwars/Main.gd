extends Node2D

export (PackedScene) var Tank
var windowsize

func _ready():
	randomize()
	windowsize = get_viewport_rect().size

	# So we spawn the tank after the terrain has spawned
	$TankSpawnTimer.connect("timeout", self, "spawn_tank")
	
func spawn_tank():
	# Spawn the tank at random location
	var tank = Tank.instance()
	var tank_size = tank.get_node("CollisionShape2D").get_shape().extents.x
	var x = rand_range(tank_size / 2, windowsize.x - tank_size / 2)
	tank.position.x = x
	tank.position.y = 0
	add_child(tank)