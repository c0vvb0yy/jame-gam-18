extends Control

# arena view stuff
onready var level_container = $LevelSelectionContainer
const ARENA_COUNT = 60
const MAX_BUTTONS_IN_ROW = 6
const SEPARATION_X = 15
var arena_select_button = preload("res://src/menus/ArenaSelectButton.tscn")

func _ready() -> void:
	create_level_items()


func create_level_items():
	# remove all levels so far
	for child in level_container.get_children():
		if child is HBoxContainer:
			child.queue_free()
	
	# create vars
	var current_button_count = 0
	var current_h_box = HBoxContainer.new()
	var button_count_row = 0
	
	while current_button_count < ARENA_COUNT:
		var new_button = arena_select_button.instance()
		
		new_button.call_deferred("set_arena", current_button_count)
		current_h_box.add_child(new_button)
		current_button_count += 1
		button_count_row += 1
		# if the hbox is large enough or we've instanced enough buttons for all the levels, add it to the vbox
		if button_count_row >= MAX_BUTTONS_IN_ROW || current_button_count == ARENA_COUNT - 1:
			level_container.add_child(current_h_box)
			current_h_box.add_constant_override("separation", SEPARATION_X)
			
			button_count_row = 0
			# if we're not at the limit, also get a new hbox
			if current_button_count < ARENA_COUNT - 1:
				current_h_box = HBoxContainer.new()
		


func _on_LevelSelectButton_button_up() -> void:
	# placeholder
	get_tree().change_scene("res://src/Base.tscn")
	
	# actual functionality:
	# toggle visibility of level_container
	pass


func _on_QuitButton_button_up() -> void:
	get_tree().quit()
