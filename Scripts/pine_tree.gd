extends Node3D
# General Stats
@export var side = "tree" 
@export var type = "natural_structure"
# Base Stats
var max_health = 100
var current_health

# Health Bar
@onready var health_bar = $CharacterBody3D/HealthBar/SubViewport/Healthbar
@onready var health_bar_controller = $CharacterBody3D
var health_bar_visible_timer_initial = 600
var health_bar_visible_timer 

func _ready():
	add_to_group(side)
	add_to_group(type)
	current_health = max_health
	health_bar_visible_timer = health_bar_visible_timer_initial 
	health_bar.value = float(current_health)/float(max_health)
	health_bar_controller.visible = false

func _process(delta):
	if health_bar_controller.visible and health_bar_visible_timer > 0:
		health_bar_visible_timer -= 1
	elif health_bar_visible_timer <= 0:
		health_bar_controller.visible = false
		health_bar_visible_timer = health_bar_visible_timer_initial


# Health Based Function
func set_health(amount):
	if current_health >= max_health:
		current_health = max_health
	if current_health >= max_health and amount > 0:
		pass
	else:
		current_health += amount
	health_bar.value = float(current_health)/float(max_health)
	if current_health <= 0:
		
		kill()
	print_debug(current_health, "CURRENT HEALTH")

func on_hit(damage):
	set_health(-damage)
	# Get healthbar to display
	health_bar_controller.visible = true
	health_bar_visible_timer = health_bar_visible_timer_initial

func kill():
	queue_free()
