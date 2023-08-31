extends Area2D

var bodyX : Node = null
var inArea := false

func _physics_process(delta):
	if inArea and bodyX != null:
		bodyX.global_position.y -= 18
	

func _on_MobBlock_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("passive"):
		inArea = true
		bodyX = body
		return bodyX

func _on_MobBlock_body_exited(body):
	if body.is_in_group("enemy") or body.is_in_group("passive"):
		inArea = false
		bodyX = null
		return bodyX
