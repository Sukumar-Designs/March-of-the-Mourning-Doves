extends CharacterBody3D

# General Stats
@export var main_type = "main_type_creatures"
@export var sub_type = "sub_type_spider"
@export var side = "side_spider"
@export var enemy = "enemy_hostile"
@export var has_inventory = "has_inventory_false"

@export var enemy_type = "*"

var speed = 4

# Navigation 
@onready var nav_agent = $NavigationAgent3D

# Health variables
var max_health = 15
var current_health
var heal_amount = 5
@onready var health_bar = $HealthBar

# Attack Variables
var main_target
var other_x_targets = []
var max_number_of_targets = 3
var targets_in_range = []
var attack_speed = 1 
var attack_cooldown = 300
var attack_cooldown_counter = attack_cooldown
var attack_damage = 1

var spider_nest

func _ready():
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)

	current_health = max_health
	update_health_bar()

	#spider_nest = get_tree().scene_tree.get_node_in_group("sub_type_spider_nest")


func _physics_process(delta):
	if main_target:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		
		velocity = velocity.move_toward(new_velocity, .25)
		move_and_slide()
		
		# Rotate the character to face the target position
		if new_velocity.length() > 0.1:
			look_at(current_location + new_velocity, Vector3.UP)
		

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)


func _process(delta):
	if main_target and is_instance_valid(main_target):
		update_target_location(main_target.position)
		
	# If there's a current target AND current target is within range and current target is enemy
	if main_target and main_target in targets_in_range:
		if attack_cooldown_counter <= 0:
			# Reset attack cooldown
			attack_cooldown_counter = attack_cooldown
			attack()
		else:
			attack_cooldown_counter -= attack_speed
		
func assign_target(object_selected):
	# If the target is an enemy, then send soldier to attack
	if object_selected.is_in_group("main_type_creatures") and !object_selected.is_in_group(side):
		main_target = object_selected

# Health Based Function
func set_health(amount):
	if current_health >= max_health:
		current_health = max_health
	if current_health >= max_health and amount > 0:
		pass
	else:
		current_health += amount
	update_health_bar()
	if current_health <= 0:
		kill()

func update_health_bar():
	""" This function controlls the health bar """
	health_bar.side = side
	health_bar.update_health_bar(current_health, max_health)
	
	
func on_hit(damage, attacker):
	set_health(-damage)
	# If no target, create new target
	if main_target == null:
		assign_target(attacker)
	# Spider can attack multiple targets, don't readd a target
	elif len(other_x_targets) < max_number_of_targets and !(attacker in other_x_targets):
		other_x_targets.append(attacker)

func kill():
	queue_free()

func attack():
	# If the current target still exists
	if main_target:
		# if the current target is in range
		if main_target in targets_in_range:
			main_target.on_hit(attack_damage, self)
		for target in other_x_targets:
			if target != null and target in targets_in_range:
				target.on_hit(attack_damage, self)

func _on_area_3d_body_entered(body):
	## If the object is an enemy
	if body.is_in_group("main_type_creatures") and !body.is_in_group(side):
		targets_in_range.append(body)
		if main_target == null:
			assign_target(body)
			


func _on_area_3d_body_exited(body):
	if body in targets_in_range:
		var index = targets_in_range.find(body, 0)
		targets_in_range.remove_at(index)
