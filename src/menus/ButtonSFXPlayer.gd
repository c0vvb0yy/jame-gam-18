extends AudioStreamPlayer


func _on_LevelSelectButton_mouse_entered() -> void:
	AudioData.play_button_hover(self)


func _on_CreditsButton_mouse_entered() -> void:
	AudioData.play_button_hover(self)


func _on_BackButton_mouse_entered() -> void:
	AudioData.play_button_hover(self)


func _on_QuitButton_mouse_entered() -> void:
	AudioData.play_button_hover(self)


func _on_ShopButton_mouse_entered() -> void:
	AudioData.play_button_hover(self)


func _on_LevelSelectButton_button_down() -> void:
	AudioData.play_button_click(self)


func _on_ShopButton_button_down() -> void:
	AudioData.play_button_click(self)

func _on_QuitButton_button_down() -> void:
	AudioData.play_button_click(self)


func _on_BackButton_button_down() -> void:
	AudioData.play_button_click(self)


func _on_CreditsButton_button_down() -> void:
	AudioData.play_button_click(self)
