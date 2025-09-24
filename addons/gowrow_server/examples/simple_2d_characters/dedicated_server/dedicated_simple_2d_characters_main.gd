extends Node

@export var character_scene: PackedScene

@export var players_container: Node

func _ready() -> void:
	# TODO: Improve error handling and allow connection configuration.
	if not GowrowNetwork.handler:
		# Client mode
		GowrowNetwork.handler = ClientHandler.new()
		GowrowNetwork.add_child(GowrowNetwork.handler)
	GowrowNetwork.handler.initialize()

	if multiplayer.is_server():

		multiplayer.peer_connected.connect(_add_player)
		multiplayer.peer_disconnected.connect(_del_character)

		return

func _add_player(id: int) -> void:
	if not multiplayer.is_server():
		return  # Only the server handles player spawning

	GowrowLogger.log("Spawning Character for player: %d" % id)

	var character = character_scene.instantiate()
	character.position = Vector2(
		randf_range(-100, 100),
		randf_range(-100, 100)
	)
	character.player = id
	character.name = "Character_%d" % id

	players_container.add_child(character)

func _del_character(id: int) -> void:
	if not multiplayer.is_server():
		return  # Only the server handles player removal

	for child in players_container.get_children():
		if child.player == id:
			child.queue_free()
			GowrowLogger.log("Removed Character for player: %d" % id)
			return

	GowrowLogger.log("No Character found for player: %d" % id, GowrowLogger.Level.WARNING)