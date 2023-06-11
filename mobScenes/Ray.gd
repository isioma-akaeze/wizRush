extends Area2D

onready var timer := $Timer
var raySpeed := 150.0
var flipped = false

func _ready():
	timer.start()

func _on_Ray_body_entered(body):
	if !body.is_in_group("player"):
		if body.is_in_group("enemy"):
			body.health -= 20
		queue_free()

func _on_Timer_timeout():
	queue_free()

func _process(delta):
	if flipped:
		position -= transform.x * raySpeed * delta
	elif not flipped:
		position += transform.x * raySpeed * delta
