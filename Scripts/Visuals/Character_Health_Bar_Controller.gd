extends Sprite3D
var health_proportion 
var side
@onready var x_scale = self.scale.x
var camera 
@onready var healthbar_texture = preload("res://Assets/Visuals/Health_Bar/Background.jpg")

func update_health_bar(current_health, max_health):
	health_proportion = (float(current_health)/float(max_health))
	self.scale.x =  (health_proportion * x_scale)

	if side == null or camera == null: 
		texture = healthbar_texture
		modulate[1] = 0
		modulate[2] = 0
	elif str(side) + "camera" != camera.side:
		texture = healthbar_texture
		modulate[1] = health_proportion
	
	#health_bar.modulate[0] = health_proportion # Size
	#modulate[1] = health_proportion # more purple as smaller
	#health_bar.modulate[2] = health_proportion # More green? maybe resolution
	#health_bar.modulate[3] = health_proportion # More transparent
