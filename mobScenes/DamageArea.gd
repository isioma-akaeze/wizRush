extends Area2D

onready var timer := $Timer

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

var bodyToKill : Node = null

func _on_body_entered(body: Node):
	if body.is_in_group("damagePlayer"):
		timer.start()
		bodyToKill = body
	return bodyToKill
		
func _on_body_exited(body: Node):
	if body.is_in_group("damagePlayer"):
		timer.stop()

func _on_Timer_timeout():
	bodyToKill.health -= 20
