extends Area2D
var interacting := false 

func _on_DamageArea_body_entered(body):
	if body.is_in_group("climber"):
		print("YOU DIED!")
		get_tree().quit()

