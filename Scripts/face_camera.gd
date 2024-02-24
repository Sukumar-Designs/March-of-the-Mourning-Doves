extends CharacterBody3D

@onready var camera_location = $"../UI_Controller"
@export var side = "squirrel"
@export var enemy = "bird"
@export var type = "soldier"
var speed = 5

# Navigation 
@onready var nav_agent = $NavigationAgent3D

# Health variables
var max_health = 50
var current_health
var heal_amount = 5
@onready var health_bar = $HealthBar/SubViewport/Healthbar

# Attack Variables
var current_target
var targets_in_range = []
var attack_speed = 1 
var attack_cooldown = 300
var attack_cooldown_counter = attack_cooldown
var attack_damage = 1


func _ready():
	add_to_group(side)
	add_to_group(type)
	current_health = max_health
	health_bar.value = float(current_health)/float(max_health)

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
	if current_target and is_instance_valid(current_target):
		update_target_location(current_target.position)
		
	# If there's a current target AND current target is within range
	if current_target:
		if attack_cooldown_counter <= 0:
			# Reset attack cooldown
			attack_cooldown_counter = attack_cooldown
			attack()
		else:
			attack_cooldown_counter -= attack_speed

		
func assign_target(opposing_object_selected):
	# If the target is an enemy, then send soldier to attack
	if opposing_object_selected.is_in_group(enemy):
		current_target = opposing_object_selected
	elif opposing_object_selected.is_in_group("natural_structure"):
		current_target = opposing_object_selected
		print_debug("Assigned Target", current_target)


# Health Based Function
func set_health(amount):
	if current_health >= max_health:
		current_health = max_health
	if current_health >= max_health and amount > 0:
		pass
	else:
		current_health += amount
	health_bar.value = float(current_health)/float(max_health)
	if current_health <= 0:
		kill()

func on_hit(damage):
	set_health(-damage)

func kill():
	queue_free()
	

func attack():
	#print_debug("attempt to attack")
	# If the current target still exists
	if current_target:
		#print_debug("current target", current_target)
		# if the current target is in range
		if current_target in targets_in_range:
			print_debug("HIT", current_target)
			current_target.on_hit(attack_damage)
			
	print_debug(targets_in_range, "TARGETS IN RANGE")


func _on_area_3d_body_entered(body):
	print_debug("Body entered!!", body)
	# If the object is an enemy
	if body.is_in_group(enemy) or body.is_in_group("natural_structure"):
		print_debug("Body attackable!!", body)
		targets_in_range.append(body)
		 ##If there's no target
		#if !target:
			#target = body

func _on_area_3d_body_exited(body):
	if body in targets_in_range:
		var index = targets_in_range.find(body, 0)
		targets_in_range.remove_at(index)
