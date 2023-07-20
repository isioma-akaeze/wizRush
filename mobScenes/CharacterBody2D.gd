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
var heartFull := preload("res://assets/images/Base pack/HUD/hud_heartFull.png")
var doubleJumpSprite := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_cheer2.png")
var hang := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_hang.png")
var GRAVITY := 475.0 #Rate at which the character vertically translate positively
var CLIMB_GRAVITY := 75.0 #Rate at which the character climbs ladders
const WALK_SPEED := 200 #Rate at which the character horizontally translates 
const velocity := Vector2.ZERO #Used for movement calculation
var JUMP_SPEED := -350.0 #Rate at which the character vertically translates negatively
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
onready var key := $Sprite/Sprite
onready var trialKey := $Sprite/Sprite2
var hasKey := false
var hasTrialKey := false
var coinCounter := 0
export var hasWon := false
export var passageBlocked := false
onready var winText := $WinText
onready var blockedText := $BlockedText
onready var blockedAnimation := $BlockedText/AnimationPlayer
onready var timer3 := $Timer3
onready var coinDisplay := $CoinCounter/BlockedText
onready var objective := $Objective
onready var objective2 := $Objective2
var anim_return := "null"
var stopwatch := 5.00
onready var stopwatchText := $Stopwatch
onready var pauseMenu := $PauseMenu
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var jumpSound := $Jump
onready var stackJumpSound := $Jump2
onready var slashTimer := $SlashTimer
onready var cooldown = false
var startClimbing := false
export var canSlip := false
onready var fallSound := $Falling
var jumping := false
export var onStone := false
onready var grassWalk := $GrassWalk
onready var stoneWalk := $StoneWalk
onready var cameraAnimation := $Camera2D/AnimationPlayer
onready var ladderSound := $LadderClimb
onready var deathSound := $Death
var pressingDown := false
var specialDeathCondition := false

func _ready() -> void:
	if difficulty.difficulty == 0:
		JUMP_SPEED = -350.0
		GRAVITY = 475.0
		stopwatch = 330.0
	elif difficulty.difficulty == 1:
		JUMP_SPEED = -522.5
		GRAVITY = 540.0
		CLIMB_GRAVITY *= 2
		stopwatch = 210.0
	pauseMenu.hide()
	objective.hide()
	objective2.hide()
	blockedText.hide()
	winText.hide()
	sprite.modulate = Color(1, 1, 1)
	stopwatchText.get_font("bold_font").extra_spacing_char = 6

