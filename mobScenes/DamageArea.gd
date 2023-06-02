extends Area2D

onready var timer := $Timer
onready var bee := $EnemyBody

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	

var bodyToKill : Node = null

func _on_body_entered(body: Node):
	print(get_parent().get_parent().health)
	if body.is_in_group("damagePlayer"):
		timer.start()
		bodyToKill = body
	return bodyToKill
		
func _on_body_exited(body: Node):
	if body.is_in_group("damagePlayer"):
		timer.stop()
		body.takingDamage == false

func _on_Timer_timeout():
	var beeParent : float = get_parent().get_parent().health
	if beeParent > 0:
		bodyToKill.health -= 20
		bodyToKill.takingDamage == true
