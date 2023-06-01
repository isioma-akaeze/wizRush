extends KinematicBody2D

onready var swordSprite := $Sprite
onready var rayCastFloor := $JumpDetect
var floorTouched := false

func _physics_process(delta) -> void:

	if rayCastFloor.is_colliding():
		floorTouched = true
	elif not rayCastFloor.is_colliding():
		floorTouched = false	
	if Input.is_action_pressed("attack") and not Input.is_action_pressed("down") and floorTouched:
		swordSprite.show()
	else:
		swordSprite.hide()
