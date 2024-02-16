extends Node

# General Stats
@export var side = "squirrel" 

# Base Stats
var max_health = 1000
var current_health
var heal_amount = 5

var heal_tick = 100

@export var main_base = false
signal healthChanged
signal baseDestroyed


func _ready():
	# Main base has 10x health
	if main_base:
		max_health *= 10 
	current_health = max_health
	emit_signal(current_health/max_health)
	if main_base:
		add_to_group("main_base")
	add_to_group("building")
	add_to_group(side + "_building")
	add_to_group(side)
	
func _process(delta):
	heal_tick -= 1
	if heal_tick <= 0:
		heal_tick = 100
		set_health(heal_amount)

func set_health(amount):
	
	current_health += amount
	emit_signal("healthChanged", current_health/max_health)
	if current_health <= 0:
		kill()

func on_hit(damage):
	set_health(-damage)

func kill():
	queue_free()
	emit_signal("baseDestroyed", side, main_base)
