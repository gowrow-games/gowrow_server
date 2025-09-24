# GowrowNetwork Autoload
extends Node

# TODO: Support configurable host and port via project settings or command line arguments.
var HOST: String = "127.0.0.1"
var PORT: int = 4242

var handler: NetworkHandler

func _ready() -> void:

	# Automatically start the server in headless mode.
	if OS.has_feature("dedicated_server") or "--dedicated_server" in OS.get_cmdline_args():
		GowrowLogger.log("Starting dedicated server...")
		# TODO: Add support for additional args to control game mode settings.
		handler = ServerHandler.new()
		add_child(handler)
