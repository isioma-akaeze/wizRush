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
	healthBar.max_value == 25
	healthBar.set_value(health)
	if health <= 0:
		set_physics_process(false)
		animation.stop()
		animation.play("death")
		timer2.start()

		


func _on_Timer_timeout():
	queue_free()


func _on_Timer3_timeout():
	timer.start()
