extends Camera3D

var mouse_start_pos
var screen_start_position
var dragging = false

func _input(event):
	if event.is_action("mouse_drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		var n = 0.01 * (mouse_start_pos - event.position + Vector2(screen_start_position.x, screen_start_position.y))
		rotate(Vector3(0,1,0), deg_to_rad(n.x))
