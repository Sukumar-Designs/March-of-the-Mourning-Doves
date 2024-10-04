extends AnimatableBody3D

var player


# General Stats
@export var main_type = "main_type_creatures"
@export var sub_type = ""
@export var side = ""
@export var enemy = ""
@export var has_inventory = "has_inventory_true"

@export var enemy_type = ""

@export var can_pick_up = "main_type_resources"
var speed = 5

# Navigation 
@onready var nav_agent = $NavigationAgent3D

# Health variables
var max_health = 5 #15
var current_health = max_health
@export var syncHealth = max_health
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
@onready var pine = preload("res://Full_Assets/Terrain/Twig_Full.tscn")

var terrain_name = "HTerrain"

func _ready():
	print_debug("CREATURE EXISTS IN WORLD", side)
	
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)

	update_health_bar()
	
	if sub_type == "sub_type_bird":
		# Birds are on layer 3 (layer), and can collide 2 (mask) but not the terrain (1)
		set_collision_layer_value(1, false)
		set_collision_layer_value(3, true)
		
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, true)
		set_collision_mask_value(4, true) # River / Buildings 
	else:
		# Other creatures are on layer 2 (layer), and can collide with 1 and 3 (mask)
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)
		
		set_collision_mask_value(1, false)
		set_collision_mask_value(3, true)
		set_collision_mask_value(4, true) # River / Buildings 


func _physics_process(delta):
	if current_target:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed

		var collision = move_and_collide(new_velocity * delta)
		if collision:
			if collision.get_collider().is_in_group("sub_type_river"):
				print_debug("!!!", collision.get_collider().name)
				collision.get_collider().get_parent().float_down_river(self)
				
		
func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func _process(delta):
	
	if current_target and is_instance_valid(current_target):
		update_target_location(current_target.position)
		
	# If there's a current target AND current target is within range and current target is enemy
	if current_target and current_target in targets_in_range:
		if current_target.is_in_group(enemy_type) or current_target.is_in_group("side_spider") or current_target.is_in_group("sub_type_construction") or current_target.is_in_group("main_type_other_structures"):
			if attack_cooldown_counter <= 0:
				# Reset attack cooldown
				attack_cooldown_counter = attack_cooldown
				attack(current_target.get_path())

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
	elif object_selected.is_in_group("sub_type_river"):
			current_target = null

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
	
func attack(target):
	var to_attack = get_node(target)
	if to_attack:
		to_attack.on_hit(attack_damage, self)
	else:
		print_debug("ERROR ERROR ERROR ERROR", to_attack)
	

func _on_area_3d_body_entered(body):
	# If the object is an enemy
	if body.is_in_group(enemy_type) or body.is_in_group("main_type_other_structures") or body.is_in_group("sub_type_construction"):
		targets_in_range.append(body)
	# Else if it's a resource and the troop was told to get it
	elif body.is_in_group(can_pick_up) and body == current_target:
		# Try to pick up the item
		if inventory.try_pick_up_item(body):
			body.kill()
			current_target = null
	elif body.is_in_group("sub_type_main_building") and body.is_in_group(side) and body == current_target:
		# Creature has arrived at the building
		inventory.try_deposite_item(body)
		current_target = null
		
func _on_area_3d_body_exited(body):
	if body in targets_in_range:
		var index = targets_in_range.find(body, 0)
		targets_in_range.remove_at(index)


func set_location(pos):
	position = pos

