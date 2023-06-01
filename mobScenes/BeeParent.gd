extends Node2D

onready var deathArea := $EnemyBody/DeathArea

func _on_DeathArea_body_entered(body):
	if body.is_in_group("damageEnemy"):
		if Input.is_action_pressed("attack"):
			queue_free()
