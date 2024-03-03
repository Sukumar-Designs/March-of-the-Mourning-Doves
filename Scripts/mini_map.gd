extends MarginContainer

@onready var player = $"../UI_Controller"
@export var zoom = 1.5
@onready var grid = $MarginContainer/BackgroundMap
@onready var player_marker = $MarginContainer/BackgroundMap/SquirrelSoldierHighlight
@onready var mob_marker = $MarginContainer/BackgroundMap/Squirrel

@onready var icons = {"side_squirrel":mob_marker, "side_bird":player_marker}

var grid_scale 
var markers = {}
var map_objects
var minimap_objects_group = "minimap_objects"
var game_started = false

func _ready():
	player_marker.position.x = grid.size.x /2
	player_marker.position.y = grid.size.y 
	grid_scale = grid.size / (get_viewport_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group(minimap_objects_group)
	for item in map_objects:
		add_minimap_marker(item)


func add_minimap_marker(item):
	print_debug(item.side, "!!!")
	print_debug(item)
	var new_marker = icons[item.side].duplicate()
	grid.add_child(new_marker)
	new_marker.show()
	markers[item] = new_marker
	print_debug("Creature Added To MiniMap")


func _process(delta):
	game_started = true 
	if !player:
		return
	for item in markers:
		# Check if item still exists
		if item and is_instance_valid(item):
			var obj_pos 
			if item.is_in_group("player"):
				# Move Player Icon
				var speed = (8.5/player.speed) * player.speed
				obj_pos = Vector2(0, 0)
				obj_pos.x = speed*(item.position.x + player.position.x) * grid_scale.x + grid.size.x / 2
				obj_pos.y = speed*(item.position.z + player.position.z) * grid_scale.y + grid.size.y #/2
				markers[item].position = obj_pos
				
				### Rotate Player Icon
				##print_debug(player_marker.position, "position")
				##markers[item].rotation = - item.rotation.y
				
			else:
				# Move all other icons
				var speed = (float(15.6)/float(item.speed)) * float(item.speed) 
				obj_pos = Vector2(0, 0)
				obj_pos.x = speed*(item.position.x) * grid_scale.x + grid.size.x / 2
				obj_pos.y = (speed+2)*(item.position.z) * grid_scale.y + grid.size.y 
			markers[item].position = obj_pos


func _on_node_3d_child_entered_tree(node):
	if game_started:
		if(node.is_in_group(minimap_objects_group) and node.side == "side_bird"):
			add_minimap_marker(node)
	
