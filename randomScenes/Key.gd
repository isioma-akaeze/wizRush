extends Area2D

onready var animation := $AnimationPlayer
onready var keyCollectSound := $KeyCollect
var collected := false

func _process(delta):
	if !collected:
		animation.play("hover")
	elif collected:
		animation.stop()
	
func _on_Key_body_entered(body):
	if body.is_in_group("player"):
		collected = true
		body.hasKey = true
		set_process(false)
		animation.play("collect")
		keyCollectSound.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()
