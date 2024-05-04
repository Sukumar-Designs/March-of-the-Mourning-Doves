extends Node

# @export var Address = "127.0.0.1"
@export var Address = "192.168.1.177" # IP4 Address
@export var port = 8910
var peer 
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if "--server" in OS.get_cmdline_args():
		hostGame()

func _process(delta):
	pass

# Called on the server and client
func peer_connected(id):
	print_debug("Player Connected " + str(id))
	
# Called on server and client
func peer_disconnected(id):
	print_debug("Player Disconnected " + str(id))
	
# Called only from cleints
func connected_to_server():
	print_debug("Connected to Server!")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
# Called only from clients
func connection_failed():
	print_debug("Failed to Connect")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	# This adds it to the server
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id":id,
			"score":0
		}
	# Server sends it to everyone else
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://Scenes/game.tscn").instantiate()
	#get_tree().root.add_child(scene)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print_debug("Cannot Host: ", error)
		return

	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	# Set up multiplayer peer, the peer is the host
	multiplayer.set_multiplayer_peer(peer)
	print_debug("Waiting for Players...")
	
func _on_host_pressed():
	hostGame()
	#SendPlayerInformation($LineEdit/Label.text, multiplayer.get_unique_id())
	$ServerBrowser.setUpBroadcast($LineEdit.text + "s server")

func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)


func _on_start_game_pressed():
	StartGame.rpc()
