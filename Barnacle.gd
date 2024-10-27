extends KinematicBody2D

onready var animation := $GeneralAnimation
onready var biteSound := $BiteSound
onready var bossMusic := $BossMusic
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var bodyToDamage : Node = null
onready var damageTimer := $DamageTimerBoss
onready var attackWaitTimer := $AttackWaitTimer
onready var bubblesAnimation := $Sprite/BubbleSprite/AnimationPlayer
var bodyHealthBar : Node = null
var health := 300
var takingDamage := false
onready var sprite := $Sprite
onready var spitSound := $BossSpit
var spitSoundPlayed := false
onready var bubbleSound := $BubblingSound
onready var deathSound := $BossDeathSound

func _ready():
	animation.play("bite")
	bossMusic.stop()
	
func _process(delta):
	if spitSoundPlayed and spitSound.playing == true:
		spitSound.stop()
	if takingDamage == true:
		sprite.modulate = Color(1, 0, 0, 1)
	elif takingDamage != true:
		sprite.modulate = Color(1, 1, 1, 1)
	if bodyHealthBar != null:
		bodyHealthBar.bossBar.value = health
	if health <= 0:
		if bodyHealthBar!= null:
			bodyHealthBar.hasWon = true
		set_process(false)
		if !deathSound.playing:
			deathSound.play()
		animation.stop()
		set_physics_process(false)
		animation.play("death")			

func _on_GeneralAnimation_animation_finished(anim_name):
	if anim_name == "bite":
		attackWaitTimer.start()
		spitSound.stop()
	if anim_name == "shake":
		if bubbleSound.playing:
			bubbleSound.stop()
		animation.play("bite")
		spitSound.stop()
	elif anim_name == "spit":
		var randomMob := (randi() % 3)
		var piranhaScene : PackedScene = null
		if randomMob == 0:
			piranhaScene = load("res://DangerFish.tscn")
		elif randomMob == 1:
			piranhaScene = load("res://mobScenes/Piranha.tscn")
		elif randomMob == 2:
			piranhaScene = load("res://randomScenes/potion.tscn")
		var xOffset := 0
		var spawns := 0
		if randomMob == 0:
			for i in range(1):
				var piranhaSceneInstance : KinematicBody2D = piranhaScene.instance()
				var piranhaX := self.position.x - rand_range(-20, 23.0) +  xOffset
				var piranhaY := self.position.y - rand_range(100.0, 320.0)
				piranhaSceneInstance.isSpawned = true
				piranhaSceneInstance.position = Vector2(piranhaX, piranhaY)
				get_tree().current_scene.add_child(piranhaSceneInstance)
				xOffset += 120
				spawns += 2
		elif randomMob == 1:
			for i in range(1):
				var piranhaSceneInstance : KinematicBody2D = piranhaScene.instance()
				var piranhaX := self.position.x - rand_range(-20, 23.0) +  xOffset
				var piranhaY := self.position.y - rand_range(100.0, 320.0)
				piranhaSceneInstance.isSpawned = true
				piranhaSceneInstance.position = Vector2(piranhaX, piranhaY)
				get_tree().current_scene.add_child(piranhaSceneInstance)
				xOffset += 120
				spawns += 2
		elif randomMob == 2:
			for i in range(1):
				var piranhaSceneInstance : Area2D = piranhaScene.instance()
				var piranhaX := self.position.x - rand_range(-20, 23.0) +  xOffset
				var piranhaY := self.position.y - rand_range(300, 350)
				piranhaSceneInstance.scale.x = 3
				piranhaSceneInstance.scale.y = 3
				piranhaSceneInstance.position = Vector2(piranhaX, piranhaY)
				get_tree().current_scene.add_child(piranhaSceneInstance)
				xOffset += 120
				spawns += 2
		if spawns == 2:
			animation.play("bite")
	elif anim_name == "death":
		queue_free()
	#elif anim_name == "vomit":
		# var vomitBallScene : PackedScence = null
		# var vomits := 0
		# vomitBallScene = load("res://VomitBall.tscn")
		# for i in range(3):
			#var vomitBallInstance : KinematicBody2D = vomitBallScence.instance()
			#var vomitX := self.position.x 
			#var vomitY := self.position.y - 70
			#vomitBallInstance.position = Vector2(vomitX, vomitY)
			#get_tree().current_scene.add_child(piranhaSceneInstance) 
			#vomits += 1
		#if vomits == 3:
			#animation.play("bite")
			

func _on_BubbleArea_body_entered(body):
	if body.is_in_group("player"):
		body.beingDragged = true
		body.takingDamage = true
		if damageTimer.is_stopped():
			damageTimer.start()
			bodyToDamage = body
	return bodyToDamage
			
func _on_BossArea_body_entered(body):
	if body.is_in_group("player"):
		bodyHealthBar = body
		body.attackingBoss = true
		if !bossMusic.is_playing():
			bossMusic.play()
	elif body.is_in_group("enemy"):
		if body.isSpawned == false:
			body.inBossArea = true
	return bodyHealthBar

func _on_BossArea_body_exited(body):
	if body.is_in_group("player"):
		body.attackingBoss = false
		bossMusic.stop()

func _on_BubbleArea_body_exited(body):
	if body.is_in_group("player"):
		body.beingDragged = false
		body.takingDamage = false
		if !damageTimer.is_stopped():
			damageTimer.stop()

func _on_TeethArea_body_entered(body):
	if body.is_in_group("player"):
		body.health -= 100
	elif body.is_in_group("enemy"):
		body.health -= 15

func _on_DamageTimerBoss_timeout():
	if difficulty.difficulty == 0:
		if !bodyToDamage == null:
			bodyToDamage.health -= 2
	elif difficulty.difficulty == 1:
		if !bodyToDamage == null:
			bodyToDamage.health -= 4
			
func _randomAttack():
	var spitSoundPlayed := false
	spitSound.stop()
	var randomAttack := (randi() % 2)
	if randomAttack == 0:
		animation.play("shake")
		if !bubbleSound.playing:
			bubbleSound.play()
		bubblesAnimation.play("bubbles")
	elif randomAttack == 1:
		animation.play("spit")
		if !spitSoundPlayed:
			spitSound.play()
			spitSoundPlayed = true
	#elif randomAttack == 3:
		#animation.play("vomit")

func _on_AttackWaitTimer_timeout():
	_randomAttack()
