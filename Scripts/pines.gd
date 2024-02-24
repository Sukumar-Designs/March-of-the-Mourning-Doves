extends CharacterBody3D
# Variables to control bobbing
var max_float = 1.3
var min_float = 0
var y_pos = 0
var delay_movement = 2.4
var delay_movement_tracker 
var going_up = true
var height_delta = .05

@export var side = "resource" 
@export var type = "resource"
@export var resource_type = "pine"


func _ready():
	delay_movement_tracker = delay_movement
	add_to_group(side)
	add_to_group(type)
	add_to_group(resource_type)

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
