extends MarginContainer

@onready var player = $"../UI_Controller"
@export var zoom = 1.5
@onready var grid = $MarginContainer/BackgroundMap
@onready var player_marker = $MarginContainer/BackgroundMap/SquirrelSoldierHighlight
@onready var mob_marker = $MarginContainer/BackgroundMap/Squirrel

@onready var icons = {"enemy":mob_marker, "ally":player_marker}

var grid_scale 
var markers = {}

func _ready():
	player_marker.position = grid.size / 2
	grid_scale = grid.size / (get_viewport_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.side].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
		print_debug("Added")

func _process(delta):
	if !player:
		return
	#print_debug(player.rotation.y + PI / 2, "player")
	#print_debug(player_marker.rotation, "marker")
	#print_debug(player_marker.position, "position")
	#player_marker.rotation = player.rotation.y + PI / 2
	#player_marker.rotate(player.rotation.y * 1.5)#+ PI / 2
	#print_debug(player_marker.rotation)
	for item in markers:
		if item.is_in_group("player"):
			# Move Player Icon
			var speed = (8.1/5) * player.speed
			var obj_pos = speed*(Vector2(item.position.x, item.position.y) + Vector2(player.position.x, player.position.z)) * grid_scale + grid.size / 2
			markers[item].position = obj_pos
			
			# Rotate Player Icon
			print_debug(player_marker.position, "position")
			markers[item].rotation = - item.rotation.y
			
		else:
			# Move all other icons
			var speed = (15.25/5) * item.speed 
			var obj_pos = speed*(Vector2(item.position.x, item.position.y))* grid_scale + grid.size / 2
			markers[item].position = obj_pos
