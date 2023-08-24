extends Area2D

onready var timer := $Timer

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.is_in_group("canWin"):
		if body.hasKey == true:
			body.hasWon = true
			timer.start()
			
		elif body.hasKey != true:
			body.passageBlocked = true
			body.position.x -= 135

func _on_Timer_timeout():
	pass
