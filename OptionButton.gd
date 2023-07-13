extends OptionButton
onready var options := get_node("/root/GlobalOptionButton")

var difficulty := 0

func _ready():
	pass
	
func _on_OptionButton_item_selected(index):
	options.difficulty = index
