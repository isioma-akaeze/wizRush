extends KinematicBody2D

const GRAVITY := 12000.0
const JUMP_SPEED := -540
export var switchingDirection := false
var targetAcquired := false
export var hasToJump := false
var speed := 35.0 
onready var animation := $AnimationPlayer
var direction := Vector2(-3,0)
var bodyX : Node = null
onready var sprite := $Sprite
onready var idle := preload("res://assets/images/Extra animations and enemies/Enemy sprites/spider.png")

func _physics_process(delta):
	if targetAcquired:
		speed = 175.0
		direction = global_position.direction_to(bodyX.global_position)
		direction.y = 0
		if direction.x >= 0:
			sprite.flip_h = -1
		elif direction.x < 0:
			sprite.flip_h = 0
		elif round(direction.x) == 0:
			sprite.flip_h = -1
		
	elif switchingDirection and !targetAcquired:
		speed = 35.0
		direction = Vector2(3, 0)
		sprite.flip_h = -1
	elif !switchingDirection and !targetAcquired:
		speed = 35.0
		direction = Vector2(-3, 0)
		sprite.flip_h = 0
	
	var velocity := direction * speed
	print(hasToJump)
	if !is_on_floor() and !hasToJump:
		velocity.y += delta * GRAVITY
	elif hasToJump:
		velocity.y = JUMP_SPEED
	if round(velocity.x) == 0:
			animation.stop()
			sprite.set_texture(idle)
	else:
		animation.play("walk")
	move_and_slide(velocity, Vector2.UP)
	

func _on_EngageArea_body_entered(body):
	if body.is_in_group("player"):
		if body.position.y <= global_position.y:
			targetAcquired = true
			bodyX = body
			return bodyX
		elif body.position.y > self.position.y:
			targetAcquired = false

func _on_EngageArea_body_exited(body):
	if body.is_in_group("player"):
		targetAcquired = false
