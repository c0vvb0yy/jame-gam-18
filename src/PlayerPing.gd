extends Node2D


onready var illumination_sprite = $Illum640000


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	illumination_sprite.scale = Vector2(100, 100)


func _on_FlashbangTimer_timeout() -> void:
	illumination_sprite.scale = Vector2(5,5)
