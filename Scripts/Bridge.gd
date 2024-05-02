extends CharacterBody3D

var main_type = "main_type_buildings"
var sub_type = "sub_type_bridge"
var side 
var enemy 
var has_inventory = "has_inventory_false"

# Health variables
var max_health = 10
var current_health
@onready var health_bar = $HealthBar

var GRAVITY = 5

func _ready():
	#var player = get_tree().get_first_node_in_group(side + "camera")
	#if player:
		#$MultiplayerSynchronizer.set_multiplayer_authority(str(player.name).to_int())
	# Add to 5 basic groups
	add_to_group(main_type)
	add_to_group(sub_type)
	add_to_group(side)
	add_to_group(enemy)
	add_to_group(has_inventory)
	current_health = max_health


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
		kill.rpc()
		kill()

func update_health_bar():
	""" This function controlls the health bar """
	health_bar.side = side
	health_bar.update_health_bar(current_health, max_health)
	
	
func on_hit(damage, attacker):
	set_health(-damage)

@rpc("any_peer")
func kill():
	queue_free()

