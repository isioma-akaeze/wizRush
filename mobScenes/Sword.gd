extends KinematicBody2D

onready var swordSprite := $SwordSprite
onready var rayCastFloor := $JumpDetect
onready var damageArea := $DamageArea
var floorTouched := false

func _physics_process(delta) -> void:

	if rayCastFloor.is_colliding():
		floorTouched = true
	elif not rayCastFloor.is_colliding():
		floorTouched = false	
	if Input.is_action_just_pressed("attack") and not Input.is_action_pressed("down") and floorTouched:
		swordSprite.show()
		#damageArea.set_collision_layer_bit(1, true)
		#damageArea.set_collision_mask_bit(1, true)
	else:
		swordSprite.hide()
		#damageArea.set_collision_layer_bit(1, false)
		#damageArea.set_collision_mask_bit(1, false)
