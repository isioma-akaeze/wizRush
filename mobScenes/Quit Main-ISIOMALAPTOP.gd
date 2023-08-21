extends Button

var timer:= Timer.new()
onready var clickSound := get_node("/root/GlobalMusicScene").get_node("ButtonClick")
onready var optionMenu := get_node("/root/GlobalQuitSettings")

func _ready():
	add_child(timer)
	timer.wait_time = 0.375
	timer.one_shot = true
	timer.connect("timeout", self, "_on_Quit_Timer_timeout")
	
func _on_Quit_Timer_timeout():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")

func _on_Quit_Main_pressed():
	clickSound.play()
	timer.start()
