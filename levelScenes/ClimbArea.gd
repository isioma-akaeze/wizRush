extends Area2D
var interacting := false

func _on_ClimbArea_body_entered(body):
	interacting = true
	if body.is_in_group("climber"):
			body.climbing = true
			body.CLIMB_GRAVITY *= 2
			body.GRAVITY /= 3


func _on_ClimbArea_body_exited(body):
	interacting = false
	if body.is_in_group("climber"):
			body.climbing = false
			body.CLIMB_GRAVITY /= 2
			body.GRAVITY *= 3
