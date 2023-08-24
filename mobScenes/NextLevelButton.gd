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
	grab_focus()

func _on_timer_timeout():
	get_tree().paused = false
	get_tree().change_scene("res://LevelSelect.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		grab_focus()
	elif Input.is_action_just_pressed("ui_down"):
		grab_focus()
