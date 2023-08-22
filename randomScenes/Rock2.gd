extends Sprite

onready var animation := $AnimationPlayer
onready var wobbleSound := $StoneWobble

func _on_Area2D_body_entered(body):
	if body.is_in_group("damageEnemy"):
		if not animation.is_playing():
			animation.play("wobble")
		wobbleSound.play()
