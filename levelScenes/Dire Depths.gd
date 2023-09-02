extends Node2D

const PROPS := [
	preload("res://randomScenes/Prop1.tscn"),
	preload("res://randomScenes/Prop2.tscn")
]

onready var world = $Water/Random
const CELL_SIZE := Vector2(64, 0)
onready var musicScene := get_node("/root/GlobalMusicScene")
onready var ambientMusic := $"Underwater Music"

func _process(delta):
	var menuMusic := get_node("/root/GlobalMusicScene")
	var previousMusic := musicScene.get_node("GreenGroves")
	var musicOption := get_node("/root/GlobalMusicOption")
	var character := $CharacterSwim2D
	menuMusic.get_node("LobbyMusic").stop()
	previousMusic.stop()
	if musicOption.musicOn == 0 and character.health > 0 and character.attackingBoss == false:
		if !ambientMusic.is_playing():
			ambientMusic.play()
	elif character.health < 0:
		ambientMusic.stop()
	elif character.attackingBoss == true:
		ambientMusic.stop()
	else:
		ambientMusic.stop()

func _ready() -> void:
	randomize()
	add_props_on_grid()
	world.visible = false

func get_random_prop() -> Sprite:
	var prop_random_index := randi() % PROPS.size()
	return PROPS[prop_random_index].instance()
	
func add_props_on_grid() -> void:
	for cell in world.get_used_cells():
		if cell.x != 0 and cell.y != 0:
			var prop:= get_random_prop()
			add_child(prop)
			var prop_size := prop.scale * prop.texture.get_size()
			var coinFlip = rand_range(1.0, 10.0)
			var available_space : Vector2 = world.cell_size - prop_size
			var random_offset := Vector2(randf(), 0)*available_space
			if coinFlip >= 5:
				prop.position = world.position + world.map_to_world(cell) + random_offset + Vector2(33, 32)
				

