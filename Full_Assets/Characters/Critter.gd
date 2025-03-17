class_name Critter
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var surroundings = $Surroundings
var task = "boat"
var task_to_function = {
	"boat": Callable(self, "boat_task")
}
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var boat

func _physics_process(delta):
	pass

func get_task():
	return task
	
func has_task():
	return task != null

func do_task():
	if task:
		task_to_function[task].callv([])

func boat_task():
	# Find the boat:
	if boat == null:
		boat = get_surroundings(Boat)
	
	if boat:
		boat.request_seat(self)

func get_surroundings(class_nm):
	for body in surroundings.get_overlapping_bodies():
		if is_instance_of(body, class_nm):
			return body
	return null

func transition_as_passenger(entering:bool, vehic):
	$CollisionShape3D.disabled = entering
