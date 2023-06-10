extends Area2D
onready var animation := $AnimationPlayer

func _process(delta):
	animation.play("New Anim")

func _on_Potion_body_entered(body):
	if body.is_in_group("player"):
		if body.health <= 75:
			body.health += 25
			queue_free()
		elif body.health > 75 and body.health < 100:
			body.health += (100 - body.health)
			queue_free()
		elif body.health >= 100:
			pass
