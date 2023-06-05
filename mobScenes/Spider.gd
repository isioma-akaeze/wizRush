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
onready var hit := preload("res://assets/images/Extra animations and enemies/Enemy sprites/spider_hit.png")
onready var sprite := $Sprite
onready var idle := preload("res://assets/images/Extra animations and enemies/Enemy sprites/spider.png")
var health := 35
onready var healthBar := $ProgressBar
onready var timer := $Timer
onready var timer2 := $Timer2
onready var timer3 := $Timer3
var bodyToKill : Node = null

func _process(delta) -> void:
	healthBar.max_value = 35
	healthBar.set_value(health)
	
	if health <= 0:
		animation.stop()
		set_process(false)
		animation.play("die")
		set_physics_process(false)
		
		
		
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
	if !is_on_floor() and !hasToJump:
		velocity.y += delta * GRAVITY
	elif hasToJump:
		velocity.y = JUMP_SPEED
	if round(velocity.x) == 0:
			animation.stop()
			sprite.set_texture(idle)
	else:
		if !health <= 0:
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


func _on_DeathArea_body_entered(body):
	if body.is_in_group("damageEnemy"):
		health -= 10
		sprite.set_texture(hit)
		

func _on_Timer_timeout():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "die":
		timer.start()




func _on_Timer3_timeout():
	if health > 0:
		bodyToKill.health -= 25


func _on_DamageArea_body_entered(body):
	if body.is_in_group("damagePlayer"):
		timer3.start()
		bodyToKill = body
		body.takingDamage = true
	return bodyToKill


func _on_DamageArea_body_exited(body):
	if body.is_in_group("damagePlayer"):
		body.takingDamage = false
		timer3.stop()
		
		timer3.stop()
