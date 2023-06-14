extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.hasDemoKey == true:
			pass
			
		elif body.hasDemoKey != true:
			body.passageBlocked = true
			body.global_position.y -= 40
	if body.is_in_group("passive"):
		body.global_position.y -= 150
		if body.randomY < 0:
			body.randomY *= -1
