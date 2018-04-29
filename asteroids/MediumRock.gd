extends "res://Rock.gd"

signal medium_rock_destroyed

func _ready():
	._ready()
	self.signal_name = "medium_rock_destroyed"