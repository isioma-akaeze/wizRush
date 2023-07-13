extends Area2D

onready var timer := $Timer
onready var box := $CollisionShape2D
onready var difficulty := get_node("/root/GlobalOptionButton")

func _process(delta) -> void:
	var beeParent : float = get_parent().get_parent().health
	if beeParent > 0:
		box.set_deferred("disabled", false)
	elif beeParent <= 0:
		box.set_deferred("disabled", true)

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
		body.takingDamage = false

func _on_Timer_timeout():
	var beeParent : float = get_parent().get_parent().health
	if beeParent > 0 and difficulty.difficulty == 0:
		bodyToKill.health -= 20
		bodyToKill.takingDamage = true
	elif beeParent > 0 and difficulty.difficulty == 1:
		bodyToKill.health -= 35
		bodyToKill.takingDamage = true
