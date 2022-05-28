extends VBoxContainer


onready var next_level_button = $ButtonContainer/NextLevelButton

func _ready() -> void:
	visible = false


func launch_arena(arena_index):
	visible = false
	var controllers = get_tree().get_nodes_in_group("ArenaController")
	if controllers.size() > 0:
		var controller = controllers[0]
		controller.load_arena(arena_index)

func _on_NextLevelButton_button_up() -> void:
	var new_arena = GameData.next_arena + 1
	if new_arena < GameData.ARENA_ORDER.size():
		GameData.next_arena += 1
		launch_arena(new_arena)
		


func _on_VictoryContainer_visibility_changed() -> void:
	var is_last_arena = GameData.next_arena >= GameData.ARENA_ORDER.size() - 1
	next_level_button.visible = !is_last_arena


func _on_MainMenuButton_button_up() -> void:
	get_tree().change_scene("res://src/menus/MainMenu.tscn")


func _on_RetryButton_button_up() -> void:
	launch_arena(GameData.next_arena)


func _on_MainMenuButton_button_down() -> void:
	pass # Replace with function body.


func _on_RetryButton_button_down() -> void:
	pass # Replace with function body.


func _on_MainMenuButton_mouse_entered() -> void:
	pass # Replace with function body.


func _on_RetryButton_mouse_entered() -> void:
	pass # Replace with function body.


func _on_NextLevelButton_button_down() -> void:
	pass # Replace with function body.
