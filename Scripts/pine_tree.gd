extends CharacterBody3D
# General Stats
@export var side = "tree" 
@export var type = "natural_structure"
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

# Drops after falling
@onready var drops = preload("res://Full_Assets/Pines_Full.tscn") 
var rng 

func _ready():
	add_to_group(side)
	add_to_group(type)
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


func on_hit(damage):
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
		
func kill():
	for i in range(0, rng.randi_range(1, 4)):
		var instance = drops.instantiate()
		var offset = rng.randi_range(-2, 2)
		instance.position.x = self.position.x + offset
		instance.position.z = self.position.z + offset
		instance.position.y = self.position.y 
		get_tree().current_scene.add_child(instance)
	queue_free()

