extends Button

onready var clickSound := get_parent().get_node("ButtonClick")
onready var timer := Timer.new()
onready var levelCheck := get_node("/root/LevelCheck")

func _ready():
	add_child(timer)
	timer.wait_time = 0.375
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	
func _on_Play3_pressed():
	clickSound.play()
	if levelCheck.levelsCompleted > 1:
		timer.start()
	
func _on_timer_timeout():
	get_tree().change_scene("res://levelScenes/Dire Depths.tscn")
