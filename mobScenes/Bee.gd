extends KinematicBody2D

onready var fly := $AnimationPlayer
export var switchingDirection = false
onready var sprite := $Sprite
onready var healthBar := $ProgressBar
onready var collision := $CollisionShape2D
onready var deathArea := $DeathArea/CollisionShape2D
var speed := 15.0
#var health := 25
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var buzz := $"Buzz Sound"

func _ready():
	buzz.play()


func _physics_process(delta) -> void:
	if difficulty.difficulty == 0:
		speed = 15.0
	elif difficulty.difficulty == 1:
		speed = 22.5
	var health : float = get_parent().health
	if health > 0:
		collision.set_deferred("disabled", false)
		deathArea.set_deferred("disabled", false)
	elif health <= 0:
		buzz.stop()
		collision.set_deferred("disabled", true)
		deathArea.set_deferred("disabled", true)
	var direction := Vector2(-3,0)
	#If touching collision box, change direction:
	if switchingDirection:
		direction.x = direction.x * -1 
		sprite.flip_h = -1
	elif not switchingDirection:
		direction.x = -3
		sprite.flip_h = 0
	var velocity := direction * speed
	move_and_slide(velocity)
	if health <= 0:
		velocity.x = 0
		velocity.y = 0
		set_physics_process(false)
