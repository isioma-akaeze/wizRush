extends Control

onready var resume := $Resume
onready var quit := $"Quit Main"
onready var timer := $Timer
onready var timerDepths := $TimerDepths

var paused = true

func _ready():
	#resume.grab_focus()
	pass

func _physics_process(delta):	
	var currentPlayer := get_parent().get_parent().get_parent().name
	if Input.is_action_just_pressed("pause") and !paused:
		if currentPlayer != "res://mobScenes/WizardSwim.tscn":
			paused = true
			timer.start()
		else:
			paused = true
			timerDepths.start()



func _on_Timer_timeout():
	if paused:
		get_tree().paused = false
		get_parent().hide()


