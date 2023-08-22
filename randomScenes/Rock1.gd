extends Sprite

onready var animation := $AnimationPlayer
onready var breakSound := $StoneBreak
		
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "break":
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("damageEnemy"):
		animation.play("break")
		breakSound.play()
