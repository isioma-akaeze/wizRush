extends Area2D
var interacting := false

func _on_EnemySwitch2_body_entered(body):
	interacting = true
	if body.is_in_group("enemy") or body.is_in_group("passive"):
			body.switchingDirection = false
