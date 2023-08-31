extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
var timer := Timer.new()

func _on_NextLevelButton_pressed():
	clickSound.play()
	timer.start()

func _ready():
	add_child(timer)
	timer.wait_time = 0.375
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	if get_parent().get_parent().get_parent().hasWon == true:
		grab_focus()

func _on_timer_timeout():
	get_tree().paused = false
	get_tree().change_scene("res://LevelSelect.tscn")

