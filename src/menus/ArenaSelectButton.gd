extends TextureButton


var arena = 0
onready var label = $Label


func set_arena(value: int):
	arena = value
	#label.text = str("Level\n", arena + 1)
	label.text = str(arena + 1)


func _on_ArenaSelectButton_button_up() -> void:
	# check if that arena exists
	#var file_path = str("res://src/level/arenas/arena", arena, ".tscn")
	var file_path = GameData.ARENA_ORDER[arena]
	var file_to_check = File.new()
	var file_exists = file_to_check.file_exists(file_path)
	# if it exists, write the relevant data into GameData and load the arena controller
	if file_exists:
		GameData.next_arena = arena
		get_tree().change_scene("res://src/level/ArenaController.tscn")

