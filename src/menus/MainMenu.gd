extends Control


enum MenuStates{
	MainMenu,
	ArenaSelect,
	Shop,
	Credits
}

onready var music_player = $MusicPlayer
onready var start_sfx_player = $StartSFXPlayer

var current_menu_state = MenuStates.MainMenu

# arena view stuff
onready var arena_container = $LevelSelectionContainer
var arena_count = GameData.ARENA_ORDER.size()
const MAX_BUTTONS_IN_ROW = 6
const SEPARATION_X = 15
var arena_select_button = preload("res://src/menus/ArenaSelectButton.tscn")
var shop_item = preload("res://src/menus/ShopItem.tscn")

# refs to other main menu ui
onready var main_menu_buttons = $MainMenuButtons
onready var arena_button = $MainMenuButtons/LevelSelectButton
onready var quit_button = $MainMenuButtons/QuitButton
onready var credits_container = $CreditsContainer
onready var shop_container = $ShopContainer
onready var shop_item_container = $ShopContainer/ShopItemContainer
onready var money_label = $ShopContainer/VBoxContainer/HBoxContainer/MoneyLabel
onready var banner_sprite = $Sprite

func _ready() -> void:
	# startup sound
	start_sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.MainMenuLoad))
	start_sfx_player.volume_db = AudioData.db_level
	start_sfx_player.play(0.0)
	
	# unlocks
	var file_to_check = File.new()
	var is_file_exists = file_to_check.file_exists("user://skully.json")
	if is_file_exists:
		UpgradeData.load_upgrade_data()
	
	# generate level selection
	create_level_items()
	create_shop_items()
	set_menu_state(MenuStates.MainMenu)
	music_player.volume_db = AudioData.db_level
	music_player.play(1.5)
	
	
	arena_container.add_constant_override("separation", SEPARATION_X)


func set_menu_state(value: int):
	current_menu_state = value
	var is_main_menu = current_menu_state == MenuStates.MainMenu
	var is_arena_select = current_menu_state == MenuStates.ArenaSelect
	var is_credits = current_menu_state == MenuStates.Credits
	var is_shop = current_menu_state == MenuStates.Shop
	
	main_menu_buttons.visible = is_main_menu
	arena_container.visible = is_arena_select
	credits_container.visible = is_credits
	shop_container.visible = is_shop
	banner_sprite.visible = is_main_menu


func create_level_items():
	# remove all levels so far
	for child in arena_container.get_children():
		if child is HBoxContainer:
			if !child.is_in_group("Heading"):
				child.queue_free()
	
	# create vars
	var current_button_count = 0
	var current_h_box = HBoxContainer.new()
	var button_count_row = 0
	
	#print(PlayerData.finished_levels)
	while current_button_count < arena_count:
		var new_button = arena_select_button.instance()

		new_button.call_deferred("set_arena", current_button_count)
		current_h_box.add_child(new_button)
		
	
#	for level in PlayerData.finished_levels:
#		var new_button = arena_select_button.instance()
#		current_h_box.add_child(new_button)
		#print(str("instancing level ", current_button_count))
#		new_button.set_arena(level)
		if !PlayerData.finished_levels.has(current_button_count) && current_button_count != 0:
			new_button.queue_free()
			print(str("deleting level ", current_button_count))
		current_button_count += 1
		button_count_row += 1
		# if the hbox is large enough or we've instanced enough buttons for all the levels, add it to the vbox
		if button_count_row >= MAX_BUTTONS_IN_ROW || current_button_count == arena_count - 1:
			arena_container.add_child(current_h_box)
			current_h_box.add_constant_override("separation", SEPARATION_X)
			
			button_count_row = 0
			# if we're not at the limit, also get a new hbox
			if current_button_count < arena_count - 1:
				current_h_box = HBoxContainer.new()
		
		

func create_shop_items():
	for i in range(4):
		var item = shop_item.instance()
		shop_item_container.add_child(item)
		item.set_upgrade(i)
	
	# shop label
	money_label.text = str(PlayerData.player_money, "  G")

func update_money_label():
	money_label.text = str(PlayerData.player_money, " G")
	UpgradeData.save_upgrade_data()

func _on_LevelSelectButton_button_up() -> void:
	# toggle visibility of level_container
	set_menu_state(MenuStates.ArenaSelect)



func _on_BackButton_button_up() -> void:
	# literally same (duplicated) back button for credits and level selection
	set_menu_state(MenuStates.MainMenu)


func _on_CreditsButton_button_up() -> void:
	set_menu_state(MenuStates.Credits)

func _on_QuitButton_button_up() -> void:
	UpgradeData.save_upgrade_data()
	get_tree().quit()






func _on_ShopButton_button_up() -> void:
	set_menu_state(MenuStates.Shop)
