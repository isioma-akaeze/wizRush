extends Sprite

onready var animation := $AnimationPlayer
onready var breakSound := $BushBreak
var broken := false

func _physics_process(delta):
	if !broken:
		animation.play("wind")
	elif broken:
		animation.stop()
		
func _on_Area2D_body_entered(body):
	if body.is_in_group("damageEnemy"):
		broken = true
		set_physics_process(false)
		animation.play("break")
		breakSound.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "break":
		queue_free()
