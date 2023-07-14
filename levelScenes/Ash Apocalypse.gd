extends Node2D

const ROCKS := [
	preload("res://randomScenes/Rock1.tscn"),
	preload("res://randomScenes/Rock2.tscn")
]

const CAVES := [
	preload("res://randomScenes/Cave1.tscn"),
	preload("res://randomScenes/Cave2.tscn")
	
	
]


onready var world = $Map/Rocks
onready var worldCaves := $Map/Cave
onready var ambientMusic := $"Cave Music"
const CELL_SIZE := Vector2(64, 0)

func _ready() -> void:
	ambientMusic.play()
	randomize()
	add_rocks_on_grid()
	world.visible = false
	add_caves_on_grid()
	worldCaves.visible = false

func get_random_rock() -> Sprite:
	var rock_random_index := randi() % ROCKS.size()
	return ROCKS[rock_random_index].instance()
	
func get_random_cave() -> Sprite:
	var cave_random_index := randi() % CAVES.size()
	return CAVES[cave_random_index].instance()

func add_rocks_on_grid() -> void:
	for cell in world.get_used_cells():
		var rock:= get_random_rock()
		add_child(rock)
		var rock_size := rock.scale * rock.texture.get_size()
		var coinFlip = rand_range(1.0, 10.0)
		var available_space : Vector2 = world.cell_size - rock_size
		var random_offset := Vector2(randf(), 0)*available_space
		if coinFlip >= 5:
			rock.position = world.position + world.map_to_world(cell) + random_offset + Vector2(36, 42)

func add_caves_on_grid() -> void:
	for cell in worldCaves.get_used_cells():
		var cave:= get_random_cave()
		add_child(cave)
		var cave_size := cave.scale * cave.texture.get_size()
		var coinFlip = rand_range(1.0, 10.0)
		var available_space : Vector2 = worldCaves.cell_size - cave_size
		var random_offset := Vector2(randf(), 0)*available_space
		if coinFlip >= 5:
			cave.position = worldCaves.position + worldCaves.map_to_world(cell) + random_offset + Vector2(33, 32)
			
