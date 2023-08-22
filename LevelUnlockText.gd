extends RichTextLabel

var levelsUnlocked := 0
onready var animation := $AnimationPlayer

func _ready():
	self.hide()

func _on_Play2_pressed():
	if levelsUnlocked > 0:
		self.show()
		if not animation.is_playing():
			animation.play("fadeAway")

func _on_AnimationPlayer_animation_finished(anim_name):
	self.hide()

func _on_Play3_pressed():
	if levelsUnlocked > 1:
		self.show()
		if not animation.is_playing():
			animation.play("fadeAway")