func _process(delta) -> void:	
	if stopwatch <= 0:
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("pause"):
		_when_pause_button_pressed()
	
	var currentScene := (get_tree().get_current_scene().filename)
	if currentScene == "res://levelScenes/Green Groves.tscn":
		objective.show()
		objective2.hide()
	elif currentScene == "res://levelScenes/Ash Apocalypse.tscn":
		objective2.show()
		objective.hide()
	else:
		objective.hide()
		objective2.hide()
	
	if hasTrialKey == true and hasKey == false:
		trialKey.show()
		trialKey.position.y = -47
	elif hasTrialKey != true:
		trialKey.hide()
	if hasKey == true and hasTrialKey != true:
		key.show()
	elif hasKey != true:
		key.hide()
	elif hasKey == true and hasTrialKey == true:
		key.show()
		trialKey.position.y = -47
		trialKey.position.x = -20
		key.position.x = 20
		trialKey.show()
	coinDisplay.text = str(coinCounter)
		
	if health > 50:
		heart.set_texture(heartFull)
	if health <= 50:
		heart.set_texture(heartHalf)
	if health <= 0:
		grassWalk.stop()
		stoneWalk.stop()
		deathSound.play()
		sprite.set_texture(dead)
		sprite.modulate = Color(0, 0, 0, 1)
		heart.set_texture(heartEmpty)
		walk.stop()
		GRAVITY *= 1.175
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
func _physics_process(delta) -> void:
	stopwatch -= delta
	stopwatchText.text = str(stopwatch).pad_decimals(1)
	if hasWon == true:
		winText.show()
		set_physics_process(false)
	elif hasWon == false:
		winText.hide()
			
	if passageBlocked == true:
		blockedText.show()
		blockedAnimation.play("fadeAway")
	
	elif passageBlocked == false:
		blockedAnimation.stop()
		blockedText.hide()
		
	if takingDamage == true:
		sprite.modulate = Color(1, 0, 0, 1)
	elif takingDamage != true:
		sprite.modulate = Color(1, 1, 1)
	if Input.is_action_just_pressed("attack") and velocity.x == 0 and is_on_floor() and !cooldown:
		cooldown = true
		walk.stop()
		walk.play("swing")
		slashTimer.start()
	#If the left key is pressed, play the walk animation.
	if Input.is_action_pressed("left"):
		if is_on_floor() and !is_on_wall() and !crouching:
			#if Input.is_action_pressed("down"):
					walk.play("walk")
	#Same thing but with the right key.
	elif Input.is_action_pressed("right"):
		if is_on_floor() and !is_on_wall() and !crouching:
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
	if velocity.x == 0 and is_on_floor() and not Input.is_action_pressed("attack") and not Input.is_action_pressed("up") and !crouching and !climbing:
		sprite.set_texture(idle)
	#Yet ANOTHER failsafe to make sure the player doesn't walk into walls.
	if velocity.x == 0 and is_on_wall() and floorTouched and not Input.is_action_pressed("attack") and not Input.is_action_pressed("up") and !crouching and !climbing:
		sprite.set_texture(idle)
	
	if is_on_floor():
		for i in get_slide_count():
			var collision : KinematicCollision2D = null
			if is_on_floor() or floorTouched:
				collision = get_slide_collision(i)
			var currentGround := get_tree().get_current_scene().get_node("Map")
			if currentGround != null:
				var cell = currentGround.world_to_map(collision.position - collision.normal - Vector2(1, 0))
				var tileID : int = currentGround.get_cellv(cell)
				var tileName : String = currentGround.get_tileset().tile_get_name(tileID)
				if tileID == 0:
					onStone = false
				elif tileID == 7:
					onStone = true
				elif tileID == 9:
					onStone == true
				elif tileID == 2:
					onStone == false
					
		fallSound.stop()
		velocity.y = 0 #Set the velocity to not change if I'm on the ground, otherwise if I slide off a collision box, the fall speed is way too fast (it's almost comical)
		if abs(velocity.x) > 0.01 and floorTouched or abs(velocity.x) > 0.01 and is_on_floor():
			if not grassWalk.is_playing() and !climbing and !onStone:
				grassWalk.play()
				grassWalk.volume_db = -12
				stoneWalk.stop()
			elif onStone and !climbing and !stoneWalk.is_playing():
				stoneWalk.play()
				stoneWalk.volume_db = -12
				grassWalk.stop()
			elif climbing:
				grassWalk.stop()
				stoneWalk.stop()
			if crouching and !onStone:
				grassWalk.volume_db = -18
			elif crouching and onStone:
				stoneWalk.volume_db = -18
				
		elif abs(velocity.x) < 0.01:
			grassWalk.stop()
			stoneWalk.stop()
			
	
	elif !is_on_floor() or !floorTouched:
		grassWalk.stop()
		if !rayCastFloor.is_colliding():
			stoneWalk.stop()
