extends Area2D

onready var timer := $Timer
var raySpeed := 210.0
var flipped = false
var rayTransform := Vector2(2,0)

func _ready():
	timer.start()

func _on_Ray_body_entered(body):
	if !body.is_in_group("player"):
		if is_instance_valid(body):
			if body.is_in_group("enemy") or body.is_in_group("passive"):
				body.health -= 15
				body.takingDamage = true
			queue_free()

func _on_Timer_timeout():
	queue_free()

func _process(delta):
	if flipped:
		position -= rayTransform * raySpeed * delta
	elif not flipped:
		position += rayTransform * raySpeed * delta


func _on_Ray_body_exited(body):
	if !body.is_in_group("player"):
		if is_instance_valid(body):
			if body.is_in_group("enemy") or body.is_in_group("passive"):
				body.takingDamage = false
