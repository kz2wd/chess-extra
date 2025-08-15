extends Node2D

@export var PORT = 9500
@export var MAX_CLIENTS = 20

func _ready() -> void:
	
	# Create server.
	var peer = ENetMultiplayerPeer.new()
	peer.peer_connected.connect(on_peer_connected)
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	if multiplayer.is_server():
		print_once_per_client.rpc()
	

@rpc
func print_once_per_client():
	print("I will be printed to the console once per each connected client.")

func on_peer_connected(id: int) -> void:
	print("Peer connected: ", id)
	
