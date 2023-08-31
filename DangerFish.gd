extends KinematicBody2D

var direction := Vector2(-3,0)
var randomSpeed := 0
var switchingDirection := false
onready var sprite := $Sprite
onready var swimSound := $SwimSound
onready var pathTimer := $PathTimer
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var animation := $AnimationPlayer
onready var damageTimer := $DamageTimer
onready var healthBar := $ProgressBar
onready var nibbleSound := $NibbleSound
var bodyToDamage : Node = null
var health := 75
var takingDamage = false

func _ready():		
	sprite.self_modulate = Color(0.917647,0.235294,0.235294,1)
	if difficulty.difficulty == 0:
		randomSpeed = rand_range(54.0, 64.8)
	elif difficulty.difficulty == 1:
		randomSpeed = rand_range(64.8, 80.2)
	pathTimer.start()
	healthBar.max_value = 60
	
func _process(delta):
	if health <= 0 and !takingDamage:
		set_process(false)
		animation.stop()
		set_physics_process(false)
		animation.play("death")


func _physics_process(delta):
	healthBar.set_value(health)
	if takingDamage:
		sprite.self_modulate = Color(0.5,0.5,0.75,1)
	elif !takingDamage:
		sprite.self_modulate = Color(0.917647,0.235294,0.235294,1)
	if !switchingDirection:
		sprite.flip_h = 0
		direction = Vector2(-3,0)
		var velocity := direction * randomSpeed
		if !swimSound.is_playing():
			swimSound.pitch_scale = (randomSpeed/20)
			swimSound.play()
		if round(velocity.x) == 0:
			swimSound.stop()
			animation.stop()
		elif round(velocity.x) != 0:
			if !animation.is_playing():
				animation.play("swim")
		if round(velocity.y) == 0:
			swimSound.stop()
		move_and_slide(velocity, Vector2.UP)
	elif switchingDirection:
		sprite.flip_h = -1
		direction = Vector2(3,0)
		var velocity := direction * randomSpeed
		if !swimSound.is_playing():
			swimSound.pitch_scale = (randomSpeed/20)
			swimSound.play()
		if round(velocity.x) == 0:
			swimSound.stop()
			animation.stop()
		elif round(velocity.x) != 0:
			if !animation.is_playing():
				animation.play("swim")
		if round(velocity.y) == 0:
			swimSound.stop()
		move_and_slide(velocity, Vector2.UP)

func _on_PathTimer_timeout():
	if difficulty.difficulty == 0:
		randomSpeed = rand_range(54.0, 64.8)
	elif difficulty.difficulty == 1:
		randomSpeed = rand_range(64.8, 80.2)


func _on_DamageArea_body_entered(body):
	if body.is_in_group("player"):
		damageTimer.start()
		body.takingDamage = true
		bodyToDamage = body
		return bodyToDamage

func _on_DamageTimer_timeout():
	if health > 0:
		if difficulty.difficulty == 0:
			bodyToDamage.health -= 18
			nibbleSound.play()
		elif difficulty.difficulty == 1:
			bodyToDamage.health -= 27
			nibbleSound.play()
	
func _on_DamageArea_body_exited(body):
	if body.is_in_group("player"):
		damageTimer.stop()
		body.takingDamage = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
