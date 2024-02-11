extends Node

const MOVE_SPEED = 10
#var left_limit = 600
#var right_limit = 2800


func _process(delta):
	print_debug(self.position.z)
	if Input.is_action_pressed("camera_forward"):
		#if(self.position.x >= left_limit):
		self.position.z -=  delta * MOVE_SPEED
	if Input.is_action_pressed("camera_back"):
		#if(self.position.x <= right_limit):
		self.position.z += delta * MOVE_SPEED
	if Input.is_action_pressed("camera_left"):
		#if(self.position.x <= right_limit):
		self.position.x -= delta * MOVE_SPEED
	if Input.is_action_pressed("camera_right"):
		#if(self.position.x <= right_limit):
		self.position.x += delta * MOVE_SPEED
