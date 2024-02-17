extends CharacterBody3D

var side = "bird"
var enemy = "squirrel"

# Camera Movement
var left_limit = -50
var right_limit = 50
var upper_limit = -58
var lower_limit = 0

var speed = 5.0
var speed_normal = 5.0
var sprint = 15
var mouse_sensativity = .7
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == 1:
			rotate_y(deg_to_rad(event.relative.x * mouse_sensativity))

func _process(delta):
	pass
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
