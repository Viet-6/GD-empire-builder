class_name GraphUI
extends Control

@export var line_color: Color = Color.GREEN
@export var background_color: Color = Color(0.1, 0.1, 0.1, 0.5)

var data_points: Array = []

func _draw():
	# Draw background
	draw_rect(Rect2(Vector2.ZERO, size), background_color)
	
	if data_points.size() < 2:
		return
		
	# Normalize and draw lines
	var max_val = data_points.max()
	var min_val = data_points.min()
	
	# Avoid division by zero
	if max_val == min_val:
		max_val += 1.0
		
	var width_per_point = size.x / (data_points.size() - 1)
	var points_to_draw = PackedVector2Array()
	
	for i in range(data_points.size()):
		var val = data_points[i]
		# Normalize 0.0 to 1.0 (inverted because Y is down)
		var normalized_y = 1.0 - ((val - min_val) / (max_val - min_val))
		# Padding
		normalized_y = normalized_y * 0.8 + 0.1
		
		var point = Vector2(i * width_per_point, normalized_y * size.y)
		points_to_draw.append(point)
		
	draw_polyline(points_to_draw, line_color, 2.0, true)

func update_data(new_points: Array):
	data_points = new_points
	queue_redraw()
