extends Area2D

onready var lavaSound := $LavaBoil
onready var burnSound := $Burnt

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	if body.is_in_group("damagePlayer"):
		body.health -= 100
		burnSound.play()

func _process(delta):
	if !lavaSound.is_playing():
		lavaSound.play()
