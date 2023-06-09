extends KinematicBody2D

onready var animation := $AnimationPlayer
onready var timer := $Timer

func _ready():
	animation.play("jump")

func _on_AnimationPlayer_animation_finished(anim_name):
	timer.start()

func _on_Timer_timeout():
	animation.play("jump")
