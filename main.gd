extends Node2D

@export var IP_ADDRESS = "127.0.0.1"
@export var PORT = 9500
@export var MAX_CLIENTS = 20

const SOLO_PLAYER = preload("res://player/solo_player.tscn")

func _init_player(color: Globals.PlayerColor) -> BoardControl:
	var player = SOLO_PLAYER.instantiate()
	player.player_color = color
	add_child(player)
	return player.board_control

func _start_server() -> void:
	_hide_ui()
	print("Server")
	# Create server.
	var peer = ENetMultiplayerPeer.new()
	peer.peer_connected.connect(on_peer_connected)
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	if multiplayer.is_server():
		print("Im server!")
	
	var player_color = Globals.PlayerColor.WHITE
	var oponent_color = Globals.PlayerColor.BLACK
	var board_control = _init_player(player_color)
	board_control.add_player(1, player_color)
	var add_colored_player = func(id):
		board_control.add_player(id, oponent_color)
	
	multiplayer.multiplayer_peer.peer_connected.connect(add_colored_player)
	

func _start_client() -> void:
	_hide_ui()
	print("Client")
	# Create client.
	multiplayer.connected_to_server.connect(_on_server_connected)
	# Create client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
	_init_player(Globals.PlayerColor.BLACK)

func _hide_ui() -> void:
	$CanvasLayer.visible = false

@rpc()
func print_once_per_client():
	print("I will be printed to the console once per each connected client.")

func on_peer_connected(id: int) -> void:
	print("Peer connected: ", id)
	
	
func _on_server_connected():
	print("connected to server")

	
func _on_host_pressed() -> void:
	_start_server()
	


func _on_join_pressed() -> void:
	_start_client()
