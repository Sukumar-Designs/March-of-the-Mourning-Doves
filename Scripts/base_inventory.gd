extends Node

@export var max_items_per_type = 10
var inventory_items = {
	"sub_type_twig":50,
	"sub_type_acorn":50,
	"sub_type_pebble":50,
	"sub_type_seed":50
} 
var rng 
@onready var inventory_items_scenes = {
	"sub_type_twig":preload("res://Full_Assets/Twig_Full.tscn"),
	"sub_type_acorn":preload("res://Full_Assets/Twig_Full.tscn"),
	"sub_type_pebble":preload("res://Full_Assets/Twig_Full.tscn"),
	"sub_type_seed":preload("res://Full_Assets/Twig_Full.tscn")
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
			
func open_inventory(player_sidebar):
	#var sidebar = get_tree().get_nodes_in_group("sidebar")[0]
	#print_debug(sidebar)
	
	player_sidebar.show_sidebar_tab("resources", self)

func get_inventory():
	return inventory_items
	
func change_item_amount(item, amt):
	inventory_items[item] = inventory_items[item] + amt 
