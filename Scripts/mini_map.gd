extends MarginContainer

@onready var player = $"../UI_Controller"
@export var zoom = 1.5
@onready var grid = $MarginContainer/BackgroundMap
@onready var player_marker = $MarginContainer/BackgroundMap/SquirrelSoldierHighlight
@onready var mob_marker = $MarginContainer/BackgroundMap/Squirrel

@onready var icons = {"squirrel":mob_marker, "bird":player_marker}

var grid_scale 
var markers = {}

func _ready():
	player_marker.position.x = grid.size.x /2
	player_marker.position.y = grid.size.y 
	grid_scale = grid.size / (get_viewport_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.side].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
		print_debug("Player Added To MiniMap")

func _process(delta):
	if !player:
		return
	for item in markers:
		# Check if item still exists
		if item:
			if item.is_in_group("player"):
				# Move Player Icon
				var speed = (8.5/player.speed) * player.speed
				var obj_pos = Vector2(0, 0)
				obj_pos.x = speed*(item.position.x + player.position.x) * grid_scale.x + grid.size.x / 2
				obj_pos.y = speed*(item.position.z + player.position.z) * grid_scale.y + grid.size.y #/2
				markers[item].position = obj_pos
				
				### Rotate Player Icon
				##print_debug(player_marker.position, "position")
				##markers[item].rotation = - item.rotation.y
				
			else:
				# Move all other icons
				var speed = (15.25/15) * item.speed 
				var obj_pos = speed*(Vector2(item.position.x, item.position.y))* grid_scale + grid.size / 2
				markers[item].position = obj_pos
