extends Node2D
class_name Arena

export var allow_grappling_hook = true
export var allow_ping = true

export var time_S = 1.0
export var time_A = 2.0
export var time_B = 3.0
export var time_C = 4.0
# export var time_D = 5.0

export var ping_S = 0
export var ping_A = 1
export var ping_B = 2
export var ping_C = 3
# export var eyes_D = 4

#arrays for easier comparison to next rank needed
onready var time_brackets = [time_C, time_B, time_A, time_S]
onready var ping_brackets = [ping_C, ping_B, ping_A, ping_S]

func _ready() -> void:
	GameData.allow_grappling_hook = allow_grappling_hook
	GameData.allow_ping = allow_ping
	


func player_spawn_point_global_coords() -> Vector2:
	if $PlayerSpawnPoint != null:
		return $PlayerSpawnPoint.global_position
	else:
		return Vector2.ZERO
