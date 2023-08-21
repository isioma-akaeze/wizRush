extends CanvasLayer

onready var start := $"Start Button"
onready var quit := $"Quit Program Button"
onready var settings := $"Settings Button"
var focus = 1


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		if focus == 1:
			focus = 1
			start.grab_focus()
			quit.release_focus()
		elif focus == 2:
			focus -= 1
			start.grab_focus()
			settings.release_focus()
		elif focus == 3:
			focus -= 1
			settings.grab_focus()
			quit.release_focus()

	elif Input.is_action_just_pressed("ui_down"):
		if focus == 1:
			focus += 1
			start.release_focus()
			settings.grab_focus()
		elif focus == 2:
			focus += 1
			quit.grab_focus()
			settings.release_focus()
		elif focus == 3:
			focus = 3
			settings.release_focus()
			quit.grab_focus()

func _ready():
	var music := get_node("/root/GlobalMusicOption")
	var mainMenu := get_node("/root/GlobalMusicScene")
	if music.musicOn == 0 and !mainMenu.get_node("LobbyMusic").playing:
		mainMenu.get_node("LobbyMusic").play()
		mainMenu.get_node("GreenGroves").stop()
	elif music.musicOn == 1:
		mainMenu.get_node("LobbyMusic").stop()
