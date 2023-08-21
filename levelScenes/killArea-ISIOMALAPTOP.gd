extends Area2D

onready var killSound := $SpikeKill
onready var burnSound := $Burnt
var tileMapName : String = ""
var touchingLava := false
onready var collideBox := $CollisionShape2D
onready var boilSound := $LavaBoil

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	var shape = collideBox.get_shape()
	var shape_extents = shape.extents
	# Set the audio max distance based on shape extents
	boilSound.max_distance = max(shape_extents.x + 1750, shape_extents.y + 1250)
	
	
func _physics_process(delta):
	var overlaps := get_overlapping_bodies()
	for body in overlaps:
		if body is TileMap and body.name == "Lava":
			if !boilSound.is_playing():
				boilSound.play()


func _on_body_entered(body: Node):
	if body.is_in_group("damagePlayer"):
		# Get the overlapping bodies
		var overlapping_bodies = get_overlapping_bodies()
		# Loop through the overlapping bodies
		for collider in overlapping_bodies:
			# Check if the collider is a tilemap
			if collider is TileMap:
				# Get the tilemap node
				var tilemap = collider
				# Get the tile position
				var tile_pos = tilemap.world_to_map(position)
				# Get the tile ID
				var tileID = tilemap.get_cellv(tile_pos)
				# Get the tilemap name
				var tileMapName = tilemap.name
				if tileMapName == "Lava":
					touchingLava = true
				else:
					touchingLava = false
				body.health -= 100
				if !touchingLava:
					killSound.play()
				elif touchingLava:
					killSound.stop()
					burnSound.play()

func _on_body_exited(body):
	pass

