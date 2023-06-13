extends Area2D

onready var timer := $Timer
var raySpeed := 150.0
var flipped = false
var rayTransform := Vector2(2,0)

func _ready():
	timer.start()

func _on_Ray_body_entered(body):
	if !body.is_in_group("player"):
		if body.is_in_group("enemy") or body.is_in_group("passive"):
			body.queue_free()
		queue_free()

func _on_Timer_timeout():
	queue_free()

func _process(delta):
	if flipped:
		print(transform.x)
		position -= rayTransform * raySpeed * delta
	elif not flipped:
		print(transform.x)
		position += rayTransform * raySpeed * delta
