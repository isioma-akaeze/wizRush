extends Node2D

onready var bubblesAttackTimer := $BubbleAttackTimer
onready var damageTimer := $DamageTimer
onready var bubblesWaitTimer := $BubblesWaitTimer
onready var bubblesSprite := $BubbleSprite
onready var spikeArea := $SpikeDragArea
onready var bodyToDamage : Node = null
onready var difficulty := get_node("/root/GlobalOptionButton")
onready var bubblingSound := $BubblingSound

func _ready():
	spikeArea.monitoring = false
	bubblesSprite.hide()
	bubblesWaitTimer.start()

func _on_BubblesWaitTimer_timeout():
	spikeArea.monitoring = true
	bubblesSprite.show()
	if !bubblingSound.playing:
		bubblingSound.play()
	bubblesAttackTimer.start()
	
func _on_BubbleAttackTimer_timeout():
	spikeArea.monitoring = false
	bubblesSprite.hide()
	if bubblingSound.playing:
		bubblingSound.stop()
	bubblesWaitTimer.start()

func _on_SpikeDragArea_body_entered(body):
	if body.is_in_group("player"):
		body.beingDragged = true

func _on_SpikeDragArea_body_exited(body):
	if body.is_in_group("player"):
		body.beingDragged = false

func _on_SpikeKillArea_body_entered(body):
	if body.is_in_group("player"):
		body.health -= 100

