extends Area2D

onready var animation := $AnimationPlayer
onready var collectSound := $KeyCollect
var collected := false

func _ready():
	global_position.x = 1800
	global_position.y = 2656

func _process(delta):
	if !collected:
		animation.play("hover")
	elif collected:
		animation.stop()
	
func _on_DemoKey_body_entered(body):
	if body.is_in_group("player"):
		collected = true
		body.hasDemoKey = true
		set_process(false)
		animation.play("collect")
		collectSound.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()

