extends Button

func _on_Resume_pressed():
	get_tree().paused = false
	get_parent().get_parent().hide()

