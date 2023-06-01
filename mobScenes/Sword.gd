extends KinematicBody2D

onready var swordSprite := $Sprite
onready var rayCastFloor := $JumpDetect
onready var swordAnim := $Sprite/AnimationPlayer
var floorTouched := false

func _physics_process(delta) -> void:
	print(swordSprite.rotation_degrees)
	if rayCastFloor.is_colliding():
		floorTouched = true
	elif not rayCastFloor.is_colliding():
		floorTouched = false	
	if Input.is_action_pressed("attack") and not Input.is_action_pressed("down") and floorTouched and not Input.is_action_pressed("right") and swordSprite.flip_h == false:
		swordSprite.show()
		swordAnim.play("slash")
	elif Input.is_action_pressed("attack") and not Input.is_action_pressed("down") and floorTouched and not Input.is_action_pressed("left") and swordSprite.flip_h == true:
		swordSprite.show()
		swordAnim.play("slash 2")
	else:
		swordSprite.hide()
