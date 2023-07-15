extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
onready var timer := get_parent().get_node("ButtonTimer2")

func _on_Settings_Button_pressed():
	clickSound.play()
	timer.start()
	
func _on_ButtonTimer2_timeout():
	get_tree().change_scene("Settings.tscn")
