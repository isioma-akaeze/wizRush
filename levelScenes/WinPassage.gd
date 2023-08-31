extends Area2D

onready var timer := $Timer
onready var winSound := $WinSound
var winCheck := false
var bodyX : Node = null

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.is_in_group("canWin"):
		if body.hasKey == true:
			if not winSound.is_playing() and winCheck == false:
				winCheck = true
				winSound.play()
				bodyX = body
			return bodyX
			
		elif body.hasKey != true:
			body.passageBlocked = true
			body.position.x -= 135

func _on_Timer_timeout():
	pass

func _on_WinSound_finished():
	if bodyX != null:
		bodyX.hasWon = true
