extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	if body.is_in_group("canWin"):
		if body.hasKey == true:
			print("LEVEL COMPLETED!")
			get_tree().quit()
		elif body.hasKey != true:
			body.position.x -= 135
			
