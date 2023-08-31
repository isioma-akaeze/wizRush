extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
onready var timer := get_parent().get_node("ButtonTimer3")

func _on_Credits_Button_pressed():
	clickSound.play()
	timer.start()
	
func _on_ButtonTimer3_timeout():
	get_tree().change_scene("Credits.tscn")
