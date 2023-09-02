extends KinematicBody2D

onready var animation := $GeneralAnimation
onready var biteSound := $BiteSound
onready var bossMusic := $BossMusic

func _ready():
	animation.play("bite")
	bossMusic.stop()
	
#func _process(delta):
#	if animation.current_animation == "bite":
#		var anim_time = animation.current_animation_position #/ animation.current_animation_length
#		if (anim_time > 0 and anim_time < 1 or anim_time > 2 and anim_time < 3 or anim_time > 4 and anim_time < 5 or anim_time > 6 and anim_time < 7 or anim_time > 7) and biteSound.is_playing():
#			biteSound.play()
#			print("true")	
#		elif anim_time in [1, 3, 5, 7]:
#			print("false")
#			biteSound.stop()
#	else:
#		biteSound.stop()
	
func _on_GeneralAnimation_animation_finished(anim_name):
	if anim_name == "bite":
		animation.play("bite")

func _on_BubbleArea_body_entered(body):
	if body.is_in_group("player"):
		body.position.y -= 5

func _on_BossArea_body_entered(body):
	if body.is_in_group("player"):
		body.attackingBoss = true
		if !bossMusic.is_playing():
			bossMusic.play()

func _on_BossArea_body_exited(body):
	if body.is_in_group("player"):
		body.attackingBoss = false
		bossMusic.stop()

func _on_BubbleArea_body_exited(body):
	if body.is_in_group("player"):
		pass

func _on_TeethArea_body_entered(body):
	if body.is_in_group("player"):
		body.health -= 100
	
