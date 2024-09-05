extends CharacterBody3D
# Variables to control bobbing
var max_float = 1.3
var min_float = 0
var y_pos = 0
var delay_movement = 2.4
var delay_movement_tracker 
var going_up = true
var height_delta = .05

@export var main_type = "main_type_resources"
@export var sub_type = "sub_type_twig"
@export var side = "side_neutral"
@export var enemy = "enemy_neutral"
@export var has_inventory = "has_inventory_false"


func _ready():
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)

	delay_movement_tracker = delay_movement

func _process(delta):
	if delay_movement_tracker <= 0:
		if going_up:
			if y_pos <= max_float:
				self.position.y += height_delta
				y_pos += height_delta
			else:
				going_up = false
		else:
			if y_pos >= min_float:
				self.position.y -= height_delta
				y_pos -= height_delta
			else:
				going_up = true
		delay_movement_tracker = delay_movement
	delay_movement_tracker -= 1

func kill():
	queue_free()
