extends ProgressBar
@export var side = "squirrel"
@onready var towerNodeBlue = get_node('../../Blue_Tower_Full')
@onready var towerNodeRed = get_node('../../Red_Tower_Full')

# Called when the node enters the scene tree for the first time.
func _ready():
	towerNodeBlue.connect("healthChanged", updateBar)
	towerNodeRed.connect("healthChanged", updateBar)

func updateBar(num, signal_side):
	if signal_side == side:
		self.value = num
