extends Area2D

func _on_enemyJump_body_entered(body):
	if body.is_in_group("enemy"):
		body.hasToJump = true


func _on_enemyJump_body_exited(body):
	if body.is_in_group("enemy"):
		body.hasToJump = false
