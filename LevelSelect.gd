extends CanvasLayer

func _ready():
	var music := get_node("/root/GlobalMusicOption")
	var mainMenu := get_node("/root/GlobalMusicScene")
	if music.musicOn == 0 and !mainMenu.get_node("LobbyMusic").playing:
		mainMenu.get_node("LobbyMusic").play()
		mainMenu.get_node("GreenGroves").stop()
	elif music.musicOn == 1:
		mainMenu.get_node("LobbyMusic").stop()

