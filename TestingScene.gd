extends Node2D

onready var difficulty := get_node("/root/GlobalOptionButton")

func _ready():
	difficulty.difficulty = 1
