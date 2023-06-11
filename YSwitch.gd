extends Area2D

func _on_YSwitch_body_entered(body):
	if body.is_in_group("passive") or body.is_in_group("enemy"):
		body.switchingY = true
		
