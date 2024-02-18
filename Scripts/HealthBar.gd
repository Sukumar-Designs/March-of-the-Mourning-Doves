extends ProgressBar
@export var side = "squirrel"
@export var enemy = "bird"
var side_main_base
var enemy_main_base

# Called when the node enters the scene tree for the first time.
func _ready():
	var bases = get_tree().get_nodes_in_group("main_base")
	for base in bases:
		if base.is_in_group(side):
			side_main_base = base
			#side_main_base.connect("healthChanged", updateBar)
		elif base.is_in_group(enemy):
			enemy_main_base = base


func _on_squirrel_base_health_changed(num):
	self.value = num

func _on_bird_base_health_changed(num):
	self.value = num
