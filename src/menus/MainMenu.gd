extends Control





func _on_LevelSelectButton_button_up() -> void:
	get_tree().change_scene("res://src/Base.tscn")


func _on_QuitButton_button_up() -> void:
	get_tree().quit()
