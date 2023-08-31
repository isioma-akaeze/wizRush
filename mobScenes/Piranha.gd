extends KinematicBody2D

const SINK_GRAVITY := -40
const MAXIMUM_SINK_GRAVITY := -40
const SWIM_GRAVITY := 50
const MAXIMUM_SWIM_GRAVITY := 50
var speed := 60.0
var dangerSpotted := false
var direction := Vector2(-3,0)
var randomY := rand_range(-3, 3)
var coinFlip := rand_range(0, 1)
var switchingDirection := false
var switchingY := false
onready var sprite := $Sprite
var bodyX : Node = null
onready var animation := $AnimationPlayer
onready var healthBar := $ProgressBar
onready var pathTimer := $PathTimer
onready var timer := $Timer
var targetAcquired := false
var health := 45
onready var chaseArea := $ChaseArea
onready var damageTimer := $DamageTimer
var bodyToKill : Node = null
var takingDamage = false
var hurt := preload("res://assets/images/Extra animations and enemies/Enemy sprites/piranha_hit.png")
var normal := preload("res://assets/images/Extra animations and enemies/Enemy sprites/piranha.png")
onready var wallCheck := $RayCast2D
var bodyToAward : Node = null
onready var biteSound := $BiteSound
onready var swimSound := $SwimSound

func _ready():
	healthBar.max_value = 45
	pathTimer.start()
	
func _process(delta):
	if health <= 0:
		animation.stop()
		set_physics_process(false)
		set_process(false)
		animation.play("New Anim")
		sprite.flip_h = 0

func _physics_process(delta) -> void:
	
	healthBar.set_value(health)
	if !targetAcquired and !switchingDirection:
		if !swimSound.is_playing():
			swimSound.pitch_scale = 2.4
			swimSound.play()
		sprite.set_rotation_degrees(270)
		sprite.flip_h = 0
		var difficulty := get_node("/root/GlobalOptionButton")
		if difficulty.difficulty == 0:
			speed = 60.0
		elif difficulty.difficulty == 1:
			speed = 72.0
		direction = Vector2(-3, randomY)
		wallCheck.cast_to = Vector2(-55, 0)
		var velocity := direction * speed
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		move_and_slide(velocity, Vector2.UP)
		if round(velocity.x) > 0:
			animation.play("swim")
		if round(velocity.x) == 0:
			animation.stop()
			swimSound.stop()
	elif !targetAcquired and switchingDirection:
		if !swimSound.is_playing():
			swimSound.pitch_scale = 2.4
			swimSound.play()
		sprite.set_rotation_degrees(90)
		sprite.flip_h = -1
		var difficulty := get_node("/root/GlobalOptionButton")
		if difficulty.difficulty == 0:
			speed = 60.0
		elif difficulty.difficulty == 1:
			speed = 72.0
		direction = Vector2(3, randomY)
		wallCheck.cast_to = Vector2(55, 0)
		var velocity := direction * speed
		if velocity.y < 0:
			velocity.y = 0
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		move_and_slide(velocity, Vector2.UP)
		if round(velocity.x) > 0:
			animation.play("swim")
		if round(velocity.x) == 0:
			animation.stop()
			swimSound.stop()
	elif targetAcquired and !wallCheck.is_colliding():
		if !swimSound.is_playing():
			swimSound.pitch_scale = 4.41
			swimSound.play()
		var difficulty := get_node("/root/GlobalOptionButton")
		if difficulty.difficulty == 0:
			speed = 110.25
		elif difficulty.difficulty == 1:
			speed = 132.3
		direction = global_position.direction_to(bodyX.global_position)
		if direction.x >= 0:
			wallCheck.cast_to = Vector2(55, 0)
			sprite.set_rotation_degrees(90)
			sprite.flip_h = -1
		elif direction.x < 0:
			wallCheck.cast_to = Vector2(-55, 0)
			sprite.set_rotation_degrees(270)
			sprite.flip_h = 0
		elif round(direction.x) == 0:
			sprite.set_rotation_degrees(90)
			sprite.flip_h = -1
		if round(direction.x) > 0:
			animation.play("swim")
		var velocity = direction * speed
		move_and_slide(velocity, Vector2.UP)
		if round(velocity.x) == 0:
			animation.stop()
			swimSound.stop()
		if takingDamage == true:
			animation.stop()
			sprite.set_texture(hurt)
		elif takingDamage == false:
			sprite.set_texture(normal)
	elif targetAcquired and wallCheck.is_colliding():
		targetAcquired = false
	




func _on_PathTimer_timeout():
	coinFlip = rand_range(0, 1)
	if coinFlip >= 0 and coinFlip < 0.5:
		randomY = rand_range(-3, 3)
	elif coinFlip >= 0.5:
		pass
	pathTimer.start()

func _on_ChaseArea_body_entered(body):
	if body.is_in_group("player") and body.health > 0 and !wallCheck.is_colliding():
		targetAcquired = true
		bodyX = body
		return bodyX
		
func _on_ChaseArea_body_exited(body):
	if body.is_in_group("player"):
		targetAcquired = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		damageTimer.start()
		bodyToKill = body
	elif body.is_in_group("passive"):
		damageTimer.start()
		bodyToKill = body


func _on_DamageTimer_timeout():
	if health > 0 and bodyToKill:
		if bodyToKill != null:
			if is_instance_valid(bodyToKill):
				var difficulty := get_node("/root/GlobalOptionButton")
				if bodyToKill.is_in_group("player") and bodyToKill.health > 0:
					if difficulty.difficulty == 0:
						bodyToKill.health -= 7
					elif difficulty.difficulty == 1:
						bodyToKill.health -= 10
					if !biteSound.is_playing():
						biteSound.play()
				elif bodyToKill.is_in_group("player") and bodyToKill.health <= 0:
					biteSound.stop()
					bodyToKill.takingDamage = true
				if bodyToKill.is_in_group("passive"):
					if bodyToKill.health > 0 or bodyToKill.health != 0:
						bodyToKill.health -= 5
						if !biteSound.is_playing():
							biteSound.play()
					elif bodyToKill.health <= 0:
						biteSound.stop()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		damageTimer.stop()
		body.takingDamage = false
		biteSound.stop()
		



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "New Anim":
		queue_free()
