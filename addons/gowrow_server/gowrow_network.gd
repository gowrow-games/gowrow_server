# GowrowNetwork Autoload
extends Node

# TODO: Support configurable host and port via project settings or command line arguments.
var HOST: String = "127.0.0.1"
var PORT: int = 4242

var _handler: NetworkHandler

enum NetworkMode {
	NONE,
	SERVER, # Dedicated server mode
	HOST,   # Host mode (server + client)
	CLIENT  # Client mode
}

func _ready() -> void:
	# Automatically start the server in headless mode.
	if OS.has_feature("dedicated_server") or "--dedicated_server" in OS.get_cmdline_args():
		GowrowLogger.log("Starting dedicated server...")
		# TODO: Add support for additional args to control game mode settings.
		_handler = ServerHandler.new()
		add_child(_handler)

func get_network_mode() -> NetworkMode:
	if _handler is ServerHandler:
		return NetworkMode.SERVER
	elif _handler is HostHandler:
		return NetworkMode.HOST
	elif _handler is ClientHandler:
		return NetworkMode.CLIENT
	return NetworkMode.NONE

func start_as_client() -> bool:
	if get_network_mode() != NetworkMode.NONE:
		GowrowLogger.log("NetworkMode has already been determined; cannot start as client", GowrowLogger.Level.ERROR)
		return false

	_handler = ClientHandler.new()
	add_child(_handler)
	return _handler.initialize()

func start_as_host() -> bool:
	if get_network_mode() != NetworkMode.NONE:
		GowrowLogger.log("NetworkMode has already been determined; cannot start as host", GowrowLogger.Level.ERROR)
		return false

	_handler = HostHandler.new()
	add_child(_handler)
	return _handler.initialize()
