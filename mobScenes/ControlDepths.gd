extends Control

onready var resume := $Resume
onready var quit := $"Quit Main"
onready var timer := $TimerDepths

var paused = true

func _ready():
	resume.grab_focus()
	
func _physics_process(delta):	
	var currentPlayer := get_parent().get_parent().get_parent().name
	if Input.is_action_just_pressed("pause") and !paused:
		paused = true
		timer.start()

func _on_TimerDepths_timeout():
	if paused:
		get_tree().paused = false
		get_parent().hide()
