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
var attack := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_action2.png")
var heartHalf := preload("res://assets/images/Base pack/HUD/hud_heartHalf.png")
var heartEmpty := preload("res://assets/images/Base pack/HUD/hud_heartEmpty.png")
const GRAVITY := 350.0 #Rate at which the character vertically translate positively
const CLIMB_GRAVITY := 100.0 #Rate at which the character climbs ladders
const WALK_SPEED := 200 #Rate at which the character horizontally translates 
const velocity := Vector2.ZERO #Used for movement calculation
const JUMP_SPEED := -275.0 #Rate at which the character vertically translates negatively
var doubleJump := false #Can the character press the jump button again?
onready var walk := $AnimationPlayer #Used to access animations, although it'd probably be better to change the variable name.
export var climbing = false #Used to connect to LadderArea2D nodes, and to determine whether or not the movement behaviour should resemble climbing.
onready var fullbody := $Fullbody #Accessing the fullbody collision box for crouching.
onready var crouchCollide := $Crouch #Accessing the crouch collision box for crouching.
var crouching := false #Determines whether or not the player is currently crouching.
onready var rayCast := $RayCast2D #Used to detect the ceiling when _is_on_ceiling() isn't fast/accurate enough.
onready var rayCastFloor := $RayCast2D2 #Used to detect the floor when _is_on_floor() is inconsistent/isn't fast enough.
var ceiling := false #To send a signal for if the player is touching the ceiling from rayCast.
var floorTouched := true #To send a signal for if the player is touching the floor from rayCastFloor.
var isMoving := false #To detect if the player is moving or not. Don't remember if it's necesscary to use this, but I'll keep it just in case.
onready var timer := $Timer #Self-explanatory.
onready var secondTimer := $Timer2
onready var swordBox := $Sword
onready var swordJump := $Sword/JumpDetect
onready var swordSprite := $Sword/Sprite
export var health := 100
onready var healthBar := $ProgressBar
onready var heart := $Heart
export var takingDamage := false

func _process(delta) -> void:
	if health <= 50:
		heart.set_texture(heartHalf)
	if health <= 0:
		sprite.set_texture(dead)
		heart.set_texture(heartEmpty)
		walk.stop()
		if is_on_floor():
			set_physics_process(false)
			set_process(false)
			secondTimer.start()
	healthBar.max_value == 100
	healthBar.set_value(health)
	if Input.is_action_just_pressed("left") and swordBox.position.x == (27):
		swordBox.position.x *= -1.75
		swordJump.position.x = swordBox.position.x + 73
		swordBox.set_rotation_degrees(360)
		swordSprite.flip_h = -1
	elif Input.is_action_just_pressed("right") and swordBox.position.x == (-27 * 1.75):
		swordBox.position.x /= -1.75
		swordJump.position.x = swordBox.position.x - 29
		swordBox.set_rotation_degrees(0)
		swordSprite.flip_h = 0

