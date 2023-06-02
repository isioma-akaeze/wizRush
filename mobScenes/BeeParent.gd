extends Node2D

onready var deathArea := $EnemyBody/DeathArea
onready var healthBar := $EnemyBody/ProgressBar
onready var health := 25
onready var animation := $EnemyBody/AnimationPlayer
onready var timer := $EnemyBody/Timer2
onready var timer2 := $EnemyBody/Timer3
onready var bee := $EnemyBody

func _on_DeathArea_body_entered(body):
	if body.is_in_group("damageEnemy"):
			health -= 10
			
func _physics_process(delta) -> void:
	animation.play("Fly")
	healthBar.max_value == 25
	healthBar.set_value(health)
	if health <= 0:
		animation.stop()
		print("Play animation")
		animation.play("death")
		

		


func _on_Timer_timeout():
	queue_free()


func _on_Timer3_timeout():
	timer.start()


func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "death":
		timer2.start()
