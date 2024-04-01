extends Node3D

@export var BirdScene: PackedScene
@export var SquirrelScene: PackedScene

#@rpc("call_local")
func _ready():
	var PlayerOrder = 0
	if multiplayer.is_server():
		PlayerOrder = 1

	var spawnPoss = get_tree().get_nodes_in_group("PlayerSpawnPoint")
		#print_debug(spawn)
	var gamePlayers = []
	for gamePlayer in GameManager.Players:
		gamePlayers.append(GameManager.Players[gamePlayer].id)
		
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



#var multiplayer_peer = ENetMultiplayerPeer.new()
#@export var player_scene_bird: PackedScene
#@export var player_scene_squirrel: PackedScene
#var spawn_bird = true
#
#const PORT = 9999
#const ADDRESS = "127.0.0.1"
#
#@onready var button1 = $Lobby/Host
#@onready var button2 = $Lobby/Join
#
#func _on_host_pressed():
	#multiplayer_peer.create_server(PORT)
	#multiplayer.multiplayer_peer = multiplayer_peer
	##button1.visible = false
	##button2.visible = false
	#multiplayer.peer_connected.connect(
		#func(id):
			#add_player(id)
	#)
	#button1.visible = false
	#button2.visible = false
	#add_player()
	#
#func _on_join_pressed():
	#multiplayer_peer.create_client(ADDRESS, PORT)
	#multiplayer.multiplayer_peer = multiplayer_peer
	#button1.visible = false
	#button2.visible = false
#
#func add_player(id=1):
	#var player
	#if spawn_bird:
		#player = player_scene_bird.instantiate()
		#spawn_bird = false
	#else:
		#player = player_scene_squirrel.instantiate()
	#player.name = str(id)
	#call_deferred("add_child", player)
#
