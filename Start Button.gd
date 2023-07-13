extends Button

func _on_Start_Button_pressed():
	get_tree().change_scene("res://levelScenes/Green Groves.tscn")
	
	print(get_tree().get_current_scene().filename)
