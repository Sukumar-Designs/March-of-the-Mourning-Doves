extends CharacterBody3D
@onready var camera_location = $"../../UI_Controller"


func _process(delta):
	if camera_location:
		look_at(camera_location.position)
