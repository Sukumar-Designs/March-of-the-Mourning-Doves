extends Node3D

@export var main_type = "main_type_resources"
@export var sub_type = "sub_type_twig"
@export var pickup_group = "attributed_pickup"


func _ready():
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(pickup_group)
