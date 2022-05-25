extends Camera2D

export var dead_zone = 160

onready var player = get_parent()

func _input(event):
	if event is InputEventMouseMotion:
		var target = to_local(event.position) - player.global_position 
		if target.length() < dead_zone:
			self.position = Vector2.ZERO
		else:
			self.position = target.normalized() * (target.length() - dead_zone) * 0.5
