extends Node2D


onready var ping_body = $PingBody
onready var ping_pulse = $PingPulse
onready var timer = $FlashbangTimer
onready var tween = $Tween

const TARGET_SCALE_BODY = 2.5
const TARGET_SCALE_PULSE = 100

func _ready() -> void:
	tween.interpolate_property(ping_body, "scale", Vector2(1, 1), Vector2(TARGET_SCALE_BODY, TARGET_SCALE_BODY), 1.0)
	tween.interpolate_property(ping_pulse, "scale", Vector2(1, 1), Vector2(TARGET_SCALE_PULSE, TARGET_SCALE_PULSE), 5.0)
	tween.start()




func _on_FlashbangTimer_timeout() -> void:
	ping_pulse.visible = false


