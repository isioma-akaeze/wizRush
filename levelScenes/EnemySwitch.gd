extends Area2D

var interacting := false

func _on_EnemySwitch_body_entered(body):
	interacting = true
	if body.is_in_group("enemy"):
			body.switchingDirection = true
			
#func _on_EnemySwitch_body_exited(body):
#	interacting = false
#	if body.is_in_group("enemy"):
#			body.switchingDirection = false
