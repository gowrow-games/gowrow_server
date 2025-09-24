extends Node

@export var character_scene: PackedScene

@export var players_container: Node

@onready var join_button: Button = $CanvasLayer/JoinButton
@onready var host_button: Button = $CanvasLayer/HostButton

func _ready() -> void:
	join_button.pressed.connect(_on_join_button_pressed)
	host_button.pressed.connect(_on_host_button_pressed)

func _on_join_button_pressed() -> void:
	# Client mode
	GowrowNetwork.handler = ClientHandler.new()
	GowrowNetwork.add_child(GowrowNetwork.handler)
	GowrowNetwork.handler.initialize()

	join_button.disabled = true
	host_button.disabled = true

func _on_host_button_pressed() -> void:
	# Host mode (server + client)
	GowrowNetwork.handler = HostHandler.new()
	GowrowNetwork.add_child(GowrowNetwork.handler)
	GowrowNetwork.handler.initialize()

	_add_player(1)  # Add local player immediately

	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_del_character)

	join_button.disabled = true
	host_button.disabled = true

func _add_player(id: int) -> void:
	if not multiplayer.is_server():
		# Only the server handles player spawning from peer connects
		# The players are added on the client side using scene replication via Godot High-level Multiplayer API
		return

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
		# Only the server handles player removal from peer disconnects
		# The players are removed on the client side using scene replication via Godot High-level Multiplayer API
		return

	for child in players_container.get_children():
		if child.player == id:
			child.queue_free()
			GowrowLogger.log("Removed Character for player: %d" % id)
			return

	GowrowLogger.log("No Character found for player: %d" % id, GowrowLogger.Level.WARNING)
