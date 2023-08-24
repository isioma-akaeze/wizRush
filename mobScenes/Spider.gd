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
var health := 45
onready var healthBar := $ProgressBar
onready var timer := $Timer
onready var timer2 := $Timer2
onready var timer3 := $Timer3
var bodyToKill : Node = null
onready var EngageArea := $EngageArea/CollisionShape2D
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var biteSound := $VenomBite
var onStone := false
onready var grassWalk := $GrassWalk
onready var stoneWalk := $StoneWalk
onready var attacking := false
onready var bodyToAward : Node = null

func _ready():
	if difficulty.difficulty == 0:
		EngageArea.scale.x = 20
		EngageArea.scale.y = 6.5
	elif difficulty.difficulty == 1:
		EngageArea.scale.x = 28
		EngageArea.scale.y = 9.1

func _process(delta) -> void:
	healthBar.max_value = 35
	healthBar.set_value(health)
	
	if health <= 0:
		bodyToAward.enemiesKilled += 1
		animation.stop()
		set_process(false)
		animation.play("die")
		set_physics_process(false)
		
		
		
func _physics_process(delta):
	if targetAcquired:
		stoneWalk.pitch_scale = 2.4
		grassWalk.pitch_scale = 2.4
		if difficulty.difficulty == 0:
			speed = 175.0
		elif difficulty.difficulty == 1:
			speed = 210.0
		direction = global_position.direction_to(bodyX.global_position) 
		direction.y = 0
		if direction.x >= 0:
			sprite.flip_h = -1
		elif direction.x < 0:
			sprite.flip_h = 0
		elif round(direction.x) == 0:
			sprite.flip_h = -1
		
	elif switchingDirection and !targetAcquired:
		stoneWalk.pitch_scale = 1.2
		grassWalk.pitch_scale = 1.2
		if difficulty.difficulty == 0:
			speed = 35.0
		elif difficulty.difficulty == 1:
			speed = 42.0
		direction = Vector2(3, 0)
		sprite.flip_h = -1
	elif !switchingDirection and !targetAcquired:
		stoneWalk.pitch_scale = 1.2
		grassWalk.pitch_scale = 1.2
		if difficulty.difficulty == 0:
			speed = 35.0
		elif difficulty.difficulty == 1:
			speed = 42.0
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
		if round (velocity.x) > 0 or  round(velocity.x) < 0 and is_on_floor() and !attacking:
			if !grassWalk.is_playing() and !onStone:
				grassWalk.play()
				stoneWalk.stop()
			elif onStone and !stoneWalk.is_playing():
				stoneWalk.play()
				grassWalk.stop()
		elif round(velocity.x) == 0:
			stoneWalk.stop()
			grassWalk.stop()
		elif attacking:
			stoneWalk.stop()
			grassWalk.stop()
		if health <= 0:
			stoneWalk.stop()
			grassWalk.stop()

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
		if difficulty.difficulty == 0:
			health -= 15
		elif difficulty.difficulty == 1:
			health -= 11.24
		sprite.set_texture(hit)
		bodyToAward = body.get_parent()
		return bodyToAward
		

func _on_Timer_timeout():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		timer.start()

func _on_Timer3_timeout():
	if health > 0:
		bodyToKill.takingDamage = true
		if difficulty.difficulty == 0:
			bodyToKill.health -= 25
			biteSound.play()
		elif difficulty.difficulty == 1:
			bodyToKill.health -= 34
			biteSound.play()
		if bodyToKill.health <= 0:
			if biteSound.is_playing():
				biteSound.stop()


func _on_DamageArea_body_entered(body):
	if body.is_in_group("damagePlayer"):
		attacking = true
		timer3.start()
		bodyToKill = body
	return bodyToKill


func _on_DamageArea_body_exited(body):
	attacking = false
	if body.is_in_group("damagePlayer"):
		body.takingDamage = false
		timer3.stop()
