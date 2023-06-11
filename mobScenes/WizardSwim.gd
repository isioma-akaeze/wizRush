extends KinematicBody2D

var sinkGravity := 80
var swimGravity := -100
var maximumSwimGravity := -100
var maximumSinkGravity := 80
var maximumVoluntarySink := 125
var velocity := Vector2.ZERO
var swimSpeed := 120
onready var sprite := $Sprite
onready var raygunSprite := $Sprite/Sprite
onready var animation := $AnimationPlayer
onready var rayTimer := $RayTimer
var rayCanShoot = true
var goingDown := false
var goingUp := false
var swimDirection := "right"

func _physics_process(delta) -> void:
	sprite.modulate = Color(0.498039, 1, 0.831373, 1)
	raygunSprite.modulate = Color(0.498039, 1, 0.831373, 1)
	
	var direction := Input.get_axis("left", "right")
	
	velocity.x = direction * swimSpeed
	
	if Input.is_action_pressed("up"):
		goingUp = true
		goingDown = false
		if sprite.flip_h == false:
			sprite.set_rotation_degrees(-7.5)
		elif sprite.flip_h == true:
			sprite.set_rotation_degrees(7.5)
		if velocity.y > maximumSwimGravity:
			velocity.y += swimGravity * delta
	elif Input.is_action_pressed("down"):
		goingDown = true
		goingUp = false
		if sprite.flip_h == false:
			sprite.set_rotation_degrees(7.5)
		elif sprite.flip_h == true:
			sprite.set_rotation_degrees(-7.5)
		if velocity.y < maximumVoluntarySink:
			velocity.y -= (maximumVoluntarySink * -1) * delta
	else:
		goingUp = false
		goingDown = false
		sprite.set_rotation_degrees(0)
		if velocity.y < maximumSinkGravity:
			velocity.y += (sinkGravity * delta) 
	
	if Input.is_action_pressed("left"):
			swimDirection = "left"
			animation.play("swim")
			sprite.flip_h = -1 #Flip the sprite
			raygunSprite.flip_h = -1
			raygunSprite.position.x = -40
	
	elif Input.is_action_pressed("right"):
			swimDirection = "right"
			animation.play("swim")
			sprite.flip_h = 0 #Flip the sprite
			raygunSprite.flip_h = 0
			raygunSprite.position.x = 40
	else:
		animation.stop()
		
	if Input.is_action_pressed("attack"):
		if rayCanShoot:
			var ray : Area2D = preload("res://mobScenes/Ray.tscn").instance()
			var raySpeed := 150.0
			if get_parent() != null:
				get_parent().add_child(ray)
			if sprite.flip_h == false:
				ray.global_position.x = raygunSprite.global_position.x + 35
				if goingDown:
					ray.global_position.y = raygunSprite.global_position.y + 5
				elif goingUp:
					ray.global_position.y = raygunSprite.global_position.y - 5
				else:
					ray.global_position.y = raygunSprite.global_position.y
				ray.rotation_degrees = sprite.rotation_degrees
				ray.flipped = false
				rayCanShoot = false
				rayTimer.start()
			elif sprite.flip_h == true:
				ray.global_position.x = raygunSprite.global_position.x - 35
				if goingDown:
					ray.global_position.y = raygunSprite.global_position.y + 5
				elif goingUp:
					ray.global_position.y = raygunSprite.global_position.y - 5
				else:
					ray.global_position.y = raygunSprite.global_position.y
				ray.rotation_degrees = sprite.rotation_degrees
				ray.flipped = true
				rayCanShoot = false
				rayTimer.start()

		
		
	move_and_slide(velocity, Vector2.UP)


func _on_RayTimer_timeout():
	rayCanShoot = true
