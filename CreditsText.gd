extends RichTextLabel

var current_line = 0
var focused := false

func _draw():
	if focused:
		draw_rect(Rect2(Vector2.ZERO, rect_size), Color(1.0, 1.0, 0.0), false, 2)
	
	else:
		draw_rect(Rect2(Vector2.ZERO, rect_size), Color(0.85, 0.85, 0.85), false, 2)

func _physics_process(delta):
	var node_focused = get_focus_owner()
	if (node_focused == self):
	   focused = true
	else:
	   focused = false
	if focused:
		if Input.is_action_pressed("scroll_up"):
			current_line = max(current_line - 1, 0)
			scroll_to_line(current_line)
		elif Input.is_action_pressed("scroll_down"):
			current_line = min(current_line + 1, get_line_count() - 1)
			scroll_to_line(current_line)
