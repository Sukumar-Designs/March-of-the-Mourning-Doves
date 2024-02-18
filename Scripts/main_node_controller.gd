extends Node

# The sides:
# Squirrels
# Birds
var enemy = "squirrel"
var side = "bird"


## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


func _process(delta):
	# Get all Squirrels
	var enemies = get_tree().get_nodes_in_group(enemy)
	var sides = get_tree().get_nodes_in_group(side)
	
	
