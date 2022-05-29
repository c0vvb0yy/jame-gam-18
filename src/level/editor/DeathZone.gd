extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var timer = $Timer
onready var sfx_player = $AudioStreamPlayer

var player 

func set_enabled(value: bool):
	for c in get_children():
		if c is CollisionPolygon2D or c is CollisionShape2D:
			c.disabled = !value
			#print("end")


func _on_DeathZone_body_entered(body: Node) -> void:
	if body.get_parent() is Player:
		player = body.get_parent()
		player.disable_movement()
		player.play_anim()
#		player.play_explosion()
		#timer.start(1.3)
		
		sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.PlayerDeath))
		sfx_player.volume_db = AudioData.db_level
		sfx_player.play(0.4)
		


func _on_Timer_timeout():
	print("killed player")
	player.kill_player()
	pass # Replace with function body.
