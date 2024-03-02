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
	
func _process(delta):
	heal_tick_counter -= 1
	if heal_tick_counter <= 0:
		heal_tick_counter = heal_tick
		set_health(heal_amount)

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