#		pass 
#		if climbing == true and !Input.is_action_pressed("down") and !health <= 0:
#			sprite.set_texture(climb)
#			velocity.y -= delta * CLIMB_GRAVITY
#
#		#Every frame, make the character fall gradually faster, and start the timer for the fall "animation".
		timer.start()
		if !startClimbing:
			velocity.y += delta * GRAVITY 
			if !climbing:
				if not fallSound.is_playing() and !jumping and health > 0:
					fallSound.play()
				elif jumping:
					fallSound.stop()
				elif health <= 0:
					fallSound.stop()
			elif climbing:
				fallSound.stop()
		crouching = false
		
		
	#The direction variable is equal to either what the left or right key provides.
	var direction := Input.get_axis("left", "right")
	#Walk animation stuff...
	if Input.is_action_pressed("left"):
		isMoving = true
		sprite.flip_h = -1 #Flip the sprite
		if floorTouched == true and !is_on_wall() and !crouching:
			walk.play("walk")
		elif is_on_wall() and floorTouched != true:
			walk.stop(true)
		elif floorTouched != true and !is_on_wall() and !is_on_floor():
			walk.stop(true)
			if doubleJump:
				sprite.set_texture(jump)
			elif !doubleJump:
				sprite.set_texture(doubleJumpSprite)
		elif is_on_wall() and !isMoving:
			walk.stop(true)
	elif Input.is_action_pressed("right"):
		isMoving = true
		sprite.flip_h = 0 #Flip the sprite
		if is_on_floor() and !is_on_wall() and !crouching:
			walk.play("walk")
		elif floorTouched != true:
			walk.stop(true)
		elif is_on_wall() and !isMoving:
			walk.stop(true)
	#IIRC this is needed to signal to the code that velocity.x is inactive. Kind of seems useless but I'll keep it.
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		isMoving = false
	#Code for jumping and double jumps.
	if Input.is_action_just_pressed("up") and floorTouched and crouching != true and !health <= 0 and !climbing or Input.is_action_just_pressed("up") and is_on_floor() and crouching != true and !health <= 0 and !climbing: 
		jumpSound.play()
		jumping = true
		doubleJump = true #Allow a double jump
		sprite.set_texture(jump)
		velocity.y = JUMP_SPEED #Add the JUMP_SPEED value as long as the if statement requirements are truee
		walk.stop(true)
	if Input.is_action_just_pressed("up") and !is_on_floor() and doubleJump and difficulty.difficulty == 0 and !climbing: # Same thing but now we're checking for if the character is allowed to do a double jump and is not on the ground.
			jumping = true
			jumpSound.play()
			stackJumpSound.play()
			sprite.set_texture(doubleJumpSprite)
			velocity.y = JUMP_SPEED  #Same thing as in the jump code.
			doubleJump = false #Restrict a double jump so that the player can't infinitely press jump and fly.
			walk.stop(true)
	#Detect if we're touching the ceiling quicker than is_on_ceiling().
	rayCast.set_collision_mask(2)
	if rayCast.is_colliding():
		ceiling = true
	elif not rayCast.is_colliding():
		ceiling = false
	#Detect if we're touching the floor quicker than is_on_floor().
	if rayCastFloor.is_colliding():
		floorTouched = true
	elif not rayCastFloor.is_colliding():
		floorTouched = false	
	if Input.is_action_pressed("down") and is_on_floor() and crouching == false and climbing != true and !health <= 0:
		if walk.current_animation == "walk":
			walk.stop()
		crouching = true
	if Input.is_action_just_released("down") and is_on_floor() and crouching == true and climbing != true:
		if ceiling == false: #If NOT touching the ceiling while crouching...
			crouching = false
		elif ceiling == true: #If touching the ceiling while crouching...
			sprite.set_texture(dead)
			health -= 100#Quit the app. Yet another placeholder for death.
	if crouching == true and is_on_floor() and climbing != true:
		sprite.set_texture(crouch)
		if walk.current_animation == "walk":
			walk.stop(true)
		if velocity.x != 0 and !is_on_wall():
			walk.play("crawl")
			cameraAnimation.play("cameraShake")
		elif velocity.x == 0 or round(velocity.x) == 0:
			walk.stop()
		fullbody.set_deferred("disabled" , true)
#			elif round(velocity.x) == 0:
#				if walk.current_animation == "crawl":
#					walk.stop()
#					sprite.set_texture("crouch")
	elif crouching == false and is_on_floor() and climbing != true:
		$Camera2D.offset = Vector2(0,0)
		$Camera2D.rotation_degrees = 0
		cameraAnimation.stop()
		sprite.set_rotation_degrees(0)
		fullbody.set_deferred("disabled", false)
		if walk.current_animation == "crawl":
			walk.stop()
		
	if is_on_wall() and round(velocity.x) == 0 and crouching:
		if walk.current_animation == "crawl":
			walk.stop()
		cameraAnimation.stop()
		if is_on_floor():
			sprite.set_texture(crouch)
			#sprite.set_texture(crouch)
