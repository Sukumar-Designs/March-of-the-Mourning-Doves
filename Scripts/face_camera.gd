extends Node3D

@onready var camera_location = $"../UI_Controller"
@export var side = "squirrel"
@export var enemy = "bird"
var speed = 5
var current_target
var targets

func _process(delta):
	if camera_location:
		look_at(camera_location.position)
	if side == "squirrel":
		if !current_target:
			var nearest_target 
			var targets = get_tree().get_nodes_in_group(enemy)
			for target in targets:
				# Get nearest target
				if !nearest_target:
					nearest_target = target	
				else:
					var distance = self.position - target.position
					if distance < (self.position - nearest_target.position):
						nearest_target = targets
		
