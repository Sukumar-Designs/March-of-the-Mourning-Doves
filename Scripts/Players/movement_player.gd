extends CharacterBody3D

var speed = 9.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var terrain_group = "terrain"
var on_ground = false
var in_vehicle = false
var vehicle 

#func _physics_process(delta):
	#if !vehicle:
		#var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_back")
		#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		#if direction:
			#velocity.x = direction.x * speed
			#velocity.z = direction.z * speed
		#else:
			#velocity.x = move_toward(velocity.x, 0, speed)
			#velocity.z = move_toward(velocity.z, 0, speed)
		#if Input.is_action_just_pressed("player_jump") and on_ground:   
			#velocity.y += 10
			#
		#velocity.y -= gravity * delta 
		#move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var clicked_object = get_clicked_object()
		if clicked_object is Critter:
			critter_interact(clicked_object)
		elif clicked_object is Boat:
			print_debug("!!")
			boat_interact(clicked_object)

func critter_interact(critter):
	if critter.has_task():
		critter.do_task()

func boat_interact(boat):
	boat.request_seat(self)
	print_debug("!!!")

func get_clicked_object():
	var camera = $Camera3D  # Make sure this points to your camera node
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000

	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
	
	if result.has("collider"):
		return result["collider"]
	return null

func _on_feet_area_3d_body_entered(body):
	if body.is_in_group(terrain_group):
		on_ground = true


func _on_feet_area_3d_body_exited(body):
	if body.is_in_group(terrain_group):
		on_ground = false

func transition_as_passenger(entering:bool, vehic):
	$CollisionShape3D.disabled = entering
	in_vehicle = entering
	vehicle = vehic
	
	if entering:
		vehicle.set_driver(self)
