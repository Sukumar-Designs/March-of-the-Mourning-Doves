extends Path3D

var creatures_to_push = []
const move_speed = 4

var Path_instance = PathFollow3D
const PATH_LENGTH = 218.0
const CREATURE_HEIGHT_OFFSET = 0.0

func _physics_process(delta):
	var to_remove = []
	var spot = 0
	for creature in creatures_to_push:
		# Push the creatures down the river
		if creature[1].progress >= PATH_LENGTH:
			# If the creature has reached the end, remove nodes from game
			creature[0].queue_free()
			creature[1].queue_free()
			to_remove.append(spot)
		else:
			creature[1].progress += move_speed * delta
		spot+=1
			
	for index in to_remove:
		# Remove creatures that reached the end from the list that tracks creatures in the river
		creatures_to_push.remove_at(index)


func float_down_river(creature):
	# This function handles creating the path, removing hitboxes from the creature
	# and setting the creature and path at the right starting location
	if !creatures_to_push.has(creature):
		var old_loc = creature.position
		
		# Clear the creature collision nodes 
		remove_features(creature)
		creature.get_parent().remove_child(creature)
		
		# Instantiate path for creature to follow
		var path_instance = Path_instance.new()
		add_child(path_instance)
		path_instance.add_child(creature)
		creature.set_global_position(Vector3(old_loc.x, old_loc.y + CREATURE_HEIGHT_OFFSET, old_loc.z))
		path_instance.progress = get_offset(path_instance, creature.position)
		creatures_to_push.append([creature, path_instance])
		


func get_offset(path_instance, local_space):
	# This function gets the nearest path progress point to the creatures 
	# position where they entered the river
	return curve.get_closest_offset(to_local(local_space))


func remove_features(creature):
	# This function removes the creatures hitboxes, so they don't collider
	# with the river anymore
	creature.set_collision_mask_value(4, false) 
	for child in creature.get_children():
		if child is CollisionShape3D or child is Area3D:
			child.queue_free()

	creature.assign_target(self)
