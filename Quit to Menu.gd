extends Button

onready var musicScene := get_node("/root/GlobalMusicScene")
onready var clickSound := musicScene.get_node("ButtonClick")
var timer := Timer.new()
var lastScene := "res://MainMenu.tscn"

func _on_Quit_to_Menu_pressed():
	timer.start()
	clickSound.play()
	
func _ready():
	add_child(timer)
	timer.wait_time = 0.375
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	grab_focus()

func _on_timer_timeout() -> void:
	get_tree().change_scene(lastScene)
