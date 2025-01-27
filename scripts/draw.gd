extends Node2D

func _process(delta):
	queue_redraw()  # Redraw every frame

func _draw():
	# Draw a circle at the position of a specific node
	var node_position = position
	draw_circle(node_position, 10, Color(1, 0, 0))  # Red circle with radius 10

	# Draw a line from the origin to the node's position
	draw_line(Vector2.ZERO, node_position, Color(0, 1, 0), 2)  # Green line with thickness 2

	# Draw text showing the node's position
	draw_string(ThemeDB.fallback_font, node_position + Vector2(20, -20), str(node_position), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(1, 1, 1))  # White text
