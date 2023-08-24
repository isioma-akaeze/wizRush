extends Area2D

onready var timer := $WinTimer
onready var lockSound := $KeyLocked
onready var unlockSound := $KeyUnlocked

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.is_in_group("canWin"):
		if body.hasKey == true:
			body.hasWon = true
			unlockSound.play()
			timer.start()
			
		elif body.hasKey != true:
			body.passageBlocked = true
			body.position.x -= 135
			lockSound.play()

func _on_WinTimer_timeout():
	pass
