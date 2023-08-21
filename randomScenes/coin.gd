extends Area2D
var collected := false

onready var animation := $AnimationPlayer
onready var collectSound := $CoinCollect

func _process(delta):
	if !collected:
		animation.play("New Anim")
	elif collected:
		animation.stop()

func _on_Coin_body_entered(body):
	if body.is_in_group("player"):
		collected = true
		body.coinCounter += 1
		set_process(false)
		animation.play("collect")
		collectSound.play()
		
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()
