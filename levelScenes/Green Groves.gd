extends Node2D



const BUSHES := [
	preload("res://randomScenes/Bush1.tscn"),
	preload("res://randomScenes/Bush2.tscn"),
	preload("res://randomScenes/Bush3.tscn")
]

const TREES := [
	preload("res://randomScenes/Tree1.tscn"),
	preload("res://randomScenes/Tree2.tscn"),
	preload("res://randomScenes/Tree3.tscn")
]

onready var world = $Map/Vegetation
onready var worldTrees = $Map/Trees
const CELL_SIZE := Vector2(64, 0)

func _ready() -> void:
	randomize()
	add_bushes_on_grid()
	world.visible = false
	add_trees_on_grid()
	worldTrees.visible = false

func get_random_bush() -> Sprite:
	var bush_random_index := randi() % BUSHES.size()
	return BUSHES[bush_random_index].instance()

func get_random_tree() -> Sprite:
	var tree_random_index := randi() % TREES.size()
	return TREES[tree_random_index].instance()

func add_bushes_on_grid() -> void:
	for cell in world.get_used_cells():
		var bush := get_random_bush()
		add_child(bush)
		var bush_size := bush.scale * bush.texture.get_size()
		var coinFlip = rand_range(1.0, 10.0)
		var available_space : Vector2 = world.cell_size - bush_size
		var random_offset := Vector2(randf(), 0)*available_space
		if coinFlip >= 2.5:
			bush.position = world.position + world.map_to_world(cell) + random_offset + Vector2(36, 42)
			
func add_trees_on_grid() -> void:
	for cell in worldTrees.get_used_cells():
		var tree := get_random_tree()
		add_child(tree)
		var tree_size := tree.scale * tree.texture.get_size()
		var coinFlip = rand_range(1.0, 10.0)
		var available_space : Vector2 = worldTrees.cell_size - tree_size
		var random_offset := Vector2(randf(), 0)*available_space
		if coinFlip >= 2.5:
			tree.position = worldTrees.position + worldTrees.map_to_world(cell) + random_offset + Vector2(0, 72)



