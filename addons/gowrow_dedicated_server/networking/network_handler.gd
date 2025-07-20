abstract
class_name NetworkHandler
extends Node

func initialize():
	push_error("NetworkHandler.initialize() must be implemented by a subclass.")

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int) -> void:
	if id == 1:  # ID 1 is reserved for the server itself and should not be handled here.
		return
	GowrowLogger.log("Peer connected: %d" % id)

func _on_peer_disconnected(id: int) -> void:
	if id == 1:  # ID 1 is reserved for the server itself and should not be handled here.
		return
	GowrowLogger.log("Peer disconnected: %d" % id)