extends Node3D

@onready var camera_location = $"../UI_Controller"
var side = "enemy"
var speed = 5
func _ready():
	pass # Replace with function body.


func _process(delta):
	if camera_location:
		look_at(camera_location.position)
	position.x += 0.1
