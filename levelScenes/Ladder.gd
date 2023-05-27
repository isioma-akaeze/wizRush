extends Area2D
var interacting := false

func _physics_process(delta):
	print("Interacting? " + str(interacting))

func _on_Ladder_body_entered(body):
	interacting = true
	if body.is_in_group("climber"):
			body.climbing = true
		


func _on_Ladder_body_exited(body):
	interacting = false
	if body.is_in_group("climber"):
			body.climbing = false
