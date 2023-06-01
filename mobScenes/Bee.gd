extends KinematicBody2D

onready var fly := $AnimationPlayer
export var switchingDirection = false
onready var sprite := $Sprite

var speed := 15.0
var health := 25

func _physics_process(delta) -> void:
	var direction := Vector2(-3,0)
	#If touching collision box, change direction:
	if switchingDirection:
		direction.x = direction.x * -1 
		sprite.flip_h = -1
	elif not switchingDirection:
		direction.x = -3
		sprite.flip_h = 0
	var velocity := direction * speed
	fly.play("Fly")
	move_and_slide(velocity)
