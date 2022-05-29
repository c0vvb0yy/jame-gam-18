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
	if visible:
		# save the current level that it was finished
		if !PlayerData.finished_levels.has(GameData.next_arena): # prevent duplicates
			PlayerData.finished_levels.append(GameData.next_arena)
			#print(GameData.next_arena)
		# also save the next level because when you finish a level, you should also be able to *access* the following arena
		var new_arena = GameData.next_arena + 1
		if new_arena < GameData.ARENA_ORDER.size():
			if !PlayerData.finished_levels.has(new_arena): # prevent duplicates
				PlayerData.finished_levels.append(new_arena)
		UpgradeData.save_upgrade_data()
			#print(str("finished lvls" , PlayerData.finished_levels))
		
		var is_last_arena = GameData.next_arena >= GameData.ARENA_ORDER.size() - 1
		next_level_button.visible = !is_last_arena
		sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.ArenaVictory))
		sfx_player.volume_db = AudioData.db_level
		sfx_player.play(0.0)


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


func _on_ShopButton_mouse_entered() -> void:
	AudioData.play_button_hover(sfx_player)


func _on_ShopButton_button_down() -> void:
	AudioData.play_button_click(sfx_player)


func _on_ShopButton_button_up() -> void:
	var controllers = get_tree().get_nodes_in_group("VictoryShop")
	if controllers.size() > 0:
		var shop = controllers[0]
		shop.create_shop_items()
		shop.visible = true
		
