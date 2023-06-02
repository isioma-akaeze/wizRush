extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	if body.is_in_group("damagePlayer"):
		body.health -= 100

