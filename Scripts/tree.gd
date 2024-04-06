extends CharacterBody3D
# General Stats
@export var main_type = "main_type_other_structures"
@export var sub_type = "sub_type_base_tree"
@export var side = "side_neutral"
@export var enemy = "enemy_neutral"
@export var has_inventory = "has_inventory_false"

# Base Stats
var max_health = 10
var current_health

# Health Bar
@onready var health_bar = $HealthBar
var health_bar_visible_timer_initial = 600
var health_bar_visible_timer 

# Emulate Chopped Down Animation
var fall_speed = 5.0  # Adjust this value to control the falling speed
var falling = false
var rotation_speed = 90.0  # Adjust this value to control the rotation speed
var target_rotation = Vector3(-93, 0, 0)  # Adjust the target rotation as needed

@onready var sync = $MultiplayerSynchronizer

# Drops after falling
@onready var drops = preload("res://Full_Assets/Twig_Full.tscn") 
var rng 

var attacker

func _ready():
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)

	current_health = max_health
	health_bar_visible_timer = health_bar_visible_timer_initial 
	update_health_bar()
	health_bar.visible = false
	
	# Variable for randomly displacing drops 
	rng = RandomNumberGenerator.new()
	rng.randomize()

func _process(delta):
	if health_bar.visible and health_bar_visible_timer > 0:
		health_bar_visible_timer -= 1
	elif health_bar_visible_timer <= 0:
		health_bar.visible = false
		health_bar_visible_timer = health_bar_visible_timer_initial
	if falling:
		fall_over(delta)

# Health Based Function
func set_health(amount):
	if current_health >= max_health:
		current_health = max_health
	if current_health >= max_health and amount > 0:
		pass
	else:
		current_health += amount
	update_health_bar()
	if current_health <= 0:
		falling = true

func update_health_bar():
	""" This function controlls the health bar """
	health_bar.side = side
	health_bar.update_health_bar(current_health, max_health)


func on_hit(damage, _current_attacker):
 	#self.set_multiplayer_authority(current_attacker.get_multiplayer_authority())
	#print_debug(get_multiplayer_authority())
	#attacker = current_attacker
	
	set_health(-damage)
	# Get healthbar to display
	health_bar.visible = true
	health_bar_visible_timer = health_bar_visible_timer_initial


func fall_over(delta):
	""" This function controls a tree falling over """
	# Rotate the character over a period of time (controlled by delta)
	if self.rotation_degrees.x > target_rotation.x:
		self.rotation_degrees.x -= rotation_speed * delta

		# Ensure the rotation is set to the exact target to avoid overshooting
		if self.rotation_degrees.x < target_rotation.x:
			self.rotation_degrees.x = target_rotation.x

		# Move the character downward to simulate falling
		translate(Vector3(-fall_speed * delta, 0, 0))
	else:
		kill()

#@rpc("any_peer")
func kill():
	for i in range(0, rng.randi_range(1, 4)):
		var instance = drops.instantiate()
		var offset = rng.randi_range(-2, 2)
		instance.position.x = self.position.x + offset
		instance.position.z = self.position.z + offset
		instance.position.y = self.position.y 
		get_tree().current_scene.add_child(instance)
	
	#print("RPC called by: ", multiplayer.get_remote_sender_id())
	#print("RPC called by: ", get_multiplayer_authority())
	#self.visible = false
	#rpc("request_node_deletion", self.get_path())
	queue_free()
# Server script

# RPC to handle deletion request from the client
#@rpc("unreliable")
func request_node_deletion(node_path: NodePath) -> void:
	print_debug("1")
	var node = get_node(node_path)
	if node:
		# Delete the node on the server
		node.queue_free()

		# Synchronize the deletion to all clients
		rpc("sync_node_deletion", node_path)

# RPC to synchronize node deletion to all clients
#@rpc("unreliable")
func sync_node_deletion(node_path: NodePath) -> void:
	print_debug("2")
	var node = get_node(node_path)
	if node:
		# Delete the node on all clients
		node.queue_free()


