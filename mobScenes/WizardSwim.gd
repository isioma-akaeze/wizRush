extends KinematicBody2D

var sinkGravity := 80
var swimGravity := -120
var maximumSwimGravity := -120
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
onready var trialKeySprite := $TrialKey
onready var demoKeySprite := $DemoKey
onready var keySprite := $Key
var hasTrialKey := false
var hasDemoKey := false
var hasKey := false
var passageBlocked := false
onready var healthBar := $ProgressBar
onready var coinDisplay := $CoinCounter/BlockedText
var coinCounter := 0
var health := 100
onready var blockedText := $BlockedText
onready var blockedAnimation := $BlockedText/AnimationPlayer
var anim_return := "null"
var stopwatch := 0.00
onready var stopwatchText := $Stopwatch
var takingDamage := false
onready var heart := $Heart
var heartHalf := preload("res://assets/images/Base pack/HUD/hud_heartHalf.png")
var heartEmpty := preload("res://assets/images/Base pack/HUD/hud_heartEmpty.png")
var heartFull := preload("res://assets/images/Base pack/HUD/hud_heartFull.png")
var dead := preload("res://assets/images/kenney_platformer-characters/PNG/Adventurer/Poses/adventurer_hurt.png")
onready var deathTimer := $DeathTimer
onready var pauseMenu := $PauseMenu
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var deathMenu := $DeathMenu
onready var failSound := $DeathMenu/FailSound
onready var breathingSound := $BreathingSound
onready var swimSound := $SwimSound
onready var killDisplay := $"KillCount Text"
var enemiesKilled := 0
onready var globalKillCount := get_node("/root/KillCountDepths")
onready var deathSound := $Death
onready var stopwatchAnimation := $Stopwatch/AnimationPlayer
onready var stopwatchSound := $Stopwatch/StopwatchSound
export var attackingBoss := false
onready var bossBar:= $BossBar
var beingDragged = false
onready var damageTimer := $DamageTimer
var hasWon = false
onready var statCheck := get_node("/root/LevelCheck")
var winTimer := Timer.new()
onready var winText := $WinMenu

func _ready():
	add_child(winTimer)
	winTimer.wait_time = 1.5
	winTimer.one_shot = true
	winTimer.connect("timeout", self, "_on_winTimer_timeout")
	bossBar.hide()
	bossBar.max_value = 300
	globalKillCount.enemiesKilled = 0
	pauseMenu.hide()
	healthBar.max_value = 100
	stopwatchText.get_font("bold_font").extra_spacing_char = 6
	keySprite.hide()
	demoKeySprite.hide()
	trialKeySprite.hide()
	blockedText.hide()
	if difficulty.difficulty == 0:
		stopwatch = 570.0
		#stopwatch = 15.0
		#stopwatch = 5.0
	elif difficulty.difficulty == 1:
		stopwatch = 395.0
	deathMenu.hide()
	winText.hide()
	
func _process(delta):	
	if beingDragged:
		takingDamage = true
		if damageTimer.is_stopped():
			damageTimer.start()
		maximumSinkGravity = 600
		sinkGravity = 600
		swimGravity = -15
		maximumSwimGravity= -15
	else:
		if !damageTimer.is_stopped():
			damageTimer.stop()
		takingDamage = false
		maximumSinkGravity = 80
		sinkGravity = 80
		swimGravity = -120
		maximumSwimGravity= -120
		
	
	if attackingBoss == true:
		bossBar.show()
	else:
		bossBar.hide()
	enemiesKilled = globalKillCount.enemiesKilled
	killDisplay.text = str(enemiesKilled)
	if !breathingSound.is_playing() and health > 0:
		breathingSound.play()
	elif health <= 0:
		breathingSound.stop()
	if Input.is_action_just_pressed("pause"):
		_when_pause_button_pressed()
	if health > 50:
		heart.set_texture(heartFull)
	if health < 50 and health > 0:
		heart.set_texture(heartHalf)
	
	if health <= 0:
		deathSound.play()
		sprite.set_texture(dead)
		heart.set_texture(heartEmpty)
		sprite.modulate = Color(0, 0, 0, 1)
		animation.stop()
		set_process(false)
		set_physics_process(false)
		deathTimer.start()

