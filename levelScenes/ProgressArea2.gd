extends Area2D

onready var lockSound := $KeyLocked
onready var unlockSound := $KeyUnlocked

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.is_in_group("canWin"):
		if body.hasTrialKey == true:
			unlockSound.play()
			pass
			
		elif body.hasTrialKey != true:
			lockSound.play()
			body.passageBlocked = true
			body.position.x -= 135
