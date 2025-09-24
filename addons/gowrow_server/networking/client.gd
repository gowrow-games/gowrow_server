class_name ClientHandler
extends NetworkHandler

func initialize():
	multiplayer.connected_to_server.connect(_client_connected)
	multiplayer.connection_failed.connect(_client_connection_failed)
	multiplayer.server_disconnected.connect(_client_connection_lost)

	var peer = ENetMultiplayerPeer.new()
	var result: int = peer.create_client(GowrowNetwork.HOST, GowrowNetwork.PORT)
	if result != OK:
		push_error("Failed to create client: " + str(result))
		OS.alert("Failed to create client: " + str(result))
		return false

	multiplayer.multiplayer_peer = peer
	return true

func _client_connected() -> void:
	GowrowLogger.log("Successfully connected to dedicated server!")

func _client_connection_failed() -> void:
	GowrowLogger.log("Failed to connect to server.", GowrowLogger.Level.ERROR)
	OS.alert("Failed to connect to server.")
	
func _client_connection_lost() -> void:
	GowrowLogger.log("Lost connection to server.", GowrowLogger.Level.ERROR)
	OS.alert("Lost connection to server.")
