extends Node2D
class_name Player


signal kill_player

onready var victory_container = $PlayerMovement/Camera2D/VictoryContainer
onready var body = $PlayerMovement
var spawn_pos : Vector2

func set_victory_container_visible(visibility: bool):
	victory_container.visible = visibility


func kill_player():
	# get the arena controller
	var controllers = get_tree().get_nodes_in_group("ArenaController")
	if controllers.size() > 0:
		var controller = controllers[0]
		
		# emit the signal that the player died
		connect("kill_player", controller, "end_run")
		emit_signal("kill_player")
		disconnect("kill_player", controller, "end_run")
	body.position = spawn_pos
