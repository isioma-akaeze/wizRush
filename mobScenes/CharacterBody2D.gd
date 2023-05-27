extends KinematicBody2D
#Defining variables
const GRAVITY := 300.0 #Rate at which the character vertically translate positively
const WALK_SPEED := 200 #Rate at which the character horizontally translates 
const velocity := Vector2.ZERO 
const JUMP_SPEED := -250.0 #Rate at which the character vertically translates negatively
var doubleJump := false #Can the character press the jump button again?

func _physics_process(delta):
	print("Double Jump Allowed?: " + str(doubleJump)) #Just some test outputs for Isioma
	velocity.y += delta * GRAVITY #Every frame, remove a certain amound from the y value of velocity
	var direction := Input.get_axis("left", "right") #The direction variable is equal to either what the left or right key provides
	if Input.is_action_just_pressed("up") and is_on_floor(): #"is_action_just_pressed" is faster than is "is_action_pressed, allowing enough time for a double jump to be allowed.
		doubleJump = true #Allow a double jump
		velocity.y = JUMP_SPEED #Add the JUMP_SPEED value as long as the if statement requirements are truee

		
	elif Input.is_action_just_pressed("up") and !is_on_floor() and doubleJump: # Same thing but now we're checking for if the character is allowed to do a double jump and is not on the ground.
			velocity.y = JUMP_SPEED #Same thing as in the jump code.
			doubleJump = false #Restrict a double jump so that the player can't infinitely press jump and fly.
	
	
	velocity.x = direction * WALK_SPEED #Every frame, add to the x value of velocity the direction value multiplied by walk speed
	move_and_slide(velocity, Vector2.UP) #Here I added "Vector2.UP" because otherwise "is_on_floor() literally would not work. 
	print("Player Touching Ground?: " + str(is_on_floor())) # Just some test outputs for Isioma
