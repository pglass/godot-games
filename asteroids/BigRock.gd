extends "res://Rock.gd"

signal big_rock_destroyed

func _ready():
	._ready()
	self.signal_name = "big_rock_destroyed"