extends AudioStreamPlayer

func play_button_hover():
	stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.ButtonHover))
	volume_db = AudioData.db_level
	play(0.0)

func play_button_click():
	stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.ButtonClick))
	volume_db = AudioData.db_level
	play(0.0)

func _on_LevelSelectButton_mouse_entered() -> void:
	play_button_hover()


func _on_CreditsButton_mouse_entered() -> void:
	play_button_hover()


func _on_BackButton_mouse_entered() -> void:
	play_button_hover()


func _on_QuitButton_mouse_entered() -> void:
	play_button_hover()


func _on_ShopButton_mouse_entered() -> void:
	play_button_hover()


func _on_LevelSelectButton_button_down() -> void:
	play_button_click()


func _on_ShopButton_button_down() -> void:
	play_button_click()

func _on_QuitButton_button_down() -> void:
	play_button_click()


func _on_BackButton_button_down() -> void:
	play_button_click()


func _on_CreditsButton_button_down() -> void:
	play_button_click()
