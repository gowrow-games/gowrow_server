# GowrowLogger Autoload
extends Node

enum Level {
	DEBUG,
	INFO,
	WARNING,
	ERROR
}

class LogMessage:
	var message: String
	var level: Level
	var timestamp: float
	var peer_id: int = 0

	var timestamp_color: String = "#555555"
	var level_colors: Dictionary[Level, String] = {
		Level.DEBUG: "#00BBEE",
		Level.INFO: "#CCFFCC",
		Level.WARNING: "#EEA511",
		Level.ERROR: "#992222"
	}
	var message_color: String = "#FFFFFF"
	var peer_color: String = "#555555"

	func _to_string() -> String:

		var timestamp_string: String = "[color=%s]%s[/color]" % [timestamp_color, Time.get_datetime_string_from_unix_time(int(timestamp), true)]
		var level_string: String = "[color=%s][%s][/color]" % [level_colors[level], Level.find_key(level)]
		var message_string: String = "[color=%s]%s[/color]" % [message_color, message]

		if peer_id == 1:
			return "%s: %s %s" % [timestamp_string, level_string, message_string]

		var peer_string: String = "[color=%s][disconnected][/color]" % [peer_color]
		if peer_id != 0:
			peer_string = "[color=%s][#%d][/color]" % [peer_color, peer_id]

		return "%s %s %s %s" % [timestamp_string, peer_string, level_string, message_string]

var level: Level = Level.DEBUG # TODO: Determine Level based on build settings

func log(message: String, log_level: Level = Level.INFO) -> void:
	if log_level >= level:
		var log_message := LogMessage.new()
		log_message.message = message
		log_message.level = log_level
		log_message.timestamp = Time.get_unix_time_from_system()

		var peer = multiplayer.multiplayer_peer
		if peer.get_unique_id():
			log_message.peer_id = peer.get_unique_id()

		if log_level == Level.DEBUG:
			print_debug(log_message.to_string())
		elif log_level == Level.ERROR:
			push_error(log_message.to_string())
		else:
			print_rich(log_message.to_string())

func debug(message: String) -> void:
	GowrowLogger.log(message, Level.DEBUG)

func info(message: String) -> void:
	GowrowLogger.log(message, Level.INFO)

func warn(message: String) -> void:
	GowrowLogger.log(message, Level.WARNING)

func error(message: String) -> void:
	GowrowLogger.log(message, Level.ERROR)
