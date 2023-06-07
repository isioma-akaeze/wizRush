extends Area2D
var interacting := false

func _on_ClimbArea_body_entered(body):
	interacting = true
	if body.is_in_group("climber"):
			body.climbing = true
			body.CLIMB_GRAVITY *= (7/3)
			body.GRAVITY /= 2


func _on_ClimbArea_body_exited(body):
	interacting = false
	if body.is_in_group("climber"):
			body.climbing = false
			body.CLIMB_GRAVITY /= (7/3)
			body.GRAVITY *= 2
