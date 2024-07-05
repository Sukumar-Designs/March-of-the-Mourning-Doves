extends Path3D

var creatures_to_push = []
const move_speed = 4

var Path_instance = PathFollow3D
const PATH_LENGTH = 218.0


func _physics_process(delta):
	var to_remove = []
	var spot = 0
	for creature in creatures_to_push:
		if creature[1].progress >= PATH_LENGTH:
			creature[0].queue_free()
			creature[1].queue_free()
			to_remove.append(spot)
		else:
			creature[1].progress += move_speed * delta
			#print_debug(creature[0].position)
		spot+=1
			
	for index in to_remove:
		creatures_to_push.remove_at(index)


func float_down_river(creature):
	if !creatures_to_push.has(creature):
		var old_loc = creature.position
		
		# Clear the creature collision nodes 
		remove_features(creature)
		
		print_debug(creature.position, "!!!!!")
		creature.get_parent().remove_child(creature)
		
		# Instantiate path for creature to follow
		var path_instance = Path_instance.new()
		add_child(path_instance)
		path_instance.add_child(creature)
		#path_instance.progress = old_loc.x - PATH_LENGTH
		creature.set_location(old_loc)
		print_debug(old_loc.x, "  ", path_instance.progress, "!!!!!!!!!!!!!!")
		#creature.set_location(old_loc)
		creatures_to_push.append([creature, path_instance])
		print_debug(creature.position, "_____")
		#creature.position = old_loc 
		#creature.moving = true
		#creature.move_speed = 1.0
		

func remove_features(creature):
	creature.set_collision_mask_value(4, false) 
	for child in creature.get_children():
		if child is CollisionShape3D or child is Area3D:
			print_debug("FREEZING", child)
			child.queue_free()

	creature.assign_target(self)
