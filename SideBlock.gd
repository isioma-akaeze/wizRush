extends Area2D

var bodyX : Node = null
var inArea := false

func _physics_process(delta):
	if inArea and bodyX != null:
		bodyX.global_position.x += 18
		bodyX.switchingDirection = true

func _on_SideBlock_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("passive"):
		inArea = true
		bodyX = body
		return bodyX

func _on_SideBlock_body_exited(body):
	if body.is_in_group("enemy") or body.is_in_group("passive"):
		inArea = false
		bodyX = null
		return bodyX