#			elif round(velocity.x) == 0:
#				if walk.current_animation == "crawl":
#					walk.stop()
#					sprite.set_texture("crouch")

	if crouching and is_on_wall():
		cameraAnimation.stop()
		walk.stop()
		sprite.set_texture(crouch)
	
	#Make the player move based on information provided to the code.
	velocity.x = direction * WALK_SPEED #Every frame, add to the x value of velocity the direction value multiplied by walk speed
	move_and_slide(velocity, Vector2.UP) #Here I added "Vector2.UP" because otherwise "is_on_floor() literally would not work. 

	
	if ceiling == true and floorTouched and velocity.x == 0 and !crouching and climbing != true or ceiling == true and is_on_floor() and velocity.x == 0 and !crouching and climbing != true:
		sprite.set_texture(dead)
		sprite.modulate = Color(0, 0, 0, 1)
		health -= 100
		specialDeathCondition = true
		secondTimer.start()
	
	
	if climbing == true and health > 0:
		_startClimbing()
		
	if climbing == false:
		startClimbing = false
		
	if startClimbing and !canSlip and health > 0:
		if is_on_floor():
			global_position.y -= 0.5
		if !is_on_floor() and velocity.x == 0:
			if velocity.y == 0 and walk.current_animation != "climbLadder":
				sprite.set_texture(climb)
				pass
		velocity.y = 0
		if Input.is_action_pressed("up"):
			if !ladderSound.is_playing() and !floorTouched:
				ladderSound.play()
			elif floorTouched:
				ladderSound.stop()
			if walk.current_animation != "climbLadder":
					walk.play("climbLadder")
			velocity.y -= CLIMB_GRAVITY
		elif Input.is_action_pressed("down"):
			if !ladderSound.is_playing() and !floorTouched:
				ladderSound.play()
			elif floorTouched:
				ladderSound.stop()
			if walk.current_animation != "climbLadder" and !floorTouched:
				walk.play("climbLadder")
			velocity.y += CLIMB_GRAVITY
		else:
			ladderSound.stop()
			if walk.current_animation == "climbLadder":
				walk.stop()
	elif startClimbing and canSlip and health > 0:
		if is_on_floor():
			global_position.y -= 0.5
		velocity.y = 0
		if Input.is_action_pressed("up"):
			sprite.set_texture(hang)
			if difficulty.difficulty == 0:
				velocity.y -= CLIMB_GRAVITY * 3.5
			elif difficulty.difficulty == 1:
				velocity.y -= CLIMB_GRAVITY * 4.2
		elif !Input.is_action_pressed("up"):
			sprite.set_texture(fall)
			if Input.is_action_pressed("up"):
				sprite.set_texture(hang)
			if difficulty.difficulty == 0:
				velocity.y += CLIMB_GRAVITY * 3.5
			elif difficulty.difficulty == 1:
				velocity.y += CLIMB_GRAVITY * 4.2
		else:
			sprite.set_texture(fall)
	elif !startClimbing:
		ladderSound.stop()
	
	if Input.is_action_pressed("down") and round(velocity.y) <= 8:
		if is_on_wall():
			cameraAnimation.stop()
			$Camera2D.offset = Vector2(0,0)
		pressingDown = true
	elif round(velocity.y) > 8:
		pressingDown = false
		
	if specialDeathCondition:
		sprite.set_texture(dead)
		sprite.modulate = Color(0, 0, 0, 1)
		get_tree().reload_current_scene()

func _startClimbing():
	startClimbing = true


#Whenever the timer for the fall animation runs out...
func _on_Timer_timeout():
	if !floorTouched and velocity.y > 0 and !climbing: #Had to use raycast floorTouched because it's faster, and had to use velocity.y to make sure the sprite doesn't change to falling too quickly after jumping.
		if !crouching:
			if !pressingDown:
				sprite.set_texture(fall)
		jumping = false
	elif !floorTouched and velocity.y <= 0 and !climbing and !jumping:
		if !crouching:
			sprite.set_texture(fall)


func _on_Timer2_timeout():
	get_tree().reload_current_scene()
	
func _on_AnimationPlayer_animation_finished(anim_name):
	anim_return = anim_name
	if anim_name == "fadeAway":
		passageBlocked = false
	return anim_return
	
func _when_pause_button_pressed():
	if pauseMenu.visible == false and get_tree().paused == false:
		get_tree().paused = true
		$PauseMenu/Control.paused = false
		pauseMenu.show()


func _on_SlashTimer_timeout():
	cooldown = false

