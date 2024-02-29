extends Node

@export var max_items_per_type = 10
var inventory_items = {
	"pine":0,
	"acorn":0,
	"pebble":0,
	"seed":0
} 
var rng 
@onready var inventory_items_scenes = {
	"pine":preload("res://Full_Assets/Pines_Full.tscn"),
	"acorn":preload("res://Full_Assets/Pines_Full.tscn"),
	"pebble":preload("res://Full_Assets/Pines_Full.tscn"),
	"seed":preload("res://Full_Assets/Pines_Full.tscn")
}

func _ready():
	# Variable for randomly displacing drops 
	rng = RandomNumberGenerator.new()
	rng.randomize()

func try_deposite_item(item, amount):
	var item_space_occupied = inventory_items[item]
	# Check the amount of space
	# (Amount of space left) - Amount to be deposited 
	var item_total = (item_space_occupied + amount) #- max_items_per_type
	var item_overflow 
	# If item_total is at most the max items
	# there's space left and the amount can be added
	if item_total <= max_items_per_type:
		inventory_items[item] += amount
		item_overflow = 0
	# Otherwise, max out inventory and return quantanty exceeded
	else:
		inventory_items[item] = max_items_per_type
		# Get the number of items in excess 
		item_overflow = item_total - max_items_per_type
	return item_overflow

func drop_all_items(parent):
	for item in inventory_items:
		for i in range(0, inventory_items[item]):
			var instance = inventory_items_scenes[item].instantiate()
			var offset = rng.randi_range(-2, 2)
			instance.position.x = parent.position.x + offset
			instance.position.z = parent.position.z + offset
			instance.position.y = parent.position.y 
			get_tree().current_scene.add_child(instance)
			
func open_inventory():
	var sidebar = get_tree().get_nodes_in_group("sidebar")[0]
	print_debug(sidebar)
	sidebar.show_sidebar_tab("resources")
