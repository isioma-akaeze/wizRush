extends Area2D

onready var biteSound := get_parent().get_node("BiteSound")
onready var difficulty := get_node("/root/GlobalOptionButton")

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	if body.is_in_group("damagePlayer"):
		if not biteSound.is_playing() and body.health > 0:
			biteSound.play()
		if difficulty.difficulty == 0:
			body.health -= 25
		else:
			body.health -= 50
