extends Area2D

onready var timer := $WinTimer
onready var winText := $WinText

func _ready():
	winText.hide()
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.is_in_group("canWin"):
		if body.hasKey == true:
			winText.rect_position.x = body.global_position.x - 60
			winText.show()
			timer.start()
			
		elif body.hasKey != true:
			print("Passage locked.")
			body.position.x -= 135

func _on_WinTimer_timeout():
	winText.hide()
	get_tree().change_scene("res://levelScenes/Ash Apocalypse.tscn")
	#get_tree().quit()