func _physics_process(delta) -> void:
	if hasWon:
		set_physics_process(false)
		statCheck.levelThreeCoins = coinCounter
		statCheck.levelThreeKills = enemiesKilled
		if difficulty.difficulty == 0:
			statCheck.levelThreeTime = 570.0 - stopwatch
			#1350.0 -
			statCheck.totalTime = (statCheck.levelOneTime + statCheck.levelTwoTime + statCheck.levelThreeTime) # + " / 1350s")
			$WinMenu/Clock/WinStopwatch.text =str(str(statCheck.totalTime).pad_decimals(1) + "/1350.0")
		elif difficulty.difficulty == 1:
			statCheck.levelThreeTime = (395.0 - stopwatch)
			 #935.0 -
			statCheck.totalTime = (statCheck.levelOneTime + statCheck.levelTwoTime + statCheck.levelThreeTime) # + " / 935s")
			$WinMenu/Clock/WinStopwatch.text = str(str(statCheck.totalTime).pad_decimals(1) + "/935.0")
		statCheck.totalCoins = statCheck.levelOneCoins + statCheck.levelTwoCoins + statCheck.levelThreeCoins # + " " + "/" + "387")
		$WinMenu/Control/WinCoinCounter/BlockedText.text =str(str(statCheck.totalCoins) + "/387")
		$WinMenu/KillCounter/BlockedText.text = str(statCheck.totalKills)
		var winTimerStart := $WinMenu.timer as Timer
		winTimerStart.start()
		winTimer.start()
	elif not hasWon:
		winText.hide()
	stopwatch -= delta
	stopwatchText.text = str(stopwatch).pad_decimals(1)
	
	if stopwatch <= 0:
		animation.stop()
		set_physics_process(false)
		set_process(false)
		get_tree().paused = true
		deathMenu.show()
		failSound.play()
	if stopwatch <= 10.0 and stopwatch > 0:
		stopwatchAnimation.play("pulsate")
		if not stopwatchSound.is_playing():
			stopwatchSound.play()

	if passageBlocked == true:
		blockedText.show()
		blockedAnimation.play("fadeAway")
	elif passageBlocked == false:
		blockedAnimation.stop()
		blockedText.hide()
	coinDisplay.text = str(coinCounter)
	healthBar.set_value(health)
	if hasTrialKey and !hasDemoKey and !hasKey:
		trialKeySprite.show()
	elif hasTrialKey and hasDemoKey and !hasKey:
		trialKeySprite.show()
		trialKeySprite.position.x = -20
		demoKeySprite.show()
		demoKeySprite.position = Vector2(17, -53)
	elif hasTrialKey and hasDemoKey and hasKey:
		trialKeySprite.show()
		trialKeySprite.position.x = -34
		demoKeySprite.show()
		demoKeySprite.position = Vector2(0, -53)
		keySprite.show()
		keySprite.position = Vector2(34, -53)
	elif !hasTrialKey:
		trialKeySprite.hide()
	if !hasDemoKey:
		demoKeySprite.hide()
	if !hasKey:
		keySprite.hide()
	
	if passageBlocked:
		pass
	elif !passageBlocked:
		pass
	if takingDamage == true:
		sprite.modulate = Color(1, 0, 0, 1)
		raygunSprite.modulate = Color(1, 0, 0, 1)
	elif takingDamage != true:
		sprite.modulate = Color(0.498039, 1, 0.831373, 1)
		raygunSprite.modulate = Color(0.498039, 1, 0.831373, 1)
	
	var direction := Input.get_axis("left", "right")
	
	velocity.x = direction * swimSpeed
	
	if Input.is_action_pressed("up"):
		if velocity.y > 0:
			velocity.y = 0
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
		if velocity.y < 0:
			velocity.y = 0
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
				ray.rotation_degrees = sprite.rotation_degrees *(2/3)
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
				ray.rotation_degrees = sprite.rotation_degrees * (2/3)
				ray.flipped = true
				rayCanShoot = false
				rayTimer.start()

	if round(velocity.x) != 0 and health > 0 and !is_on_floor():
		swimSound.pitch_scale = 1
		if !swimSound.is_playing():
			swimSound.play()
	elif is_on_floor():
		swimSound.pitch_scale = 0.8
		if !swimSound.is_playing():
			swimSound.play()
	elif round(velocity.x) == 0:
		swimSound.stop()
		
	move_and_slide(velocity, Vector2.UP)


func _on_RayTimer_timeout():
	rayCanShoot = true


func _on_AnimationPlayer_animation_finished(anim_name):
	anim_return = anim_name
	if anim_name == "fadeAway":
		passageBlocked = false
	return anim_return


func _on_DeathTimer_timeout():
	animation.stop()
	set_physics_process(false)
	set_process(false)
	get_tree().paused = true
	deathMenu.show()
	$DeathMenu/Control/ResumeDie2.grab_focus()
	failSound.play()

func _when_pause_button_pressed():
	if pauseMenu.visible == false and get_tree().paused == false:
		get_tree().paused = true
		$PauseMenu/ControlDepths.paused = false
		$PauseMenu/ControlDepths/Resume2.grab_focus()
		pauseMenu.show()


func _on_DamageTimer_timeout():
	if difficulty.difficulty == 0:
		health -= 3
	elif difficulty.difficulty == 1:
		health -= 4
		
func _on_winTimer_timeout():
	var soundTimer := 1
	get_tree().paused = true
	$WinMenu/Control/NextLevelButton.grab_focus()
	winText.show()
	if soundTimer == 1:
		if not $WinMenu/WinSound.playing:
			$WinMenu/WinSound.play()
		soundTimer = 2
	else:
		$WinMenu/WinSound.stop()
