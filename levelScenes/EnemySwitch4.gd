extends Area2D

var interacting := false

func _on_EnemySwitch4_body_entered(body):
	interacting = true
	if body.is_in_group("enemy"):
			body.switchingDirection = true
