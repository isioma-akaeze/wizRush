extends Area2D

onready var animation := $AnimationPlayer

func _process(delta):
	animation.play("New Anim")

func _on_Coin_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
