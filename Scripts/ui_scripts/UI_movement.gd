extends CharacterBody3D

# For checking groups 
@export var side = "side_bird"
@export var enemy = "enemy_squirrel"
var creature_main_type = "main_type_creatures"
var building_type = "main_type_buildings"
var other_structures_type = "main_type_other_structures"
var resource_main_type = "main_type_resources"
@export var enemy_type = "side_squirrel"

# Sidebar variables
@onready var sidebar_scene = "res://Full_Assets/sidebar.tscn"
@onready var sidebar = $Sidebar

# Camera Movement
#var left_limit = -50
#var right_limit = 150
#var upper_limit = -135
#var lower_limit = 0
var left_limit = -500
var right_limit = 1500
var upper_limit = -1350
var lower_limit = 1000
var scroll_upper_limit = 45
var scroll_lower_limit = 15
var left_turn_limit = 1
var right_turn_limit = -1

var speed = 9.0
var speed_normal = 9.0
var sprint = 19
var mouse_sensativity = .7
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#@onready var current_navigation_agent := $"../bird"
# For selecting the objects
@onready var camera := $Camera3D
@onready var select_box := preload("res://Full_Assets/select_box_full.tscn")
var select_box_parents = []

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	print_debug("!!!!!")
	camera.current = is_multiplayer_authority()
	# Assign the player to a side depending if a side is already taken
	var player_in_scene = get_tree().get_nodes_in_group("player")
	add_to_group(side + "camera")
	
func _input(event):
	if is_multiplayer_authority():
		if event is InputEventMouseMotion:
			if event.button_mask == 1:
				#if self.rotation.y <= left_turn_limit and event.relative.x > 0:
				rotate_y(deg_to_rad(event.relative.x * mouse_sensativity))
				#elif self.rotation.y >= right_turn_limit and event.relative.x < 0:
					#rotate_y(deg_to_rad(event.relative.x * mouse_sensativity))
		# Click on Objects in Scene
		if Input.is_action_just_pressed("left_mouse"):
			var result = cast_ray_to_select()
			if result:
				try_to_select(result)
		if Input.is_action_just_pressed("camera_zoom_up") and self.position.y <= scroll_upper_limit:
			self.position.y += 5
		elif Input.is_action_just_pressed("camera_zoom_down") and self.position.y >= scroll_lower_limit:
			self.position.y -= 5
		
		if Input.is_action_just_pressed("clear_selection"):
			clear_selection()
	
	
func cast_ray_to_select():
	"""" 
	This function casts a ray from the camera that returns the 
	first thing the ray hits, can be null.
	"""
	if is_multiplayer_authority():
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
	if is_multiplayer_authority():
		var object = result["collider"].get_parent()
		# If choosing a soldier on your side, select them
		if object.is_in_group(side) and object.is_in_group(creature_main_type):
			multiple_select(object)
		# Else, if you're selecting an enemy
		elif object.is_in_group(enemy_type):
			# if you have you're type=soldier or building selected, attack enemy soldier
			if object.is_in_group(creature_main_type) or object.is_in_group(building_type):
				attack_enemy_object(object)
		# Collecting resources
		elif object.is_in_group(other_structures_type) or object.is_in_group(resource_main_type):
			attack_enemy_object(object)
		# Depositing resources in base on player's side
		elif object.is_in_group(building_type) and object.is_in_group(side):
			attack_enemy_object(object)
			if object.is_in_group("has_inventory_true"):
				object.open_inventory()
		elif object.is_in_group("side_spider"):
			attack_enemy_object(object)
		
func clear_selection():
	""" This function clears all selected soldiers """
	if is_multiplayer_authority():
		# Deselect all current select boxs
		for select_box_parent in select_box_parents:
			# If the parent still exists
			if select_box_parent[0]:
				# Remove the selection 
				select_box_parent[0].remove_child(select_box_parent[1])
		# Then clear the list
		select_box_parents = []
		
func multiple_select(object):
	""" This function controls selecting multiple soldiers on your team """
	if is_multiplayer_authority():
		# If selecting multiple objects
		var reselected_index = -1
		var index = -1
		for select_box_parent in select_box_parents:
			index += 1
			# If the object is on the list, mark it
			if object == select_box_parent[0]:
				reselected_index = index
		
		# If the object is not reselected, select it and add it to selected objects
		if reselected_index == -1:
			var new_select_box = select_box.instantiate()
			object.add_child(new_select_box)
			select_box_parents.append([object, new_select_box])
		# Otherwise, the object is reselect and needs to be deselected
		else:
			# Check if object still exists
			select_box_parents[reselected_index][0].remove_child(select_box_parents[reselected_index][1])
			# Regardless of if it exists, remove it from the list
			select_box_parents.remove_at(reselected_index)

func attack_enemy_object(enemy_object):
	if is_multiplayer_authority():
		# Command each selected soldier to target the enemy soldier
		for select_box_parent in select_box_parents:
			# If the soldier and enemy_soldier still exist
			if select_box_parent[0] and enemy_object: 
				select_box_parent[0].assign_target(enemy_object)

func _process(delta):
	if is_multiplayer_authority():
		if Input.is_action_pressed("sprint"):
			speed=sprint
		else:
			speed = speed_normal
	

func _physics_process(delta):
	if is_multiplayer_authority():
		#if is_multiplayer_authority():
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
		
		#var sync_pos = get_tree().get_nodes_in_group("player")
		#for node in sync_pos:
			#if node.is_in_group("side_squirrel"):
				#sync_pos_func(node.creature_positions)
		#rpc("remote_set_position", position)
		#move_all_objects()

@rpc("unreliable")
func remote_set_position(authority_position):
	position = authority_position
		
func sync_pos_func(creature_positions):
	if is_multiplayer_authority():
		if creature_positions.size() == 2:
			creature_positions[0].assign_target(creature_positions[1])
		#if creature_positions:
			#print_debug("!!!!!!!!", creature_positions)
			#if creature_positions.size() > 0:
				#for creature in creature_positions:
					#creature.move()
