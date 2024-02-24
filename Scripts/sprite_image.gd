extends Sprite3D

var taking_damage = false
var taking_damage_time = 7
var taking_damage_tracker 

func _process(delta):
	if taking_damage:
		show_taking_damage()

func just_hit():
	# Variables for visually showing damage taken
	taking_damage = true
	taking_damage_tracker = taking_damage_time


func show_taking_damage():
	# No longer taking damage
	if taking_damage_tracker <= 0:
		taking_damage = false
		self.modulate[1] = 1
	# Just took damage
	elif taking_damage_tracker == taking_damage_time:
		self.modulate[1] = 0 
	taking_damage_tracker -= 1
