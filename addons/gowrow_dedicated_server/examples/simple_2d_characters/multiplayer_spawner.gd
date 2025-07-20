extends MultiplayerSpawner

@export var character_scene: PackedScene

# func _spawn(data: Variant) -> Node:
# 	var character: Character = character_scene.instantiate()
# 	character.set_multiplayer_authority(data["id"])
# 	character.name = "Character_%d" % data["id"]
# 	return character
