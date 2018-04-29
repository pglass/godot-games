extends "res://Rock.gd"

signal small_rock_destroyed

func _ready():
	._ready()
	self.signal_name = "small_rock_destroyed"