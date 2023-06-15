extends Control

onready var resume := $Resume
onready var quit := $"Quit Main"

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		resume.grab_focus()
		quit.release_focus()
	elif Input.is_action_just_pressed("ui_down"):
		quit.grab_focus()
		resume.release_focus()
