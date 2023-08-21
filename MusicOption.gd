extends OptionButton
onready var music := get_node("/root/GlobalMusicOption")
onready var clickSound := get_node("/root/GlobalMusicScene").get_node("ButtonClick")
var musicOn := 0

func _ready():
	pass

func _on_MusicOption_item_selected(index):
	clickSound.play()
	music.musicOn = index
	get_tree().reload_current_scene()
	
func _on_MusicOption_pressed():
	clickSound.play()
