extends Node

# General Stats
@export var side = "squirrel" 
@export var type = "building"
@export var has_inventory = "has_inventory"
# Base Stats
var max_health = 100
var current_health
var heal_amount = 5

var heal_tick_counter = 3000000
var heal_tick 

@export var main_base = false
signal healthChanged
signal baseDestroyed

# Inventory Variables
@onready var inventory = $Inventory

func _ready():
	# Main base has 10x health
	if main_base:
		max_health *= 10 
	current_health = max_health
	if main_base:
		print_debug("added to main base")
		add_to_group("main_base")
	add_to_group(side + "_" + type)
	add_to_group(side)
	add_to_group(type)
	add_to_group(has_inventory)
	
	emit_signal("healthChanged", float(current_health)/float(max_health))
	
	# Set starting health
	heal_tick = heal_tick_counter
	
	
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

