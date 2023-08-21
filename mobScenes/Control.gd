extends Control

onready var resume := $Resume
onready var quit := $"Quit Main"
onready var timer := $Timer

var paused = true

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		resume.grab_focus()
		quit.release_focus()
	elif Input.is_action_just_pressed("ui_down"):
		quit.grab_focus()
		resume.release_focus()

func _physics_process(delta):
	if Input.is_action_just_pressed("pause") and !paused:
		paused = true
		timer.start()


func _on_Timer_timeout():
	if paused:
		get_tree().paused = false
		get_parent().hide()


