extends Node

const MOVE_SPEED = 10
var left_limit = -50
var right_limit = 50
var upper_limit = -58
var lower_limit = 0

@onready var you_are_here = $Map/You_Are_Here
var YAH_move_speed_UD = 27
var YAH_move_speed_LR = 90
#func _ready():
	#print_debug(you_are_here)


func _process(delta):
	
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
