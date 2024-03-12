extends Node3D


var multiplayer_peer = ENetMultiplayerPeer.new()
@export var player_scene_bird: PackedScene
@export var player_scene_squirrel: PackedScene
var spawn_bird = true

const PORT = 9999
const ADDRESS = "127.0.0.1"

@onready var button1 = $Lobby/Host
@onready var button2 = $Lobby/Join

func _on_host_pressed():
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	#button1.visible = false
	#button2.visible = false
	multiplayer.peer_connected.connect(
		func(id):
			add_player(id)
	)
	button1.visible = false
	button2.visible = false
	add_player()
	
func _on_join_pressed():
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	button1.visible = false
	button2.visible = false

func add_player(id=1):
	var player
	if spawn_bird:
		player = player_scene_bird.instantiate()
		spawn_bird = false
	else:
		player = player_scene_squirrel.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

