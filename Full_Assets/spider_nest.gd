extends Node3D

# General Stats
@export var main_type = "main_type_buildings"
@export var sub_type = "sub_type_spider_nest"
@export var side = "side_spider"
@export var enemy = "enemy_hostile"
@export var has_inventory = "has_inventory_false"

@export var enemy_type = "*"
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
