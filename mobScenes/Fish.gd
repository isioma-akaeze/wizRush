extends KinematicBody2D

const SINK_GRAVITY := -40
const MAXIMUM_SINK_GRAVITY := -40
const SWIM_GRAVITY := 50
const MAXIMUM_SWIM_GRAVITY := 50
var speed := 45.0
var dangerSpotted := false
var direction := Vector2(-3,0)
var randomY := rand_range(-3, 3)
var coinFlip := rand_range(0, 1)
var switchingDirection := false
onready var pathTimer := $PathTimer
var switchingY := false
onready var sprite := $Sprite
onready var colliderCheck := $RayCast2D
var bodyX : Node = null
onready var scaredTimer := $Timer
var lastDirection := false
var inputAxis := 0
var green := preload("res://assets/images/Extra animations and enemies/Enemy sprites/fishGreen.png")
var pink := preload("res://assets/images/Extra animations and enemies/Enemy sprites/fishPink.png")
var isOnWall := false
var colorSelected := "null"
onready var animation := $AnimationPlayer
var health := 15
onready var healthBar := $ProgressBar
var takingDamage := false
var hurt := preload("res://assets/images/Extra animations and enemies/Enemy sprites/fishGreen_hit.png")
onready var swimSound := $SwimSound
var isInvincible := false

func _ready():
	healthBar.max_value = 15
	pathTimer.start()
	
	var randText := (randi() % 2)
	if randText == 0:
		sprite.set_texture(green)
		colorSelected = "green"
	elif randText == 1:
		sprite.set_texture(pink)
		colorSelected = "pink"

func _process(delta):
	healthBar.set_value(health)
	if health <= 0 and !takingDamage:
		if colorSelected == "green":
			set_physics_process(false)
			animation.play("greenDeath")
		elif colorSelected == "pink":
			set_physics_process(false)
			animation.play("pinkDeath")

func _physics_process(delta):	
	if takingDamage:
		pass
	elif !takingDamage:
		pass
	
	if colorSelected == "pink":
		animation.play("pinkSwim")
	elif colorSelected == "green":
		animation.play("greenSwim")
	var inputAxis = Input.get_axis("left", "right")
	if !dangerSpotted and !switchingDirection:
		sprite.flip_h = 0
		speed = 45.0
		direction = Vector2(-3, randomY)
		var velocity := direction * speed
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		if !swimSound.is_playing():
			swimSound.pitch_scale = 3
			swimSound.play()
		if round(velocity.x) == 0:
			swimSound.stop()
		if round(velocity.y) == 0:
			swimSound.stop()
		move_and_slide(velocity, Vector2.UP)
	elif !dangerSpotted and switchingDirection:
		sprite.flip_h = -1
		speed = 45.0
		direction = Vector2(3, randomY)
		var velocity := direction * speed
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		if !swimSound.is_playing():
			swimSound.pitch_scale = 3
			swimSound.play()
		if round(velocity.x) == 0:
			swimSound.stop()
		if round(velocity.y) == 0:
			swimSound.stop()
		move_and_slide(velocity, Vector2.UP)
	
	if dangerSpotted:
		speed = 90.0
		var velocity := direction * speed
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		if !swimSound.is_playing():
			swimSound.pitch_scale = 5.51
			swimSound.play()
		if round(velocity.x) == 0:
			swimSound.stop()
		if round(velocity.y) == 0:
			swimSound.stop()
		move_and_slide(velocity, Vector2.UP)
		
func _on_PathTimer_timeout():
	coinFlip = rand_range(0, 1)
	if coinFlip >= 0 and coinFlip < 0.5:
		randomY = rand_range(-3, 3)
	elif coinFlip >= 0.5:
		pass
	pathTimer.start()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and health != 0 or body.is_in_group("enemy") and health != 0:
		if body.global_position.x > global_position.x:
			direction.x = -3
			sprite.flip_h = 0
		elif body.global_position.x <= global_position.x:
			direction.x = 3
			sprite.flip_h = -1
		if is_on_wall():
			direction.x *= -1
			if sprite.flip_h == true:
				sprite.flip_h = 0
			elif sprite.flip_h == false:
				sprite.flip_h = -1
		dangerSpotted = true
		bodyX = body
		lastDirection = sprite.flip_h
		return bodyX
		return lastDirection
	

func _on_Area2D_body_exited(body):
	if body.is_in_group("player") or body.is_in_group("enemy"):
		scaredTimer.start()

func _on_Timer_timeout():
	if not bodyX in $Area2D.get_overlapping_bodies():
		dangerSpotted = false
	else:
		if is_on_wall():
			direction.x *= -1
			if sprite.flip_h == true:
				sprite.flip_h = 0
			elif sprite.flip_h == false:
				sprite.flip_h = -1



func _on_DangerSwitch_timeout():
	if is_on_wall():
		direction.x *= -1
		if sprite.flip_h == true:
			sprite.flip_h = 0
		elif sprite.flip_h == false:
			sprite.flip_h = -1


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "greenDeath" or anim_name == "pinkDeath":
		queue_free()
