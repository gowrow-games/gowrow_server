class_name ServerHandler
extends NetworkHandler

func initialize() -> bool:
	var peer = ENetMultiplayerPeer.new()
	var result: int = peer.create_server(GowrowNetwork.PORT)
	if result != OK:
		GowrowLogger.error("Failed to create server: " + str(result))
		OS.alert("Failed to create server: " + str(result))
		return false

	GowrowLogger.log("Server started on port %d" % GowrowNetwork.PORT)
	multiplayer.multiplayer_peer = peer
	return true