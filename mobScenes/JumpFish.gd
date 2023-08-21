extends KinematicBody2D

onready var animation := $AnimationPlayer
onready var timer := $Timer
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var splashSound := $WaterSplash

func _ready():
	if difficulty.difficulty == 0:
		animation.play("jump")
		splashSound.pitch_scale = 0.84
		splashSound.play()
		animation.playback_speed = 1.05
	elif difficulty.difficulty == 1:
		animation.play("jump")
		splashSound.pitch_scale = 1
		splashSound.play()
		animation.playback_speed = 1
func _on_AnimationPlayer_animation_finished(anim_name):
	splashSound.stop()
	splashSound.pitch_scale = 0.21
	splashSound.play()
	timer.start()

func _on_Timer_timeout():
	if difficulty.difficulty == 0:
		animation.play("jump")
		splashSound.pitch_scale = 0.84
		splashSound.play()
		animation.playback_speed = 0.8
	elif difficulty.difficulty == 1:
		animation.play("jump")
		splashSound.pitch_scale = 1.05
		splashSound.play()
		animation.playback_speed = 1
