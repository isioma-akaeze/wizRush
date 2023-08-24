extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
onready var levelCheck := get_node("/root/LevelCheck")

func _on_Play2_pressed():
	clickSound.play()
	if levelCheck.levelsCompleted > 0:
		get_tree().change_scene("res://levelScenes/Ash Apocalypse.tscn")
