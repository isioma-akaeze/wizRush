extends Area2D

onready var animation := $AnimationPlayer

func _process(delta):
	animation.play("hover")
	
func _on_DemoKey_body_entered(body):
	if body.is_in_group("player"):
		body.hasDemoKey = true
		queue_free()
