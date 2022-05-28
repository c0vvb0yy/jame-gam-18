extends Control


enum MenuStates{
	MainMenu,
	ArenaSelect,
	Shop,
	Credits
}

onready var music_player = $MusicPlayer

var current_menu_state = MenuStates.MainMenu

# arena view stuff
onready var arena_container = $LevelSelectionContainer
var arena_count = GameData.ARENA_ORDER.size()
const MAX_BUTTONS_IN_ROW = 6
const SEPARATION_X = 15
var arena_select_button = preload("res://src/menus/ArenaSelectButton.tscn")

# refs to other main menu ui
onready var main_menu_buttons = $MainMenuButtons
onready var arena_button = $MainMenuButtons/LevelSelectButton
onready var quit_button = $MainMenuButtons/QuitButton
onready var credits_container = $CreditsContainer


func _ready() -> void:
	create_level_items()
	set_menu_state(MenuStates.MainMenu)
	music_player.volume_db = AudioData.db_level
	music_player.play(1.5)


func set_menu_state(value: int):
	current_menu_state = value
	var is_main_menu = current_menu_state == MenuStates.MainMenu
	var is_arena_select = current_menu_state == MenuStates.ArenaSelect
	var is_credits = current_menu_state == MenuStates.Credits
	
	main_menu_buttons.visible = is_main_menu
	arena_container.visible = is_arena_select
	credits_container.visible = is_credits


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
	
	while current_button_count < arena_count:
		var new_button = arena_select_button.instance()
		
		new_button.call_deferred("set_arena", current_button_count)
		current_h_box.add_child(new_button)
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
		


func _on_LevelSelectButton_button_up() -> void:
	# toggle visibility of level_container
	set_menu_state(MenuStates.ArenaSelect)



func _on_BackButton_button_up() -> void:
	# literally same (duplicated) back button for credits and level selection
	set_menu_state(MenuStates.MainMenu)


func _on_CreditsButton_button_up() -> void:
	set_menu_state(MenuStates.Credits)

func _on_QuitButton_button_up() -> void:
	get_tree().quit()

