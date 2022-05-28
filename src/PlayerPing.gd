extends Node2D


onready var ping_body = $PingBody
onready var ping_pulse = $PingPulse
onready var tween = $Tween

onready var sfx_player = $AudioStreamPlayer2D

var target_scale_body = 2.5
const TARGET_SCALE_PULSE = 100

export var upgrade_scale_body = 1.5

func _ready() -> void:
	if UpgradeData.has_upgrade(UpgradeData.Upgrades.PingRange):
		target_scale_body += upgrade_scale_body
	
	tween.interpolate_property(ping_body, "scale", Vector2(1, 1), Vector2(target_scale_body, target_scale_body), 1.0)
	tween.interpolate_property(ping_pulse, "scale", Vector2(1, 1), Vector2(TARGET_SCALE_PULSE, TARGET_SCALE_PULSE), 5.0)
	tween.start()
	
	sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.PlayerPing))
	sfx_player.volume_db = AudioData.db_level
	sfx_player.play(0.0)


