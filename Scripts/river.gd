extends Path3D

@onready var path = $PathFollow3D
var creatures_to_push = []
const move_speed = 0.4

func _physics_process(delta):
	if creatures_to_push.size() > 0:
		path.progress += move_speed * delta
		print_debug(path.progress)
		#for creature in creatures_to_push:
			#if creature.get_child($MultiplayerSynchronizer).get_multiplayer_authority() == multiplayer.get_unique_id():
		#if path.progress < 1:
			#path.progress += move_speed * delta
			#print_debug(path.progress)
					#print_debug(path.progress_ratio)
		#else:
			
			#creature.queue_freeze()


func float_down_river(creature):
	if !creatures_to_push.has(creature):
		var old_loc = creature.position
		creature.get_parent().remove_child(creature)
		self.add_child(creature)
		remove_features(creature)
		creatures_to_push.append(creature)
		creature.position = old_loc 
		#creature.moving = true
		#creature.move_speed = 1.0
		

func remove_features(creature):
	creature.set_collision_mask_value(4, false) 
	for child in creature.get_children():
		if child is CollisionShape3D or child is Area3D:
			print_debug("FREEZING", child)
			child.queue_free()

	creature.assign_target(self)
	#func delete_components():
	#for child in get_children():
		#child.queue_free()
