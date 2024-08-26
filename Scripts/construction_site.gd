extends CharacterBody3D

@export var main_type = "main_type_buildings"
@export var sub_type = "sub_type_construction"
@export var side = ""
@export var enemy = ""
@export var has_inventory = "has_inventory_false"

@onready var base = load("res://Full_Assets/bird_base_full.tscn")
@onready var range_tower_1 = load("res://Assets/Pine_Tree.glb") 
@onready var range_tower_2 = load("res://Full_Assets/tree_full.tscn")
@onready var bridge = load("res://Full_Assets/Bridge_Full.tscn")

var final_construction_type
var final_construction_sub_type

# Health variables
var max_health = 10
var current_health
@onready var health_bar = $HealthBar

func _ready():
	var player = get_tree().get_first_node_in_group(side + "camera")
	if player:
		$MultiplayerSynchronizer.set_multiplayer_authority(str(player.name).to_int())
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)
	current_health = max_health


func construct():
	var instance
	if final_construction_sub_type == "sub_type_base":
		instance = base.instantiate()
	elif final_construction_sub_type == "sub_type_range_tower_1":
		instance = range_tower_1.instantiate()
	elif final_construction_sub_type == "sub_type_range_tower_2":
		instance = range_tower_2.instantiate()
	elif final_construction_sub_type == "sub_type_bridge":
		instance = bridge.instantiate()
		instance.rotation.y = 45
	
	instance.global_position = global_position
	instance.sub_type = final_construction_sub_type
	instance.side = side
	instance.enemy = enemy
	get_tree().current_scene.add_child(instance) 
	queue_free()

# Health Based Function
func set_health(amount, attacker_side):
	if current_health >= max_health:
		current_health = max_health
	if current_health >= max_health and amount > 0:
		pass
	else:
		current_health += amount
	update_health_bar()
	if current_health <= 0:
		if side != attacker_side:
			# If the building was not "destoryed"/build by the side
			print_debug("Side:", side, " Attacker:", attacker_side)
			queue_free()
		else:
			construct()

func update_health_bar():
	""" This function controlls the health bar """
	health_bar.side = side
	health_bar.update_health_bar(current_health, max_health)
	
	
func on_hit(damage, attacker):
	set_health(-damage, attacker.side)
