extends TileMap
#
## Get the TileMap node
#onready var tilemap := self
## Get the timer node
#func _ready():
#	var timer = Timer.new()
#	# Set the timer interval to 0.2 seconds
#	timer.set_wait_time(0.2)
#	# Start the timer
#	timer.start()
#	# Connect the timeout signal of the timer to a function
#	timer.connect("timeout", self, "_on_Timer_timeout")
#
#func _on_Timer_timeout():
#	# Loop through all the cells in the tilemap
#	for x in range(tilemap.get_used_rect().size.x):
#		for y in range(tilemap.get_used_rect().size.y):
#			# Get the cell position
#			var cell_pos = Vector2(x, y) + tilemap.get_used_rect().position
#			# Get the cell index
#			var cell_index = tilemap.get_cell(cell_pos.x, cell_pos.y)
#			# Check if the cell index is 5
#			if cell_index == 5:
#				# Get the current flip_h flag of the cell
#				var transpose := tilemap.get_cellv(cell_index).transpose
#				# Toggle the flip_h flag
#				transpose = !transpose
#				# Set the new flip_h flag for the cell
#				tilemap.set_cell(cell_pos.x, cell_pos.y, -1, transpose)

	
