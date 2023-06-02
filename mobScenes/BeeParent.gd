extends Node2D

onready var deathArea := $EnemyBody/DeathArea
onready var healthBar := $EnemyBody/ProgressBar
onready var health := 25
onready var death := $EnemyBody/AnimationPlayer

func _on_DeathArea_body_entered(body):
	if body.is_in_group("damageEnemy"):
			health -= 10
			
func _physics_process(delta) -> void:
	healthBar.max_value == 25
	healthBar.set_value(health)
	if health <= 0:
		death.stop()
		death.play("death")
		death.stop()
		queue_free()
		
