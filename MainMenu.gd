extends CanvasLayer

onready var start := $"Start Button"
onready var quit := $"Quit Program Button"
	
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		start.grab_focus()
		quit.release_focus()

	elif Input.is_action_just_pressed("ui_down"):
		quit.grab_focus()
		start.release_focus()
