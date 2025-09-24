class_name HostHandler
extends NetworkHandler

func initialize():
	var peer = ENetMultiplayerPeer.new()
	var result: int = peer.create_server(GowrowNetwork.PORT)
	if result != OK:
		GowrowLogger.error("Failed to create local server: " + str(result))
		OS.alert("Failed to create local server: " + str(result))
		return

	GowrowLogger.log("Local server started on port %d" % GowrowNetwork.PORT)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(_client_connected)
	multiplayer.connection_failed.connect(_client_connection_failed)
	multiplayer.server_disconnected.connect(_client_connection_lost)

func _client_connected() -> void:
	GowrowLogger.log("Successfully connected to local server!")

func _client_connection_failed() -> void:
	GowrowLogger.log("Failed to connect to local server.", GowrowLogger.Level.ERROR)
	OS.alert("Failed to connect to local server.")

func _client_connection_lost() -> void:
	GowrowLogger.log("Lost connection to local server.", GowrowLogger.Level.ERROR)
	OS.alert("Lost connection to local server.")
