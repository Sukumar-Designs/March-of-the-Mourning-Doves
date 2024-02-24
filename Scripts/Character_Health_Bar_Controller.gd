extends Sprite3D
var health_proportion 
var side

@onready var x_scale = self.scale.x

func update_health_bar(current_health, max_health):
	health_proportion = (float(current_health)/float(max_health))
	self.scale.x =  (health_proportion * x_scale)
	
	# If side is not bird, make health bar red
	if side != "bird":
		modulate[1] = 0
		modulate[2] = 0
	else:
		modulate[1] = health_proportion
	
	#health_bar.modulate[0] = health_proportion # Size
	#modulate[1] = health_proportion # more purple as smaller
	#health_bar.modulate[2] = health_proportion # More green? maybe resolution
	#health_bar.modulate[3] = health_proportion # More transparent
