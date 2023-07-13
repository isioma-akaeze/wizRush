extends Button

func _on_Quit_to_Menu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	
func _ready():
	grab_focus()
