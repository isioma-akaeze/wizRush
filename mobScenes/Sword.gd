extends KinematicBody2D

onready var swordSprite := $Sprite
onready var rayCastFloor := $JumpDetect
onready var swordAnim := $Sprite/AnimationPlayer
onready var swordBox := $CollisionShape2D
var floorTouched := false
onready var player : KinematicBody2D = get_parent()
onready var slashSound := $Slash
onready var timer := $Timer
var cooldown := false

func _ready():
	swordSprite.hide()

func _physics_process(delta) -> void:
	if rayCastFloor.is_colliding():
		floorTouched = true
	elif not rayCastFloor.is_colliding():
		floorTouched = false	
	if Input.is_action_just_pressed("attack") and not Input.is_action_pressed("down") and player.is_on_floor() and not Input.is_action_pressed("right") and swordSprite.flip_h == false and !cooldown:
		cooldown = true
		slashSound.stop()
		slashSound.play()
		timer.start()
		swordSprite.show()
		swordBox.set_deferred("disabled", false)
		swordAnim.stop()
		swordAnim.play("slash")
	elif Input.is_action_just_pressed("attack") and not Input.is_action_pressed("down") and player.is_on_floor() and not Input.is_action_pressed("left") and swordSprite.flip_h == true and !cooldown:
		cooldown = true
		timer.start()
		slashSound.stop()
		slashSound.play()
		swordSprite.show()
		swordBox.set_deferred("disabled", false)
		swordAnim.stop()
		swordAnim.play("slash 2")
	else:
		#swordSprite.hide()
		swordBox.set_deferred("disabled", true)
		
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		swordAnim.stop()
		swordSprite.hide()
		swordBox.set_deferred("disabled", true)

func _on_Timer_timeout():
	cooldown = false
	#swordAnim.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	swordSprite.hide()
