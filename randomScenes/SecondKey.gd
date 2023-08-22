extends Area2D

onready var animation := $AnimationPlayer
var collected := false
onready var collectSound := $KeyCollect

func _process(delta):
	if !collected:
		animation.play("hover")
	elif collected:
		animation.stop()

func _on_SecondKey_body_entered(body):
	collected = true
	if body.is_in_group("player"):
		body.hasTrialKey = true
		set_process(false)
		animation.play("collect")
		collectSound.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()
