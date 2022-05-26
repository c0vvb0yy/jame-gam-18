extends Node2D
class_name Arena

export var allow_grappling_hook = true
export var allow_ping = true


func _ready() -> void:
	GameData.allow_grappling_hook = allow_grappling_hook
	GameData.allow_ping = allow_ping


func player_spawn_point_global_coords() -> Vector2:
	if $PlayerSpawnPoint != null:
		return $PlayerSpawnPoint.global_position
	else:
		return Vector2.ZERO
