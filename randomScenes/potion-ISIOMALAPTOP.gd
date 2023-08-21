extends Area2D
onready var animation := $AnimationPlayer
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var healSound := $HealUp
var collected := false

func _process(delta):
	if !collected:
		animation.play("New Anim")
	elif collected:
		animation.stop()

func _on_Potion_body_entered(body):
	if body.is_in_group("player"):
		if difficulty.difficulty == 0:
			if body.health <= 75 and body.health > 0:
				body.health += 25
				animation.play("collect")
				healSound.play()
				set_process(false)
			elif body.health > 75 and body.health < 100:
				body.health += (100 - body.health)
				animation.play("collect")
				healSound.play()
				set_process(false)
			elif body.health >= 100:
				pass
		elif difficulty.difficulty == 1:
			if body.health <= 85 and body.health > 0:
				body.health += 15
				animation.play("collect")
				healSound.play()
				set_process(false)
			elif body.health > 85 and body.health < 100:
				body.health += (100 - body.health)
				animation.play("collect")
				healSound.play()
				set_process(false)
			elif body.health >= 100:
				pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()
