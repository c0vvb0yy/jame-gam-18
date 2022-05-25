extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_DeathZone_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		print("killed player")
		# kill player
		# reset level, implement recording


func _on_DeathZone_body_entered(body: Node) -> void:
	if body.get_parent() is Player:
		print("killed player")
		body.get_parent().kill_player()
