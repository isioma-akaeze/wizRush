extends Button

func _on_Quit_Main_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")
	
