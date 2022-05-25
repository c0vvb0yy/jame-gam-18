extends Node2D
class_name Arena



func player_spawn_point_global_coords() -> Vector2:
	if $PlayerSpawnPoint != null:
		return $PlayerSpawnPoint.global_position
	else:
		return Vector2.ZERO
