extends Area2D

onready var lockSound := $KeyLocked
onready var unlockSound := $KeyUnlocked

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.hasKey == true:
			if !unlockSound.is_playing():
				unlockSound.play()
			
		elif body.hasKey != true:
			if !lockSound.is_playing():
				lockSound.play()
			body.passageBlocked = true
			body.global_position.x -= 20
	if body.is_in_group("passive"):
		body.global_position.y -= 150
		if body.randomY < 0:
			body.randomY *= -1
