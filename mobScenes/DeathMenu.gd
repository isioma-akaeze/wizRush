extends CanvasLayer

onready var resume := $Control/ResumeDie
onready var quit := $Control/QuitDie

func _ready():
	resume.grab_focus()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		resume.grab_focus()
	elif Input.is_action_just_pressed("ui_down"):
		quit.grab_focus()
