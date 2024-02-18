extends CharacterBody3D

@onready var camera_location = $"../UI_Controller"
@export var side = "squirrel"
@export var enemy = "bird"
var speed = 5
var current_target

# Navigation 
@onready var nav_agent = $NavigationAgent3D

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	#collision()

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)


func _process(delta):
	if camera_location:
		look_at(camera_location.position)
	if side == "squirrel":
		if !current_target:
			var targets = get_tree().get_nodes_in_group(enemy)
			if len(targets) > 0:
				current_target = targets[0]
		if current_target:
			update_target_location(current_target.position)
			#for target in targets:
				## Get nearest target
				#if !nearest_target:
					#nearest_target = target
				#else:
					#var distance = self.position - target.position
					#if distance < (self.position - nearest_target.position):
						#nearest_target = targets
		
			#current_target = nearest_target

# if area box (hit range) triggered

#func collision():
	#for index in get_slide_collision_count():
		#var collide = get_slide_collision(index)
		#print_debug(collide)


	
