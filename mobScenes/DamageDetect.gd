extends Area2D

func _on_DamageDetect_body_entered(body):
	if body.is_in_group("damageEnemy"):
		body.queue_free()
