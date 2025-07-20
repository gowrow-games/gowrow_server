extends Node

var chat_log = []

@export var input: LineEdit
@export var send_button: Button
@export var chat_display: RichTextLabel

func _ready() -> void:
	# TODO: Improve error handling and allow connection configuration.
	GowrowNetwork.handler.initialize()

	if multiplayer.is_server():
		return # Server does not need to set up the UI

	send_button.pressed.connect(_on_send_button_pressed)
	input.text_submitted.connect(_on_line_submitted)

	input.placeholder_text = "Send message from client %d" % multiplayer.get_unique_id()

func _on_send_button_pressed() -> void:
	_send_chat_message(input.text)

func _on_line_submitted(text: String) -> void:
	_send_chat_message(text)

func _send_chat_message(msg: String) -> void:
	msg = msg.strip_edges()
	if msg != "":
		rpc_id(1, "send_chat_message", msg)  # Send message to server
		input.clear()

# Called when a client sends a message
@rpc("any_peer")
func send_chat_message(msg: String):
	if multiplayer.get_unique_id() != 1:
		return  # Ignore if not running on the server. Clients should not send messages to other clients directly.

	var peer_id: int = multiplayer.get_remote_sender_id()

	# Perform server-side processing of the message
	if msg.strip_edges() == "":
		return  # Ignore empty messages

	if msg.length() > 256:
		GowrowLogger.log("Message too long from peer %d: %s" % [peer_id, msg], GowrowLogger.Level.WARNING)
		rpc_id(peer_id, "receive_chat_warning", "Message too long (max 256 characters).")
		return

	if msg.contains("foo_bar"):
		GowrowLogger.log("Forbidden content detected in message from peer %d: %s" % [peer_id, msg], GowrowLogger.Level.WARNING)
		rpc_id(peer_id, "receive_chat_warning", "Message contains forbidden content (foo_bar).")
		return # Ignore messages containing "foo_bar"

	# Prepend the peer ID to the message for identification
	msg = "[%d]: %s" % [peer_id, msg]

	chat_log.append(msg)
	# Broadcast to all clients (including sender)
	rpc("receive_chat_message", msg)

# Call by the server to display the message on all clients (including the message sender and the server itself)
@rpc("authority", "call_local")
func receive_chat_message(msg: String):
	GowrowLogger.log("Chat: %s" % msg)
	chat_log.append(msg)
	chat_display.append_text(msg + "\n")

@rpc("authority", "call_local")
func receive_chat_warning(msg: String):
	GowrowLogger.log(msg, GowrowLogger.Level.WARNING)
	chat_display.append_text(msg + "\n")