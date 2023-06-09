extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.is_in_group("canWin"):
		if body.hasTrialKey == true:
			pass
			
		elif body.hasTrialKey != true:
			body.passageBlocked = true
			body.position.x -= 135
