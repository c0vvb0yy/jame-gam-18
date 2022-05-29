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
		player.die()
#		player.play_explosion()
		#timer.start(1.3)
		
		
		


func _on_Timer_timeout():
	print("killed player")
	player.kill_player()
	pass # Replace with function body.
