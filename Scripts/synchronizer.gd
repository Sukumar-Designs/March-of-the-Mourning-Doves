extends MultiplayerSynchronizer

var x = 0

@export var position:Vector3:
	set(val):
		if is_multiplayer_authority():
			position = val
		else:
			get_parent().position = val
#@rpc
#func _process(_delta):
	##print_debug(multiplayer.is_server(), x)
	#print_debug(is_multiplayer_authority(), x)
	##if multiplayer.is_server():
		##print_debug("!!!!!!", get_multiplayer_authority())
	#x += 1
