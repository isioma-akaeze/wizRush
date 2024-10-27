extends Area2D

onready var timer := $Timer
var raySpeed := 210.0
var flipped = false
var rayTransform := Vector2(2,0)
onready var animation := $AnimationPlayer
onready var shootSound := $ShootSound
onready var sprite := $Sprite
var blast = preload("res://assets/images/Request pack/Tiles/laserYellowBurst.png")
onready var blastTimer := $BlastTimer
var inContact := false
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var blastSound := $BlastSound

func _ready():
	if !shootSound.is_playing():
		shootSound.play()
	timer.start()

func _on_Ray_body_entered(body):
	var shot := false
	var globalKillCount := get_node("/root/KillCountDepths")
	if !body.is_in_group("player"):
		if is_instance_valid(body):
			if body.is_in_group("enemy") or body.is_in_group("passive"):
				if body.isInvincible == false:
					if difficulty.difficulty == 0:
						body.health -= 15
					else:
						body.health -= 7.5
						body.takingDamage = true
				else:
					if not body.startSlow:
						body.startSlow = true
					if not body.slowedDown:
						body.slowedDown = true
				if body.health == 0 and shot == false:
					globalKillCount.enemiesKilled += 1
					shot = true
				if body.health > 0:
					shot = false
			elif body.is_in_group("boss"):
				if difficulty.difficulty == 0:
					body.health -= 2
				else:
					body.health -= 2.5
				body.takingDamage = true
			animation.play("shrink")
	inContact = true
	return inContact

func _on_Timer_timeout():
	animation.play("shrink")

func _process(delta):
	if flipped and !inContact:
		position -= rayTransform * raySpeed * delta
	elif not flipped and !inContact:
		position += rayTransform * raySpeed * delta
	elif inContact:
		position += Vector2(0, 0) * 0 * 0


func _on_Ray_body_exited(body):
	if !body.is_in_group("player"):
		if is_instance_valid(body):
			if body.is_in_group("enemy") or body.is_in_group("passive"):
				body.takingDamage = false
			if body.is_in_group("boss"):
				body.takingDamage = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shrink":
		sprite.set_texture(blast)
		sprite.scale.x = 0.63
		sprite.scale.y = 0.63
		blastSound.play()
		blastTimer.start()


func _on_BlastTimer_timeout():
	queue_free()
