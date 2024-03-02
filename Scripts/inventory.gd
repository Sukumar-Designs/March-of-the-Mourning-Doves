extends Node

@export var max_items_per_type = 3
var inventory_items = {
	"sub_type_twig":0,
	"sub_type_acorn":0,
	"sub_type_pebble":0,
	"sub_type_seed":0
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

func try_pick_up_item(item):
	""" This function controls trying to pick up an item """
	if inventory_items[item.sub_type] <= max_items_per_type:
		inventory_items[item.sub_type] = inventory_items[item.sub_type] + 1
		return true
	else:
		return false
		
func try_deposite_item(depository):
	for item in inventory_items:
		var amount_left_over = depository.try_deposite_item(item, inventory_items[item])
		# Assign amount left over to inventory
		inventory_items[item] = amount_left_over
		
func drop_all_items(parent):
	for item in inventory_items:
		for i in range(0, inventory_items[item]):
			var instance = inventory_items_scenes[item].instantiate()
			var offset = rng.randi_range(-2, 2)
			instance.position.x = parent.position.x + offset
			instance.position.z = parent.position.z + offset
			instance.position.y = parent.position.y 
			get_tree().current_scene.add_child(instance)


