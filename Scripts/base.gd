extends Node

# General Stats
@export var main_type = "main_type_buildings"
@export var sub_type = "sub_type_base_main_base"
@export var side = "side_bird"
@export var enemy = "enemy_bird"
@export var has_inventory = "has_inventory_true"
# Base Stats
var max_health = 100
var current_health
var heal_amount = 5
var heal_tick_counter = 30000
var heal_tick 

@export var main_base = false
signal healthChanged
signal baseDestroyed

# Inventory Variables
@onready var inventory = $Inventory

var rng 
var number_of_spawns = 5
@onready var creature = preload("res://Full_Assets/creature_full.tscn") 
var initial_place = true

func _ready():
	if sub_type == "sub_type_base_main_base":
		# Main base has 10x health
		max_health *= 10
		print_debug("added to main base")
		#add_to_group("main_base")
	
	current_health = max_health
	emit_signal("healthChanged", float(current_health)/float(max_health))
	# Set starting health
	heal_tick = heal_tick_counter
	
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)
		# Variable for randomly displacing drops 
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
func _process(delta):
	heal_tick_counter -= 1
	if heal_tick_counter <= 0:
		heal_tick_counter = heal_tick
		set_health(heal_amount)
	if initial_place:
		spawn_creatures(sub_type, side, enemy)
		initial_place = false

	
func set_health(amount):
	if current_health >= max_health:
		current_health = max_health
	if current_health >= max_health and amount > 0:
		pass
	else:
		current_health += amount
		emit_signal("healthChanged", float(current_health)/float(max_health))
	
	if current_health <= 0:
		kill()

func on_hit(damage):
	set_health(-damage)

func kill():
	inventory.drop_all_items(self)
	queue_free()
	emit_signal("baseDestroyed", side, main_base)

func try_deposite_item(item, amount):
	return inventory.try_deposite_item(item, amount)
	
func open_inventory():
	inventory.open_inventory()

func spawn_creatures(sub_type, side, enemy):
	for i in range(0, number_of_spawns):
		var creature = load("res://Full_Assets/creature_full.tscn")
		var instance = creature.instantiate()
		instance.sub_type = str("sub_type" + side.substr(4,len(side) - 4))
		instance.side = side
		instance.enemy = enemy
		instance.enemy_type = "side" + enemy.substr(5,len(side) + 1)
		instance.add_to_group("minimap_objects")
		
		var offset = 1.5 * (i + 2.7)
		var z_offset = offset-10 
		if instance.side == "side_squirrel":
			offset = -offset
			z_offset = -z_offset
		instance.position = self.position + Vector3(offset, (self.position.y/self.position.y)-1, z_offset)
		get_tree().current_scene.add_child(instance)
