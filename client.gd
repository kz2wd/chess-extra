extends Node2D

@export var IP_ADDRESS = "127.0.0.1"
@export var PORT = 9500

func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_server_connected)
	# Create client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
	


func _on_server_connected():
	print("connected to server")
