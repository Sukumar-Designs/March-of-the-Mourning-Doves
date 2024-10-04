extends CharacterBody3D

var left_limit = -500
var right_limit = 1500
var upper_limit = -1350
var lower_limit = 1000
var scroll_upper_limit = 35
var scroll_lower_limit = 12
var left_turn_limit = 1
var right_turn_limit = -1

var speed = 9.0
var speed_normal = 9.0
var sprint = 19
var mouse_sensativity = .7
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


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
