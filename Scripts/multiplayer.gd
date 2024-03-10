extends Node


var peer = ENetMultiplayerPeer.new()
@export var player_scene_bird: PackedScene
@export var player_scene_squirrel: PackedScene
var spawn_bird = true

func _on_host_pressed():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	
func _add_player(id=1):
	var player
	if spawn_bird:
		player = player_scene_bird.instantiate()
		spawn_bird = false
	else:
		player = player_scene_squirrel.instantiate()
	player.name = str(id)
	var button1 = $Host
	var button2 = $Join
	button1.visible = false
	button2.visible = false
	call_deferred("add_child", player)

func _on_join_pressed():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	var button1 = $Host
	var button2 = $Join
	button1.visible = false
	button2.visible = false
