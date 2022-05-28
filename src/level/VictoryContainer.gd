extends VBoxContainer


onready var next_level_button = $ButtonContainer/NextLevelButton
onready var sfx_player = $SFXPlayer

func _ready() -> void:
	visible = false


func launch_arena(arena_index):
	visible = false
	var controllers = get_tree().get_nodes_in_group("ArenaController")
	if controllers.size() > 0:
		var controller = controllers[0]
		controller.load_arena(arena_index)

func _on_NextLevelButton_button_up() -> void:
	GameData.last_arena = GameData.next_arena
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
	GameData.last_arena = GameData.next_arena
	launch_arena(GameData.next_arena)


func _on_MainMenuButton_button_down() -> void:
	AudioData.play_button_click(sfx_player)


func _on_RetryButton_button_down() -> void:
	AudioData.play_button_click(sfx_player)


func _on_MainMenuButton_mouse_entered() -> void:
	AudioData.play_button_hover(sfx_player)

func _on_RetryButton_mouse_entered() -> void:
	AudioData.play_button_hover(sfx_player)


func _on_NextLevelButton_button_down() -> void:
	AudioData.play_button_click(sfx_player)


func _on_NextLevelButton_mouse_entered() -> void:
	AudioData.play_button_hover(sfx_player)
