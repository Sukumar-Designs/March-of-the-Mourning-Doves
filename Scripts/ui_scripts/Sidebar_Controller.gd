extends Node3D

var side = "side_bird"
var enemy = "enemy_squirrel"
var enemy_type = "side_squirrel"

# Tabs
@onready var resources_ui = $Resource_Container
@onready var buildings_ui = $Building_Container
@onready var base_inventory = $Base_Resources

# Visual behind tabs
@onready var sidebar_background = $Sidebar_Background 

# Building Types
@onready var base_preview = load("res://Assets/Mushroom.glb") 
@onready var base = load("res://Full_Assets/bird_base_full.tscn")
@onready var range_tower_1_preview = load("res://Assets/Pine_Tree.glb") 
@onready var range_tower_1 = load("res://Full_Assets/tree_full.tscn")

@onready var bridge_preview = load("res://Assets/Mushroom.glb")
@onready var bridge = load("res://Full_Assets/Bridge_Full.tscn")

@onready var construction = load("res://Full_Assets/Construction_Site_Full.tscn")

var preview_building
var building 
var base_selected # The base the player clicked on to open sidebar
var base_type_selected

var ray_caster 
var terrian_name = "Terrian_Area3D"
var ray
# Resource Type
var pebble = "sub_type_pebble"
var twig = "sub_type_twig"
var seed = "sub_type_seed"
var acorn = "sub_type_acorn"
var resource_types = [pebble, twig, seed, acorn]
var ui_paths = "Resource_Container/VBoxContainer/HBoxContainer/"
var ui_paths2 = "Resource_Container/VBoxContainer/HBoxContainer2/"
var ui_base_path = ui_paths + "Base/Resource_Images/"
var ui_base_path2 = ui_paths + "Base/Resource_Images2/"
var ui_range_tower_1_path = ui_paths + "range_tower_1/Resource_Images/"
var ui_range_tower_1_path2 = ui_paths + "range_tower_1/Resource_Images2/"
var ui_range_tower_2_path = ui_paths2 + "range_tower_2/Resource_Images/"
var ui_range_tower_2_path2 = ui_paths2 + "range_tower_2/Resource_Images2/"
var bridge_path = ui_paths2 + "bridge/Resource_Images/"
var bridge_path2 = ui_paths2 + "bridge/Resource_Images2/"
@onready var buildings = {
	"base":{
		pebble:[get_node(ui_base_path + str("Pebble_Container/Pebble_Amount")), 15],
		twig:[get_node(ui_base_path + str("Twig_Container/Twig_Amount")), 15],
		seed:[get_node(ui_base_path2 + str("Seed_Container/Seed_Amount")), 15],
		acorn:[get_node(ui_base_path2 + str("Acorn_Container/Acorn_Amount")), 15]
	},
	"range_tower_1":{
		pebble:[get_node(ui_range_tower_1_path + str("Pebble_Container/Pebble_Amount")), 2],
		twig:[get_node(ui_range_tower_1_path + str("Twig_Container/Twig_Amount")), 5],
		seed:[get_node(ui_range_tower_1_path2 + str("Seed_Container/Seed_Amount")), 0],
		acorn:[get_node(ui_range_tower_1_path2 + str("Acorn_Container/Acorn_Amount")), 3]
	},
	"range_tower_2":{
		pebble:[get_node(ui_range_tower_2_path + str("Pebble_Container/Pebble_Amount")), 15],
		twig:[get_node(ui_range_tower_2_path + str("Twig_Container/Twig_Amount")), 15],
		seed:[get_node(ui_range_tower_2_path2 + str("Seed_Container/Seed_Amount")), 10],
		acorn:[get_node(ui_range_tower_2_path2 + str("Acorn_Container/Acorn_Amount")), 0]
	},
	"bridge":{
		pebble:[get_node(bridge_path + str("Pebble_Container/Pebble_Amount")), 10],
		twig:[get_node(bridge_path + str("Twig_Container/Twig_Amount")), 25],
		seed:[get_node(bridge_path2 + str("Seed_Container/Seed_Amount")), 10],
		acorn:[get_node(bridge_path2 + str("Acorn_Container/Acorn_Amount")), 0]
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
			buildings[resource_cost][resource][0].text = str(buildings[resource_cost][resource][1])
	resources_ui.visible = false
	buildings_ui.visible = false
	base_inventory.visible = false
	sidebar_background.visible = false
	
	
func _process(delta):
	fill_inventory_ui()


func show_sidebar_tab(to_show, base_selected_inv):
	#if self.get_multiplayer_authority() == multiplayer.get_unique_id():
		#if to_show == "resources":
	resources_ui.visible = !resources_ui.visible
	buildings_ui.visible = !buildings_ui.visible
	base_inventory.visible = !base_inventory.visible 
	sidebar_background.visible = !sidebar_background.visible
	if resources_ui.visible:
		base_selected = base_selected_inv
		fill_inventory_ui()
	else:
		base_selected = null
		clear_preview()


func fill_inventory_ui():
	if base_selected:
		var base_selected_inventory = base_selected.get_inventory()
		for item in base_selected_inventory:
			inventory_items[item].text = str(base_selected_inventory[item])
		
		
func try_to_build(building_type_preview, building_actual, to_build_type):
	#if self.get_multiplayer_authority() == multiplayer.get_unique_id():
	if player_can_affort(to_build_type):
		base_type_selected = to_build_type
		preview_building = building_type_preview.instantiate()
		get_tree().current_scene.add_child(preview_building) 
		building = building_actual
	
func player_can_affort(to_build_type):
	""" This function figures out if the player can afford the building they clicked on"""
	var can_afford = true
	for item in buildings[to_build_type]: 
		# Amount player has - cost
		var difference = base_selected.get_inventory()[item.to_lower()] - buildings[to_build_type][item][1]
		if difference < 0:
			base_selected = false
	return base_selected

func get_ray_caster():
	if !ray_caster:
		var players = get_tree().get_nodes_in_group("player")
		for player in players:
			if str(player.name) == str(multiplayer.get_unique_id()):
				ray_caster = player


func _input(event):
	if !ray_caster:
		get_ray_caster()
	#if self.get_multiplayer_authority() == multiplayer.get_unique_id():
	if preview_building != null:
		# If moving mouse, move the preview building
		if event is InputEventMouseMotion:
			ray = ray_caster.cast_ray_to_select()
			# If looking at the ground (as oppose to off to infinity)
			if ray != { }:
				preview_building.position = ray.position 
				
		elif Input.is_action_just_pressed("place") and ray:
			if ray != { } and ray["collider"].name == terrian_name:
				purchase_building()
		if Input.is_action_just_pressed("clear_selection"):
			clear_preview()


func find_ray_caster():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		if player.name == multiplayer.get_unique_id():
			ray_caster = player

func purchase_building():
	if player_can_affort(base_type_selected):
		for item in buildings[base_type_selected]: 
			base_selected.change_item_amount(item.to_lower(), -buildings[base_type_selected][item][1]) 
		place_building.rpc(ray, base_type_selected, side, enemy)
		place_building(ray, base_type_selected, side, enemy)


@rpc("any_peer") 
func place_building(placeRay, base_type_selected_string, s, e):
	print_debug("!!!!!!!!!!!!!!!!!!! ", base_type_selected_string)
	# Place construction ready to be worked on:
	var instance = construction.instantiate()
	instance.final_construction_type = building 
	instance.position = placeRay.position + Vector3(1.55, 0, 1.55)
	instance.final_construction_sub_type = "sub_type_" + base_type_selected_string
	instance.side = s
	instance.enemy = e
	get_tree().current_scene.add_child(instance) 
	clear_preview()


func clear_preview():
	""" This function controls removing preview of building after selecting building """
	#if self.get_multiplayer_authority() == multiplayer.get_unique_id():
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
	try_to_build(bridge_preview, bridge, "bridge")
