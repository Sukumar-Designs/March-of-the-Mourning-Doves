extends CharacterBody3D

var side = "bird"
var enemy = "squirrel"

# Camera Movement
var left_limit = -50
var right_limit = 50
var upper_limit = -55
var lower_limit = 0
var scroll_upper_limit = 45
var scroll_lower_limit = 15

var speed = 5.0
var speed_normal = 5.0
var sprint = 15
var mouse_sensativity = .7
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var current_navigation_agent := $"../bird"
# For selecting the objects
@onready var camera := $Camera3D
@onready var select_box := preload("res://Full_Assets/select_box_full.tscn")
@onready var current_select_box = select_box.instantiate()
var select_box_parent 


func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == 1:
			rotate_y(deg_to_rad(event.relative.x * mouse_sensativity))
	# Click on Objects in Scene
	elif Input.is_action_just_pressed("left_mouse"):
		var result = cast_ray_to_select()
		if result:
			try_to_select(result)
	elif Input.is_action_just_pressed("camera_zoom_up") and self.position.y <= scroll_upper_limit:
		self.position.y += 5
	elif Input.is_action_just_pressed("camera_zoom_down") and self.position.y >= scroll_lower_limit:
		self.position.y -= 5
		
func cast_ray_to_select():
	"""" 
	This function casts a ray from the camera that returns the 
	first thing the ray hits, can be null.
	"""
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
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
	# If choosing a troop on your side, select them
	if object.is_in_group(side):
		# If select box parent exists
		if select_box_parent:
			# Deselect current select box
			select_box_parent.remove_child(current_select_box)
			
			# If the selected object is the same as the previously select object
			if select_box_parent == object:
				select_box_parent = null
			else:
				# Select the new parent
				object.add_child(current_select_box)
				# update select box parent
				select_box_parent = object
		else:
			# Add select box to object
			object.add_child(current_select_box)
			select_box_parent = object
	# Else, if you're selecting an enemy
	elif object.is_in_group(enemy):
		# if you have you're type=soldier selected, attack enemy soldier
		if select_box_parent:
			if select_box_parent.is_in_group("soldier"):
				select_box_parent.assign_target(object)
			

func _process(delta):
	if Input.is_action_pressed("sprint"):
		speed=sprint
	else:
		speed = speed_normal

func _physics_process(delta):
		
	var input_dir = Input.get_vector("camera_left", "camera_right", "camera_forward", "camera_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	
	# Clamp player position
	var new_position = position + velocity * delta
	new_position.x = clamp(new_position.x, left_limit, right_limit)
	new_position.z = clamp(new_position.z, upper_limit, lower_limit)
	position = new_position
