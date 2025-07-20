class_name Character
extends Sprite2D

@export var label: Label

@export var input: PlayerInput

@export var player: int = -1

func _ready() -> void:
	if multiplayer.get_unique_id() != player:
		$Camera2D.queue_free()

	if not label:
		push_error("Label is not set for the character.")
		return

	label.text = str(player)


func _process(delta: float) -> void:
	var speed := 200.0

	if input.direction != Vector2.ZERO:
		position += input.direction * speed * delta