#Every frame...
func _physics_process(delta):
	if takingDamage == true:
		print("takingDamage")
	if Input.is_action_pressed("attack") and velocity.x == 0 and $Sword/JumpDetect.is_colliding():
		sprite.set_texture(attack)
	#If the left key is pressed, play the walk animation.
	if Input.is_action_pressed("left"):
		if is_on_floor() and !is_on_wall():
			#if Input.is_action_pressed("down"):
					walk.play("walk")
	#Same thing but with the right key.
	elif Input.is_action_pressed("right"):
		if is_on_floor() and !is_on_wall():
				walk.play("walk")
	#Prevents the player from walking into walls.
	if Input.is_action_just_released("left"):
		walk.stop(true)
	elif Input.is_action_just_released("right"):
		walk.stop(true)
	#Helps make sure the player isn't walking into walls if the first system isn't working for whatever reason.
	if is_on_wall() and !is_on_floor():
		walk.stop(true)
		velocity.x = 0

	#If the player isn't moving and is on the floor, set their texture to the idle one.
	if velocity.x == 0 and is_on_floor() and not Input.is_action_pressed("attack") and not Input.is_action_pressed("up"):
		sprite.set_texture(idle)
	#Yet ANOTHER failsafe to make sure the player doesn't walk into walls.
	if velocity.x == 0 and is_on_wall() and floorTouched and not Input.is_action_pressed("attack") and not Input.is_action_pressed("up"):
		sprite.set_texture(idle)
	
	if is_on_floor():
		velocity.y = 0 #Set the velocity to not change if I'm on the ground, otherwise if I slide off a collision box, the fall speed is way too fast (it's almost comical)
	elif !is_on_floor():
		if climbing == true and Input.is_action_pressed("down"):
			velocity.y -= delta * CLIMB_GRAVITY
			sprite.set_texture(climb)
		#Every frame, make the character fall gradually faster, and start the timer for the fall "animation".
		else:
			timer.start()
			velocity.y += delta * GRAVITY 
	#The direction variable is equal to either what the left or right key provides.
	var direction := Input.get_axis("left", "right")
	#Walk animation stuff...
	if Input.is_action_pressed("left"):
		isMoving = true
		sprite.flip_h = -1 #Flip the sprite
		if floorTouched == true and !is_on_wall():
			walk.play("walk")
		elif is_on_wall() and floorTouched != true:
			walk.stop(true)
		elif floorTouched != true:
			walk.stop(true)
		elif is_on_wall() and !isMoving:
			walk.stop(true)
	elif Input.is_action_pressed("right"):
		isMoving = true
		sprite.flip_h = 0 #Flip the sprite
		if is_on_floor() and !is_on_wall():
			walk.play("walk")
		elif floorTouched != true:
			walk.stop(true)
		elif is_on_wall() and !isMoving:
			walk.stop(true)
	#IIRC this is needed to signal to the code that velocity.x is inactive. Kind of seems useless but I'll keep it.
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		isMoving = false
	#Code for jumping and double jumps.
	if Input.is_action_pressed("up") and is_on_floor() and crouching != true: 
		doubleJump = true #Allow a double jump
		sprite.set_texture(jump)
		velocity.y = JUMP_SPEED #Add the JUMP_SPEED value as long as the if statement requirements are truee
		walk.stop(true)
	if Input.is_action_just_pressed("up") and !is_on_floor() and doubleJump: # Same thing but now we're checking for if the character is allowed to do a double jump and is not on the ground.
			sprite.set_texture(jump)
			velocity.y = JUMP_SPEED  #Same thing as in the jump code.
			doubleJump = false #Restrict a double jump so that the player can't infinitely press jump and fly.
			walk.stop(true)
	#Detect if we're touching the ceiling quicker than is_on_ceiling().
	if rayCast.is_colliding():
		ceiling = true
	elif not rayCast.is_colliding():
		ceiling = false
	#Detect if we're touching the floor quicker than is_on_floor().
	if rayCastFloor.is_colliding():
		floorTouched = true
	elif not rayCastFloor.is_colliding():
		floorTouched = false	
	if Input.is_action_pressed("down") and is_on_floor() and crouching == false and climbing != true:
		crouching = true
	if Input.is_action_just_released("down") and is_on_floor() and crouching == true and climbing != true:
		if ceiling == false: #If NOT touching the ceiling while crouching...
			crouching = false
		elif ceiling == true: #If touching the ceiling while crouching...
			sprite.set_texture(dead)
			health -= 100#Quit the app. Yet another placeholder for death.
	if crouching == true and is_on_floor() and climbing != true:
		walk.stop(true)
		fullbody.set_deferred("disabled" , true)
		sprite.set_texture(crouch)
	elif crouching == false and is_on_floor() and climbing != true:
		fullbody.set_deferred("disabled", false)
		
	if is_on_wall() and velocity.x == 0 and crouching:
		sprite.set_texture(crouch)
	
	#Make the player move based on information provided to the code.
	velocity.x = direction * WALK_SPEED #Every frame, add to the x value of velocity the direction value multiplied by walk speed
	move_and_slide(velocity, Vector2.UP) #Here I added "Vector2.UP" because otherwise "is_on_floor() literally would not work. 

#Whenever the timer for the fall animation runs out...
func _on_Timer_timeout():
	if !floorTouched and velocity.y > 0: #Had to use raycast floorTouched because it's faster, and had to use velocity.y to make sure the sprite doesn't change to falling too quickly after jumping.
		sprite.set_texture(fall)

func _on_Timer2_timeout():
	print("You died.")
	get_tree().quit()
	
