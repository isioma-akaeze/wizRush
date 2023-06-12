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
onready var onWall := $RayCast2D
var isOnWall := false

func _ready():
	pathTimer.start()
	var texturePicked := "null"
	var randText := (randi() % 2)
	if randText == 0:
		sprite.set_texture(green)
		texturePicked = "green"
	elif randText == 1:
		sprite.set_texture(pink)
		texturePicked = "pink"
	print(texturePicked)

func _physics_process(delta):
	var inputAxis = Input.get_axis("left", "right")
	if !dangerSpotted and !switchingDirection:
		onWall.position.x = 12
		onWall.cast_to = Vector2(-50, 0)
		sprite.flip_h = 0
		speed = 45.0
		direction = Vector2(-3, randomY)
		var velocity := direction * speed
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		move_and_slide(velocity, Vector2.UP)
	elif !dangerSpotted and switchingDirection:
		onWall.position.x = -12
		onWall.cast_to = Vector2(50, 0)
		sprite.flip_h = -1
		speed = 45.0
		direction = Vector2(3, randomY)
		var velocity := direction * speed
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		move_and_slide(velocity, Vector2.UP)
	
	if dangerSpotted:
		speed = 90.0
		var velocity := direction * speed
		if velocity.y < MAXIMUM_SINK_GRAVITY:
			velocity.y += SINK_GRAVITY * delta
		elif velocity.y > MAXIMUM_SWIM_GRAVITY:
			velocity.y += SWIM_GRAVITY * delta
		move_and_slide(velocity, Vector2.UP)
		
		if onWall.is_colliding():
			isOnWall = true
		else:
			isOnWall = false
		
		print(isOnWall)
		
		

func _on_PathTimer_timeout():
	coinFlip = rand_range(0, 1)
	if coinFlip >= 0 and coinFlip < 0.5:
		randomY = rand_range(-3, 3)
	elif coinFlip >= 0.5:
		pass
	pathTimer.start()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if body.global_position.x > global_position.x:
			direction.x = -3
			sprite.flip_h = 0
		elif body.global_position.x <= global_position.x:
			direction.x = 3
			sprite.flip_h = -1
		if isOnWall == true:
			direction.x *= -1
			if sprite.flip_h == true:
				sprite.flip_h = 0
			elif sprite.flip_h == false:
				sprite.flip_h = -1
		if direction.x == 3:
			onWall.position.x = -12
			onWall.cast_to = Vector2(50, 0)
		elif direction.x == -3:
			onWall.position.x = 12
			onWall.cast_to = Vector2(-50, 0)
		dangerSpotted = true
		bodyX = body
		lastDirection = sprite.flip_h
		return bodyX
		return lastDirection
	

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		scaredTimer.start()

func _on_Timer_timeout():
	
	if not bodyX in $Area2D.get_overlapping_bodies():
		dangerSpotted = false
