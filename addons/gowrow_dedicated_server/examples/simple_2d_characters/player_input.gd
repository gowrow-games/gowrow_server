class_name PlayerInput
extends MultiplayerSynchronizer

@export var direction := Vector2.ZERO

func _ready() -> void:
	set_multiplayer_authority(get_parent().player) # TODO: This sucks
	# Only process for the local player.
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		GowrowLogger.log("PlayerInput is not the authority, disabling processing.", GowrowLogger.Level.WARNING)

func _process(delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized()  # Normalize to prevent faster diagonal movement