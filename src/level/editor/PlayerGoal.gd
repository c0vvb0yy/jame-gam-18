extends Node2D


signal arena_completed


func _on_Area2D_body_entered(body: Node) -> void:
	if body.get_parent() is Player:
		# get the arena controller
		var controllers = get_tree().get_nodes_in_group("ArenaController")
		if controllers.size() > 0:
			var controller = controllers[0]
			
			# emit the signal that the player completed the level
			connect("arena_completed", controller, "show_victory_screen")
			emit_signal("arena_completed")
			disconnect("arena_completed", controller, "show_victory_screen")
		
		# epic win for the player
		body.get_parent().set_victory_container_visible(true)
