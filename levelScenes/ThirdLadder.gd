extends Area2D

var interacting := false

func _on_ThirdLadder_body_entered(body):
	interacting = true
	if body.is_in_group("climber"):
			body.climbing = true

func _on_ThirdLadder_body_exited(body):
	interacting = false
	if body.is_in_group("climber"):
			body.climbing = false
