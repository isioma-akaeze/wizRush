extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	print("YOU DIED!")
	get_tree().quit()

