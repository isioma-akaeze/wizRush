extends OptionButton
onready var music := get_node("/root/GlobalMusicOption")
var musicOn := 0

func _ready():
	pass

func _on_MusicOption_item_selected(index):
	music.musicOn = index
	get_tree().reload_current_scene()
