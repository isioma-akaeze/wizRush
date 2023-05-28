extends Area2D

var interacting := false #Leftover for testing,

func _on_FinalLadder_body_entered(body):
	interacting = true
	if body.is_in_group("climber"): #If body matches group signal...
			body.climbing = true 

func _on_FinalLadder_body_exited(body):
	interacting = false
	if body.is_in_group("climber"): #If body matches group signal...
			body.climbing = false
