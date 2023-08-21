extends Button

onready var clickSound := get_node("/root/GlobalMusicScene").get_node("ButtonClick")

func _on_Resume_pressed():
	clickSound.play()
	get_tree().paused = false
	get_parent().get_parent().hide()

