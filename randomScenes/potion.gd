extends Area2D
onready var animation := $AnimationPlayer
onready var difficulty := get_node("/root/GlobalOptionButton")

func _process(delta):
	animation.play("New Anim")

func _on_Potion_body_entered(body):
	if body.is_in_group("player"):
		if difficulty.difficulty == 0:
			if body.health <= 75 and body.health > 0:
				body.health += 25
				queue_free()
			elif body.health > 75 and body.health < 100:
				body.health += (100 - body.health)
				queue_free()
			elif body.health >= 100:
				pass
		elif difficulty.difficulty == 1:
			if body.health <= 85 and body.health > 0:
				body.health += 15
				queue_free()
			elif body.health > 85 and body.health < 100:
				body.health += (100 - body.health)
				queue_free()
			elif body.health >= 100:
				pass
