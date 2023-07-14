extends Area2D

onready var animation := get_parent().get_node("AnimationPlayer")
var broken := false

func _on_Bush1_body_entered(body):
	if body.is_in_group("damageEnemy"):
		broken = true
		set_physics_process(false)
		animation.play("break")
		
func _physics_process(delta) -> void:
	if !broken:
		animation.play("wind")
	elif broken:
		animation.stop()
		

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "wind":
		print(anim_name)
		get_parent().queue_free()
