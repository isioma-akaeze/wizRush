extends Node2D
#
#onready var bush1 := load("res://randomScenes/Bush1.tscn")
#var packedScene = PackedScene.new
#onready packedScene.pack(bush1)
#var bushInstance = bush1.instance()
#var rootBush = bushInstance.get_node("path_to_sprite_node")
#var bushTexture1 = rootBush.Texture
#
#
#onready var bush2 := load("res://randomScenes/Bush2.tscn")
#var bushInstance2 = bush2.instance()
#var rootBush2 = bushInstance.get_node("path_to_sprite_node")
#var bushTexture2 = rootBush2.Texture
# Use the texture as needed



const BUSHES := [
	preload("res://randomScenes/Bush1.tscn"),
	preload("res://randomScenes/Bush2.tscn"),
]

onready var world = $Map/Vegetation


const CELL_SIZE := Vector2(64, 0)


func _ready() -> void:
	randomize()
	add_bushes_on_grid()
	world.visible = false





func get_random_bush() -> Sprite:

	var bush_random_index := randi() % BUSHES.size()

	return BUSHES[bush_random_index].instance()





# Generates rocks on drawn cells in the Mask tilemap and randomly offsets them

# using blue noise.

func add_bushes_on_grid() -> void:

	# TileMap.get_used_cells() returns an array of Vector2 cell coordinates

	# where we drew a tile.

	for cell in world.get_used_cells():

		var bush := get_random_bush()

		add_child(bush)



		var bush_size := bush.scale * bush.texture.get_size()

		# Because the Mask node has a cell_size property, we use it instead of

		# the previously hard-coded CELL_SIZE constant.

		var available_space : Vector2 = world.cell_size - bush_size

		var random_offset := Vector2(randf(), 0)*available_space

		bush.position = world.position + world.map_to_world(cell) + random_offset + Vector2(36, 42)
			
			
