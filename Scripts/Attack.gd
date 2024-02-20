extends Area3D
@export var side = "squirrel"
@export var enemy = "bird"
var target
var attack_speed = 1 
var attack_cooldown = 300
var attack_cooldown_counter = attack_cooldown
var attack_damage = 1

func _process(delta):
	if target:
		if attack_cooldown_counter <= 0:
			# Reset attack cooldown
			attack_cooldown_counter = attack_cooldown
			attack()
		else:
			attack_cooldown_counter -= attack_speed

func attack():
	if target:
		target.on_hit(attack_damage)


func _on_body_entered(body):
	# If the object is an enemy
	if body.is_in_group(enemy) and body.is_in_group("building"):
		# If there's no target
		if !target:
			target = body
