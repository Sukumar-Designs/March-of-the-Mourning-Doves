extends Node3D

var pickup_group = "attributed_pickup"
@onready var camera:Camera3D=$"../Camera3D"

func _input(event):
	# Click on Objects in Scene
	if Input.is_action_just_pressed("left_mouse"):
		var result = cast_ray_to_select()
		if result:
			try_to_select(result)


func cast_ray_to_select():
	"""" 
	This function casts a ray from the camera that returns the 
	first thing the ray hits, can be null.
	"""
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var result = space.intersect_ray(ray_query)
	return result


func try_to_select(result):
	var object = result["collider"].get_parent()
	# If item can be picked up:
	if object.is_in_group(pickup_group):
		object.queue_free()
