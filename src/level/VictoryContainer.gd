extends VBoxContainer


func _ready() -> void:
	visible = false


func _on_NextLevelButton_button_up() -> void:
	var new_arena = GameData.next_arena + 1
	if new_arena < GameData.ARENA_ORDER.size():
		visible = false
		var controllers = get_tree().get_nodes_in_group("ArenaController")
		if controllers.size() > 0:
			var controller = controllers[0]
			controller.load_arena(new_arena)
		GameData.next_arena += 1
