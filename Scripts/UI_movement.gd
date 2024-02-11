extends Node3D

# Camera Movement
const MOVE_SPEED = 10
var left_limit = -50
var right_limit = 50
var upper_limit = -58
var lower_limit = 0

# Map Movement
@onready var you_are_here = $Map/You_Are_Here
var YAH_move_speed_UD = 27
var YAH_move_speed_LR = 90

var sensitivity = 1  # Adjust the rotation sensitivity as needed
var is_dragging = false
var previous_mouse_position = Vector2()



func _process(delta):
	# Translate the Camera
	if Input.is_action_pressed("camera_forward"):
		if(self.position.z >= upper_limit):
			self.position.z -=  delta * MOVE_SPEED
			you_are_here.position.y -= delta * MOVE_SPEED*YAH_move_speed_UD
	if Input.is_action_pressed("camera_back"):
		if(self.position.z <= lower_limit):
			self.position.z += delta * MOVE_SPEED
			you_are_here.position.y += delta * MOVE_SPEED*YAH_move_speed_UD
	if Input.is_action_pressed("camera_left"):
		if(self.position.x >= left_limit):
			self.position.x -= delta * MOVE_SPEED
			you_are_here.position.x -= delta * MOVE_SPEED*YAH_move_speed_LR
	if Input.is_action_pressed("camera_right"):
		if(self.position.x <= right_limit):
			self.position.x += delta * MOVE_SPEED
			you_are_here.position.x += delta * MOVE_SPEED*YAH_move_speed_LR
#
	#if is_dragging:
		#var mouse_delta = (get_viewport().get_mouse_position()*1.1) - previous_mouse_position 
		#var delta_x = mouse_delta.x * sensitivity
		#print(delta_x)
		#rotate_object_local(Vector3(0, delta_x, 0), deg_to_rad(2.0))
		#previous_mouse_position = get_viewport().get_mouse_position()
#
#func _input(event):
	##print_debug(event)
	#if event is InputEventMouseButton:
		#is_dragging = event.pressed
		#if is_dragging:
			#previous_mouse_position = event.position
