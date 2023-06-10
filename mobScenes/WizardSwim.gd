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

func _physics_process(delta) -> void:
	sprite.modulate = Color(0.498039, 1, 0.831373, 1)
	raygunSprite.modulate = Color(0.498039, 1, 0.831373, 1)
	
	
	var direction := Input.get_axis("left", "right")
	
	velocity.x = direction * swimSpeed
	
	if Input.is_action_pressed("up"):
		if sprite.flip_h == false:
			sprite.set_rotation_degrees(-7.5)
		elif sprite.flip_h == true:
			sprite.set_rotation_degrees(7.5)
		if velocity.y > maximumSwimGravity:
			velocity.y += swimGravity * delta
	elif Input.is_action_pressed("down"):
		if sprite.flip_h == false:
			sprite.set_rotation_degrees(7.5)
		elif sprite.flip_h == true:
			sprite.set_rotation_degrees(-7.5)
		if velocity.y < maximumVoluntarySink:
			velocity.y -= (maximumVoluntarySink * -1) * delta
	else:
		sprite.set_rotation_degrees(0)
		if velocity.y < maximumSinkGravity:
			velocity.y += (sinkGravity * delta) 
	
	if Input.is_action_pressed("left"):
			animation.play("swim")
			sprite.flip_h = -1 #Flip the sprite
			raygunSprite.flip_h = -1
			raygunSprite.position.x = -40
	
	elif Input.is_action_pressed("right"):
			animation.play("swim")
			sprite.flip_h = 0 #Flip the sprite
			raygunSprite.flip_h = 0
			raygunSprite.position.x = 40
	else:
		animation.stop()
		
	if Input.is_action_pressed("attack"):
		print("SHOOT")
		
	move_and_slide(velocity, Vector2.UP)
