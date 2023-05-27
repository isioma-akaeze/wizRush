extends KinematicBody2D
#Defining variables
onready var sprite := $Sprite
var idle := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_stand.png")
var jump := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_jump.png")
var fall := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_fall.png")
var crouch := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_duck.png")
var climb := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_climb1.png")
const GRAVITY := 300.0 #Rate at which the character vertically translate positively
const CLIMB_GRAVITY := 100.0
const WALK_SPEED := 200 #Rate at which the character horizontally translates 
const velocity := Vector2.ZERO 
const JUMP_SPEED := -250.0 #Rate at which the character vertically translates negatively
var doubleJump := false #Can the character press the jump button again?
onready var walk := $AnimationPlayer
export var climbing = false

func _physics_process(delta):
	print("Climbing? " + str(climbing))
	if Input.is_action_pressed("left"):
		if is_on_floor() and walk.current_animation != "walk" and !is_on_wall():
			if Input.is_action_pressed("down"):
					walk.play("walk")
	elif Input.is_action_pressed("right"):
		if is_on_floor() and walk.current_animation != "walk" and !is_on_wall():
				walk.play("walk")
	if Input.is_action_just_released("left"):
		walk.stop(false)
	elif Input.is_action_just_released("right"):
		walk.stop(false)
	if is_on_wall() or is_on_ceiling():
		walk.stop(true)
	if is_on_floor():
		velocity.y = 0 #Set the velocity to not change if I'm on the ground, otherwise if I slide off a collision box, the fall speed is way too fast (it's almost comical)
	else:
		if climbing == true and Input.is_action_pressed("down"):
			sprite.set_texture(climb)
			velocity.y -= delta * CLIMB_GRAVITY
		else:
			velocity.y += delta * GRAVITY #Every frame, remove a certain amound from the y value of velocity
	var direction := Input.get_axis("left", "right") #The direction variable is equal to either what the left or right key provides
	if Input.is_action_pressed("left") and not Input.is_action_pressed("up"):
		sprite.flip_h = -1
		if is_on_floor():
			walk.play("walk")
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("up"):
		sprite.flip_h = 0
		if is_on_floor():
			walk.play("walk")

	
	if Input.is_action_just_pressed("up") and is_on_floor(): #"is_action_just_pressed" is faster than is "is_action_pressed, allowing enough time for a double jump to be allowed.
		doubleJump = true #Allow a double jump
		velocity.y = JUMP_SPEED #Add the JUMP_SPEED value as long as the if statement requirements are truee
		walk.stop(true)
		sprite.set_texture(jump)
		
	elif Input.is_action_just_pressed("up") and !is_on_floor() and doubleJump: # Same thing but now we're checking for if the character is allowed to do a double jump and is not on the ground.
			velocity.y = JUMP_SPEED #Same thing as in the jump code.
			doubleJump = false #Restrict a double jump so that the player can't infinitely press jump and fly.
			walk.stop(true)
			sprite.set_texture(jump)
	
	elif is_on_floor() and not Input.is_action_just_pressed("up") and doubleJump:
		sprite.set_texture(idle)
	
	elif is_on_floor() and not Input.is_action_just_pressed("up") and !doubleJump:
		sprite.set_texture(idle)
	
	elif not Input.is_action_pressed("up") and !is_on_floor() and doubleJump and climbing != true:
		#PLACEHOLDER WAIT A CERTAIN AMOUNT OF SECONDS
		walk.stop(true)
		sprite.set_texture(fall)
	
	elif not Input.is_action_pressed("up") and !is_on_floor() and !doubleJump and climbing != true:
		#PLACEHOLDER WAIT A CERTAIN AMOUNT OF SECONDS
		walk.stop(true)
		sprite.set_texture(fall)
	
	if Input.is_action_pressed("down") and is_on_floor():
		walk.stop(true)
		$Crouch.disabled = false
		$Fullbody.disabled = true
		sprite.set_texture(crouch)
		
	elif !Input.is_action_pressed("down") and is_on_floor():
		if !is_on_ceiling() and not Input.is_action_pressed("up"):
			$Crouch.disabled = true
			$Fullbody.disabled = false
			sprite.set_texture(idle)
		elif is_on_ceiling():
			$Crouch.disabled = false
			$Fullbody.disabled = true
			sprite.set_texture(crouch)
		
	elif !Input.is_action_pressed("down") and !is_on_floor():
		if !is_on_ceiling() and not Input.is_action_pressed("up"):
			$Crouch.disabled = true
			$Fullbody.disabled = false
			sprite.set_texture(fall)
		elif is_on_ceiling():
			$Crouch.disabled = false
			$Fullbody.disabled = true
			sprite.set_texture(crouch)

	
	velocity.x = direction * WALK_SPEED #Every frame, add to the x value of velocity the direction value multiplied by walk speed
	move_and_slide(velocity, Vector2.UP) #Here I added "Vector2.UP" because otherwise "is_on_floor() literally would not work. 


