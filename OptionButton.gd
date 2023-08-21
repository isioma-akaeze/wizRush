extends OptionButton
onready var options := get_node("/root/GlobalOptionButton")
onready var clickSound := get_node("/root/GlobalMusicScene").get_node("ButtonClick")

var difficulty := 0

func _ready():
	pass
	
func _on_OptionButton_item_selected(index):
	options.difficulty = index
	clickSound.play()

func _on_OptionButton_pressed():
	clickSound.play()
