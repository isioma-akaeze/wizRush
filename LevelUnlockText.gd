extends RichTextLabel

onready var animation := $AnimationPlayer
onready var levelCheck := get_node("/root/LevelCheck")

func _ready():
	self.hide()

func _on_Play2_pressed():
	if levelCheck.levelsCompleted < 1:
		self.show()
		if not animation.is_playing():
			animation.play("fadeAway")

func _on_AnimationPlayer_animation_finished(anim_name):
	self.hide()

func _on_Play3_pressed():
	if levelCheck.levelsCompleted < 2:
		self.show()
		if not animation.is_playing():
			animation.play("fadeAway")
