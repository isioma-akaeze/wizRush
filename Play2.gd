extends Button

onready var clickSound := get_parent().get_node("ButtonClick")

func _on_Play2_pressed():
	clickSound.play()
	get_tree().change_scene("res://levelScenes/Ash Apocalypse.tscn")
