extends Node2D

onready var deathArea := $EnemyBody/DeathArea
onready var healthBar := $EnemyBody/ProgressBar
onready var health := 25
onready var animation := $EnemyBody/AnimationPlayer
onready var timer := $EnemyBody/Timer2
onready var timer2 := $EnemyBody/Timer3
onready var bee := $EnemyBody/Sprite
onready var dead := preload("res://assets/images/Extra animations and enemies/Enemy sprites/bee_hit.png")
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var bodyToKill : Node = null

func _on_DeathArea_body_entered(body):
	if body.is_in_group("damageEnemy"):
		if difficulty.difficulty == 0:
			health -= 12.5
		elif difficulty.difficulty == 1:
			health -= 8.34
		bee.set_texture(dead)
		bodyToKill = body.get_parent()
		return bodyToKill
			
func _physics_process(delta) -> void:
	animation.play("Fly")
	healthBar.max_value == 25
	healthBar.set_value(health)
	if health <= 0:
		bodyToKill.enemiesKilled += 1
		animation.stop()
		set_physics_process(false)
		animation.play("death")
		bee.set_physics_process(false)

		


func _on_Timer_timeout():
	queue_free()


func _on_Timer3_timeout():
	timer.start()


func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "death":
		
		timer2.start()
