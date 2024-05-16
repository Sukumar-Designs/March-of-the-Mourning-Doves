extends Control

signal found_server(ip, port, roomInfo)
signal update_server(ip, port, roomInfo)
signal joinGame(ip)

var broadcastTimer : Timer
var RoomInfo = {"name": "name", "playerCount":0}
var broadcaster : PacketPeerUDP
var listener : PacketPeerUDP
@export var listenPort : int = 8911
@export var broadcastPort : int = 8912
@export var broadcastAddress : String = '192.168.1.255' # Local IP4 Address with .255 replacing last numbers
@export var serverInfo : PackedScene

func _ready():
	broadcastTimer = $BroadcastTimer
	setUp()

func setUp():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listenPort)
	
	if ok == OK:
		print_debug("Bound to Listen Port Successful", str(listenPort))
		$Label.text = "Bound to Listen Port: true"
	else:
		print_debug("Failed to bind to Listen Port!")
		$Label.text = "Bound to Listen Port: false"


func setUpBroadcast(name):
	RoomInfo.name = name
	RoomInfo.playerCount = GameManager.Players.size()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcastAddress, listenPort)
	
	var ok = broadcaster.bind(broadcastPort)
	
	if ok == OK:
		print_debug("Bound to Broadcast Port Successful", str(broadcastPort))
	else:
		print_debug("Failed to bind to Broadcast Port!")
	broadcastTimer.start()

func _process(delta):
	if listener.get_available_packet_count() > 0:
		var serverip = listener.get_packet_ip()
		var serverPort = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		print_debug("Server IP: " + str(serverip) + " Server Port: " + str(serverPort) + " Room Info: " + str(roomInfo))
		
		# Whenever a player is found, we need to display the server
		for i in $Panel/VBoxContainer.get_children():
			if i.name == roomInfo.name:
				update_server.emit(serverip, serverPort, roomInfo)
				i.get_node("IP").text = serverip
				i.get_node("PlayerCount").text = str(roomInfo.playerCount)
				return
	
		var currentInfo = serverInfo.instantiate()
		currentInfo.name = roomInfo.name
		currentInfo.get_node("Name").text = roomInfo.name
		currentInfo.get_node("IP").text = serverip
		currentInfo.get_node("PlayerCount").text = str(roomInfo.playerCount)
		$Panel/VBoxContainer.add_child(currentInfo)
		currentInfo.joinGame.connect(joinbyIP)
		found_server.emit(serverip, serverPort, roomInfo)


func _on_broadcast_timer_timeout():
	print("Broadcasting Game!")
	RoomInfo.playerCount = GameManager.Players.size()
	
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)


func clean_up():
	listener.close()
	if broadcastTimer:
		broadcastTimer.stop()
		
	if broadcaster != null:
		broadcaster.close()

func _exit_tree():
	clean_up()

func joinbyIP(ip):
	joinGame.emit(ip)
