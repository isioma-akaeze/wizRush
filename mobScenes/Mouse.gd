extends KinematicBody2D

const GRAVITY := 12000.0
const JUMP_SPEED := -540
var speed := 27.0
var direction := Vector2(-3, 0)
onready var hit := preload("res://assets/images/Extra animations and enemies/Enemy sprites/mouse_hit.png")
export var hasToJump := false
onready var animation := $AnimationPlayer
export var switchingDirection := false
onready var sprite := $Sprite
onready var grassWalk := $GrassWalk
onready var stoneWalk := $StoneWalk
var onStone = false
onready var deathTimer := $DeathTimer
var bodyToKill : Node = null
var health := 24
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var deleteTimer := $DeleteTimer
onready var healthBar := $ProgressBar
onready var biteSound := $MouseBite

func _process(delta):
	healthBar.max_value = 24
	healthBar.set_value(health)
	if health > 0:
		pass
	elif health <= 0:
		animation.stop()
		set_process(false)
		if !switchingDirection:
			animation.play("death")
		elif switchingDirection:
			animation.play("deathFlipped")
		set_physics_process(false)
		
func _physics_process(delta):
	if difficulty.difficulty == 0:
		speed = 27.0
	elif difficulty.difficulty == 1:
		speed = 31.0
	var velocity := direction * speed
	if !is_on_floor() and !hasToJump:
		velocity.y += delta * GRAVITY
	elif hasToJump:
		velocity.y = JUMP_SPEED
	if round(velocity.x) != 0:
		animation.play("walk")
	else:
		animation.stop()
	if is_on_floor():
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var currentGround := get_tree().get_current_scene().get_node("Map")
			if currentGround != null:
				var cell = currentGround.world_to_map(collision.position - collision.normal - Vector2(1, 0))
				var tileID : int = currentGround.get_cellv(cell)
				var tileName : String = currentGround.get_tileset().tile_get_name(tileID)
				if tileID == 0:
					onStone = false
				elif tileID == 7:
					onStone = true
				elif tileID == 2:
					onStone == true	
			velocity.y = 0 #Set the velocity to not change if I'm on the ground, otherwise if I slide off a collision box, the fall speed is way too fast (it's almost comical)
		if round (velocity.x) > 0 or  round(velocity.x) < 0 and is_on_floor():
			if !grassWalk.is_playing() and !onStone:
				grassWalk.play()
				stoneWalk.stop()
			elif onStone and !stoneWalk.is_playing():
				stoneWalk.play()
				grassWalk.stop()
		elif round(velocity.x) == 0:
			stoneWalk.stop()
			grassWalk.stop()
		elif !is_on_floor():
			stoneWalk.stop()
			grassWalk.stop()

	if !switchingDirection:
		direction.x = -3
		sprite.flip_h = 0
	elif switchingDirection:
		direction.x = 3
		sprite.flip_h = -1
	move_and_slide(velocity, Vector2.UP)


func _on_DamageArea_body_entered(body):
	if body.is_in_group("player"):
		deathTimer.start()
		body.takingDamage = true
		bodyToKill = body
		return bodyToKill
	

func _on_DamageArea_body_exited(body):
	if body.is_in_group("player"):
		deathTimer.stop()
		body.takingDamage = false

func _on_DeathTimer_timeout():
	if health > 0:
		bodyToKill.takingDamage = true
		if difficulty.difficulty == 0:
			bodyToKill.health -= 20
			biteSound.play()
		elif difficulty.difficulty == 1:
			bodyToKill.health -= 25
			biteSound.play()
		if bodyToKill.health <= 0:
			if biteSound.is_playing():
				biteSound.stop()


func _on_DeathArea_body_entered(body):
	if body.is_in_group("damageEnemy"):
		if difficulty.difficulty == 0:
			health -= 8
			sprite.set_texture(hit)
		elif difficulty.difficulty == 1:
			health -= 4.8
			sprite.set_texture(hit)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death" or anim_name == "deathFlipped":
		deleteTimer.start()


func _on_DeleteTimer_timeout():
	queue_free()
