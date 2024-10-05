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
var terrain_group = "terrain"
var on_ground = false

func _physics_process(delta):
	var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	if Input.is_action_just_pressed("player_jump") and on_ground:   
		velocity.y += 10
		
	velocity.y -= gravity * delta 
	
	move_and_slide()


func _on_feet_area_3d_body_entered(body):
	if body.is_in_group(terrain_group):
		on_ground = true


func _on_feet_area_3d_body_exited(body):
	if body.is_in_group(terrain_group):
		on_ground = false
