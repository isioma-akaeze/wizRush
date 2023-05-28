extends KinematicBody2D
#Defining variables
onready var sprite := $Sprite
#Importing movement sprites
var idle := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_stand.png")
var jump := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_jump.png")
var fall := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_fall.png")
var crouch := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_duck.png")
var climb := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_climb1.png")
var dead := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_hurt.png")
const GRAVITY := 300.0 #Rate at which the character vertically translate positively
const CLIMB_GRAVITY := 100.0 #Rate at which the character climbs ladders
const WALK_SPEED := 200 #Rate at which the character horizontally translates 
const velocity := Vector2.ZERO 
const JUMP_SPEED := -250.0 #Rate at which the character vertically translates negatively
var doubleJump := false #Can the character press the jump button again?
onready var walk := $AnimationPlayer
export var climbing = false
onready var fullbody := $Fullbody
onready var crouchCollide := $Crouch
var crouching := false
onready var rayCast := $RayCast2D
onready var rayCastFloor := $RayCast2D2
var ceiling := false
var floorTouched := true
var isMoving := false
onready var timer := $Timer

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		if is_on_floor() and !is_on_wall():
			if Input.is_action_pressed("down"):
					walk.play("walk")
	elif Input.is_action_pressed("right"):
		if is_on_floor() and !is_on_wall():
				walk.play("walk")
	if Input.is_action_just_released("left"):
		walk.stop(true)
		sprite.set_texture(idle)
	elif Input.is_action_just_released("right"):
		walk.stop(true)
	if is_on_wall() and !is_on_floor():
		walk.stop(true)
		velocity.x = 0

		
	if velocity.x == 0 and is_on_floor():
		sprite.set_texture(idle)
		
	if velocity.x == 0 and is_on_wall() and floorTouched:
		sprite.set_texture(idle)
		
	
		
	if is_on_floor():
		velocity.y = 0 #Set the velocity to not change if I'm on the ground, otherwise if I slide off a collision box, the fall speed is way too fast (it's almost comical)
	elif !is_on_floor():
		if climbing == true and Input.is_action_pressed("down"):
			velocity.y -= delta * CLIMB_GRAVITY
			sprite.set_texture(climb)
		else:
			timer.start()
			velocity.y += delta * GRAVITY 
			#Every frame, remove a certain amound from the y value of velocity
	var direction := Input.get_axis("left", "right") #The direction variable is equal to either what the left or right key provides
	if Input.is_action_pressed("left"):
		isMoving = true
		sprite.flip_h = -1
		if floorTouched == true and !is_on_wall():
			walk.play("walk")
		elif is_on_wall() and floorTouched != true:
			walk.stop(true)
			#sprite.set_texture(idle)
		elif floorTouched != true:
			walk.stop(true)
	elif Input.is_action_pressed("right"):
		isMoving = true
		sprite.flip_h = 0
		if is_on_floor() and !is_on_wall():
			walk.play("walk")
		elif floorTouched != true:
			walk.stop(true)
		elif is_on_wall() and !isMoving:
			#sprite.set_texture(idle)
			walk.stop(true)
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		isMoving = false
	
	if Input.is_action_pressed("up") and floorTouched and crouching != true: #"is_action_just_pressed" is faster than is "is_action_pressed, allowing enough time for a double jump to be allowed.
		doubleJump = true #Allow a double jump
		sprite.set_texture(jump)
		velocity.y = JUMP_SPEED #Add the JUMP_SPEED value as long as the if statement requirements are truee
		walk.stop(true)
	if Input.is_action_just_pressed("up") and !floorTouched and doubleJump: # Same thing but now we're checking for if the character is allowed to do a double jump and is not on the ground.
			sprite.set_texture(jump)
			velocity.y = JUMP_SPEED  #Same thing as in the jump code.
			doubleJump = false #Restrict a double jump so that the player can't infinitely press jump and fly.
			walk.stop(true)
#	elif is_on_floor() and not Input.is_action_just_pressed("up") and doubleJump and !isMoving:
#		sprite.set_texture(idle)
#	elif is_on_floor() and not Input.is_action_just_pressed("up") and !doubleJump and !isMoving:
#		sprite.set_texture(idle)
#	elif is_on_floor() and not Input.is_action_just_pressed("up") and !doubleJump and !isMoving:
#		sprite.set_texture(idle)
	#elif not Input.is_action_pressed("up") and floorTouched == false and climbing != true:
		#PLACEHOLDER WAIT A CERTAIN AMOUNT OF SECONDS

	if rayCast.is_colliding():
		ceiling = true
	elif not rayCast.is_colliding():
		ceiling = false
	if rayCastFloor.is_colliding():
		floorTouched = true
	elif not rayCastFloor.is_colliding():
		floorTouched = false	
	if Input.is_action_pressed("down") and is_on_floor() and crouching == false and climbing != true:
		crouching = true
	if Input.is_action_just_released("down") and is_on_floor() and crouching == true and climbing != true:
		if ceiling == false:
			crouching = false
		elif ceiling == true:
			#sprite.set_texture(dead)
			print("YOU DIED!")
			get_tree().quit()
	if crouching == true and is_on_floor() and climbing != true:
		walk.stop(true)
		fullbody.set_deferred("disabled" , true)
		sprite.set_texture(crouch)
	elif crouching == false and is_on_floor() and climbing != true:
		fullbody.set_deferred("disabled", false)
		
	velocity.x = direction * WALK_SPEED #Every frame, add to the x value of velocity the direction value multiplied by walk speed
	move_and_slide(velocity, Vector2.UP) #Here I added "Vector2.UP" because otherwise "is_on_floor() literally would not work. 

func _on_Timer_timeout():
	if !floorTouched and velocity.y > 0:
		sprite.set_texture(fall)
