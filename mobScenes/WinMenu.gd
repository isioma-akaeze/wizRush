extends CanvasLayer

var timer := Timer.new()
var anim = 0

func _ready():
	$Control/WinCoinCounter.hide()
	$Clock.hide()
	$KillCounter.hide()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim != 1:
		$Clock.show()
		$Clock/AnimationPlayer.play("impact")
		anim = 1
	elif anim == 1:
		$Clock/AnimationPlayer.stop()
		$KillCounter.show()
		$KillCounter/AnimationPlayer.play("impactKill")
		anim = 2
		

func _on_timer_timeout():
	var playedAnimation := 0
	$Control/WinCoinCounter.show()
	if not $Control/WinCoinCounter/AnimationPlayer.is_playing() and playedAnimation == 0:
		$Control/WinCoinCounter/AnimationPlayer.play("impact")
		playedAnimation = 1
		
