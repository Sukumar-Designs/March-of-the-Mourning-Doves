extends CharacterBody3D

@onready var camera_location = $"../UI_Controller"
@export var side = "squirrel"
@export var enemy = "bird"
@export var type = "soldier"
var speed = 5
var current_target

# Navigation 
@onready var nav_agent = $NavigationAgent3D

func _ready():
	add_to_group(side)
	add_to_group(type)

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()


func update_target_location(target_location):
	nav_agent.set_target_position(target_location)


func _process(delta):
	if camera_location:
		look_at(camera_location.position)
	if current_target:
		update_target_location(current_target.position)

		
func assign_target(target):
	# If the target is an enemy, then send soldier to attack
	if target.is_in_group(enemy):
		current_target = target
