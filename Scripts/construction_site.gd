extends CharacterBody3D

@export var main_type = "main_type_buildings"
@export var sub_type = "sub_type_construction"
@export var side = "side_bird"
@export var enemy = "enemy_squirrel"
@export var has_inventory = "has_inventory_false"

var final_construction_type
var final_construction_sub_type

# Health variables
var max_health = 50
var current_health
@onready var health_bar = $HealthBar

func _ready():
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)
	current_health = max_health

func construct():
	if final_construction_type:
		var instance = final_construction_type.instantiate()
		instance.position = self.position
		instance.sub_type = final_construction_sub_type
		instance.side = side
		instance.enemy = enemy
		get_tree().current_scene.add_child(instance) 
		queue_free()

# Health Based Function
func set_health(amount):
	if current_health >= max_health:
		current_health = max_health
	if current_health >= max_health and amount > 0:
		pass
	else:
		current_health += amount
	update_health_bar()
	if current_health <= 0:
		construct()

func update_health_bar():
	""" This function controlls the health bar """
	health_bar.side = side
	health_bar.update_health_bar(current_health, max_health)
	
	
func on_hit(damage, attacker):
	set_health(-damage)
