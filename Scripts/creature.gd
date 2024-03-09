extends CharacterBody3D

@onready var cameras_list #= $"../UI_Controller"
var camera_location
# General Stats
@export var main_type = "main_type_creatures"
@export var sub_type = "sub_type_squirrel"
@export var side = "side_squirrel"
@export var enemy = "enemy_bird"
@export var has_inventory = "has_inventory_true"

@export var enemy_type = "side_bird"

@export var can_pick_up = "main_type_resources"
var speed = 5

# Navigation 
@onready var nav_agent = $NavigationAgent3D

# Health variables
var max_health = 15
var current_health
var heal_amount = 5
@onready var image = $CreatureImage
@onready var health_bar = $HealthBar

# Attack Variables
var current_target
var targets_in_range = []
var attack_speed = 1 
var attack_cooldown = 300
var attack_cooldown_counter = attack_cooldown
var attack_damage = 1

# Inventory
@onready var inventory = $Inventory
@onready var pine = preload("res://Full_Assets/Twig_Full.tscn")

func _ready():
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)

	current_health = max_health
	update_health_bar()
	
	cameras_list = get_tree().get_nodes_in_group(side + "camera")
	

func _physics_process(delta):
	if current_target:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		
		velocity = velocity.move_toward(new_velocity, .25)
		move_and_slide()


func update_target_location(target_location):
	nav_agent.set_target_position(target_location)


func _process(delta):
	if len(cameras_list) > 0:
		camera_location = cameras_list[0]
	else:
		cameras_list = get_tree().get_nodes_in_group(side + "camera")
		
	
	if camera_location:
		look_at(camera_location.position)
	if current_target and is_instance_valid(current_target):
		update_target_location(current_target.position)
		
	# If there's a current target AND current target is within range and current target is enemy
	if current_target and current_target in targets_in_range and (current_target.is_in_group(enemy_type) or current_target.is_in_group("side_spider") or current_target.is_in_group("sub_type_construction")):
		if attack_cooldown_counter <= 0:
			# Reset attack cooldown
			attack_cooldown_counter = attack_cooldown
			attack()
		else:
			attack_cooldown_counter -= attack_speed
		
func assign_target(object_selected):
	# If the target is an enemy, then send soldier to attack
	if object_selected.is_in_group(enemy_type) or object_selected.is_in_group("side_spider"):
		current_target = object_selected
	# Attacking natural structures to get resources
	elif object_selected.is_in_group("main_type_other_structures"):
		current_target = object_selected
	# Picking up resources
	elif object_selected.is_in_group("main_type_resources"):
		current_target = object_selected
	# Depositing resources in base
	elif object_selected.is_in_group("main_type_buildings"):
		current_target = object_selected


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
	image.just_hit()
	# If no target, create new target
	if current_target == null:
		assign_target(attacker)

func kill():
	inventory.drop_all_items(self)
	queue_free()
	

func attack():
	# If the current target still exists
	if current_target:
		# if the current target is in range
		if current_target in targets_in_range:
			current_target.on_hit(attack_damage, self)


func _on_area_3d_body_entered(body):
	# If the object is an enemy
	if body.is_in_group(enemy_type) or body.is_in_group("main_type_other_structures") or body.is_in_group("sub_type_construction") or body.is_in_group("side_spider"):
		targets_in_range.append(body)
		 ##If there's no target
		#if !target:
			#target = body
	# Else if it's a resource and the troop was told to get it
	elif body.is_in_group(can_pick_up) and body == current_target:
		# Try to pick up the item
		if inventory.try_pick_up_item(body):
			body.queue_free()
			current_target = null
	elif body.is_in_group("sub_type_main_building") and body.is_in_group(side) and body == current_target:
		# Creature has arrived at the building
		inventory.try_deposite_item(body)
		current_target = null

func _on_area_3d_body_exited(body):
	if body in targets_in_range:
		var index = targets_in_range.find(body, 0)
		targets_in_range.remove_at(index)
