extends KinematicBody2D

onready var swordSprite := $Sprite
onready var rayCastFloor := $JumpDetect
onready var swordAnim := $Sprite/AnimationPlayer
onready var swordBox := $CollisionShape2D
var floorTouched := false
onready var player : KinematicBody2D = get_parent()

func _physics_process(delta) -> void:
	if rayCastFloor.is_colliding():
		floorTouched = true
	elif not rayCastFloor.is_colliding():
		floorTouched = false	
	if Input.is_action_pressed("attack") and not Input.is_action_pressed("down") and player.is_on_floor() and not Input.is_action_pressed("right") and swordSprite.flip_h == false:
		swordSprite.show()
		swordBox.set_deferred("disabled", false)
		swordAnim.play("slash")
	elif Input.is_action_pressed("attack") and not Input.is_action_pressed("down") and player.is_on_floor() and not Input.is_action_pressed("left") and swordSprite.flip_h == true:
		swordSprite.show()
		swordBox.set_deferred("disabled", false)
		swordAnim.play("slash 2")
	else:
		swordSprite.hide()
		swordBox.set_deferred("disabled", true)
