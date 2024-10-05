extends CharacterBody3D

var speed = 9.0
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
