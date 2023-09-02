extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
var timer := Timer.new()


func _ready():
	add_child(timer)
	timer.wait_time = 0.375
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	
func _on_timer_timeout():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_ResumeDie2_pressed():
	clickSound.play()
	timer.start()
