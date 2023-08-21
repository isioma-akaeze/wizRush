extends CanvasLayer

onready var start := $Options/OptionButton
onready var settings := $Music/MusicOption
onready var quit := $"Quit to Menu"
var focus = 1
onready var menu := get_node("/root/GlobalMusicScene")
onready var options := get_node("/root/GlobalOptionButton")
onready var music := get_node("/root/GlobalMusicOption")
var optionToggled := menu

func _ready():
	start.selected = options.difficulty
	settings.selected = music.musicOn
	if music.musicOn == 0 and !menu.get_node("LobbyMusic").playing:
		menu.get_node("LobbyMusic").play()
	elif music.musicOn == 1:
		menu.get_node("LobbyMusic").stop()
