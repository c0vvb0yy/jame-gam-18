extends TextureButton


var arena = 0
onready var label = $Label


func set_arena(value: int):
	arena = value
	label.text = str("Level\n", arena + 1)


func _on_ArenaSelectButton_button_up() -> void:
	print("a")
	GameData.next_arena = arena
	get_tree().call_deferred("change_scene", "res://src/level/ArenaController.gd")

