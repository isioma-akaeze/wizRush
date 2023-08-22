extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
onready var timer := Timer.new()

func _ready():
	add_child(timer)
	timer.wait_time = 0.375
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	
func _on_Play3_pressed():
	clickSound.play()
	timer.start()
	
func _on_timer_timeout():
	get_tree().change_scene("res://levelScenes/Dire Depths.tscn")
