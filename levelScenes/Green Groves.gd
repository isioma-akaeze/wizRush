extends Node2D

#const BUSHES := [
#	preload("res://randomScenes/Bush1.tscn"),
#	preload("res://randomScenes/Bush2.tscn"),
#]
#
#onready var world = $Map
#
#
#const CELL_SIZE := Vector2(64, 0)
#
#func _ready() -> void:
#	$Map/Vegetation.visible = false
#	for i in world.get_children():
#		if i == $Map/Vegetation:
#			add_bushes_with_blue_noise(10)
#
#func add_bushes_with_blue_noise(rows: int) -> void:
#	for row in range(rows):
#		var cell := Vector2(row, 0)
#		var bushScene: PackedScene = BUSHES[randi() % BUSHES.size()]
#		var bush: Node2D = bushScene.instance()
#		add_child(bush)
#		var bush_size: Vector2 = bush.get_node("Sprite").texture.get_size() * bush.get_node("Sprite").scale
#		var available_space := CELL_SIZE - bush_size
#
#		# Calculate a random x-axis offset within each bush's grid cell.
#		var random_offset_x := rand_range(0, available_space.x)
#		# Create a zero y-axis offset.
#		var random_offset_y := 0
#
#		# Take the random offset into account when placing the bush.
#		var position = CELL_SIZE * cell + Vector2(random_offset_x, random_offset_y)
#
#		# Set the position of the bush.
#		bush.position = position


const BUSHES := [
	preload("res://randomScenes/Bush1.tscn"),
	preload("res://randomScenes/Bush2.tscn"),
]

onready var vegetationTilemap: TileMap = $Map/Vegetation
var clouds: Array = [
	"Clouds",
	"Clouds2",
	"Clouds3",
	"Clouds4",
	"Clouds5",
	"Clouds6",
	"Clouds7"
]

const CELL_SIZE := Vector2(64, 64)

func _ready() -> void:
	vegetationTilemap.visible = true

	for cloud_name in clouds:
		var cloud: TextureRect = $Node2D.get_node(cloud_name)
		if cloud != null:
			cloud.set("z_index", 0)  # Set the z_index property of each TextureRect
		else:
			print("Invalid TextureRect node:", cloud_name)

	add_bushes_with_blue_noise(10)

func add_bushes_with_blue_noise(rows: int) -> void:
	for row in range(rows):
		var cell := Vector2(row, 0)
		var bushScene: PackedScene = BUSHES[randi() % BUSHES.size()]
		var bushInstance: Node = bushScene.instance()
		var bush: Sprite = bushInstance as Sprite
		if bush != null:
			vegetationTilemap.add_child(bush)
			bush.position = vegetationTilemap.map_to_world(CELL_SIZE * cell)
		else:
			print("Invalid bush scene or missing Sprite node.")
