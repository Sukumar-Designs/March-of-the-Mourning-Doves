extends Node3D

@export var side = "side_bird"

# Tabs
@onready var resources_ui = $Resource_Container
@onready var buildings_ui = $Building_Container
@onready var base_inventory = $Base_Resources

# Building Types
@onready var base_preview = load("res://Assets/Mushroom.glb") 
@onready var base = load("res://Full_Assets/bird_base_full.tscn")
@onready var range_tower_1_preview = load("res://Assets/Pine_Tree.glb") 
@onready var range_tower_1 = load("res://Full_Assets/tree_full.tscn")

var preview_building
var building 
var base_selected # The base the player clicked on to open sidebar
var base_type_selected

@onready var ray_caster = $"../UI_Controller"
var terrian_name = "Terrian_Area3D"
var ray
# Resource Type
var pebble = "sub_type_pebble"
var twig = "sub_type_twig"
var seed = "sub_type_seed"
var acorn = "sub_type_acorn"
var resource_types = [pebble, twig, seed, acorn]
var ui_paths = "Resource_Container/VBoxContainer/"
var ui_base_path = ui_paths + "Base/Resource_Images/"
var ui_range_tower_1_path = ui_paths + "range_tower_1/Resource_Images/"
var ui_range_tower_2_path = ui_paths + "range_tower_2/Resource_Images/"
var bridge_path = ui_paths + "bridge/Resource_Images/"
@onready var buildings = {
	"base":{
		pebble:[get_node(ui_base_path + str("Pebble_Container/Pebble_Amount")), 15],
		twig:[get_node(ui_base_path + str("Twig_Container/Twig_Amount")), 15],
		seed:[get_node(ui_base_path + str("Seed_Container/Seed_Amount")), 15],
		acorn:[get_node(ui_base_path + str("Acorn_Container/Acorn_Amount")), 15]
	},
	"range_tower_1":{
		pebble:[get_node(ui_range_tower_1_path + str("Pebble_Container/Pebble_Amount")), 2],
		twig:[get_node(ui_range_tower_1_path + str("Twig_Container/Twig_Amount")), 5],
		seed:[get_node(ui_range_tower_1_path + str("Seed_Container/Seed_Amount")), 0],
		acorn:[get_node(ui_range_tower_1_path + str("Acorn_Container/Acorn_Amount")), 3]
	},
	"range_tower_2":{
		pebble:[get_node(ui_range_tower_2_path + str("Pebble_Container/Pebble_Amount")), 15],
		twig:[get_node(ui_range_tower_2_path + str("Twig_Container/Twig_Amount")), 15],
		seed:[get_node(ui_range_tower_2_path + str("Seed_Container/Seed_Amount")), 10],
		acorn:[get_node(ui_range_tower_2_path + str("Acorn_Container/Acorn_Amount")), 0]
	},
	"bridge":{
		pebble:[get_node(bridge_path + str("Pebble_Container/Pebble_Amount")), 10],
		twig:[get_node(bridge_path + str("Twig_Container/Twig_Amount")), 25],
		seed:[get_node(bridge_path + str("Seed_Container/Seed_Amount")), 10],
		acorn:[get_node(bridge_path + str("Acorn_Container/Acorn_Amount")), 0]
	}
}

@onready var inventory_items = {
	"sub_type_twig":$Base_Resources/Twigs/Twigs_Amount,
	"sub_type_acorn":$Base_Resources/Acorns/Acorns_Amount,
	"sub_type_pebble":$Base_Resources/Pebbles/Pebbles_Amount,
	"sub_type_seed":$Base_Resources/Seeds/Seeds_Amount
} 

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("sidebar")
	for resource_cost in buildings:
		for resource in buildings[resource_cost]:
			print_debug(buildings[resource_cost][resource][0])
			buildings[resource_cost][resource][0].text = str(buildings[resource_cost][resource][1])
	
	resources_ui.visible = false
	buildings_ui.visible = false
	base_inventory.visible = false

func _process(delta):
	fill_inventory_ui()

func show_sidebar_tab(to_show, base_selected_inv):
	if to_show == "resources":
		resources_ui.visible = !resources_ui.visible
		buildings_ui.visible = !buildings_ui.visible
		base_inventory.visible = !base_inventory.visible 
		if resources_ui.visible:
			base_selected = base_selected_inv
			fill_inventory_ui()
		else:
			base_selected = null
		
func fill_inventory_ui():
	if base_selected:
		var base_selected_inventory = base_selected.get_inventory()
		for item in base_selected_inventory:
			inventory_items[item].text = str(base_selected_inventory[item])
		
		
func try_to_build(building_type_preview, building_actual, to_build_type):
	if player_can_affort(to_build_type):
		base_type_selected = to_build_type
		preview_building = building_type_preview.instantiate()
		get_tree().current_scene.add_child(preview_building) 
		building = building_actual
	
func player_can_affort(to_build_type):
	""" This function figures out if the player can afford the building they clicked on"""
	var can_affort = true
	for item in buildings[to_build_type]: 
		# Amount player has - cost  
		var difference = base_selected.get_inventory()[item.to_lower()] - buildings[to_build_type][item][1]
		if difference < 0:
			can_affort = false
	return can_affort
	
	
func _input(event):
	if preview_building != null:
		# If moving mouse, move the preview building
		if event is InputEventMouseMotion:
			ray = ray_caster.cast_ray_to_select()
			# If looking at the ground (as oppose to off to infinity)
			if ray != { }:
				preview_building.position = ray.position 
				
		elif Input.is_action_just_pressed("place") and ray:
			if ray != { } and ray["collider"].name == terrian_name:
				purchase_and_place()
		
		
		if Input.is_action_just_pressed("clear_selection"):
			clear_preview()


func purchase_and_place():
	if player_can_affort(base_type_selected):
		for item in buildings[base_type_selected]: 
			base_selected.change_item_amount(item.to_lower(), -buildings[base_type_selected][item][1]) 
		var instance = building.instantiate()
		instance.position = ray.position + Vector3(1.55, 0, 1.55)
		get_tree().current_scene.add_child(instance) 
		clear_preview()


func clear_preview():
	""" This function controls removing preview of building after selecting building """
	if preview_building != null and building != null:
		preview_building.queue_free()
		preview_building = null
		building = null
		base_type_selected = null
		
func _on_base_pressed():
	clear_preview()
	try_to_build(base_preview, base, "base")


func _on_range_tower_1_pressed():
	clear_preview()
	try_to_build(range_tower_1_preview, range_tower_1, "range_tower_1")


func _on_range_tower_2_pressed():
	clear_preview()
	try_to_build(range_tower_1_preview, range_tower_1, "range_tower_2")


func _on_bridge_pressed():
	clear_preview()
	try_to_build(range_tower_1_preview, range_tower_1, "bridge")
