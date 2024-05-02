extends Control

signal found_server
signal server_removed

var broadcastTimer : Timer
var RoomInfo = {"name": "name", "playerCount":0}
var broadcaster : PacketPeerUDP
var listener : PacketPeerUDP
@export var listenPort : int = 8911
@export var broadcastPort : int = 8912
@export var broadcastAddress : String = '172.20.10.255'

func _ready():
	broadcastTimer = $BroadcastTimer
	setUp()

func setUp():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listenPort)
	
	if ok == OK:
		print_debug("Bound to Listen Port Successful", str(listenPort))
	else:
		print_debug("Failed to bind to Listen Port!")


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
		
	$BroadcastTimer.start()

func _process(delta):
	if listener.get_available_packet_count() > 0:
		var serverip = listener.get_packet_ip()
		var serverPort = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		print_debug("Server IP: " + serverip + " Server Port: " + serverPort + " Room Info: " + roomInfo)

func _on_broadcast_timer_timeout():
	print("Broadcasting Game!")
	RoomInfo.playerCount = GameManager.Players.size()
	
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)


func clean_up():
	listener.close()
	
	$BroacastTimer.stop()
	if broadcaster != null:
		broadcaster.close()

func _exit_tree():
	clean_up()


