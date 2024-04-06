extends Node3D

@export var BirdScene: PackedScene
@export var SquirrelScene: PackedScene

@rpc("any_peer")
func _ready():
	var PlayerOrder = 0
	
	var gamePlayers = []
	for gamePlayer in GameManager.Players:
		gamePlayers.append(GameManager.Players[gamePlayer].id)
	
	gamePlayers.sort()
	print_debug("GAME PLAYERS:", gamePlayers)
	if str(gamePlayers[0]).to_int() == multiplayer.get_unique_id():
		PlayerOrder = 1
	else:
		PlayerOrder = 0
	
	var spawnPoss = get_tree().get_nodes_in_group("PlayerSpawnPoint")
	

	if PlayerOrder == 0:
		var bird = BirdScene.instantiate()
		bird.name = str(gamePlayers[0])
		add_child(bird)
		bird.global_position = spawnPoss[0].global_position
		
		var squirrel = SquirrelScene.instantiate()
		squirrel.name = str(gamePlayers[1])
		add_child(squirrel)
		squirrel.global_position = spawnPoss[1].global_position
		print_debug("Making Camera", multiplayer.is_server())
	elif PlayerOrder == 1:
		var squirrel = SquirrelScene.instantiate()
		squirrel.name = str(gamePlayers[1])
		add_child(squirrel)
		squirrel.global_position = spawnPoss[1].global_position
		
		var bird = BirdScene.instantiate()
		bird.name = str(gamePlayers[0])
		add_child(bird)
		bird.global_position = spawnPoss[0].global_position
		print_debug("Making Camera", multiplayer.is_server())
