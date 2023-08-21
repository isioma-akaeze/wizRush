extends Button

onready var clickSound := get_parent().get_node("ButtonClick")

func _on_Start_Button_pressed():
	clickSound.play()
	get_tree().change_scene("res://levelScenes/Green Groves.tscn")
