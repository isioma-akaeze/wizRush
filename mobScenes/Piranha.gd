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
		sprite.set_rotation_degrees(270)
		sprite.flip_h = 0
		speed = 60.0
		direction = Vector2(-3, randomY)
		var velocity := direction * speed
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		move_and_slide(velocity, Vector2.UP)
		if round(velocity.x) > 0:
			animation.play("swim")
	elif !targetAcquired and switchingDirection:
		sprite.set_rotation_degrees(90)
		sprite.flip_h = -1
		speed = 60.0
		direction = Vector2(3, randomY)
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
	elif targetAcquired:
		speed = 103.75
		direction = global_position.direction_to(bodyX.global_position)
		if direction.x >= 0:
			sprite.set_rotation_degrees(90)
			sprite.flip_h = -1
		elif direction.x < 0:
			sprite.set_rotation_degrees(270)
			sprite.flip_h = 0
		elif round(direction.x) == 0:
			sprite.set_rotation_degrees(90)
			sprite.flip_h = -1
		if round(direction.x) > 0:
			animation.play("swim")
		var velocity = direction * speed
		move_and_slide(velocity, Vector2.UP)
		if takingDamage == true:
			animation.stop()
			sprite.set_texture(hurt)
		elif takingDamage == false:
			sprite.set_texture(normal)


func _on_PathTimer_timeout():
	coinFlip = rand_range(0, 1)
	if coinFlip >= 0 and coinFlip < 0.5:
		randomY = rand_range(-3, 3)
	elif coinFlip >= 0.5:
		pass
	pathTimer.start()

func _on_ChaseArea_body_entered(body):
	if body.is_in_group("player") and body.health > 0:
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
				if bodyToKill.is_in_group("player") and bodyToKill.health > 0:
					bodyToKill.health -= 14
					bodyToKill.takingDamage = true
				if bodyToKill.is_in_group("passive"):
					if bodyToKill.health > 0 or bodyToKill.health != 0:
						bodyToKill.health -= 5

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		damageTimer.stop()
		body.takingDamage = false



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "New Anim":
		queue_free()
