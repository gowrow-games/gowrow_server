@tool
extends EditorPlugin


func _enable_plugin() -> void:
	print("Enabling Gowrow Dedicated Server plugin...")
	add_autoload_singleton("GowrowNetwork", "gowrow_network.gd")
	add_autoload_singleton("GowrowLogger", "gowrow_logger.gd")

func _disable_plugin() -> void:
	print("Disabling Gowrow Dedicated Server plugin...")
	remove_autoload_singleton("GowrowNetwork")
	remove_autoload_singleton("GowrowLogger")