extends Area2D
var interacting := false

func _on_ClimbArea_body_entered(body):
	interacting = true
	if body.is_in_group("climber"):
			body.climbing = true
			body.CLIMB_GRAVITY *= 1.25
			body.canSlip = true
			body.GRAVITY /= 3


func _on_ClimbArea_body_exited(body):
	interacting = false
	if body.is_in_group("climber"):
			body.climbing = false
			body.canSlip = false
			body.CLIMB_GRAVITY /= 1.25
			body.GRAVITY *= 3
