extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
onready var timer := get_parent().get_node("ButtonTimer")

func _on_Quit_Program_Button_pressed():
	clickSound.play()
	timer.start()

func _on_ButtonTimer_timeout():
	get_tree().quit()
