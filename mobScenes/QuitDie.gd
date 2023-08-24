extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
var timer := Timer.new()

func _on_QuitDie_pressed():
	get_tree().paused = false
	timer.start()
	clickSound.play()

func _ready():
	add_child(timer)
	timer.wait_time = 0.375
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	
func _on_timer_timeout():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")
