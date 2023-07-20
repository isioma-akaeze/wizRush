extends Button

var timer:= Timer.new()
onready var clickSound := get_node("/root/GlobalMusicScene").get_node("ButtonClick")
onready var optionMenu := get_node("/root/GlobalQuitSettings")

func _ready():
	add_child(timer)
	timer.wait_time = 0.25
	timer.one_shot = true
	timer.connect("timeout", self, "_on_SettingsTimer_timeout")
	
func _on_SettingsTimer_timeout():
	get_tree().paused = true
 
func _on_SettingsJump_pressed():
	clickSound.play()
	timer.start()
